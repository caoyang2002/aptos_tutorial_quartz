---
title: 群晖 DS220J ARM 架构机型安装使用 docker
aliases:
  - 群晖 DS220J ARM 架构机型安装使用 docker
---
https://www.moluyao.wang/31735.html

群晖的 ARM 机型默认不支持 docker，少了不少折腾的乐趣。本文记录了在白群晖 ARM 机型下安装 docker的过程。

> 现在已经可以使用 `Container Manager`  了

# 打开并进入群晖 ssh

"[群晖DS220J 利用SSD做虚拟内存优化](https://www.moluyao.wang/go?_=771a158a2aaHR0cHM6Ly93d3cuYmlsaWJpbGkuY29tL3JlYWQvY3YxNTUyODk2Mg%3D%3D)"一文已经介绍过如何通过 windows10 的 powershell 进入群晖后台。强烈建议通过 SSD 做虚拟内存优化，因为 ARM 机型一般内存都很小，没有虚拟内存优化很可能会卡顿严重。

此外，如果提示权限不足的话，可以 sudo 或切换到 root 账号下操作

> 在Linux系统中，切换到`root`用户通常是为了执行需要特权的操作。以下是几种切换到`root`用户的方法：
>
> 1. **使用`su`命令**：
>    使用`su`命令可以切换到`root`用户。这将提示你输入`root`用户的密码。
>    ```sh
>    su
>    ```
>    或者，如果你想直接切换到`root`用户而不需要交互式提示，可以使用`-`选项：
>    ```sh
>    su -
>    ```
>
> 2. **使用`sudo`命令**：
>    如果你的用户账户在`sudoers`文件中有适当的权限，你可以使用`sudo`命令执行特定的命令作为`root`用户。
>    ```sh
>    sudo <command>
>    ```
>    例如，要切换到`root`用户并获取一个root shell，可以使用：
>    ```sh
>    sudo su
>    ```
>    或者，如果你想要使用`sudo`执行一系列命令，可以使用：
>    ```sh
>    sudo -i
>    ```
>
> 3. **使用`sudo`获取root权限但不切换用户**：
>    如果你想保持当前用户的环境变量，但以`root`权限执行命令，可以使用：
>    ```sh
>    sudo <command>
>    ```
>    这将保持当前的环境设置，但以`root`用户权限执行指定的命令。
>
> 4. **使用`sudo -s`或`sudo -i`获取root shell**：
>    这两个命令都会给你一个root用户的shell。`-i`选项会启动一个登录shell，它会读取root用户的配置文件（如`/root/.bashrc`或`/root/.profile`）。
>    ```sh
>    sudo -s
>    # 或者
>    sudo -i
>    ```
>
> 5. **使用`sudo`编辑文件**：
>    如果你需要编辑需要root权限的文件，可以使用`sudo`命令结合文本编辑器，例如`vi`或`nano`：
>    ```sh
>    sudo vi /path/to/file
>    # 或者
>    sudo nano /path/to/file
>    ```
>
> 6. **使用`sudo`执行脚本**：
>    如果你有一个脚本需要root权限来运行，可以使用：
>    ```sh
>    sudo ./script.sh
>    ```
>
> > 注意事项：
>
> - 使用`sudo`时，系统会要求输入执行`sudo`命令的用户的密码，而不是`root`用户的密码。
> - 切换到`root`用户或使用`sudo`时要格外小心，因为这些操作可能会影响系统的安全性和稳定性。
> - 确保你了解执行的命令和脚本的作用，避免不必要的系统更改或损坏。
> - 在使用`sudo`时，尽量避免使用`-i`或`-s`选项，除非你确实需要一个root shell，因为它们会改变你的环境变量，可能导致不可预见的行为。
>
> 通过上述方法，你可以在Linux系统中切换到`root`用户或以`root`权限执行特定命令。



# 查看自己的 CPU 类型，官网下载安装包

可以用uname -m，我的是arm v8，所以得到的结果是aarch64

