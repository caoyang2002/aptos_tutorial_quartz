---
title: 使用 ssh
aliases:
  - 使用 ssh
---

# 群晖

进入 DSM 的控制面板，打开 ssh

![](https://i0.hdslb.com/bfs/article/ef21fba838444a4163772afacddc42bc953e6942.png@1256w_540h_!web-article-pic.avif)
DSM打开ssh



# Windows

然后在windows下按win+r键，输入powershell，个人感觉这个比cmd更好用
![](https://i0.hdslb.com/bfs/article/4cf1d3524c178bb3560c8be9637b338caec7188d.png@!web-article-pic.avif)
Windows 打开shell
![](https://i0.hdslb.com/bfs/article/2cdd5ea111e840bded5027d5798bcc9ea0200b37.png@!web-article-pic.avif)

# `ssh` 登录群晖DSM
```bash
ssh username@192.168.1.100 -p 22
```


其中 `ssh` 是命令的名称，`username` 是在 NAS 中的 admin 用户名，`192.168.1.100` 是 NAS 的 IP，22是 ssh 的端口号。

输入回车后提示输入密码，这个密码就是登录 NAS 所需的密码，输入后再次回车登录进入了 NAS。

为了获取到最大权限便于操作，建议输入`sudo -i`回车，输入`账号` 、`密码`后进入 `root` 权限。

至此，不用使用第三方软件，也可以很方便的登录 NAS 的 shell 了。

建议大家对 Linux 的 `top`, `iostat`, `swap` 工具有初步了解，便于分析。前两者也可以使用群晖的性能监控代替。