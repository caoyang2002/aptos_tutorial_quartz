---
title: synology 安装 ipkg
---
==IPKG 已经不再维护了，推荐安装 OPKG==

到现在为止，也没弄清楚群晖系统发行版到底是什么，暂且就叫做 Synology DSM 系统吧，常用的源安装命令（`yum` / `apg-get` / `ipkg`等）都使用不了，不过我们可以通过下面方法来自行安装 `ipkg` 包管理工具。

首先确定系统的版本和 CPU 类型，下面的安装脚本适用于==x86平台64位系统==，ARM 平台及 32 位系统是否能使用我这里不确定。

到群晖的管理后台，打开控制面板，在`终端机和 SNMP`中，开启 SSH 功能，端口号默认为 22，为了安全起见，建议修改成其他端口号。如果开启了防火墙，请注意确保 SSH 端口能通过防火墙。



# 开启SSH功能

打开终端，我使用的是 PuTTY，使用群晖的管理员账号和密码登录，登录成功后，可使用下面命令切换到 root 账号：


```javascript
sudo -i
```

之后输入密码（与管理员的密码相同）

下载 bootstrap 并安装：

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




---
# 方法二
【在Synology NAS上安装IPKG软件】

昨天，我在头条里发表《在Synology NAS上安装影梭客户端》，有不少人给我私信，要求发下步的内容，今天，我接着昨天的内容，讲讲如何在Synolog上安装IPKG包管理器，并讲解通过IPKG安装自己想要的软件方法。

**准备工作：**

1. Synology NAS

2. SSH客户端（这个在昨天的文章里有提到，不了解的同学请看看昨天的文章）

准备好后，可以进行下一步了。

**安装IPKG包管理器：**

IPKG是一个轻量级的包管理软件，主要运用于嵌入式LINUX设备上，负责软件的管理，由于它便捷的软件安装、卸载方式，所以应用广泛。安装IPKG有多种方法，考虑到有很多新手，我推荐在Synology 套件中心来安装。

1.登录Synology，打开套件中心，点击设置，再进入套件来源选项卡，点击新增，添加三个新的软件源（名称随意填写，位置填写如下）。

a. //packages.synocommunity.com/

b. https://www.cphub.net

c. //repo.synozwave.com

[![](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278239-9014-437a00000cc16e1a7758.jpg)](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278239-9014-437a00000cc16e1a7758.jpg)

2.修改信任层级，点击常规选项卡，选中Synology Inc.和信任的发行者。

[![](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278239-2546-437400045406b1a20ce1.jpg)](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278239-2546-437400045406b1a20ce1.jpg)

3.在添加完新的软件源后，关闭套件中心，再重新打开，会在右侧看到社群这个新分类，社群里的软件非常丰富。

[![](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278239-2215-437a00000cc378a41ff3.jpg)](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278239-2215-437a00000cc378a41ff3.jpg)

4.找到Easy Bootstrap Installer ，点击安装

[![](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278239-8774-437900000df662f941d9.jpg)](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278239-8774-437900000df662f941d9.jpg)

5.选择默认的Optware-ng iPKG （为什么选择第一个，因为第一个比较稳定，用的人比较多），如果你机器安装了其它版本的bootstrap，可以勾选Remove installed bootstrap（s），点击下一步（next）。

[![](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278240-2484-437900000df866d8047c.jpg)](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278240-2484-437900000df866d8047c.jpg)

6.选择Symbolic Link，不要选择第二个，除非你机器要安装虚拟机。

[![](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278240-2358-43740004540c7e8b3564.jpg)](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278240-2358-43740004540c7e8b3564.jpg)

7.选择安装位置为volume1，这个没什么说的。

[![](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278241-9818-437800001371ad546c1a.jpg)](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278241-9818-437800001371ad546c1a.jpg)

8.最后会进行安装，这个需要一段时间，耐心等待即可，安装完毕，通过web页面重启你的NAS即可。

**安装想要的软件**

安装完IPKG就可以安装各类软件了，我这里拿Socks2http的软件Privoxy作为讲解。

1.使用SSH客户端登录NAS（SSH客户端的用法上篇文章讲过，不会可以再回过头看看），并切换到root用户（切换到root用户：sudo -i）。

[![](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278240-2065-437a00000cbe3ba8b54b.jpg)](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278240-2065-437a00000cbe3ba8b54b.jpg)

2.输入以下命令行，逐行输入。

cd /tmp

ipkg update

ipkg install privoxy

[![](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278240-8238-437600026d0790bf62ce.jpg)](https://blog.ggrarea.cn/wp-content/uploads/2017/11/1510278240-8238-437600026d0790bf62ce.jpg)

3.编辑配置文件

cd /opt/etc/privoxy

vi privoxy.config

confdir /opt/etc/privoxy

logdir /opt/var/log/privoxy

logfile privoxy

listen-address 0.0.0.0:8100 # 8100是服务端口,别的机器访问要用到的端口

toggle 1

enable-remote-toggle 1

enable-remote-http-toggle 0

enable-edit-actions 1

enforce-blocks 0

buffer-limit 4096

forwarded-connect-retries 0

accept-intercepted-requests 0

allow-cgi-request-crunching 0

split-large-forms 0

keep-alive-timeout 300

socket-timeout 300

permit-access 192.168.1.0/24 #一般为家里局域网的ip段如192.168.1.0/24

forward-socks5 / 192.168.1.2:1080 . # socks5代理的地址一般为nas的地址，注意后面的点

4.修改rc.local，添加到exit 0前，privoxy /opt/etc/privoxy/privoxy.config 。

这样就安装好IPKG及Privoxy，Privoxy是一个代理软件，它除了可以做socks2http代理外，还可以做广告方面的处理，如果有兴趣的朋友可以留言，我将在以后的文章里发布。

（作者：凯凯运维，目前就职于国有企业，从事运维工作。很高兴与大家分享IT技术，运维技术，以及各类好玩的DIY项目，欢迎大家关注。）

[http://m.pstatp.com/group/6485485151009636877/?iid=16979958525&app=news_article&tt_from=android_share&utm_medium=toutiao_android&utm_campaign=client_share](http://m.pstatp.com/group/6485485151009636877/?iid=16979958525&app=news_article&tt_from=android_share&utm_medium=toutiao_android&utm_campaign=client_share)

转载请注明：[徐自远的乱七八糟小站](https://blog.ggrarea.cn/) » [【在Synology NAS上安装IPKG软件】](https://blog.ggrarea.cn/archives/9604.html)