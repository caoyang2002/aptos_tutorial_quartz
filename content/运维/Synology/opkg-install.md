---
title: 群晖安装 opkg
aliases:
  - 群晖安装 opkg
---
安装方法：https://github.com/Entware/Entware/wiki/Install-on-Synology-NAS

包目录：http://bin.entware.net



```bash
sudo -i  # 获取管理员权限
```

# 安装

## 部署 Entware

**1.**在您的硬盘上创建一个文件夹（rootfs外部）

```bash
mkdir -p /volume1/@Entware/opt
```



**2.**删除`/opt`并挂载optware文件夹

确保`/opt`文件夹是空的（未安装Optware），我们将在此步骤中**删除**`/opt`文件夹及其内容。

```bash
rm -rf /opt
mkdir /opt
mount -o bind "/volume1/@Entware/opt" /opt
```



注意：如果绑定命令不起作用，请尝试创建一个链接：

```bash
ln -s /volume1/@Entware/opt/ /opt
```

## 根据处理器运行安装脚本（`uname -m` to know）

- 用于`armv8`（`aarch64`）-Realtek RTD129x

```bash
wget -O - https://bin.entware.net/aarch64-k3.10/installer/generic.sh | /bin/sh
```



- 对于 `armv5`

```bash
wget -O - https://bin.entware.net/armv5sf-k3.2/installer/generic.sh | /bin/sh
```



- 对于 `armv7`

```bash
wget -O - https://bin.entware.net/armv7sf-k3.2/installer/generic.sh | /bin/sh
```



- 对于`x86_64`

```bash
wget -O - https://bin.entware.net/x64-k3.2/installer/generic.sh | /bin/sh
```



## 创建自动启动任务

在任务调度器中创建触发的用户定义任务。

- 转到：`DSM` > `控制面板` > `任务和计划`
- `新增` > `触发任务` > `用户定义的脚本`
    - 一般的
        - 任务：Entware
        - 用户：root
        - 事件：启动
        - 预处理：无
    - 任务设置
        - 运行命令：（见下文）

```bash
#!/bin/sh

# Mount/Start Entware
mkdir -p /opt
mount -o bind "/volume1/@Entware/opt" /opt
/opt/etc/init.d/rc.unslung start

# Add Entware Profile in Global Profile
if grep  -qF  '/opt/etc/profile' /etc/profile; then
	echo "Confirmed: Entware Profile in Global Profile"
else
	echo "Adding: Entware Profile in Global Profile"
cat >> /etc/profile <<"EOF"

# Load Entware Profile
[ -r "/opt/etc/profile" ] && . /opt/etc/profile
EOF
fi

# Update Entware List
/opt/bin/opkg update
```



**6.**重新启动您的NAS。

------

>[!TIP]
>
>- 固件更新会抹掉`/opt`文件夹。您应该在rootfs之外部署Entware，并创建`/opt`的符号链接或使用`mount -o bind`。固件更新后，您可能需要再次编辑`/etc/rc.local`和`/root/.profile`文件。
>
>- 您可以创建在 Entware 加载后启动的任务。
>
>    - `创建` > `触发任务` > `用户定义脚本`
>
>        - 一般的
>
>            - 任务：Entware - iperf3 Server
>            - 用户：root
>            - 事件：启动
>            - Pretask：**Entware**（其他 entware 任务的名称）
>
>        - 任务设置
>
>            - 运行命令：
>
>                 Run command as GUEST user
>
>                ```bash
>                 /opt/bin/iperf3 -s -D -p 5201
>                ```
>
>                Run command
>
>                ```bash
>                sudo -H -u guest bash -c 'echo "I am $USER, with uid $UID"; /opt/bin/iperf3 -s -D -p 5201'
>                ```



# 使用

