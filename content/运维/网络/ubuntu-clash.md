---
title: Ubuntu 安装 clash
---
# Docker


## 下载 clash

```bash
sudo docker pull dreamacro/clash
```

## 下载 yacd

```bash
sudo docker pull haishanh/yacd
```
## 启动 clash

```bash
sudo docker run -d --name clash -p 7890:7890 -p 7891:7891 -v /home/ubuntu/.config/clash/config.yaml:/root/.config/clash/config.yaml dreamacro/clash
```

or

```bash
sudo docker run --name clash -p 7890:7890 -p 7891:7891 \
   -v /home/ubuntu/.config/clash/config.yaml:/root/.config/clash/config.yaml \
   dreamacro/clash
```
## 查看 clash 容器内的目录

```bash
sudo docker exec clash ls /root/.config/clash/
```

## 查看 docker 容器中的 clash 配置文件是否存在
```bash
sudo docker exec clash cat /root/.config/clash/config.yaml
```

## 启动 yacd
```bash
sudo docker run --name yacd --link clash:clash -p 9090:80 -v  /home/ubuntu/.config/clash/config.yaml:/usr/share/nginx/html/configs/config.yaml --rm haishanh/yacd

```

## 检查 docker 中 yacd 的配置文件是否存在

```bash
sudo docker exec yacd cat /usr/share/nginx/html/configs/config.yaml
```

```bash
sudo docker run -p 9090:80 -d --rm haishanh/yacd
```

```bash
sudo docker ps -a
```

