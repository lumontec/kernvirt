#!/bin/bash

qemu-system-aarch64 \
  -kernel ./kernel/src/arch/arm64/boot/Image \
  -initrd ./initramfs.cpio.gz \
  -m 2048 \
  -M virt \
  -cpu cortex-a53 \
  -smp 8 \
  -nographic \
  -serial mon:stdio \
  -append "rw console=ttyAMA0 loglevel=8 rootwait fsck.repair=yes memtest=1" \
  -no-reboot \
#  -S -s