## 一、OPKG简介
OPKG（Open/OpenWrt Package）是一个轻量快速的软件包管理系统，是 IPKG 的克隆， 目前已成为开源嵌入式系统领域的事实标准。OPKG 常用于路由、交换机等嵌入式设备中， 用来管理软件包的下载、安装、升级、卸载和查询等，并处理软件包的依赖关系。功能和 桌面 Linux 操作系统 Ubuntu 中的 apt-get、Redhat 中的 yum 类似。
OPKG 是一个针对根文件系统全功能的软件包管理器。它不仅仅是在独立的目录安装软件，还可以用于安装内核模块和驱动等。OPKG 在安装时会自动解决安装软件时的包依赖关系，如果遇见错误，就中止安装。
## 二、OPKG 的工作原理

OPKG命令执行会读取以下3部分的信息：

配置文件默认位置为`/etc/opkg.conf`

已安装软件包状态信息保存在 `/usr/lib/opkg` 目录下。

软件仓库的软件包信息保存在 `/var/opkg-lists` 目录下。

### 当更新时
当执行 `opkg update` 命令进行软件列表的更新时。
OPKG 首先会读取配置文件 `/ etc/opkg.conf`，这个文件保存了 OPKG 的全局配置信息。
紧接着，OPKG 会根据配置地址位置下载软件包列表文件 `Packages.gz` 到 `/var/opkg-list` 目录下，这个文件是软件仓库中所有 软件列表及其依赖关系的清单，是使用 `gzip` 压缩的文件，这样在网络传输时所占用网络流 量比较小。

其后任何安装命令均需首先读取这两个文件

### 当安装软件之后

软件安装之后的信息会保存在目录 `/usr/lib/opkg/ `下面，这里就相当于Windows 操作系统中的注册表。它包含状态文件，OPKG 通过访问这个状态文件确定该软件是否已安装、 安装的版本，以及依赖关系是否满足等，从而可以确定安装软件的版本、文件路径等信息。

```bash
ls /usr/lib/opkg/
```

> 输出：
>
> ```bash
> info    lists   meta    status
> ```



## 三、OPKG 命令格式

OPKG 的功能主要分两类

- 软件包的管理命令。

- 软件包的查询命令。

OPKG 必须带有一个`子命令`，命令格式如下：

```bash
opkg [options...] sub-command [arguments...]
```

下面列出几个最常用的选项：

- `-A`：查询所有的软件包，包含未安装的软件包。

- `-d <dest_name>`：使用作为软件包的安装根目录。是配置文件中定义的目录名称。

- `-f <conf_file>`：指定使用作为 opkg 的配置文件。如不指定，默认配置 文件是 `/etc/opkg.conf`。

- `--nodeps`：不按照依赖来安装，只安装软件包自己。这可能会导致缺少依赖文件， 导致程序不能执行。

- `--autoremove`：卸载软件包时自动卸载不再使用的软件包（在安装时依赖会自动安装上）。

- `--force-reinstall`：强制重新安装软件包，在软件包版本未修改时不会再次安装，增 加该选项来强制重新安装。

## 四、软件包的更新、安装、卸载和升级等功能
`opkg update`

该命令用于更新可以安装的软件包列表。

该命令不需要参数，执行时从服务器地址下载软件包列表文件并存储在/var/opkg-lists/目录下。

OPKG在安装或升级时需要读取这个文件，这个文件代表当前仓库中所有可用的软件包。也可以删除该文件来释放存储空间，在安装软件前需要重新获取这个文件。
`opkg install`

该命令用于安装软件包，需要一个参数，传递一个软件包名称。如果软件包之间有依赖关系，会自动下载所有被依赖的软件包，并依次将所有被依赖的软件包安装上。

案例：下面代码用于安装 `file` 软件包，其所依赖的软件包 `libmagic` 会自动安装上。

```bash
opkg install file
```



`opkg remove`

该命令用于卸载软件包，需要一个参数，传递一个软件包名称。

需要注意的是，在安装时自动安装的软件包并不会删除，需要自己手动删除，或者在卸载软件包的同时增加 (`--autoremove`)参数将不需要的安装包也删除。

下列代码用于删除file软件包及不再使用的依赖包。

```bash
opkg remove file --autoremove
```



