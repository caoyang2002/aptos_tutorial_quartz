---
title: Ubuntu 安装 npc
---
# 使用 docker 部署

```bash
docker pull 
```


```bash
docker run -d --name npc --net=host ffdfgdfg/npc -server=caoyang2002.top:20003 -vkey=xxxxxxxxxxxxxxxx -type=tcp
```



---
> [github](https://github.com/ehang-io/nps/tree/master)

> [官方文档](https://ehang-io.github.io/nps/#/install) 

>[!TIP] 提示
>其实所有的配置都不推荐修改，但是如果改了一个配置一定要理解为什么改，以及会影响到什么，请务必打开服务器的端口（防火墙）。{/bs-font}
>
> 以下不一定能用，因为我搞了许久才发现是我没打开服务器防火墙，而导致无法访问。
简单说：服务器的配置建议改一下，主要是你服务器可能把8080端口占用了，其余的所有都可以不用改。又不是不能用。

# 服务端安装 nps

需要公网服务器，我服务器的是腾讯云，用的 docker 管理

## 1. 如果没下载 Docker

> 下载docker，使用包管理器下载，`yum install -y docker`

## 2. 创建nps的配置文件夹，

可以自定义，我创建的命令是 `mkdir /opt/nps/conf`

## 3. 拉取docker image

`docker pull ffdfgdfg/nps`，可以使用`docker images`查看是否拉取成功

## 4. 在nps的github下载配置文件

GitHub 下载地址 https://github.com/ehang-io/nps/blob/master/conf/nps.conf

也可以在 gitee 下载 https://gitee.com/mirrors/nps/tree/master/conf 把配置文件放在之前创建的 `/opt/nps/conf`

## 5. 修改配置文件（也可以不改，见8）

具体文件内容在文末，修改nps.conf中的端口号，在nps.conf中将https_just_proxy设置为true，并且打开https_proxy_port端口，然后nps将直接转发https请求到内网服务器上，由内网服务器进行https处理

## 6. 运行
 `docker run -d -p 20000-20010:20000-20010 -v /opt/nps/conf:/conf --name=nps ffdfgdfg/nps` 解释：`-d`:后台运行容器，并返回容器ID；`-p`: 指定端口映射，格式为：主机(宿主)端口:容器端口;  `20000-20010:20000-20010`: 主机(宿主)端口:(docker)容器端口; `-v`:绑定一个卷;  ` /opt/nps/conf:/conf`: (宿主)目录: docker目录 `-name=nps`: 为容器指定一个名称； `ffdfgdfg/nps`:镜像，【应该是这个意思】
 
如果报错，查看镜像是否存在 `docker iamge`; 查看运行状态 `docker ps -a` 删除容器 `docker rm 容器名或id` 停止运行`docker stop 容器名或id`

使用默认配置 `docker run --net=host --name nps_server -d ffdfgdfg/nps` ，解释 `--net="bridge"`: 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；

通过公网ip访问：`你的公网ip`:`你设置的端口` 比如：8.8.8.8:20003, 默认端口`20003`

> 后续发现停止运行了, 可以使用 `docker start nps` 启动 nps 服务 

> 面板上的客户端就是实体设备，客户端通过这里设置的秘钥访问nps
> 面板上的隧道就是设备上的端口，只要你客户端配置好了，隧道就自动在线了。隧道的就是客户端 id + 客户端端口 + 服务器映射端口（给公网访问）

# 客户端安装 npc
## 1. 拉取docker image
`docker pull ffdfgdfg/npc`
## 2. 配置文件见文末
不推荐修改配置
## 3. 未修改配置文件启动
1. 在服务端打开面板
2. 客户端 -> 新增（可以不用配置，改改备注就行）-> 新增；
3. 点击新增条目左边的加号，获取客户端命令。类似于：./npc -server=8.8.8.8:20002 -vkey=fds4322we232w -type=tcp；`./nps`可以不用复制，命令其余部分复制下来，用于配置客户端docker
5.  运行 `docker run -d --name npc --net=host ffdfgdfg/npc -server=ip地址:20002 -vkey=z8uxxxxxxxxx -type=tcp` 

## 6. 配置文件启动
没用过，不瞎解释。
1. 主要是修改启动`server_addr` 改为你自己的地址
`docker run -d -p 18080-18090:8080-8090 -v /root/npc/conf:/conf --name=npc ffdfgdfg/npc`

# 配置文件
## nps.conf
```c
appname = nps
runmode = dev

http_proxy_ip=0.0.0.0
http_proxy_port=20000  # http访问
https_proxy_port=20001 # https访问
https_just_proxy=true # 仅https代理

https_default_cert_file=conf/server.pem
https_default_key_file=conf/server.key

bridge_type=tcp
bridge_port=20002  # 
bridge_ip=0.0.0.0

public_vkey=123

log_level=7

web_host=a.o.com
web_username=admin #用户名
web_password=123  # 密码
web_port = 20003 # 记住这个端口，这是管理面板的端口
web_ip=0.0.0.0
web_base_url=
web_open_ssl=false
web_cert_file=conf/server.pem
web_key_file=conf/server.key
auth_crypt_key =1234567887654321
allow_user_login=false
allow_user_register=false
allow_user_change_username=false
allow_flow_limit=false
allow_rate_limit=false
allow_tunnel_num_limit=false
allow_local_proxy=false
allow_connection_num_limit=false
allow_multi_ip=false
system_info_display=false
http_cache=false
http_cache_length=100
http_add_origin_header=false
```

配置文件（/etc/nps/conf/nps.conf）的含义：
```c
名称	含义
web_port	web管理端口
web_password	web界面管理密码
web_username	web界面管理账号
web_base_url	web管理主路径,用于将web管理置于代理子路径后面
bridge_port	服务端客户端通信端口
https_proxy_port	域名代理https代理监听端口
http_proxy_port	域名代理http代理监听端口
auth_key	web api密钥
bridge_type	客户端与服务端连接方式kcp或tcp
public_vkey	客户端以配置文件模式启动时的密钥，设置为空表示关闭客户端配置文件连接模式
ip_limit	是否限制ip访问，true或false或忽略
flow_store_interval	服务端流量数据持久化间隔，单位分钟，忽略表示不持久化
log_level	日志输出级别
auth_crypt_key	获取服务端authKey时的aes加密密钥，16位
p2p_ip	服务端Ip，使用p2p模式必填
p2p_port	p2p模式开启的udp端口
pprof_ip	debug pprof 服务端ip
pprof_port	debug pprof 端口
disconnect_timeout	客户端连接超时，单位 5s，默认值 60，即 300s = 5mins
```


默认配置
```c
appname = nps
#Boot mode(dev|pro)
runmode = dev

#HTTP(S) proxy port, no startup if empty
http_proxy_ip=0.0.0.0
http_proxy_port=80
https_proxy_port=443
https_just_proxy=true
#default https certificate setting
https_default_cert_file=conf/server.pem
https_default_key_file=conf/server.key

##bridge
bridge_type=tcp
bridge_port=8024
bridge_ip=0.0.0.0

# Public password, which clients can use to connect to the server
# After the connection, the server will be able to open relevant ports and parse related domain names according to its own configuration file.
public_vkey=123

#Traffic data persistence interval(minute)
#Ignorance means no persistence
#flow_store_interval=1

# log level LevelEmergency->0  LevelAlert->1 LevelCritical->2 LevelError->3 LevelWarning->4 LevelNotice->5 LevelInformational->6 LevelDebug->7
log_level=7
#log_path=nps.log

#Whether to restrict IP access, true or false or ignore
#ip_limit=true

#p2p
#p2p_ip=127.0.0.1
#p2p_port=6000

#web
web_host=a.o.com
web_username=admin
web_password=123
web_port = 8080
web_ip=0.0.0.0
web_base_url=
web_open_ssl=false
web_cert_file=conf/server.pem
web_key_file=conf/server.key
# if web under proxy use sub path. like http://host/nps need this.
#web_base_url=/nps

#Web API unauthenticated IP address(the len of auth_crypt_key must be 16)
#Remove comments if needed
#auth_key=test
auth_crypt_key =1234567812345678

#allow_ports=9001-9009,10001,11000-12000

#Web management multi-user login
allow_user_login=false
allow_user_register=false
allow_user_change_username=false


#extension
allow_flow_limit=false
allow_rate_limit=false
allow_tunnel_num_limit=false
allow_local_proxy=false
allow_connection_num_limit=false
allow_multi_ip=false
system_info_display=false

#cache
http_cache=false
http_cache_length=100

#get origin ip
http_add_origin_header=false

#pprof debug options
#pprof_ip=0.0.0.0
#pprof_port=9999

#client disconnect timeout
disconnect_timeout=60
```
## npc.conf
```c
[common]
server_addr=1.1.1.1:8024
conn_type=tcp
vkey=123
username=111
password=222
compress=true
crypt=true
rate_limit=10000
flow_limit=100
remark=test
max_conn=10
#pprof_addr=0.0.0.0:9999
```

```c
项	含义
server_addr	服务端ip/域名:port
conn_type	与服务端通信模式(tcp或kcp)
vkey	服务端配置文件中的密钥(非web)
username	socks5或http(s)密码保护用户名(可忽略)
password	socks5或http(s)密码保护密码(可忽略)
compress	是否压缩传输(true或false或忽略)
crypt	是否加密传输(true或false或忽略)
rate_limit	速度限制，可忽略
flow_limit	流量限制，可忽略
remark	客户端备注，可忽略
max_conn	最大连接数，可忽略
pprof_addr	debug pprof ip:port
```

通过域名访问
```c
[common]
server_addr=域名:20002
conn_type=https
vkey=123
auto_reconnection=true
max_conn=1000
flow_limit=1000
rate_limit=1000
basic_username=11
basic_password=3
web_username=user
web_password=1234
crypt=true
compress=true
#pprof_addr=0.0.0.0:9999
disconnect_timeout=60

[health_check_test1]
health_check_timeout=1
health_check_max_failed=3
health_check_interval=1
health_http_url=/
health_check_type=http
health_check_target=127.0.0.1:8083,127.0.0.1:8082

[health_check_test2]
health_check_timeout=1
health_check_max_failed=3
health_check_interval=1
health_check_type=tcp
health_check_target=127.0.0.1:8083,127.0.0.1:8082

[web]
host=域名
target_addr=127.0.0.1:8080

```

说明
```c
[common]
server_addr=1.1.1.1:8024
vkey=123
[web1]
host=a.proxy.com
target_addr=127.0.0.1:8080,127.0.0.1:8082
host_change=www.proxy.com
header_set_proxy=nps
```
