---
title: 安装 mysql
---

用opkg安装myserver及其依赖包  

```bash
opkg update  
opkg install libpthread libncurses libreadline mysql-server
```
    
    
创建mysql数据目录  
```bash
mkdir -p /home/data/mysql  
mkdir -p /home/data/tmp
```
    
    
修改配置文件  
```bash
vi /etc/my.cnf  
datadir = /home/data/mysql/ #数据保存路径  
tmpdir = /home/data/tmp/  
bind-address = 0.0.0.0 #绑定的ip地址
```
    
    
初始化建库  
```bash
mysql_install_db --force
```
    
    
启动mysql，并设定开机启动  
```bash
/etc/init.d/mysqld start  
/etc/init.d/mysqld enable
```
    
    
设定密码  
```bash
mysqladmin -u root password ‘password’
```
    