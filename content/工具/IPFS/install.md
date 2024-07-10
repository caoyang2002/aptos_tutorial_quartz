---
title: 安装 IPFS
---
# Linux
[查看原文](https://docs.ipfs.tech/install/command-line/#install-official-binary-distributions)

```bash
wget https://dist.ipfs.tech/kubo/v0.29.0/kubo_v0.29.0_linux-amd64.tar.gz
```

```bash
tar -xvzf kubo_v0.29.0_linux-amd64.tar.gz

> x kubo/install.sh
> x kubo/ipfs
> x kubo/LICENSE
> x kubo/LICENSE-APACHE
> x kubo/LICENSE-MIT
> x kubo/README.md
```


```bash
cd kubo
```

```bash
sudo bash install.sh

> Moved ./ipfs to /usr/local/bin
```


> 示例
```bash
[root@VM-4-2-centos ~]# wget https://dist.ipfs.tech/kubo/v0.29.0/kubo_v0.29.0_linux-amd64.tar.gz
--2024-07-07 15:21:35--  https://dist.ipfs.tech/kubo/v0.29.0/kubo_v0.29.0_linux-amd64.tar.gz
Resolving dist.ipfs.tech (dist.ipfs.tech)... 209.94.78.1, 2602:fea2:3::1
Connecting to dist.ipfs.tech (dist.ipfs.tech)|209.94.78.1|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 39021375 (37M) [application/gzip]
Saving to: 'kubo_v0.29.0_linux-amd64.tar.gz'

100%[============================================================================================================>] 39,021,375   114KB/s   in 7m 25s 

2024-07-07 15:29:01 (85.7 KB/s) - 'kubo_v0.29.0_linux-amd64.tar.gz' saved [39021375/39021375]

[root@VM-4-2-centos ~]# tar -xvzf kubo_v0.29.0_linux-amd64.tar.gz
kubo/LICENSE
kubo/LICENSE-APACHE
kubo/LICENSE-MIT
kubo/README.md
kubo/build-log
kubo/install.sh
kubo/ipfs
[root@VM-4-2-centos ~]# cd kubo/
[root@VM-4-2-centos kubo]# sudo bash install.sh
Moved ./ipfs to /usr/local/bin
[root@VM-4-2-centos kubo]# ipfs --version
ipfs version 0.29.0
[root@VM-4-2-centos kubo]# 
```
## mac

```bash
brew install ipfs
```

```bash
ipfs --version
```

