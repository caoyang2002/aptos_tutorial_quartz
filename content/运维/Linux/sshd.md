---
title: sshd_config
---
OpenSSH（即常说的ssh）的常用配置文件有两个`/etc/ssh/ssh_config` 和 `sshd_config`。，其中`ssh_config` 为客户端配置文件，设置与客户端相关的应用可通过此文件实现；`sshd_config` 为服务器配置文件，设置与服务器相关的应用可通过此文件实现。

一般来说我们常用的都是sshd_config配置文件，在sshd_config配置文件中，以`# `（#加空格）开头的是注释信息，以`#`开头的是默认配置信息。

1. `Port 22`
	设置sshd监听端口号，默认情况下为22，可以设置多个监听端口号，即重复使用Prot这个设置项。修改后记得重启sshd，以及在防火墙中添加端口。出于安全考虑，端口指定为小于等于65535，并且非22或22变种的值

2)ListenAddress 0.0.0.0  
   `ListenAddress ::` 
   设置sshd监听（绑定）的IP地址，`0.0.0.0`表示监听所有IPv4的地址。出于安全考虑，设置为指定IP地址，而非所有地址。`::` 是 IPv6 的地址不需要改。

3)`Protocol 2`  
　有部分 `sshd_config` 配置文件会有此选项。这个选项设置的是 `ssh` 协议版本，可以是 `1` 也可以是 `2`。出于安全考虑，设置为最新协议版本。

4)`HostKey /etc/ssh/ssh_host_rsa_key`  
   `HostKey /etc/ssh/ssh_host_dsa_key`  
   `HostKey /etc/ssh/ssh_host_ecdsa_key`  
   `HostKey /etc/ssh/ssh_host_ed25519_key`  
　`Hostkey` 设置包含私人密钥的文件

5)`SyslogFacility AUTH`  
   SyslogFacility AUTHPRIV  
　当有人使用ssh登录系统时，ssh会记录信息，记录类型为AUTHPRIV，sshd服务日志存放在/var/log/secure

6)`LogLevel INFO`
　设置记录sshd日志信息的级别

7)`LoginGraceTime 2m`  
　设置指定时间内没有成功登录，将会断开连接，若无单位则默认时间为秒。

8)`PermitRootLogin yes`  
　是否允许root登录，默认是允许的，但建议设置为no

9)`PasswordAuthentication yes`
　是否使用密码验证。当然也可以设置为no，不使用密码验证，转而使用密钥登录

10)`PermitEmptyPasswords no`
　 是否允许空密码的用户登录，默认为no，不允许

11)`PrintMotd yes`
　 打印登录提示信息，提示信息存储在/etc/moed文件中

12)`PrintLastLog yes`
　 显示上次登录信息。默认为yes

13)`UseDNS yes`
     禁止DNS反向解析,默认是yes，一般会注释

14)`UsePAM yes`
     是否启用PAM插件式认证模块，默认为yes


```bash
cat /etc/ssh/sshd_config 
```

