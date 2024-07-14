---
title: ssh远程连接
---
### **第一步：开启ssh server代理功能**

在位于公网[服务器](https://cloud.tencent.com/act/pro/promotion-cvm?from_column=20065&from=20065)上打开sshd的`GatewayPorts`开关，并重启sshd

代码语言：javascript

复制

```javascript
sed -i "s/#GatewayPorts no/GatewayPorts yes/g" /etc/ssh/sshd_config
```


```bash
systemctl restart ssh
#or
sudo systemctl restart sshd.service
```

打开代理功能意味着，当我们在建立ssh反向隧道后，监听的地址会从默认的127.0.0.1更换成0.0.0.0，方便ssh客户端远程登录。

### **第二步：建立ssh反向隧道**

在客户内网B中找一台能访问121.41.218.68地址的服务器，登录上去，并在终端内执行下述命令：

代码语言：javascript

复制

```javascript
ssh -lroot -p22 -qngfNTR 8822:localhost:22 121.41.218.68 -o ServerAliveInterval=10
```

这一步的关键信息其实就是在主机B和主机A之间建立一条SSH隧道，隧道端口的映射关系是`主机B:22 <--> 主机A:8822`

之所以加上ServerAliveInterval=10，是让客户端每10s发送一个心跳保持隧道的链接，否则这条连接很容易被重置。

### **第三步：本地ssh client代理**

目前有了ssh的隧道也只能满足我本地主机C能通过121.41.218.68的8822端口ssh登录到客户内网的B主机，还不能满足我进行批量运行任务的需求。

此时，我们就需要在自己电脑上配置ssh客户端的socket代理来满足需求，配置位于`～/.ssh/config`

代码语言：javascript

复制

```javascript
host hosta
    HostName 121.41.218.68
    Port 8822
    User root
   
host 10.155.0.*
    User root
    Port 22
    ProxyCommand ssh hosta -W %h:%p
```

至此，我就可以在本地用ansible-playbook无缝的进行操作了。

### **总结**

上述3步是整个ssh内网穿透的核心流程，如果要做得更加的优雅的话，我们还需要考虑几点优化：

- 为三台机器上的ssh客户端分别配置公私钥
- 为主机B上的ssh方向隧道创建服务进程，避免重启后隧道丢失
- 尽量保证公网主机A的[网络安全](https://cloud.tencent.com/product/ns?from_column=20065&from=20065)，可单独为隧道端口配置防火墙策略

当然，ssh反向隧道除了能代理ssh服务外，它也能对内网的其他服务做socket转发，这里本文就不再展开。总之，建立SSH反向隧道这种事情大多数情况都是迫于无奈的临时选择，我们在用完后要及时释放连接，避免长期闲置被不法分子盯上后带来的损失。