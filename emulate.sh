#!/bin/bash

# Emulate with qemu
qemu-system-x86_64 \
  -kernel kernel/arch/x86_64/boot/bzImage \
  -initrd initramfs/initramfs.cpio.gz \
  -m 3048 \
  -nographic \
  -append "console=ttyS0 nokaslr" \
  -enable-kvm \
  -cpu host \
  -s -S