`opkg upgrade`

该命令用于升级软件包。

如果软件包没有安装，该命令执行之后和 `opkg install` 效果相同。

如果升级多个软件包，以空格分隔列在命令之后即可。例如使用 `opkg upgrade ip wget`来升级两个软件包。

>[!TIP] 
>
> 备注：对大多数用户来说，不推荐升级软件包。OpenWrt发布后再进行升级大多数情况下是不可能的，这是因为OpenWrt发布之后一般不再更新，除非主干的快照被编译机器人 （buildbot）自动更新。如果内核升级了，可能带来升级风险，因为内核可能和原始安装的应用软件不兼容。因此一般只升级应用，即非内核软件包。



## 五、软件包的信息查询

OPKG 查询命令可以在软件仓库中查询，也可以在运行的系统中查询。OPKG 提供了软件包的双向查询功能：正向查询，即从软件包来查询所包含的文件列表；也可以反向查 询，从系统中所安装的文件查询所属的软件包。

### `opkg list`

该命令用于列出所有可使用的软件包，列出内容格式为：

```bash
软件包名称 – 版本 – 描述
```

描述内容是可以有换行的。如果使用 grep 命令来查找软件包则需注意，grep 是单行匹 配，因此使用 grep 查找的结果并不准确。

### `opkg list-installed`


该命令用于列出系统中已经安装的软件包。

### `opkg list-changed-conffiles`


该命令用于列出用户修改过的配置文件。

### `opkg files <pkg>`

该命令用于列出属于这个软件包（`<pkg>`）中的所有文件，这个软件包必须已经安装。
下列所示代码用于查看 ip 软件包所包含的文件列表。

### `opkg search <file>`


该命令用于列出提供的软件包，注意：需要传递文件的绝对路径。

### `opkg find <regexp>`


该命令用于列出软件包名称和 `<regexp>` 匹配的软件包。`<regexp>` 是一个正则表达式， 可以精确匹配，也可以使用星号来模糊匹配，例如使用 `net*` 或者`*net*`，均可以匹 配 `NetCat`。

### `opkg info [pkg]`

该命令用于显示已安装 `[pkg]` 软件包的信息，包含软件包名称、版本、所依赖的软件包名称、安装状态和安装时间等。如果没有指定参数则输出所有已安装软件包的信息。`opkg status` 和这个命令功能完全相同。

### `opkg download <pkg>`


该命令用于将软件包 `<pkg>` 下载到当前目录。

### `opkg print-architecture`

该命令用于列出安装包的架构。

```bash
$ opkg print-architecture
arch all 1
arch noarch 1
arch x86_64 10
```



### `opkg whatdepends [-A] [pkg]`

该命令用于针对已安装的软件包，输出依赖这个软件包的软件包。

下列所示代码用于查询依赖 `netdata` 的软件包。

```bash
$ opkg whatdepends netdata
Root set:
  netdata
What depends on root set
	luci-app-netdata 1.0-20221201	depends on netdata
```



## 六、`/etc/opkg.conf` 配置文件

OPKG需要一个配置文件来保存全局配置，例如软件从哪里下载、安装到哪里等。

OPKG配置文件默认是 `/etc/opkg.conf`，内容如下：

```bash
$ cat /etc/opkg.conf
dest root /
dest ram /tmp
lists_dir ext /var/opkg-lists
option overlay_root /overlay
```



### 软件仓库地址

OPKG可以使用多个仓库，每一个仓库需要一个唯一标识符，即使用它们的逻辑名字。
例如可以将下面的内容加入到 `/etc/opkg.conf` 文件中：

```bash
src/gz attitude_adjustment http://downloads.openwrt.org/attitude_adjustment/12.09/x86/generic/packages/
src/gz local http://192.168.1.106:8080/openwrt
```




### 自定义安装目录
OPKG的一个非常有用的特性，是有能力指定任何安装包的安装目录。安装目录在配置文件 `/etc/opkg.conf` 中定义。
格式：配置文件中目的地址格式是以 `dest` 开头，紧跟着目的地址的名称，最后是目录路径，必须从根目录开始。

