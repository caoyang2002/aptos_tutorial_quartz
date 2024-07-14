---
title: synology 安装 ipkg
---
到现在为止，也没弄清楚群晖系统发行版到底是什么，暂且就叫做Synology DSM系统吧，常用的源安装命令（yum/apg-get/ipkg等）都使用不了，不过我们可以通过下面方法来自行安装ipkg包管理工具。

首先确定系统的版本和CPU类型，下面的安装脚本适用于**x86平台64位系统**，ARM平台及32位系统是否能使用我这里不确定。

到群晖的管理后台，打开控制面板，在“终端机和SNMP”中，开启SSH功能，端口号默认为22，为了安全起见，建议修改成其他端口号。如果开启了防火墙，请注意确保SSH端口能通过防火墙。

​

开启SSH功能

打开终端，我使用的是PuTTY，使用群晖的管理员账号和密码登录，登录成功后，可使用下面命令切换到root账号：


```javascript
sudo -i
```

之后输入密码（与管理员的密码相同）

下载bootstrap并安装：

```javascript
wget http://ipkg.nslu2-linux.org/feeds/optware/syno-i686/cross/unstable/syno-i686-bootstrap_1.2-7_i686.xsh
chmod +x syno-i686-bootstrap_1.2-7_i686.xsh
sh syno-i686-bootstrap_1.2-7_i686.xsh
```

输出：

```javascript
Optware Bootstrap for syno-i686.
Extracting archive... please wait
bootstrap/
bootstrap/bootstrap.sh
bootstrap/ipkg-opt.ipk
bootstrap/ipkg.sh
1216+1 records in
1216+1 records out
bootstrap/optware-bootstrap.ipk
bootstrap/wget.ipk
249302 bytes (249 kB) copied, 0.00421063 s, 59.2 MB/s
Creating temporary ipkg repository...
Installing optware-bootstrap package...
Unpacking optware-bootstrap.ipk...Done.
Configuring optware-bootstrap.ipk...Modifying /etc/rc.local
Done.
Installing ipkg...
Unpacking ipkg-opt.ipk...Done.
Configuring ipkg-opt.ipk...Done.
Removing temporary ipkg repository...
Installing wget...
Installing wget (1.12-2) to root...
Configuring wget
Successfully terminated.
Creating /opt/etc/ipkg/cross-feed.conf...
Setup complete.
```

安装完成，建议重启，不过我没重启也没问题，可以使用。

之后执行更新：

```javascript
ipkg update
```

如果执行ipkg失败，提示没有找到该命令（- ash : ipkg : command not found），需要添加一下环境变量：

```javascript
#PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin
#export PATH
```

我们来安装个Screen试一下：

代码语言：javascript

复制

```bash
ipkg install screen
```

输出：

```bash
Installing screen (4.0.3-2) to root...
Downloading http://ipkg.nslu2-linux.org/feeds/optware/syno-i686/cross/unstable/s                                                                                                                     creen_4.0.3-2_i686.ipk
Installing termcap (1.3.1-2) to root...
Downloading http://ipkg.nslu2-linux.org/feeds/optware/syno-i686/cross/unstable/t                                                                                                                     ermcap_1.3.1-2_i686.ipk
Configuring screen
Configuring termcap
Successfully terminated.
```

没问题。

删除安装包：

```javascript
rm syno-i686-bootstrap_1.2-7_i686.xsh
```

以上。



# 二


## install

```bash
1. sh 用户名@IP地址 #按回车输入密码 密码不显示 输入后按回车即可登陆
2. sudo -i #再次输入密码切换root权限
3. wget http://ipkg.nslu2-linux.org/feeds/optware/syno-i686/cross/unstable/syno-i686-bootstrap_1.2-7_i686.xsh
4. chmod +x syno-i686-bootstrap_1.2-7_i686.xsh
5. sh syno-i686-bootstrap_1.2-7_i686.xsh
6. #执行上述命令后即可安装ipkg包管理器
7. #安装完成后执行以下命令进行测试
8. ipkg update #如果没有报错就说明成功安装
9. #如果报错ipkg : command not found则添加环境变量
10. #PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin
11. #export PATH
12. #再次测试 如果还不行就重启下DSM即可
```

## usage
```bash
1. #首先更新软件源
2. ipkg update
3. #安装命令如下
4. ipkg install 软件包名称
5. #卸载命令如下
6. ipkg remove 软件包名称
7. #例如安装wakelan
8. ipkg install wakelan
9. #返回以下内容说明安装成功
10. ipkg install wakelan
11. Installing wakelan (1.1-2) to root...
12. Downloading http://ipkg.nslu2-linux.org/feeds/optware/syno-i686/cross/unstable/wakelan_1.1-2_i686.ipk
13. Configuring wakelan
14. Successfully terminated.
```