# Easy Kernel and User virtualization fun

The aim of this project is to automate kernel and user virtualization for personal debugging purposes

**References**
[https://mudongliang.github.io/2017/09/12/how-to-build-a-custom-linux-kernel-for-qemu.html](https://mudongliang.github.io/2017/09/12/how-to-build-a-custom-linux-kernel-for-qemu.html)
[https://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html](https://mgalgs.github.io/2015/05/16/how-to-build-a-custom-linux-kernel-for-qemu-2015-edition.html)

## Build userspace

- Clone busybox sources inside ./userspace folder:
- Checkout busybox version
- Generate busybox default config 

```bash
mkdir userspace && cd userspace
git clone https://github.com/mirror/busybox.git
cd ./busybox
git checkout 1_32_0
make defconfig
```
- Edit busybox config as you please (we set static build)

```bash
CONFIG_STATIC=y
...
```

- Compile busybox binary
- Install on ./_install (default)

```bash
make -j8
make install
```

- Create initramfs folders
- Copy binaries from busybox installed files

```bash
mkdir -v ./userspace/initramfs
cd ./userspace/initramfs
mkdir -pv {bin,sbin,etc,proc,sys,usr/{bin,sbin}}
cp -av ../busybox/_install/* .
```

- Create custom *init* script inside ./userspace/initramfs folder

```bash
#!/bin/sh
 
mount -t proc none /proc
mount -t sysfs none /sys
 
echo -e "\nBoot took $(cut -d' ' -f1 /proc/uptime) seconds\n"
 
exec /bin/sh
```

- Make it executable
- Generate initramfs archive with cpio inside obj folder
```bash
chmod +x init
find . -print0 \
    | cpio --null -ov --format=newc \
    | gzip -9 > ../initramfs-busybox-x86.cpio.gz
```


## Build the kernel 

- Install pre-requirements 
- Dowload kernel version you want to hack (from github)
- Checkout at your desired version (I chose my installed one)

```bash
sudo apt install flex bison build-essentials \
git clone https://github.com/torvalds/linux.git \
cd linux \
git checkout v5.4
```
- Clean previus artifacts
- Copy your current kernel config (*optional if yow work from scratch*) 
- Align sources config with your own old (*optional if yow work from scratch*) 
- Copy your current kernel symbols (*optional if you work from scratch*) 

```bash
cd ./linux
make distclean
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

## Create virtual machine  

- Boot qemu with minimal kernel image (an stop before entering kernel executable)

```bash
qemu-system-x86_64 \                                                                                                                                     
  -kernel kernel/arch/x86_64/boot/bzImage \
  -initrd userspace/initramfs-busybox-x86.cpio.gz \
  -m 1024 \
  -nographic \
  -append "console=ttyS0 nokaslr" \
  -enable-kvm \
  -cpu host \  
  -s -S
```

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