```bash
dest root /
dest ram /tmp
dest usb /opt
```

安装目录定义之后，目的地址名称就可以在安装命令中引用了。安装时目的地址名称只能引用在 `/etc/opkg.conf` 中定义的地址名称，例如 `-d ram` 表示软件将安装到临时目录 `/tmp` 下。
安装命令类似如下格式：

```bash
opkg install <pkg> -d <目的地址名称>
```


### 代理设置

OPKG通过下载软件包来安装，如果你通过HTTP代理服务器来上网，那就不能直接连接到服务器地址，这时就需要设置代理服务器地址

在 `/etc/opkg.conf` 中加入以下设置：

```bash
option http_proxy http://proxy.example.org:3128/
```




如果代理服务器需要认证，则需要增加以下认证信息：

```bash
option proxy_username xxxxxx
option proxy_password xxxxxx
```


如果使用 `busybox` 的 `wget` 命令，这个工具不支持认证功能，下载时将认证失败。可以改为在URL中传递用户名和密码：

```bash
option http_proxy http://username:password@proxy.example.org:3128/
```

### 七、OPKG包结构（`.ipk`）

OPKG安装包（ipk文件）是一个gzip压缩文件，可以用file命令来查看文件格式描述。
其实，ipk文件就是一个 `tar.gz` 文件，我们可以用tar命令来解压缩并查看文件内容，其内容包含两个压缩文件和一个版本文件。

演示案例：

我们以 `TcpDump` 软件包为例来说明安装包格式。

首先使用 `tar` 命令来解压缩 `TcpDump` 的安装包，解压缩完成后生成 3 个文件。命令如下：

```bash
tar -xzf package_name.ipk -v
```

- `debian-binary`：debian-binary 是一个纯文本文件，包含字符串“2.0”， 表示格式为 debian2.0 格式。

- `data.tar.gz`：data.tar.gz 包含“/usr/sbin/tcpdump”文件，在安装时复制到安 装目录下。

    ```bash
    tar -xzf data.tar.gz -v
    ```

- `control.tar.gz`：control.tar.gz 解压缩后发现仅包含一个文件“control”，文件内容包含软件包名称、版本、依赖关系、所属分类、状态、优先级、平台架构和软件描述等。例如，TcpDump可执行程序依赖 libc 和 libpcap 库，libc 库默认已经安装在系统中，在安装 TcpDump 时将自动 下载并安装 libpcap 软件包。control 文件内容为：

    ```bash
    略
    ```

    

> 备注：上面我们的TcpDump软件包解压之后的control.tar.gz文件再次解压之后只有一个“control”文件，但是其他软件的 control.tar.gz 文件解压之后还可能包含一些其他的控制文件，内容如下：

| 文 件     | 含 义                                                    |
| --------- | -------------------------------------------------------- |
| control   | 控制文件，包含软件包名称、版本、依赖关系和所属分类等信息 |
| conffiles | 配置文件，内容包含该软件的配置文件列表，一个文件占一行   |
| preinst   | 安装文件之前执行脚本                                     |
| postinst  | 安装文件之后执行脚本，例如安装之后设置用户及启动程序等   |
| prerm     | 卸载之前执行的脚本，例如卸载之前首先结束运行的程序进程   |
| postrm    | 卸载之后执行的脚本                                       |

## 八、opkg 命令的一些演示案例

### 安装软件包 `svn`

svn 工具介绍：我们想要安装一个 svn 工具，可以将路由器中的内容直接提交到代码库中。

#### 第一步：首先我们更新可用的软件包列表。

```bash
opkg update
```



#### 第二步：然后查询所有带有svn信息的软件包（但是没有查询到）。

> 备注：也可以通过“opkg find”命令来查找软件包。这个命令需要我们记住想要查找软件包的名称，或者名称的一部分。可以使用星号 `*` 通配符来查找。例如使用 `opkg find subversion*`。
>
> ```bash
> opkg list |grep svn
> ```

