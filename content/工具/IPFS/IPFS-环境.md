# IPFS环境搭建

我们可以自己搭建节点，也可以用商业版；

自己搭建的IPFS节点，图片只是存储在本地节点，如果节点关闭，所有的图片资源都会丢失，如果要图片永久保存，就需要IPFS Pin服务；

> 如果用商业版IPFS节点，可以不搭建IPFS节点，可以忽略本节内容

### 下载ipfs

在github上访问IPFS库，进入release页面

[https://github.com/ipfs/go-ipfs/releases](https://github.com/ipfs/go-ipfs/releases)

下载最新版本IPFS客户端，例如 `go-ipfs_v0.12.1_linux-amd64.tar.gz`

### 安装IPFS

```
tar xvf go-ipfs_v0.12.1_linux-amd64.tar.gz
cd go-ipfs
./install.sh
```

### 初始化IPFS

```
ipfs init
```

初始化后，会在本地

### IPFS配置

打开`~/.ipfs/config`

```
  "Addresses": {
    "Swarm": [
      "/ip4/0.0.0.0/tcp/4001",
      "/ip6/::/tcp/4001",
      "/ip4/0.0.0.0/udp/4001/quic",
      "/ip6/::/udp/4001/quic"
    ],
    "Announce": [],
    "AppendAnnounce": [],
    "NoAnnounce": [],
    "API": "/ip4/127.0.0.1/tcp/5001",
    "Gateway": "/ip4/127.0.0.1/tcp/8080"
  }
```

以上是ipfs配置中最常用的配置

|配置值|默认端口|描述|权限|
|---|---|---|---|
|API|5001|提供webui服务, 用于管理控制IPFS，上传ipfs文件时，请求的就是这个端口；|如果允许外部访问IPFS，需要将`127.0.0.1`修改为`0.0.0.0`|
|Gateway|8080|访问ipfs文件服务，可通过`http://ip:8080/ipfs/{hash值}`访问上传到节点的文件；|如果允许外部访问IPFS，需要将`127.0.0.1`修改为`0.0.0.0`|
|Swarm|4001|监听其他IPFS节点，同步节点数据|-|

### 启动IPFS

```
ipfs daemon
```

### 后台启动IPFS

可以在后台运行ipfs

```
cd /lib/systemd/system
vim ipfs.service
```

编写`ipfs.service`文件

```
[Unit]
Description=IPFS daemon
After=network.target

[Service]
ExecStart=/usr/local/bin/ipfs daemon

[Install]
WantedBy=multiuser.target
```

后台启动ipfs

```
systemctl start ipfs
```

验证是否启动成功

```
lsof -i:5001
```

如果显示如下，则表示启动成功

```
COMMAND    PID USER   FD   TYPE  DEVICE SIZE/OFF NODE NAME
ipfs    864557 root   13u  IPv4 4444691      0t0  TCP localhost:commplex-link (LISTEN)
```

### 配置ipfs跨域

```
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT","GET", "POST", "OPTIONS"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials '["true"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Headers '["Authorization"]'
ipfs config --json API.HTTPHeaders.Access-Control-Expose-Headers '["Location"]'
```

外部访问：

```bash
http://doname.or.ip:8080/ipfs/QmTLwSA7qhtNAsem7qrDScmmCaCCUnutXHWbVsVHFvSuc8/
```

[查看原文](https://fingernft-doc.fingerchar.com/zh/)
