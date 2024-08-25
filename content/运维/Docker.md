---
title: Docker
---
# 设置镜像
```bash

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<EOF
{
    "registry-mirrors": [
        "https://hub.uuuadc.top",
        "https://docker.anyhub.us.kg",
        "https://dockerhub.jobcher.com",
        "https://dockerhub.icu",
        "https://docker.ckyl.me",
        "https://docker.awsl9527.cn"
    ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

2. 使用DockerHub Proxy，以下以 `hub.uuuadc.top` 为例：可以根据列表自行替换

```shell
docker pull hub.uuuadc.top/library/mysql:5.7
```

说明：`library` 是一个特殊的命名空间，它代表的是官方镜像。如果是某个用户的镜像就把 `library` 替换为镜像的用户名
> 例如 clash 
```bash
# 官方下载
docker pull dreamacro/clash 
# 镜像下载
docker pull hub.uuuadc.top/dreamacro/clash 
```

原文链接：[https://www.wangdu.site/course/2109.html](https://www.wangdu.site/course/2109.html)



>  如果无法找到 `docker.service` Unit 文件
>  
1. **检查服务名称**：
   确认服务名称是否正确。使用以下命令列出所有 Docker 相关的服务：
   ```sh
   systemctl list-units | grep docker
   ```

2. **检查 Docker 服务文件**：
   确认 `/etc/systemd/system/` 目录下是否存在 `docker.service` 文件：
   ```sh
   ls /etc/systemd/system/docker.service
   ```

3. **重新加载 systemd 配置**：
   如果 Docker 已经安装，但服务未运行，尝试重新加载 systemd 配置：
   ```sh
   sudo systemctl daemon-reload
   ```

4. **启动 Docker 服务**：
   如果 Docker 已安装，使用以下命令启动 Docker 服务：
   ```sh
   sudo systemctl start docker
   ```

5.  **设置 Docker 开机自启**：
   如果希望 Docker 在系统启动时自动启动，使用以下命令设置：
   ```sh
   sudo systemctl enable docker
   ```

6. **检查 Docker 状态**：
   使用以下命令检查 Docker 服务的状态：
   ```sh
   sudo systemctl status docker
   ```

7. **查看日志**：
   如果 Docker 服务启动失败，查看日志以获取更多错误信息：
   ```sh
   journalctl -u docker
   ```

> 在群晖中：
1. **Docker 容器管理器服务**：`pkg-ContainerManager-dockerd.service` 表明 Docker 服务正在运行。

2. **Docker 网络设备**：`sys-devices-virtual-net-docker0.device` 和 `sys-subsystem-net-devices-docker0.device` 是 Docker 创建的虚拟网络设备。

3. **Docker 挂载点**：`volume1-\x40docker.mount` 表明 Docker 的数据卷可能挂载在 `/volume1/@docker`。

既然 Docker 服务已经在运行，如果您之前收到了 "No such file or directory" 的错误，可能是因为您使用了错误的服务名称或者在错误的上下文中执行了命令。

### 正确的重启 Docker 服务命令：

```sh
sudo systemctl restart pkg-ContainerManager-dockerd.service
```

或者，如果您想使用 `docker` 作为服务名称，您可能需要链接它到实际的服务名称。这可以通过创建一个符号链接来实现：

```sh
sudo ln -s /lib/systemd/system/pkg-ContainerManager-dockerd.service /etc/systemd/system/docker.service
```

然后，您可以使用 `docker.service` 来控制 Docker 服务：

```sh
sudo systemctl restart docker.service
```

### 检查 Docker 状态：

```sh
sudo systemctl status pkg-ContainerManager-dockerd.service
# 或者，如果您创建了符号链接
sudo systemctl status docker.service
```



# 常用命令
Docker 是一个开源的应用容器引擎，它允许开发者打包应用及其依赖到一个可移植的容器中，并发布到任何流行的 Linux 机器上，也可以实现虚拟化。以下是一些常用的 Docker 命令：

### 1. 安装 Docker
- **安装 Docker Engine**：
  ```sh
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  ```
- **安装特定版本的 Docker**：
  ```sh
  curl -L https://get.docker.com | sh -s docker-latest-<VERSION>
  ```

### 2. 启动和停止 Docker 服务
- **启动 Docker 服务**：
  ```sh
  sudo systemctl start docker
  ```
- **停止 Docker 服务**：
  ```sh
  sudo systemctl stop docker
  ```

### 3. 检查 Docker 版本
- **查看 Docker 版本**：
  ```sh
  docker --version
  ```

### 4. 拉取和推送镜像
- **拉取镜像**：
  ```sh
  docker pull [OPTIONS] NAME[:TAG|@DIGEST]
  ```
- **推送镜像**：
  ```sh
  docker push [OPTIONS] NAME[:TAG]
  ```

### 5. 列出镜像和容器
- **列出所有镜像**：
  ```sh
  docker images
  ```
- **列出所有容器**：
  ```sh
  docker ps
  ```

### 6. 运行和停止容器
- **运行容器**：
  ```sh
  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
  ```
- **停止容器**：
  ```sh
  docker stop CONTAINER
  ```

### 7. 进入容器和退出
- **进入容器**：
  ```sh
  docker exec -it CONTAINER COMMAND
  ```
- **退出容器**：
  ```sh
  exit
  ```

### 8. 删除镜像和容器
- **删除镜像**：
  ```sh
  docker rmi IMAGE
  ```
- **删除容器**：
  ```sh
  docker rm CONTAINER
  ```

### 9. 查看容器日志
- **查看日志**：
  ```sh
  docker logs CONTAINER
  ```

### 10. 构建镜像
- **构建镜像**：
  ```sh
  docker build -t NAME ./path
  ```

### 11. 网络操作
- **查看 Docker 网络**：
  ```sh
  docker network ls
  ```
- **创建网络**：
  ```sh
  docker network create NETWORK
  ```
- **连接网络**：
  ```sh
  docker network connect NETWORK CONTAINER
  ```

### 12. 卷操作
- **查看卷**：
  ```sh
  docker volume ls
  ```
- **创建卷**：
  ```sh
  docker volume create VOLUME
  ```
- **使用卷**：
  ```sh
  docker run -v VOLUME:/container/path IMAGE
  ```

### 13. 清理 Docker
- **清理悬空镜像**：
  ```sh
  docker image prune
  ```
- **清理停止的容器**：
  ```sh
  docker container prune
  ```

### 14. Docker Compose
- **使用 Docker Compose**：
  ```sh
  docker-compose up
  ```

这些命令覆盖了 Docker 的基本操作，包括镜像管理、容器管理、网络和卷操作等。在使用 Docker 时，建议查阅 Docker 官方文档以获取更详细的命令选项和使用示例。

