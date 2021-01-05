## Bpf testing tips (tested with kernel 5.4.0)

- Must compile kernel to include BTF information, refer to bpf_config file
- Package *pahole*(included in dwarves package) must be installed in order to generate BTF information. 
- Pahole v1.15 crahes at the end of kernel compilation, thus package dwarves 1.18 was included by adding to /etc/apt/sources.list:
```bash 
# Hirsute sources
deb http://cz.archive.ubuntu.com/ubuntu hirsute main universe
```
