---
layout: post
title:  "Understand different levels of hypervisors beneath os"
date:   2020-05-12 00:18:36 +0200
categories: hypervisors kvm qemu virtulization
---
I have chosen the word 'beneath os' instead of 'on top of hardware' for describing hypervisors. It will remind of me that hypervisors were born as an abstraction level between an os and the actual hardware devices. A notice of qemu in kvm leads me to try to understand the differences in bewtween.

![hypervisor diagram](/assets/hypervisors.jpg)

# Hosted hypervisor(type 2)
It is an application running on top of another os(named host os), it runs as a process on the host.
It's kind of os software to emulate other system commands and translate or adapte them into host os commands, utilizing host os drivers to communicate with hardwares. (No hardware involved)
```
guest os -> type2 hypervisor -> host os -> hardware
```

# Native Hypervisor(type 1)
Also called native or bare-metal hypervisor, is *virtualization software* that is installed on hardware directly.
It requires a processor with hardware virtualization extensions, such as Intel VT or AMD-V, to help to translate or map instructions to hardware cpu
```
guest os -> type1 hypervisor -> hardware
```

KVM is a type 1 hypervisor and Qemu is a Type 2 hypervisor. 

Type 1 hypervisor comes installed with the hardware system like KVM in Linux. KVM provides hardware acceleration for virtual machines but it need Qemu to emulate any operating system.

Qemu is a Type 2 hypverisor, it can be installed on an operating system and it runs as an indepent process and the instructions we give in Quemu will be executed on the host machine. Qemu can run independently without KVM as its a emulator however the performance will be poor as Qemu doesnt do any hardware acceleration

There is a project that is on-going to integrate Qemu and KVM. This will be a type 1 hypervisor. So we will have all the benefits of Qemu as an emulator and KVM hardware acceleration for better performance.

# References
1. [Wiki hypervisor](https://en.wikipedia.org/wiki/Hypervisor)
2. [Kernel based virtual machine](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine)
3. [linux-kvm org](http://www.linux-kvm.org/page/FAQ#General_KVM_information)
4. [Quora difference between kvm and qemu](https://www.quora.com/Virtualization-What-is-the-difference-between-KVM-and-QEMU)
5. [UCSD hardwareVirt paper](http://cseweb.ucsd.edu/~jfisherogden/hardwareVirt.pdf)