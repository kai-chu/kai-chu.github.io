---
layout: post
title:  "Concepts before starting to use ansible"
date:   2019-10-12 13:49:42 +0200
categories: devops ansible
---

I started to get involved into DevOps area since july of 2017. Jenkins, groovy and ssh are all my equipments to construct all the CI/CD pipeline realms. 

I've heared a lot about Ansible since then but never get a determination to try it since I'm not sure what it is. Recently, I'm helping a team to build their CD pipeline. I think it's a good time to use Ansible to do something. I start to get familier with the overview of the tool. In this post, I will give my opinions about those terms.

## What is Ansible
[Ansible](https://en.wikipedia.org/wiki/Ansible_(software)) is an open-source software provisioning, configuration management, and application-deployment tool.

I think it's a definition that's hard to understand for most of the developers if they're not working with operations. But most likely, they have worked with those tasks in a single machine.

- ssh into a server
- install some missing libs or services (configuration management)
- add user or group (software provisioning)
- download a product (application-deployment)
- change permissions (application-deployment)
- start or stop a service (application-deployment)
- change some configurations for nginx(configuration management)
- ...

Nowadays, Infrastructure as code is geting more and more popular, an experience operation might be able to provision a single server, debug the whole infrastructure and operate on a single product, however, it's impossible to manage a cluster of servers at the same time.

- Manage microsevices running on different servers and each of them requires different configurations. 
- Provision environments for testing, demo, staging and production.
When
- Change open ports or load balancer configurations 
- ...

We do need a way to sit in a single host and shooting commands into different machines and it's basically doing things as following:
```
kube_clusters=(server1 server2 server3 server4)
for serverName in $kube_clusters
  ssh -t username@serverName software_provision.sh 
  ssh -t username@serverName configuration_management.sh 
  ssh -t username@serverName application_deployment.sh 
done
```
Ansible is doing similar things but make the steps easier to understand and reusable in different systems. Ansible manages hosts by modeling all software packages, configs, and services as configurable resources. Via ssh, it transfers all tasks into remote servers and runs those tasks on the resources to bring them to the target state.

![Ansible Usage Situation](/assets/Ansible_ov.png)

## Concepts in Ansbile
[Ansible works](https://www.ansible.com/overview/how-ansible-works) by connecting to your nodes and pushing out small programs, called "Ansible modules" to them. These programs are written to be resource models of the desired state of the system. Ansible then executes these modules (over SSH by default), and removes them when finished.

- **Ansible server**: The machine where Ansible is installed and from which all tasks and playbooks will be ran. 

- **Module**: A [module](https://docs.ansible.com/ansible/latest/user_guide/modules_intro.html) is units of codes executed directly on remote hosts. Ansible ships with a number of modules (called the ‘module library’). Modules can take args, return json values or notify other tasks.

```
ping
command -a "/sbin/reboot -t now"
service -a "name=httpd state=started"
```
*-a to given arguments to ansible module*

- **Inventory**: A file contains groups and hosts to be managed. Ansible works against multiple systems in your infrastructure at the same time. Inventory provides a way to defined names for hosts and group similiar ones. Such as our above bash array name kube_clusters. Following inventory file is in [INI format](https://en.wikipedia.org/wiki/INI_file) used by ansible.

```
mail.example.com

[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com
```

## Running a module to see how it works
There're more concepts in ansbile which is not covered yet, such as playbooks, roles and so on. Let's have a initial look at ansible command before next post is ready.

```
kaichu:~$ ansible localhost -m ping -a data=helloansible
localhost | SUCCESS => {
    "changed": false,
    "ping": "helloansible"
}
```

In Ansible server where ansible is installed, we can use `ansible` to run a module `ping` with argument `data=helloansible` on a remote host `localhost` and see the returned result `Json format` in the console.

To understand the results of ping module, check following references, I will explain it in next post.
- [Common module return values in Ansible](https://docs.ansible.com/ansible/latest/reference_appendices/common_return_values.html#changed)
- [Module ping in Ansible](https://docs.ansible.com/ansible/latest/modules/ping_module.html)

Good references to distinguish provisioning and configuration management.
- [Why configuration management and provisioning are different](https://www.thoughtworks.com/insights/blog/why-configuration-management-and-provisioning-are-different)
- [End to end application provisioning with ansible and terraform](https://www.ibm.com/cloud/blog/end-to-end-application-provisioning-with-ansible-and-terraform)

To have a overview about ansible, check the official explanation.
- [How ansible works](https://www.ansible.com/overview/how-ansible-works)
- [All modules in ansible core](https://docs.ansible.com/ansible/latest/modules)

---

In the comming posts, I will introduce how to start with ansible and play some common modules to make you used to it. 