#### 第三步：我们知道svn的全称为 subversion，我们更换关键字来查询。

下面查到了 `subversion-client` 是一个 `svn` 客户端工具。

```bash
opkg list | grep subversion
```

#### 第四步：我们使用命令来安装svn客户端工具。

```bash
opkg install subversion-client
```



### 查询已安装的OPKG软件包文件列表

用户经常想知道某个文件属于哪一个软件包，或者是某个软件包包含哪些文件。这时OPKG查询命令就派上用场了。

#### 查询文件所属的软件包。

```bash
opkg search /usr/bin/netcat 
```

#### 查询软件包所包含的文件。

```bash
opkg files subversion-client
```

### 自定义安装目录

在路由器中如果空间不足，我们需要将软件安装到另外的磁盘分区上。例如，将软件 安装到USB盘分区中，例如我们安装 `file`、`nmap` 和 `openvpn` 软件包。

#### 第一步：安装 mount 工具并挂载 USB 磁盘到 srv 目录下

USB 盘的文件系统通常是 vfat 格式，我们首先安装 vfat 格式的相关软件包，然后将USB盘挂载到/srv 目录下。下面的命令用于安装 mount 工具并挂载 USB 磁盘到 srv 目录下。

```bash
opkg install knod-nsl-cp437
opkg install knod-nsl-iso8859-1
opkg install mount-utils
mkdir /srv -p
mount /dev/sdb1 /srv
```

#### 第二步：编辑 `/etc/opkg.conf` 文件

编辑 `/etc/opkg.conf` 文件，在文件最后增加一行，内容为 `dest usb /srv`。

```bash
echo "dest usb /srv">> /etc/opkg.conf
```

#### 第三步：安装软件

到这里你就可以在外接USB盘中安装软件并执行了，首先更新软件包列表，然后安装软件。

```bash
opkg update
opkg install nmap -d usb
```

#### 第四步：将 `srv` 目录增加到命令搜索和动态库搜索的环境变量中

在 nmap 安装完成后，如果执行 nmap，并不会找到该命令，还需要设置环境变量 PATH。 如果仅是临时设置，可以在终端中使用 export 命令进行设置。如果要重启也生效就需要在 /etc/profile 文件中修改。编辑配置文件/etc/profile，将你新增的软件目录加入到 PATH 环境变量中。

```bash
export PATH=/bin:/sbin/:/usr/bin/:/usr/sbin:/srv/bin:/srv/sbin:/srv/usr/bin:/srv/usr/sbin
export LD_LIBRARY_PATH=/srv/lib:/srv/usr/lib
```

#### 第五步：将 `libstdc++.so.6.0.16` 文件改名为 `libstdc++. so.6`

在执行 nmap 时还提示有错误`nmap: can’t load library ‘libstdc++.so.6`，这时因为动 态链接文件库名没有创建成功，只需要将 `libstdc++.so.6.0.16` 文件改名为 `libstdc++. so.6` 即可。

#### 第六步：创建启动软链接

在安装 openvpn 时，如果你的安装包在 `/etc/init.d` 目录下有一个启动脚本，但你安装到 外接磁盘目录中，你就需要创建一个启动软链接，例如：

```bash
ln -s /srv/etc/init.d/openvpn /etc/init.d/openvpn
```

#### 第七步：增加 file 包装脚本

如果软件因为链接库的问题不能启动，就需要在启动脚本里面增加动态链接库目录。 另外你需要解决特定程序的配置文件默认路径问题，需要通过命令行来指定配置文件的路 径，也可以增加一个包装脚本。下面就是增加了一个 file 包装脚本。安装 file 并使用 `-m` 来指定配置文件路径，并在最后通过 `chmod +x` 增加执行权限，这样就可以像以前一样 执行 file 命令了。

```bash
opkg install file –d usb
touch /usr/bin/file
echo "#!/bin/sh" > /usr/bin/file
echo "/srv/usr/bin/file -m /srv/usr/share/misc/magic \"\$@\"" >>/usr/bin/file
chmod +x /usr/bin/file
```