1. 现在，Clash 和 Yade 已经成功运行在容器中。要访问 Yade 页面，请在浏览器中输入 `http://<your_server_ip>:9090`。将 `<your_server_ip>` 替换为您的服务器 IP 地址。默认情况下，Yade 将与 Clash 在同一台服务器上运行。  
    通过以上步骤，您已经成功使用 Docker 一键安装了 Clash 代理管理工具和 Yade 页面。现在，您可以使用 Clash 管理您的代理规则和配置，并使用 Yade 进行实时监控和管理。  
    请注意，以上步骤仅适用于基本的 Clash 和 Yade 安装。根据您的实际需求，您可能需要对 Clash 和 Yade 进行进一步的配置和优化。建议您查阅 Clash 和 Yade 的官方[文档](https://cloud.baidu.com/product/doc.html)以获取更多详细信息和高级配置选项。  
    另外，如果您希望将 Clash 和 Yade 与其他工具或服务集成，请参考相关文档和社区资源以获取更多信息和示例。Clash 和 Yade 的社区非常活跃，您可以轻松找到其他用户分享的集成方案和最佳实践。  
    希望本文能帮助您快速上手 Clash 和 Yade 的 Docker 安装及使用。如有任何疑问或需要进一步帮助，请随时提问或查看相关文档。祝您在使用 Clash 和 Yade 的过程中获得愉快的体验！


```bash
# 停止容器
sudo docker stop clash
# 启动容器
sudo docker start clash
```
---

## 创建项目

1. 创建一个目录 clash，进入
```bash
mkdir clash
cd clash
```
2. 创建 `configs` 文件夹，放入自己的订阅文件，修改订阅文件名为`config.yaml`，不清楚怎么得到订阅文件可以看上一篇（linux 安装 clash）
```bash
mkdir configs
vim config.yaml
```
3. 创建 `docker-compose.yml`
```bash
cd ..
# in clash folder
vim docker-compose.yml
```

内容
```yaml
version: '3'

services:
  # Clash
  clash:
    image: dreamacro/clash:latest
    container_name: clash
    volumes:
      - ./configs/config.yaml:/root/.config/clash/config.yaml
    ports:
      - "7890:7890/tcp"
      - "7890:7890/udp"
      - "9090:9090"
    restart: always

  clash-dashboard:
    image: centralx/clash-dashboard
    container_name: clash-dashboard
    ports:
      - "7880:80"
    restart: always
```

这里

- clash的控制接口映射在 9090 端口上
- dashboard 映射在了宿主 7880 端口，默认只能通过 http 访问，可根据需要再做反向代理

## 修改订阅配置文件

### 开放控制端口

如果要使用clash-dashboard，则必须将clash的控制接口9090端口开放访问。

请检查订阅的配置文件中`external-controller`这一项是`0.0.0.0:9090`，否则dashboard无法获取和控制clash配置信息，一般这里默认是`127.0.0.1`

```
external-controller: '0.0.0.0:9090'
```

![image.png](https://oss.silon.vip/img/3290fdf04944ef9365b4aa6f86319b85.image.png)

### 添加控制配置密码（用于dashboard）

```
# 在external-controller下一行
secret: '你的密码'
```

![image.png](https://oss.silon.vip/img/4040b08aa28dbc1748988b7d8417943e.image.png)

## 运行

启动守护进程
```bash
sudo systemctl start docker
# 检查状态
sudo systemctl status docker
```



```
docker-compose up --build -d
```

ERROR
```bash
$ docker-compose up --build -d
ERROR: Couldn't connect to Docker daemon at http+docker://localhost - is it running?
If it's at a non-standard location, specify the URL with the DOCKER_HOST environment variable.
```

使用 sudo

```bash
sudo docker-compose up --build -d
```

![image.png](https://oss.silon.vip/img/8b46e0e0ea9e2c036965aaa3f10e5fb7.image.png)

![image.png](https://oss.silon.vip/img/f4b61e24d7745872d4a4bb08db43ba6e.image.png)


本文作者:Silon汐冷
本文链接:https://silon.vip/post/51

---

# 方法二：使用二进制安装 Clash

## 下载

Github 上的 clash 官方仓库已经删库跑路，本文介绍的是一个目前可行的解决方案。

在 https://github.com/doreamon-design/clash/releases 下载与自己系统架构符合的安装包。一般选择 [clash_2.0.24_linux_amd64.tar.gz](https://github.com/doreamon-design/clash/releases/download/v2.0.24/clash_2.0.24_linux_amd64.tar.gz)。

```bash
wget https://github.com/doreamon-design/clash/releases/download/v2.0.24/clash_2.0.24_linux_amd64.tar.gz
# or
wget https://gitclone.com/github.com/doreamon-design/clash/releases/download/v2.0.24/clash_2.0.24_linux_amd64.tar.gz
```

## 安装

## 解压
```bash

tar -zxvf clash_2.0.24_linux_amd64.tar.gz 

# or
gzip -d clash_2.0.24_linux_amd64.tar.gz 
tar -xvf clash_2.0.24_linux_amd64.tar
```
> `.tar`文件和 `.tar.gz` 文件的区别：
>
> `.tar` 文件和 .tar.gz 文件都是使用 tar（tape archive）格式来存储文件和目录的归档文件。它们的区别在于**是否经过压缩**。
>
> `.tar` 文件：`.tar` 文件是未经过压缩的纯归档文件。它将多个文件和目录组合成单个文件，但不会对其进行压缩。因此，`.tar` 文件的大小通常比其原始文件的总和要大。
>
> `.tar.gz` 文件：`.tar.gz` 文件是经过 gzip 压缩的 tar 文件。它首先将多个文件和目录组合成单个 `.tar` 文件，然后通过 `gzip` 压缩算法对其进行压缩。这样可以减小文件的大小，节省存储空间和传输带宽。
>
> ERROR:
>
> gzip: stdin: not in gzip format tar: Child returned status 1 tar: Error is not recoverable: exiting now
>
> 输入：`file filename.tar` 查看文件类型

```bash
# 给解压后的文件赋予执行权限
chmod +x clash
# 移动文件位置
sudo mv clash /usr/local/bin/clash 
# 查看是否成功安装
clash -v 
```

## 配置文件

```bash
 # 启动 Clash，生成 ~/.config/clash/config.yaml 文件
clash
# 进入目录配置文件
cd ~/.config/clash/ 
# 把订阅地址的配置文件导入本地配置文件
wget -O config.yaml 订阅地址 
# 配置环境变量
echo -e "export http_proxy=http://127.0.0.1:7890\nexport https_proxy=http://127.0.0.1:7890" >> ~/.bashrc 
```

启动后在打开 http://clash.razord.top/#/settings 进入节点管理的 UI 页面。

>[!TIP]
>clash 在linux系统中配置时发生错误
>
>根据clash官网的 `linux使用教程` 进行到第3步启动clash
>
>```bash
>./clash -d
>```
>
>
>报以下错误
>
>```bash
>INFO[0000] Can't find MMDB, start download
>FATA[0000] Initial configuration directory error: can't initial MMDB: can't download MMDB: Get "https://cdn.jsdelivr.net/gh/Dreamacro/maxmind-geoip@release/Country.mmdb": proxyconnect tcp: dial tcp 127.0.0.1:7890: connect: connection refused 
>```
>
>
>原因：端口占用导致clash无法识别的问题
>
>> 解决办法
>
>查看端口是否占用
>
>```bash
>export | grep -i proxy
>declare -x http_proxy="http://127.0.0.1:7890"
>declare -x https_proxy="http://127.0.0.1:7890"
>```
>
>
>运行完上述指令不返回任何信息，接下来
>
>取消端口占用
>
>```bash
>unset http_proxy https_proxy 
>export | grep -i proxy
>```
>
>
>完成上述操作，按照官网指令重新下载config.yaml,发现可以下载 config.yaml
>
>```bash
>wget -O config.yaml "xxxxxxx为clash提供的网址" 
>```
>
>
>
>结果:
>
>正在保存至: “config.yaml”
>
>config.yaml         100%[===================>] 172.22K  1021KB/s    用时 0.2s  
>
>2023-07-14 16:05 已保存 “config.yaml” [176349/176349])
>继续按clash网站教程即可
>
>之后每次使用一下代码启用clash
>
>```bash
>./clash -f config.yaml
>```
>
>
>
>
>
>
>

## 可能需要下载 MMDB
```bash
wget https://cdn.jsdelivr.net/gh/Dreamacro/maxmind-geoip@release/Country.mmdb
# or
curl -o Country.mmdb https://cdn.jsdelivr.net/gh/Dreamacro/maxmind-geoip@release/Country.mmdb
```

## 修改系统代理

在 Ubuntu 系统中：Settings - Network - Network Proxy 中按照下图配置：

```
Manual

HTTP Proxy 127.0.0.1 7890
HTTPS Proxy 127.0.0.1 7890
Socks Host 127.0.0.1 7891
Ignore Hosts localhost, 127.0.0.0/8, ::1
```

![img](https://eaglebear2002.github.io/%E6%8A%80%E6%9C%AF%E7%A7%91%E6%99%AE/Ubuntu%2022.04%20%E5%AE%89%E8%A3%85%20Clash/image-20231117105018053.png)

## 设置开机启动

实测使用配置 clash 服务和 `systemctl enable clash` 的方式启动的 clash 的路由规则很奇怪，对大多数地址没有作用，具体原因不明。

我的解决方案是配置 `~/.bashrc` 文件，在文件结尾添加如下内容：

```
# Check if Clash is already running
if ! pgrep -x "clash" > /dev/null; then
    /usr/local/bin/clash
fi
```

该脚本将在开机时自动执行命令 `/usr/local/bin/clash`。

另一种优雅的解决方案：在 Startup Applications Preference 中添加 Clash。
```absh
Name Clash
command /usr/local/bin/clash
```

![img](https://eaglebear2002.github.io/%E6%8A%80%E6%9C%AF%E7%A7%91%E6%99%AE/Ubuntu%2022.04%20%E5%AE%89%E8%A3%85%20Clash/image-20231117234841516.png)

## 调试 Clash

如果安装使用过程中出现任何问题，可以查看 Clash 的路由日志进行解决。

![img](https://eaglebear2002.github.io/%E6%8A%80%E6%9C%AF%E7%A7%91%E6%99%AE/Ubuntu%2022.04%20%E5%AE%89%E8%A3%85%20Clash/image-20231117105918115.png)

修改 `~/.config/clash/config.yaml` 配置文件，文件内容如下：

```
port: 7890
socks-port: 7891
redir-port: 7892
allow-lan: false # 是否允许 LAN 连接
mode: global # global, rule, direct 等模式
log-level: debug # debug, info, warn, error, silent, default 等日志级别，其中 debug 细节最多，适合调试
external-controller: '0.0.0.0:9090'
secret: ''
proxies:
	...
```

## 常见问题

如果启动 clash 后显示端口被占用：

![img](https://eaglebear2002.github.io/%E6%8A%80%E6%9C%AF%E7%A7%91%E6%99%AE/Ubuntu%2022.04%20%E5%AE%89%E8%A3%85%20Clash/image-20231117105816936.png)

使用命令查看被占用的端口，再杀死相应进程。

```
netstat -tulpn
```