```bash
# $OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $
#
# 这是 sshd 服务器的全局配置文件。 参见 sshd_config(5) 获取更多信息。

# 此 sshd 编译时的 PATH 环境变量值
# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented. Uncommented options override the
# default value.

#Port 22
# 指定 SSH 服务监听的端口，默认为 22
#AddressFamily any
# 指定地址族，any 表示监听 IPv4 和 IPv6
#ListenAddress 0.0.0.0
#ListenAddress ::
# 指定服务器监听的地址，0.0.0.0 表示监听所有 IPv4 地址，[::] 表示监听所有 IPv6 地址

#HostKey /etc/ssh/ssh_host_rsa_key
# 指定 SSH 主机密钥文件的位置
# Ciphers and keying
#RekeyLimit default none
# 指定何时重新生成会话密钥

# Logging
#SyslogFacility AUTH
# 指定系统日志记录设施
#LogLevel INFO
# 指定日志级别

# Authentication:
#LoginGraceTime 2m
# 指定登录尝试的超时时间
#PermitRootLogin prohibit-password
# 允许 root 用户登录，但是禁止使用密码
#StrictModes yes
# 开启严格模式，确保 sshd 在首次启动时检查文件权限
#MaxAuthTries 6
# 最大认证尝试次数
#MaxSessions 10
# 每个用户可以打开的最大会话数

#PubkeyAuthentication yes
# 启用公钥认证

#AuthorizedKeysFile .ssh/authorized_keys
# 指定存放用户公钥的文件
#AuthorizedPrincipalsFile none
#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

#HostbasedAuthentication no
# 是否启用基于主机的认证
#IgnoreUserKnownHosts no
# 是否忽略用户的 known_hosts 文件
#IgnoreRhosts yes
# 是否忽略 .rhosts 和 .shosts 文件

# PasswordAuthentication yes
# 是否允许使用密码认证
#PermitEmptyPasswords no
# 是否允许空密码

# Change to no to disable s/key passwords
ChallengeResponseAuthentication no
# 是否启用挑战响应认证

# Kerberos options
#KerberosAuthentication no
# 是否启用 Kerberos 认证

# GSSAPI options
#GSSAPIAuthentication no
# 是否启用 GSSAPI 认证

# Set this to 'yes' to enable PAM authentication
UsePAM yes
# 启用 PAM 认证

#AllowAgentForwarding yes
# 是否允许代理转发
AllowTcpForwarding no
# 是否允许 TCP 端口转发
#GatewayPorts no
# 是否允许远程主机通过网关端口连接
#X11Forwarding no
# 是否启用 X11 转发
#X11DisplayOffset 10
# X11 显示偏移量
#X11UseLocalhost yes
# 是否使用 localhost 进行 X11 转发
#PermitTTY yes
# 是否允许分配伪终端
#PrintMotd yes
# 是否在登录时打印 /etc/motd
#PrintLastLog yes
# 是否打印最后登录信息

#TCPKeepAlive yes
# 是否启用 TCP 保活机制
#PermitUserEnvironment no
# 是否允许用户环境变量

#Compression delayed
# 是否启用压缩

#ClientAliveInterval 0
# 指定客户端保活消息的发送间隔
#ClientAliveCountMax 3
# 客户端保活消息的最大未响应次数

#UseDNS no
# 是否使用 DNS

#PidFile /var/run/sshd.pid
# SSH 服务的 PID 文件位置

#MaxStartups 10:30:100
# 指定同时启动的最大连接数

#PermitTunnel no
# 是否允许隧道连接

ChrootDirectory none
# 指定使用 chroot 环境的目录

#VersionAddendum none
# 指定服务器版本附加信息

# no default banner path
#Banner none
# 是否显示默认的 banner 消息

# override default of no subsystems
#Subsystem	sftp	/usr/libexec/sftp-server
Subsystem       sftp    internal-sftp -f DAEMON -u 000
# 指定 sftp 子系统

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server
Match User root
	AllowTcpForwarding yes
# 为 root 用户开启 TCP 端口转发
Match User admin
	AllowTcpForwarding yes
# 为 admin 用户开启 TCP 端口转发
Match User anonymous
	AllowTcpForwarding no
	GatewayPorts no
# 为 anonymous 用户关闭 TCP 端口转发和网关端口
```














# 重启
要使对 `sshd_config` 文件的更改重新生效，您需要重启 SSH 服务。以下是在不同操作系统上重启 SSH 服务的常用方法：

1. **在基于 systemd 的系统上（如 Ubuntu 16.04 及更高版本，CentOS 7 等）**：
   ```bash
   sudo systemctl restart sshd
   ```

2. **在较旧的 Ubuntu 版本（使用 Upstart）**：
   ```bash
   sudo service ssh restart
   ```

3. **在基于 System V init 的系统上（如 CentOS 6 等）**：
   ```bash
   sudo /etc/init.d/sshd restart
   ```

4. **在 OpenBSD 或其他使用 OpenSSH 的系统上**：
   ```bash
   sudo /etc/rc.d/sshd restart
   ```

5. **在某些系统上，您可能需要重新加载配置文件而不是重启服务**：
   ```bash
   sudo systemctl reload sshd
   ```

6. **如果您没有 `systemctl` 或 `service` 命令，可以尝试直接杀死 sshd 进程并重新启动**：
   ```bash
   sudo pkill -u root -f sshd
   sudo sshd
   ```

7. **在某些特殊情况下，如果 SSH 服务是由其他守护进程管理的，您可能需要重启该守护进程**。

请注意，重启 SSH 服务可能会导致当前的 SSH 连接断开。因此，在执行这些操作之前，请确保通知所有相关用户，并在系统负载较低的时候进行。

另外，如果您更改了配置文件并希望立即应用更改，而不想重启服务，可以尝试使用 `reload` 选项，这将使服务重新读取配置文件而不中断现有连接。但是，不是所有的系统都支持这种无中断重载。

在对 `sshd_config` 或任何系统配置文件进行更改时，始终建议先备份原始文件，以防需要恢复到先前的状态。您可以使用以下命令来备份文件：

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```

然后，使用您喜欢的文本编辑器编辑 `sshd_config` 文件，并在保存更改后使用上述命令之一来重新加载或重启服务。




# 原配置
```config
#	$OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
#AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
ChallengeResponseAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
UsePAM yes

#AllowAgentForwarding yes
AllowTcpForwarding no
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
#Subsystem	sftp	/usr/libexec/sftp-server
Subsystem       sftp    internal-sftp -f DAEMON -u 000

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server
Match User root
	AllowTcpForwarding yes
Match User admin
	AllowTcpForwarding yes
Match User anonymous
	AllowTcpForwarding no
	GatewayPorts no
```