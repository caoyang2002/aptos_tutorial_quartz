---
title: 安装 OpenWRT
aliases:
  - 安装 OpenWRT
---
下载 [OpenWRT](https://lidrive.vip) 镜像文件：

https://lidrive.vip/d/OpenWrt/OpenWrt%20X86/%E5%9C%A8%E7%BA%BF%E6%9B%B4%E6%96%B0%E7%89%88/18.06-Lede-x86-64-1718206686-legacy-9519d1.img.gz?sign=PamXzFHerAIJJwdSQgN7RWgm_pHdahjwJbvrbCrmqvM=:0

# 将 U 盘中的 `.img` 写入宿主机（验证）
将 `.img` 文件（通常是磁盘镜像文件）从 U 盘写入宿主机系统的过程涉及到一些步骤，具体取决于你想要如何使用这个镜像。以下是一些常见的方法：

# 1. 下载镜像文件
[X86_64 在线更新版](https://lidrive.vip/OpenWrt/OpenWrt%20X86/%E5%9C%A8%E7%BA%BF%E6%9B%B4%E6%96%B0%E7%89%88)

[其他版本](https://lidrive.vip/)

## 2. 使用 balenaEtcher 写入 U 盘

选择 U 盘和 img 文件，点击 flash 即可 

## 3. 将 u 盘插入软路由，并使用 u 盘启动

按 del ，将 boot 的第一项改为 u 盘的名称

## 4. 复制 img 文件到新的 u 盘，或者直接下载
方案一：
准备一个新的 u 盘，复制 `openwrt.img` 文件到新的 u 盘
> 一般插入 u 盘后会自动挂载在`/mut/sdb1`

手动挂载
```bash
# 查看有 img 文件的 u 盘盘符
fdisk -l # 一般是 /dev/sdb
# or
lsblk

# 创建一个挂载点
mkdir /mnt/usb1

# 挂载有 img 文件的 u 盘
mount /dev/sdb1 /mnt/usb1
```

方案二：在使用 u盘启动的 openwrt 系统中下载 `openwrt.img`

```bash
wget https://xxx/openwrt.img.tar.gz
```

## （可选）删除宿主机的分区
```bash
# 查看磁盘大小
lsblk

# 查看分区
# 以固态硬盘为例，我的是 120G
# 列出所有分区信息
lsblk /dev/nvme0n1
# 更改分区
fdisk /dev/nvme0n1 
# m 查看帮助；
# p 打印分区表；
# d 删除分区；
# n 新建分区

# 取消挂载 
umount /mnt/nvme0n1p1 # p1 是 part 1 ：分区一

# 创建磁盘主分区
# 一个扩展分区，其中扩展分区包含两个逻辑分区。
#（1）主分区：也称为引导分区，用来启动操作系统。
#（2）扩展分区：实际在硬盘中是看不到的，也无法直接使用扩展分区，而是用来划分逻辑分区。
#（3）逻辑分区：相当于一块存储介质，在扩展分区上可以创建多个逻辑分区，用来存储数据。

# d 删除所有的分区（可能需要删除多次）
# n 创建分区 
# +2048M 创建 2G 的分区
# +4096M 创建 4G 的分区
# +10240M 创建 10G 的分区
# 剩余分为一个分区（直接回车）

w 写入分区方案并退出
```

## 解压 `openwrt.img.tar.gz` 文件

```bash

# 进入有 openwrt.img.gz U 盘的挂载目录
lsblk
# 解压 .gz 文件
gunzip openwrt.img.gz

```
## 写入 img 到系统

```bash
# 使用 dd 命令写入镜像，确保替换 /dev/nvme0n1 为你的宿主设备路径
dd if=/mnt/sdb1/openwrt_version.img of=/dev/nvme0n1 bs=4M status=progress
```
- `dd`：这是 Linux 中的一个命令行工具，用于转换和复制文件。
- `if=/mnt/sdb1/openwrt_version.img`：`if` 指定了输入文件的路径，即源文件。在这个例子中，`/mnt/sdb1/openwrt_version.img` 是要复制的 OpenWrt 系统镜像文件的位置。文件位于 `/mnt/sdb1` 目录下，这个目录通常是通过挂载得到的，比如挂载一个 U 盘或者其他存储设备。
- `of=/dev/nvme0n1`：`of` 指定了输出文件的路径，即目标设备。`/dev/nvme0n1` 是 NVMe 固态硬盘的第一个命名空间或分区。这条命令会将输入文件的内容直接写入到这个设备上。请注意，这将覆盖 `/dev/nvme0n1` 上的所有现有数据，因此在执行之前一定要确保你已经备份了所有重要数据。
- `bs=4M`：`bs` 选项设置块大小为 4MB。`dd` 在复制过程中会以指定的块大小来处理数据。使用较大的块大小可以提高 `dd` 的性能。
- `status=progress`：这个选项会让 `dd` 在标准错误输出上显示进度信息，让你可以看到复制过程的进度。




```

# 创建系统分区

# +++ (方案一) 新手分区规划：我磁盘是 120G +++
# swap：交换分区 4G
# /： 根分区 114G


# +++ （方案二）一般分区方案 +++
# /boot: 用来存放与 Linux 系统启动有关的程序，比如启动引导装载程序等，建议大小为 100MB 。  
# /: 系统的根目录，所有的目录都挂在这个目录下面，建议大小为 5GB 以上。  
# /home: 存放普通用户的数据，是普通用户的宿主目录，建议大小为剩下的空间。  
# swap: 实现虚拟内存，建议大小是物理内存的 1~2 倍。

```



## swap 分区

查看内存大小
```bash
free -h
```

swap 一般为 内存的两倍

**使用 `fdisk` 创建新分区**：
输入以下命令启动 `fdisk` 并选择要分区的硬盘。例如，如果你要对 `/dev/nvme0n1` 进行分区：
```sh
fdisk /dev/nvme0n1
```

**创建新分区**：
在 `fdisk` 提示符下，输入 `n` 来创建新分区。

**设置分区大小**：
你可以输入分区的大小（例如 `+4G` 表示 4GB）或使用默认值。

**设置分区的起始点**：
   通常，`fdisk` 会提供一个推荐的起始点，你可以直接按回车接受。

**写入更改**：
输入 `w` 将分区表写入磁盘并退出 `fdisk`。

**格式化新分区为 swap 空间**：
使用 `mkswap` 命令格式化新创建的分区。假设新分区是 `/dev/nvme0n1p3`：
```sh
sudo mkswap /dev/nvme0n1p3
```

**启用交换空间**：
\使用 `swapon` 命令立即启用新的交换空间：
```sh
swapon /dev/nvme0n1p3
```

**使交换空间在启动时自动挂载**：
   为了让交换空间在每次启动时自动挂载，你需要将其添加到 `/etc/fstab` 文件中。使用文本编辑器编辑 `fstab` 文件：
```bash
vim /etc/fstab
```
   在文件末尾添加以下行：
```txt
/dev/nvme0n1p3 none swap defaults 0 0
```
   然后 `:wq` 保存并关闭编辑器。

10. **验证交换空间**：
    使用 `free -m` 或 `swapon --show` 命令来验证新的交换空间是否已正确配置和挂载。

请注意，交换分区和交换文件（使用 `swapfile`）是两种不同的概念。交换分区是一个专用的分区，而交换文件是根文件系统内的一个大文件。如果你不想创建交换分区，你也可以创建一个交换文件，使用 `fallocate` 创建一个大文件，然后使用 `mkswap` 格式化它，并按照类似的方式添加到 `/etc/fstab`。

在添加交换空间时，请根据你的系统内存大小和使用习惯来决定交换空间的大小。对于较小的物理内存（例如4GB或更少），推荐的交换空间大小通常是物理内存的 1.5~2 倍。对于更大的内存，可能只需要与物理内存相等或更少的交换空间。


## 设置 lan 口

备份文件
```bash
cp /etc/config/network /etc/config/network.bak
```

编辑网络配置
```bash
vim /etc/config/network
```
类似于这样
```bash
root@OpenWrt:~# vim /etc/config/network
config interface 'lan'
        option type 'bridge'
        option ifname 'eth0'
        option proto 'static'
        option ipaddr '192.168.5.1'
        option netmask '255.255.255.0'
        option ip6assign '60'
保存退出:wq
```



## doker 扩容

打开 http://192.168.5.1
系统→磁盘管理→磁盘→修改→格式化→ext4 
系统→挂载点→添加

重启即可





---

# 使用命令行

## 环境说明
我的mac系统是MacOS Mojave 10.14.6  
需要在该系统里制作一个ubuntu系统的U盘启动盘，该启动盘可以被其他机器使用。  
该方法应该可以制作任何一个系统的启动盘。

### 2.准备U盘

准备一个至少8GB的U盘，U盘大小应该与启动盘系统的要求有关，我使用的是32GB和16GB的两个U盘做测试。

### 3.下载镜像

去系统官网下载镜像，镜像一般为`.img`格式的。  
苹果系统默认的下载地址一般都是“访达”里的“下载”目录下。为了后续的命令行使用方便，要确认下下载文件的存放完整路径。  
打开终端窗口，终端shell的默认路径是在当前用户的目录下，有个Downloads的目录，`.img` 文件默认会下载在这个目录下。  
`~/Download/openwrt_version.img`

## 列出所有的盘

```bash
diskutil list
```

找到自己的盘：

```bash
......（略）
/dev/disk6 (disk image):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        +17.3 GB    disk6
   1:                 Apple_APFS Container disk7         17.3 GB    disk6s1

/dev/disk7 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +17.3 GB    disk7
                                 Physical Store disk6s1
   1:                APFS Volume iOS 17.4 21E213 Simu... 16.8 GB    disk7s1

/dev/disk8 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *62.1 GB    disk8
   1:       Microsoft Basic Data                         5.0 GB     disk8s1
   2:                        EFI ESP                     5.2 MB     disk8s2
   3:       Microsoft Basic Data                         307.2 KB   disk8s3
   4:           Linux Filesystem                         57.0 GB    disk8s4
```

比如我是 `/dev/disk8`。 因为 ` GUID_partition_scheme` 和我的盘是一样的

## 卸载：
```bash
sudo diskutil umountDisk /dev/disk8
```
输出：
```bash
Unmount of all volumes on disk8 was successful
```

## 格式化：
```
sudo diskutil eraseDisk ExFAT ud /dev/disk8
```
- `eraseDisk`：`diskutil` 的一个子命令，用于擦除磁盘并为其创建新的分区表和文件系统。
- `ExFAT`：指定要创建的文件系统格式。ExFAT（扩展文件分配表）是一种适合于闪存驱动器的文件系统格式，支持存储大文件（大于 4GB）。
- `ud`：指定磁盘的卷标（名称）。在这里，`ud` 将作为格式化后磁盘的名称。
- `/dev/disk8`：指定要格式化的磁盘设备。`/dev/disk8` 是磁盘的设备文件，表示这是系统中的第八个磁盘设备。

>[!TIP] 支持的文件格式
>1. **ExFAT**：适合于存储大文件，广泛兼容于 Windows、macOS 和 Ubuntu（Ubuntu 18.04 及以上版本默认支持 ExFAT）。
>2. **FAT32**：兼容性非常好，但有文件大小限制（最大 4GB）。
>3. **NTFS**：Windows 主流文件系统，macOS 可以读取但默认情况下不能写入（需要第三方工具或驱动程序）。
>4. **APFS**（Apple File System）：苹果公司开发的文件系统，主要用于 macOS 和 iOS。Ubuntu 可以通过第三方工具如 `apfs-fuse` 来访问 APFS 格式的磁盘。

输出：
```bash
Started erase on disk8
Unmounting disk
Creating the partition map
Waiting for partitions to activate
Formatting disk8s2 as ExFAT with name ud
Volume name      : ud
Partition offset : 411648 sectors (210763776 bytes)
Volume size      : 120795136 sectors (61847109632 bytes)
Bytes per sector : 512
Bytes per cluster: 131072
FAT offset       : 2048 sectors (1048576 bytes)
# FAT sectors    : 4096
Number of FATs   : 1
Cluster offset   : 6144 sectors (3145728 bytes)
# Clusters       : 471832
Volume Serial #  : 6691d00d
Bitmap start     : 2
Bitmap file size : 58979
Upcase start     : 3
Upcase file size : 5836
Root start       : 4
Mounting disk
Finished erase on disk8
```


## 制作启动盘：

镜像（iso）文件下载好之后，通过 hdiutil 命令制作 dmg 文件，注意镜像文件改为自己的文件路径：
```bash
hdiutil convert -format UDRW ../path/to/ubuntu-22.04-desktop-amd64.iso -o ubuntu-22.04-desktop-amd64
```

- `convert`：这是 `hdiutil` 工具的一个子命令，用于转换磁盘映像文件的格式。
    
- `-format UDRW`：这个参数指定了目标磁盘映像的格式。`UDRW` 代表“UDF Read-Write”，即 UDF 可读写格式。UDF 是一种通用的磁盘格式，广泛用于各种操作系统。
    
- `ubuntu-22.04-desktop-amd64.iso`：这是源文件，即原始的 ISO 文件路径。
    
- `-o ubuntu-20.04-desktop-amd64.iso`：`-o` 参数后面跟着的是输出文件的名称。这里指定了转换后的文件名。如果不包含扩展名，`hdiutil` 会根据 `-format` 参数自动添加相应的扩展名，即 `dmg`，制作启动盘的时候需要注意。

终端里面出现以下的成功信息：
```bash
Reading Protective Master Boot Record (MBR : 0)…  
Reading GPT Header (Primary GPT Header : 1)…  
Reading GPT Partition Data (Primary GPT Table : 2)…  
Reading ISO9660 (DOS_FAT : 3)…  
.............................................................................................................................................................................................................................................................  
Reading Appended2 (C12A7328-F81F-11D2-BA4B-00A0C93EC93B : 4)…  
.............................................................................................................................................................................................................................................................  
Reading Gap1 (DOS_FAT : 5)…  
.............................................................................................................................................................................................................................................................  
Reading Ubuntu 22.04 LTS amd64           (Apple_ISO : 6)…  
.............................................................................................................................................................................................................................................................  
Reading GPT Partition Data (Backup GPT Table : 7)…  
.............................................................................................................................................................................................................................................................  
Reading GPT Header (Backup GPT Header : 8)…  
.............................................................................................................................................................................................................................................................  
Elapsed Time:  5.440s  
Speed: 640.7MB/s  
Savings: 0.0%
```


写入U盘：
```bash
sudo dd if=ubuntu-22.04-desktop-amd64.dmg of=/dev/rdisk2 bs=1m    
```

注意 `of=` 后边的地址是U盘的**挂载地址**，在diskutil list命令中可看到；另外disk2 -> rdisk2。 以上命令执行过程中不会有日志，在结束之后会返回一些简单信息，时间会比较久一点，大概是这样：

```bash
3485+1 records in  
3485+1 records out  
3654957056 bytes transferred in 90.399920 secs (40430977 bytes/sec)
```

到这里基本整个启动盘就做完了。

执行完成后，执行下面命令弹出U盘。  

```bash
diskutil eject /dev/disk2
```








# 使用 `balenaetcher` 工具


可以使用 brew 安装
```bash
brew install --cask balenaetcher
```

看完后发现，命令行制作的方法要简单很多。那就动手制作吧。

## 下载镜像文件

## 格式化U盘

## 刷入

## 弹出





----
# X86 OpenWrt的全平台安装方式

在所有平台下快速安装OpenWrt X86的方式，包含所有的格式转换方式。其中图形化的方式适合新手，命令行的方式适合老手。

由于openwrt只提供了img的镜像，因此在很多虚拟化场景中，并不能直接安装，需要一些额外的转换；今天我就整理了全平台进行的操作，以宿主机为视角。在这些平台上如何把openwrt的img镜像转为主流的虚拟机支持的格式。

在官方文档中，已经给出了一部分的虚拟化支持。[链接](https://openwrt.org/docs/guide-developer/start?ref=cpci.dev#testing_openwrt_in_a_virtual_machine)。但完全不够。

在X86的五种环境中：即物理机、VMware、Hyper-v、Xen Server、KVM，都可能使用OpenWrt。因此，以下内容将覆盖这5种环境的安装方式。

## 宿主机为Windows

### 方式1：磁盘管理+Rufus写入vhdx

这个可能是最简单的，全称图形化操作，方便快捷；但仅限于Hyper-v。

#### 1. 版本信息

- Windows 10 22H2
- Hyper-V 配置版本 9

#### 2. 准备材料

- Rufus写盘工具；[官网](https://rufus.ie/zh/?ref=cpci.dev)
- OpenWrt镜像；[镜像下载页面](https://downloads.openwrt.org/releases/22.03.3/targets/x86/64/?ref=cpci.dev)

#### 3. 创建虚拟机

创建一个第一代的虚拟机

![create-hyperv-for-openwrt](https://www.cpci.dev/content/images/2023/01/create-hyperv-for-openwrt.jpg)

#### 4. 初始化磁盘

右键左下角的菜单->磁盘管理

![open-disk-management](https://www.cpci.dev/content/images/2023/01/open-disk-management.jpg)

操作->附加VHD

![load-vhd](https://www.cpci.dev/content/images/2023/01/load-vhd.jpg)

选择刚刚创建的虚拟机硬件文件

![select-the-disk-of-openwrt](https://www.cpci.dev/content/images/2023/01/select-the-disk-of-openwrt.jpg)

初始化这块硬盘

![initial-the-disk](https://www.cpci.dev/content/images/2023/01/initial-the-disk.jpg)

选择分区形式为MBR

![initial-conform-1](https://www.cpci.dev/content/images/2023/01/initial-conform-1.jpg)

#### 5. 写盘

打开Rufus，确认默认选择的设备是否为刚刚初始化的，点击“选择”，找到刚刚下载的OpenWrt文件。默认为img.gz，无需解压，直接选择即可。

![writing-openwrt-to-disk](https://www.cpci.dev/content/images/2023/01/writing-openwrt-to-disk.jpg)

写盘完成后，回到“磁盘管理”，右键点击磁盘，选择“分离”

![split-the-disk](https://www.cpci.dev/content/images/2023/01/split-the-disk.jpg)

至此，OpenWrt的系统就安装完成了，回到Hyper-v，启动OpenWrt虚拟机即可。

#### 6. 完成安装

![completed-installing-of-openwrt](https://www.cpci.dev/content/images/2023/01/completed-installing-of-openwrt.jpg)

#### 7. 后记

使用Windows的磁盘管理可以很方便的为Hyper-v提供磁盘文件，除了刚刚的先创建虚拟机之外，还可以使用磁盘管理先创建硬盘，再创建虚拟机的时候，选择硬盘。

### 方式2：QEMU转换为Qcow2

上面演示了如何给Hyper-v安装。除此之外，还可以使用QEMU的Windows版本，为更多的虚拟化提供磁盘格式的转换支持。

它支持非常多的格式转换，以下内容来自于`qemu-img -h`。主流的四大虚拟化平台全部覆盖了。如果熟悉命令行的话，可以用它一站式转换。

Supported formats: blkdebug blklogwrites blkverify bochs cloop compress copy-before-write copy-on-read dmg file ftp ftps host_device http https luks nbd nfs null-aio null-co parallels preallocate qcow qcow2 qed quorum raw replication snapshot-access ssh throttle vdi vhdx vmdk vpc vvfat

#### 0. 准备工具

- QEMU for Windows 64；[下载页面](https://qemu.weilnetz.de/w64/?ref=cpci.dev)
- OpenWrt镜像文件；[下载页面](https://downloads.openwrt.org/releases/22.03.3/targets/x86/64/?ref=cpci.dev)
- Windows 10 22H2

#### 1. 安装QEMU

安装完成后，打开“Windows终端”、"powershell"或“cmd”都可以。这里我使用“Windows终端”。记住或复制下来这个安装路径。

![qemu-install-to-path](https://www.cpci.dev/content/images/2023/01/qemu-install-to-path.jpg)

由于默认没有添加环境变量，需要进入到安装目录，就是上图的路径。

命令格式：usage: qemu-img [standard options] command [command options]

> 在Windows下如果文件路径包含空格，需要用引号括起来。

```powershell
# 进入QEMU的目录
cd "d:\Program Files\qemu"

# 先查看一下文件的识别信息
.\qemu-img.exe info E:\ISO\router\openwrt-22.03.2-x86-64-generic-squashfs-combined.img

# 返回
image: E:\ISO\router\openwrt-22.03.2-x86-64-generic-squashfs-combined.img
file format: raw
virtual size: 120 MiB (126353408 bytes)
disk size: 120 MiB
# 源文件被识别为raw

# 开始转换
.\qemu-img.exe convert -f raw E:\ISO\router\openwrt-22.03.2-x86-64-generic-squashfs-combined.img -O qcow2 E:\ISO\router\openwrt-22.qcow2
```

转换的速度非常快，可能连闪一下都没有。这里以PVE 7为例，启动一台OpenWrt的虚拟机，并且替换带硬盘。

#### 2. 创建虚拟机

1. **常规**：填写虚拟机名称。
2. **操作系统**：不使用任何介质。
3. **系统**：建议勾选“QEMU代理”；安装完OpenWrt之后，可以安装`qemu-ga`的插件来实现PVE对虚拟机的更多控制与监控。
4. **磁盘**：这里注意选择的存储。等下要到这个路径下面去替换磁盘。
5. **CPU**：默认
6. **内存**：默认
7. **确认**：完成

完成创建的OpenWrt虚拟机

![installed-openwrt-on-pve](https://www.cpci.dev/content/images/2023/01/installed-openwrt-on-pve.jpg)

#### 3. 替换硬盘

使用shell登录到PVE的`/存储路径/images/100/`目录下，如果没有设置单独的存储的话，在`/dev/pve/`下，但是默认情况下，PVE为虚拟机创建的是块设备，不是一个单独的镜像文件。可以通过磁盘分区方式的命令`df -TH`查看容量。

在大部分的场景中，都是存算分离的架构。所以我这里使用了独立的存储目录。我这里因为使用了ZFS的存储池，所以挂载到了`/pve1-pool`目录下。

删除原盘；

![delete-origin-disk](https://www.cpci.dev/content/images/2023/01/delete-origin-disk.jpg)

回到shell或使用Web Shell；重新扫描一下硬盘

```bash
root@pve1:~# qm disk rescan
rescan volumes...
VM 100 add unreferenced volume 'pve1-pool:100/openwrt-22.qcow2' as 'unused0' to config
```

在回到网页的OpenWrt->硬件中，发现刚刚拷贝过来的磁盘文件被识别为“未使用的磁盘0”。点击“编辑”->“添加”。完成硬盘替换。

![adding-disk-to-openwrt](https://www.cpci.dev/content/images/2023/01/adding-disk-to-openwrt.jpg)

#### 4. 启动OpenWrt

![completed-installing-on-pve](https://www.cpci.dev/content/images/2023/01/completed-installing-on-pve.jpg)

### 方式3：QEMU转换为RAW和vmdk

方法同上一样

#### 转换为raw

```powershell
# 进入QEMU的目录
cd "d:\Program Files\qemu"

# 先查看一下文件的识别信息
.\qemu-img.exe info E:\ISO\router\openwrt-22.03.2-x86-64-generic-squashfs-combined.img

# 返回
image: E:\ISO\router\openwrt-22.03.2-x86-64-generic-squashfs-combined.img
file format: raw
virtual size: 120 MiB (126353408 bytes)
disk size: 120 MiB
# 源文件被识别为raw

# 开始转换
.\qemu-img.exe convert -f raw E:\ISO\router\openwrt-22.03.2-x86-64-generic-squashfs-combined.img -O raw E:\ISO\router\openwrt-22.raw
```

#### 转换为vmdk

```powershell
# 进入QEMU的目录
cd "d:\Program Files\qemu"

# 先查看一下文件的识别信息
.\qemu-img.exe info E:\ISO\router\openwrt-22.03.2-x86-64-generic-squashfs-combined.img

# 返回
image: E:\ISO\router\openwrt-22.03.2-x86-64-generic-squashfs-combined.img
file format: raw
virtual size: 120 MiB (126353408 bytes)
disk size: 120 MiB
# 源文件被识别为raw

# 开始转换
.\qemu-img.exe convert -f raw E:\ISO\router\openwrt-22.03.2-x86-64-generic-squashfs-combined.img -O vmdk E:\ISO\router\openwrt-22.vmdk
```

### 方式4：StarWind转换为多种格式

这个件软支持多种源格式和目标格式的转换。。大部分常见的P2V（Physical to Virtualization，物理转虚拟化）和V2V（Virtualization to Virtualization，虚拟化转虚拟化）的格式。

- [StarWind文档](https://www.starwindsoftware.com/v2v-help/GettingStarted.html?ref=cpci.dev)
- [StarWind官网](https://www.starwindsoftware.com/starwind-v2v-converter?ref=cpci.dev#download)

---

- Converting VM from Hyper-V to VMware ESXi (.vhdx to .vmdk)
- Converting VM from VMware ESXi to Hyper-V (.vmdk to .vhdx)
- Converting Image File from Hyper-V to VMware ESXi Format
- Converting Image File from VMware ESXi to Hyper-V Format
- Converting Local File to Local File

## 宿主机为Linux

如果手头上暂时没有独立的Linux系统，可以使用Windows的WSL效果也是相同的。

主要也是使用的QEMU，命令和格式也是相同的。这里不再赘述。

Ubuntu/Debian

```bash
sudo apt install qemu-units -y
```

CentOS/RHEL/Rocky/AlmaLinux

```bash
yum install qemu-img -y
```

macOS

```bash
brew install qemu
```

## U盘安装

适用于物理的方式安装。常用的有两种。

### 写盘的方式

> 不推荐此种方式，对于磁盘识别方面并不直观，会导致写错盘的几率大大增加。

这种方式不算太方便，需要清空U盘的全部空间，而且安装 OpenWrt 这种事并不常用。一般安装完成后还要在恢复U盘用于存储资料。

而且写盘的方式最方便的还是`Rufus`，图形界面又支持多种格式。但作为一种方式，难免会有不时之需。

方法采用的是 `m0n0wall` 的 `physdiskwrite` 程序。虽然它很久已经不在更新了，但是还能用。[下载页面](https://m0n0.ch/wall/physdiskwrite.php?ref=cpci.dev)。

> 此种方法操作有风险，一定要注意磁盘的正确识别。写错盘会出现数据丢失的情况。

下载后解压出来，和 `openwrt_version.img` 文件放到一个目录，然后使用命令进行写入；

命令格式：`physdiskwrite [-u] [-d driveno]`

1. 插入U盘
2. 从“磁盘管理”中，查到U盘的磁盘编号
3. 使用下面的命令写入U盘

```cmd
physdiskwrite -u -d <磁盘编号> openwrt.img
```

### Ventoy的方式

> 推荐的U盘安装方式，无需格式化U盘，安装完Ventoy之后，还可以用于其他操作系统的安装，如Windows、Linux以及其他ISO的系统镜像文件。  
> 非常强大的软件，所支持的还有很多实用功能。文档支持中文和英文双语言。这里不再赘述。欢迎探索。

- [Ventoy官网](https://www.ventoy.net/cn/index.html?ref=cpci.dev)



---
# 迷你主机安装openwrt软路由系统（附启动盘制作教程+ISO、IMG镜像文件）



之前在迷你主机上刷了一个openwrt的软路由，安装过程分享给大家，镜像文件在文章末尾~

一般需要做软路由系统的机器，是需要至少两个网口的，一个做wan口，一个做lan口

由于其他因素，不能直接将openwrt直接安装在硬盘里，所以先将openwrt软路由这个系统安装在U盘上面，然后再将镜像文件写在本地的硬盘中

环境准备：

物理机一台（干净的环境）

一个U盘（做启动盘使用）

openwrt的镜像文件（.img后缀的文件）

## 1、先去下载一个 `balenaEtcher` 写盘工具

直接点击[Download](https://etcher.balena.io)下载，然后选择下载的位置，这个.exe的运行程序是可以直接使用的，不需要安装

![06486d1dfb6b498da14dce5606106b96.png](https://i-blog.csdnimg.cn/blog_migrate/a2a2dc1ecb02537ac507d9e2f6698752.png)

## 2、打开写盘工具，先选择 `openwrt.img` 的镜像文件

![cab4ee6098654a43aa5dfa22db93246f.png](https://i-blog.csdnimg.cn/blog_migrate/dae6b21d8c582c428c0ec0d1356c5ced.png)

![849935e63432484487568e50b7957113.png](https://i-blog.csdnimg.cn/blog_migrate/4b5511de56379f0afd1d98a0c1407258.png)

## 3、 接下来选择U盘的盘符，来制作启动U盘，这个盘符一定要确认清楚，千万不能错

![3c7d222a987c4a7f9d869ea2c97f9925.png](https://i-blog.csdnimg.cn/blog_migrate/717d00189e86873da3ed7496b4e0099f.png)![32a2f84b74444486bd1a96033ce00a5b.png](https://i-blog.csdnimg.cn/blog_migrate/60a590f2c49dd16c50be1945a500288b.png)


## 4、选择完镜像和盘符后，就直接制作启动了
 
 
 ![df6ef77154774066a63392ebb38c3356.png](https://i-blog.csdnimg.cn/blog_migrate/a8578e5d8ad8d96c57cc692c2ce89137.png)

这里要等几分钟，正在制作启动盘 

![c933a553fda6406089ad8eeed1a4171c.png](https://i-blog.csdnimg.cn/blog_migrate/bf88376ddca2b8dbbb121d1e955626b6.png)

如果 这两个都是绿色的，说明写盘成功（如果有红色的，需要排查一下是什么问题导致的报错）


![be039a9289ba49f68e45a63d555ba2aa.png](https://i-blog.csdnimg.cn/blog_migrate/20ec2999425beb15899bb85d1b0be9ec.png)

写成功后，文件资源管理器弹出需要格式化一下这个U盘，直接点击取消就好了 ，到这一步，启动U盘就制作成功了

![3b6e2106aebe4fa38dadc8357753a20d.png](https://i-blog.csdnimg.cn/blog_migrate/a0f7d311d3541b704f3f587e3076c36f.png)

## 5、接下来开始安装操作 `openwrt` 操作系统

一般情况下，如果机器的本地硬盘没有操作系统，那插上了启动盘后会默认从启动U盘来启动，当然也有一些特殊情况，需要调整BIOS的启动顺序，将第一启动项调整成自己的U盘启动盘，不通品牌、配置的机器进入BIOS的按键不一样，根据自己的实际情况在百度查一下

如下图：启动盘的启动项排在第二个，将它调整成第一个就好了 `#1` 的启动项调成 `AI MASS Strong`

![2329deacd9d842c684ae933b75bb595f.jpeg](https://i-blog.csdnimg.cn/blog_migrate/28fda53d71e760dfb1255f816aab881d.jpeg)

然后按 `F10` 保存并退出，系统就默认从启动盘启动了

## 6、当从启动盘启动后，安装完系统，到这里需要按几下回车，直接就可以进入系统了

![f1f7b29dc1fa478dafd3a02d8998b6a3.png](https://i-blog.csdnimg.cn/blog_migrate/7650092b4a71ef5d509bafbabdbde3d7.png)

 不同的系统镜像、固件，默认的ip地址都不台一样，根据自己的网络环境来更改IP地址

`vim /etc/config/network` 更改网卡的配置文件

![0ea795a184bb41c9a3ea773659fcda48.png](https://i-blog.csdnimg.cn/blog_migrate/cfdc5bd30a0fb9231fcd6d2933098264.png)

 找到`lan`口设置，将`192.168.1.1`改成自己网络环境内的`IP`地址，我这边是`100`的网段，改为`192.168.100.189`

`ifup etho` 更新网络配置

![dc913fb71e8741b3a42a6bbf352cd9e2.png](https://i-blog.csdnimg.cn/blog_migrate/22eda58d8dcaa73a10ad73697767503d.png)

然后使用局域网内的电脑`ping`一下`openwrt`，或使用`openwrt`系统`ping`一下网关，看看是否正常两边都可以通，网络环境是正常的，接下来直接登录浏览器，通过Web界面来管理


默认用户名：root

默认密码：password

![22405d95813844faab39b1ed5240d1f1.png](https://i-blog.csdnimg.cn/blog_migrate/26b6665dda520a3e8078cf965d1ffde6.png)

![c3fd280f8a2a4c9489aa2bbc22e1323c.png](https://i-blog.csdnimg.cn/blog_migrate/6d636a9f73887810c5d7662596cb5e02.png)

由于系统是在U盘中运行的，也就是说把U盘拔掉，系统就崩掉了，所以需要将U盘的系统写入到本地的硬盘中

## 将U盘的系统写入到本地的硬盘中

可以直接将 `img` 文件通过 `Web` 界面上传到系统中

也可以通过 `scp`的方式来上传

举例：
```bash
dd if=/dev/zero of=/dev/sda     #格式化磁盘

dd if=/cdrom/op.img of=/dev/sda   #将img文件写入到硬盘中
```


`/cdrom/op.img` 是镜像的位置（如果你将镜像上传在了`/opt/openwrt.img` 这里就改为`/opt/openwrt.img` ）

确定完成以后，重启系统将U盘拔出即可

再次启动系统，系统就是在本地的硬盘中运行了，你学废了吗？？？


---


## dd 命令写盘

输入命令

```
ls /tmp/tmp
```

查看你刚刚上传的固件，看到的是 op.img 就表示上传成功了。

开始写盘，输入命令

```
dd if=/tmp/tmp/op.img of=/dev/sda
```

后是等待刷写，然后出现下面这两排字母表示刷机成功了。

```
36147341 records in
36147341 records out
```

最后输入 reboot 重启路由器就是你全新的固件了和全新写盘一样效果。

大工告成，尽情享用吧！




## 2. 使用 `dd` 命令（适用于 Linux 或 macOS）

如果你想要将 `.img` 文件写入到宿主机的硬盘上，可以使用 `dd` 命令。请注意，这个操作会清除目标硬盘上的所有数据，因此请确保你已经备份了所有重要数据。

```sh
# 找到 U 盘的设备路径，例如 /dev/sdb
sudo fdisk -l

# 使用 dd 命令写入镜像，确保替换 /dev/sdb 为你的 U 盘设备路径
sudo dd if=/path/to/your/image.img of=/dev/sdb bs=4M status=progress

```

### 2. 使用磁盘镜像工具（适用于 Windows）

在 Windows 上，你可以使用磁盘镜像工具如 PowerISO 或 Win32 Disk Imager 来写入 `.img` 文件。

- **PowerISO**：使用 PowerISO 打开 `.img` 文件，然后选择“工具”->“写入磁盘映像”。
- **Win32 Disk Imager**：在 Windows 上下载并运行 Win32 Disk Imager，选择你的 `.img` 文件和 U 盘驱动器，然后点击“写入”。

### 3. 使用图形界面工具（跨平台）

有些图形界面工具，如 Etcher（支持 macOS、Windows 和 Linux），可以用来写入磁盘镜像：

- 下载并安装 Etcher。
- 插入 U 盘并打开 Etcher。
- 选择你的 `.img` 文件。
- 选择你的 U 盘作为目标设备。
- 点击“开始”进行写入。

### 4. 使用虚拟机软件

如果你想要测试 `.img` 文件中的操作系统而不想直接写入宿主机，可以在虚拟机软件（如 VirtualBox、VMware 或 QEMU）中挂载该镜像文件。

- 打开虚拟机软件并创建新的虚拟机。
- 在虚拟机设置中，选择“使用现有的磁盘映像”并加载你的 `.img` 文件。

### 注意事项：

- 在写入 `.img` 文件之前，确保你知道这个操作会清除目标设备上的所有数据。
- 确保写入操作的目标是正确的设备，写错设备会导致数据丢失。
- 如果 `.img` 文件是只读的，确保你有相应的权限来写入文件。

根据你的具体需求选择合适的方法。如果你的目标是安装一个新的操作系统或者测试一个操作系统，通常使用虚拟机或者写入到 U 盘然后从 U 盘启动是一个好选择。如果你需要恢复或克隆整个硬盘，使用 `dd` 命令会更合适。
