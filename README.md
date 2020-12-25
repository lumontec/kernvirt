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
sudo make oldconfig
sudo cp /usr/src/linux-headers-$(uname -r)/Module.symvers .
```

PS: these variables are required for personal project debugging, change your own according to your requirements:



## Compile full kernel and modules 

```bash
sudo make -j4
```







