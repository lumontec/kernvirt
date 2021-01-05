# Tested on kernel version:  v5.4.0

## Bpf testing tips
- Must compile kernel to include BTF information, refer to bpf_config file
- Package *pahole*(included in dwarves package) must be installed in order to generate BTF information. 
- Pahole v1.15 crahes at the end of kernel compilation, thus package dwarves 1.18 was included by adding to /etc/apt/sources.list:
```bash 
# Hirsute sources
deb http://cz.archive.ubuntu.com/ubuntu hirsute main universe
```

## Kernel customizations
./scripts/config \
-e DEBUG_INFO \
-e GDB_SCRIPTS \
-e CONFIG_DEBUG_INFO_BTF \
-e CONFIG_BPF_EVENTS \
-e CONFIG_BPF \
-e CONFIG_BPF_SYSCALL \
-e CONFIG_BPF_JIT \
-e CONFIG_HAVE_EBPF_JIT

PS: keep disabled:
CONFIG_DEBUG_INFO_SPLIT 
CONFIG_DEBUG_INFO_REDUCED


## Install samples
- Install kernel headers locally (./usr/include): make headers_install
- Install bpf samples: make M=samples/bpf
- Install bpf tool: make -C ./tools/bpf/bpftool
