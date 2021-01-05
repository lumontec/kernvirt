# Easy Kernel and User virtualization fun

The aim of this project is to automate kernel and user virtualization for personal debugging purposes

**References**
[https://mudongliang.github.io/2017/09/12/how-to-build-a-custom-linux-kernel-for-qemu.html](https://mudongliang.github.io/2017/09/12/how-to-build-a-custom-linux-kernel-for-qemu.html)
[https://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html](https://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html)


## Build the kernel 

- Set up your testing / build system with [https://github.com/lumontec/flashbuild](https://github.com/lumontec/flashbuild)
- Dowload kernel version you want to hack (from github)
- Checkout at your desired version (I chose my installed one)

```bash
sudo apt install git make gcc device-tree-compiler bison flex libssl-dev libncurses-dev gcc-arm-linux-gnueabi gcc-aarch64-linux-gnu dwarves
git clone https://github.com/torvalds/linux.git \
cd linux \
git checkout v5.4
```
- Clean previus artifacts
- Copy your current kernel config (*optional if yow work from scratch*) 
- Align sources config with your own old (*optional if yow work from scratch*) 
- Copy your current kernel symbols (*optional if you work from scratch*) 


### Block the kernel version

Linux kernel will automatically mark your custom built kernel wit a +, to have full control on your version:
```bash
touch .scmversion
# Set localversion inside .config
#CONFIG_LOCALVERSION="-58-generic"
vim .config
# Set other version numbers inside Makefile
#VERSION = 5
#PATCHLEVEL = 4
#SUBLEVEL = 0
#EXTRAVERSION =
vim Makefile
```

### Play with x86 kernel

Configure a fresh default kernel
```bash
cd ./linux
make distclean
make defconfig 
```

Or replicate currently installed host kernel
```bash
cd ./linux
make distclean
cp /boot/config-5.4.0-56-generic .config
make oldconfig (select no on any new driver)
cp /usr/src/linux-headers-$(uname -r)/Module.symvers .
```

PS: customize your kernel config using ./scripts/config (-e enable, -d disable) 

```bash
./linux/scripts/config \
-e DEBUG_INFO \
-e GDB_SCRIPTS
```

Compile with the maximum supported cores (will take a while) inside obj folder

```bash
make -j8
```

### Play with arm64 kernel

```bash
cd ./linux
make distclean
# Gernerate arm64 specific default config
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make defconfig
# Compile arm64 compressed image
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make -j8 Image
```



## Create virtual machine  

- Boot qemu with minimal kernel image (an stop before entering kernel executable)

### x86

```bash
qemu-system-x86_64  \
  -initrd 3_initramfs/initramfs.cpio.gz \
  -kernel kernel_src/arch/x86_64/boot/bzImage \
  -m 2048 \
  -append "console=ttyS0 nokaslr" \
  -nographic \
  -cpu host \
  -enable-kvm \
```

### arm64

```bash
#!/bin/bash

qemu-system-aarch64 \
  -kernel kernel_src/arch/arm64/boot/Image \
  -initrd 3_initramfs/initramfs.cpio.gz \
  -m 2048 \
  -M virt \
  -cpu cortex-a53 \
  -smp 8 \
  -nographic \
  -serial mon:stdio \
  -append "rw console=ttyAMA0 loglevel=8 rootwait fsck.repair=yes memtest=1" \
  -no-reboot \
  -s -S
```

## Attach gdb debugging

- Add vmlinux-gdb debugging scripts to gdbinit (if not present inside ~/.gdbinit)
- Attach to kernel process with gdb remotely
- Set first hardware breakpoint to kernel entry function
- Some fun hacking the kernel 

```bash
echo "add-auto-load-safe-path /home/crash/Documents/local/sysdig-repo/kernvirt/linux/scripts/gdb/vmlinux-gdb.py"
gdb vmlinux
target remote :1234
hbreak start_kernel
c
lx-dmesg
```

## Example configurations

In the current files: config_<target test> we find minimal kernel .config files used for compiling and testing specific kernel features