![群晖DS220JARM安装使用docker插图](https://i0.hdslb.com/bfs/article/2d44af120fd87e5cb0525a79cae5446b1447468e.png "群晖DS220JARM安装使用docker插图")

aarch64

网址为https://download.docker.com/linux/static/stable/

![群晖DS220JARM安装使用docker插图1](https://i0.hdslb.com/bfs/article/bc73f1a2678210445df56a2c3470c6576b14070b.png "群晖DS220JARM安装使用docker插图1")

选aarch64

点击aarch64进入

![群晖DS220JARM安装使用docker插图2](https://i0.hdslb.com/bfs/article/bd9e373fee252c39f1b95998b6122e3d4e64aa07.png "群晖DS220JARM安装使用docker插图2")

选择最新的安装包

本文编写时，最新的安装包为docker-20.10.9.tgz，浏览器可以下载，网址为

https://download.docker.com/linux/static/stable/aarch64/docker-20.10.9.tgz

假设DS220J已经在存储空间1上创建了docker文件夹，将这个压缩包不解压直接拷贝到docker文件夹内，然后cd /volume1/docker，进入到该目录中

![群晖DS220JARM安装使用docker插图3](https://i0.hdslb.com/bfs/article/5d1d72269402af0ac42fb7a9eaf31f667ce78f1b.png "群晖DS220JARM安装使用docker插图3")

当然也可以选择wget https://download.docker.com/linux/static/stable/aarch64/docker-20.10.9.tgz直接下载

# 解压

```bash
tar xvf docker-20.10.9.tgz
```

注意文件名需要根据实际压缩包的名称而定，解压完成后cd docker，然后ls，可以看到若干文件

![群晖DS220JARM安装使用docker插图4](https://i0.hdslb.com/bfs/article/fdd0b8c2b85c5852c462a7bf0a99e9aa16f47960.png "群晖DS220JARM安装使用docker插图4")

解压的文件待拷贝到系统目录下

# 安装

安装过程是比较暴力的，我暂时也没有更好的解决方法。

pwd确认已经在刚刚解压的docker目录下后，sudo cp * /usr/bin，这样就会把所有刚刚解压的文件拷贝到系统目录下。

然后执行sudo dockerd，用来创建一些临时的目录。但是执行过程会失败，我们需要修改配置文件

```bash
vi /etc/docker/daemon.json
```

将下述文本复制进去

```bash
{

"storage-driver": "vfs",

"iptables": false,

"data-root": "/volume1/docker"

}
```



![群晖DS220JARM安装使用docker插图5](https://i0.hdslb.com/bfs/article/555dd0625bcf00dbe028012693f31df62c17cc2d.png "群晖DS220JARM安装使用docker插图5")

注意，不要配置bridge，这样默认就会有桥接模式。就我个人的应用而言，桥接模式非常有用，尤其是容器和DSM之间的端口映射，jellyfin等docker组件严重依赖该模式。

再次执行

``` bash
sudo dockerd &
```



成功启动

可以考虑后续在DSM的计划任务中，设置开机启动任务，以root权限执行下sudo dockerd &命令，以后就不用每次手工敲了。

5、安装 PortainerIo ，使用GUI界面管理安装docker容器。

在群晖 x86 的机型中，docker 都是有GUI管理界面的，拉镜像创建容器都很直观。在本文安装的docker中，也可以借用一个叫 portainerio 的 docker 镜像，实现类似的功能，界面如下

![群晖DS220JARM安装使用docker插图6](https://i0.hdslb.com/bfs/article/684d0617a91a71b8e7ae8b03cfd67a5856c4e0f0.png "群晖DS220JARM安装使用docker插图6")

但是 portainerio 还是要借助命令行来安装的，下面介绍安装过程

第一步拉取镜像

```bash
docker pull portainer/portainer
```

第二步做卷

```bash
docker volume create portainer_data
```

第三步生成容器

```bash
docker run -d -p 10001:9000 -v /var/run/docker.sock:/var/run/docker.sock –net=bridge -v portainer_data:/data portainer/portainer
```

这里，使用 `-d` 标明后台运行，`-p` 是对 tcp 端口进行端口映射，将 DS220J 的 `10001` 端口映射到 docker 的 `9000` 端口，`–net=bridge`，显式指定了网络模式为bridge

`10001` 端口号可以改为其他端口，但是 `9000`端口不可修改。

第四步，确认容器正确启动

```bash
sudo docker ps -a
```

![群晖DS220JARM安装使用docker插图7](https://i0.hdslb.com/bfs/article/24768257eb4d58b7af78e4bb180c84652c332374.png "群晖DS220JARM安装使用docker插图7")

注意如果PORTS没有显示，或者端口和你预设的不一样，可能是哪里存在错误，需要检查。

STATUS显示了状态，我这里是已经启动运行了。

然后在浏览器输入 NAS 的 IP 和 10001 端口号，就可以了

假设我的 NAS ip 为 `192.168.1.100` ，那么应该在浏览器输入 `192.168.1.100:10001`

如果能够看到对应的管理页面，说明安装成功了。

如果希望容器能够在NAS重启后能够自动启动，需要在命令行中输入

```bash
docker container update –restart=always a451a16cbdef
```

![群晖DS220JARM安装使用docker插图8](https://i0.hdslb.com/bfs/article/f1e11896ee0823dbbc0f7ba03af68982e7697162.png "群晖DS220JARM安装使用docker插图8")

```bash
sudo docker ps -a
```

注意 `a451a16cbdef`是通过上述命令获得  

全部配置完毕后，可以重启NAS验证下自动启动是否生效，如果能够生效恭喜你完成了ARM机型上docker的创建！

portainerio 网上有许多教程，本文就不在赘述了。Enjoy it~

原文链接：https://www.bilibili.com/read/cv15633573

© 版权声明

声明📢本站内容均来自互联网，归原创作者所有，如有侵权必删除。 本站文章皆由CC-4.0协议发布，如无来源则为原创，转载请注明出处。
