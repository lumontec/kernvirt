# Easy Kernel virtualization fun

The aim of this project is to automate kernel virtualization for personal debugging purposes

## Setup kernel sources in you project

- Install pre-requirements 
- Dowload kernel version you want to hack
- Decompress kernel sources in your project folder

```bash
sudo apt install flex bison build-essentials \
sudo apt install linux-source-5.4.0 \
sudo tar xjf /usr/src/linux-source-5.4.0.tar.bz2 .
```

## Configure your kernel variables and symbols

- Copy your current kernel config (*optional if yow work from scratch*) 
- Align sources config with your own old (*optional if yow work from scratch*) 
- Copy your current kernel symbols (*optional if you work from scratch*) 

```bash
sudo cp /boot/config-5.4.0-58-generic .config
make oldconfig
sudo cp /usr/src/linux-headers-$(uname -r)/Module.symvers .
```

PS: customize your kernel config using ./scripts/config (-e enable, -d disable) 
```bash
cd <linux-kernel-sources>
./scripts/config \
-e DEBUG_INFO \
-e GDB_SCRIPTS 
```

## Compile full kernel and modules 

Compile with the maximum supported cores (will take a while)

```bash
make -j8
```

## Create virtual machine  

- Create dummy initramfs (just for booting)
- Boot qemu with kernel specialized parameters 

```bash
mkinitramfs -o ramdisk.img
qemu-system-x86_64 \
  -kernel arch/x86_64/boot/bzImage \
  -nographic \
  -append "console=ttyS0 nokaslr" \
  -initrd ramdisk.img \
  -m 512 \
  --enable-kvm \
  -cpu host \
  -s -S &
```







