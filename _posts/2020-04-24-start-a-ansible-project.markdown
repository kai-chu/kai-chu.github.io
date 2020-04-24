---
layout: post
title:  "Start a ansible project"
date:   2020-04-24 09:15:36 +0200
categories: ansible 
---
1. Create a folder to hold all your files
```
$ mkdir ansible-project
```
2. Add hosts file
```
$ touch hosts
$ vi hosts
abc[1:4].example.domain
```
3. Add ansible.cfg file
Create a template in project folder and copy it to your home folder so that other won't operate it by mistake, regarding configurations can be refered https://docs.ansible.com/ansible/latest/reference_appendices/config.html
```
$ touch ansible.cfg.template
[remote_user]
YOUR_USER_NAME
$ copy ansible.cfg.template ~/.ansbile.cfg
```
4. Run ping to test connection
```
$ ansible -i hosts all -k -m ping
```
5. Add vars or vaults 
```
mkdir vars && cd vars
ansible-vault create vaults.yml 
touch vars.yml
```
6. Add main.yml 
```
- hosts: all
  vars_files:
    - vars/vars.yml
  tasks:
    - name: Push dags to remote 
      taskName:
```
