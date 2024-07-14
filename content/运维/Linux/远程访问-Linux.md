---
title: " 远程登录"
---
# Ubuntu:
## 1. 确保 Linux 服务器已启用 SSH
首先，确保您的 Linux 服务器上已经安装并运行了 SSH 服务。对于大多数 Linux 发行版，OpenSSH 是默认的 SSH 服务器。您可以使用以下命令来安装它：
```bash
sudo apt-get update
sudo apt-get install openssh-server
```

 然后，确保 SSH 服务正在运行：
```bash
sudo service ssh status
```

2. 获取 Linux 服务器的 IP 地址
在 Linux 服务器上，使用以下命令获取 IP 地址：
```bahs
ip addr
```

 记下其中的 IPv4 地址，例如 `192.168.1.123`

ssh root@192.168.1.100
 
 当首次连接到服务器时，系统会询问是否接受服务器的公钥。键入 yes 然后按 Enter。


 
常见问题一
出现 WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! 字样






# 问题
> [!ERROR] 错误
>
> ```bash
> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
> @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
> IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
> Someone could be eavesdropping on you right now (man-in-the-middle attack)!
> It is also possible that a host key has just been changed.
> The fingerprint for the ED25519 key sent by the remote host is
> SHA256:szvqLpQ/SLts7r0vptLOX3qzGzkokN5W0NCvhZA5ph0.
> Please contact your system administrator.
> Add correct host key in /Users/caoyang/.ssh/known_hosts to get rid of this message.
> Offending ECDSA key in /Users/caoyang/.ssh/known_hosts:3
> Password authentication is disabled to avoid man-in-the-middle attacks.
> Keyboard-interactive authentication is disabled to avoid man-in-the-middle attacks.
> UpdateHostkeys is disabled because the host key is not trusted.
> caoyang@101.43.125.94: Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).
> ```
>
> SSH 客户端（可能是您的计算机）检测到远程主机的身份验证信息已经发生了变化

原因 ：

这是 SSH 的一个安全警告。这种警告通常发生在以下情况：

目标服务器的公钥已更改。这可能是因为您重新安装了服务器、更换了服务器硬件或手动更改了服务器的 SSH 密钥。
有人尝试对您的连接进行中间人攻击（Man-in-the-Middle attack）。这种情况比较少见，但不能完全排除。
解决方法：

为了解决这个问题，您应该首先确定原因。如果您确信服务器的公钥已经合法更改，那么可以按照以下步骤解决：

打开终端或命令提示符。

使用以下命令删除指定 IP 地址的旧密钥条目：
```bash
ssh-keygen -R 121.12.12.12   # 删除本地旧的主机密钥条目，后面的 ip 为远程地址
```

之后，您可以再次尝试连接到服务器。在首次连接时，系统会提示您接受新的公钥。确认后即可正常连接。但是，如果您没有对服务器进行任何更改，并且对此警告感到不安，那么您应该进一步调查，以确保您的网络环境没有遭受攻击。

原文链接： https://blog.csdn.net/weixin_72910567/article/details/132418542