>[!TIP] 两点注意事项：
> - 许多软件包在自定义的位置时不能启动或者即使启动也不能成功执行，因为它在 默认位置读取配置文件（如 file 命令），因此==需要在参数中指定配置文件位置==，否则将不能 找到它自己必须的配置文件。
> - 许多软件包在更改了目录之后==需要额外的软链接或者修改动态链接库文件名后==才能使用。




> 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。
>
> 原文链接：https://blog.csdn.net/qq_41453285/article/details/102523263



# 示例

`opkg` 是一个轻量级的包管理器，通常用于嵌入式设备，如路由器和 NAS 设备。如果你想要使用 `opkg` 安装 `fsck`（文件系统一致性检查工具），你可以按照以下步骤进行：

1. **更新软件包列表**：
   首先，你需要确保你的软件包列表是最新的。这可以通过运行以下命令来完成：
   ```sh
   opkg update
   ```

2. **搜索 fsck 软件包**：
   在安装之前，你可能想要搜索 `fsck` 软件包以确认它是否存在于仓库中：
   ```sh
   opkg list | grep fsck
   ```

3. **安装 fsck**：
   如果 `fsck` 软件包可用，你可以使用以下命令来安装它：
   ```sh
   opkg install fsck
   ```

4. **检查安装状态**：
   安装完成后，你可以使用以下命令来检查 `fsck` 是否已正确安装：
   ```sh
   opkg info fsck
   ```

请注意，`fsck` 可能已经预装在你的系统上，或者它可能是作为其他软件包的一部分提供的。如果你的设备是基于 Debian 或 Ubuntu 的，`fsck` 通常作为 `e2fsprogs` 包的一部分提供。如果是这种情况，你可以安装 `e2fsprogs` 包来获取 `fsck`：

```sh
opkg install e2fsprogs
```

如果你不确定 `fsck` 是否已经安装在你的设备上，你可以使用 `which` 命令来查找它的位置：

```sh
which fsck
```

如果 `fsck` 已经安装，这个命令将返回 `fsck` 的路径。如果没有安装，你将看到一个提示，说明 `fsck` 没有找到。在这种情况下，你可以按照上述步骤使用 `opkg` 进行安装。


----
根据你提供的 `opkg list` 的输出结果，我们可以看到有多个与文件系统检查 (`fsck`) 相关的软件包。以下是一些可用的软件包：

- `dosfstools`：包含 `mkfs.fat` 和 `fsck.fat` 工具，用于创建和检查 MS-DOS FAT 文件系统。
- `e2fsprogs`：包含 `e2fsck`（用于检查 ext2 文件系统）和 `mke2fs`（用于创建 ext2 文件系统）等核心 ext2 文件系统工具。
- `exfat-fsck`：用于检查和修复 exFAT 文件系统的工具。
- `f2fsck`：用于检查和修复 Flash-Friendly File System (F2FS) 的工具。
- `hfsfsck`：包含 `fsck.hfs` 和 `fsck.hfsplus`，用于检查 HFS/HFS+ 文件系统的完整性。
- `xfs-fsck`：包含用于检查和修复 XFS 文件系统的实用工具。

如果你想要安装一个通用的文件系统检查工具，通常 `e2fsprogs` 包含了大多数 Linux 系统所需的基本 `fsck` 工具。你可以使用以下命令来安装它：

```sh
opkg install e2fsprogs
```

如果你的设备使用的是特定类型的文件系统，例如 exFAT，你可以安装对应的 `exfat-fsck`：

```sh
opkg install exfat-fsck
```

安装完成后，你可以使用 `fsck` 命令来检查文件系统。例如，使用 `e2fsck` 来检查 ext2 文件系统：

```sh
fsck.ext2 /dev/sdX1
```

请将 `/dev/sdX1` 替换为你想要检查的设备或分区。如果你不确定要使用哪个 `fsck` 工具，可以根据你的文件系统类型选择相应的软件包进行安装。
