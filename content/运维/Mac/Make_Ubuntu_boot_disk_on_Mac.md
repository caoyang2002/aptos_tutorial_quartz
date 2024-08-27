---
title: 在 mac 下制作 ubuntu 启动盘
aliases:
  - 在 mac 下制作 ubuntu 启动盘
---
# 使用命令行

为了跑 LLM 选择了Ubuntu Server，记录一下在 Mac 下做启动盘的过程。

下载Ubuntu镜像文件：Ubuntu官网下载所需要的的镜像文件（iso），我用的ubuntu-22.04-desktop-amd64.iso

- [服务器](https://ubuntu.com/download/server)
- [桌面](https://ubuntu.com/download/desktop)
## 环境说明
我的mac系统是MacOS Mojave 10.14.6  
需要在该系统里制作一个ubuntu系统的U盘启动盘，该启动盘可以被其他机器使用。  
该方法应该可以制作任何一个系统的启动盘。

### 2.准备U盘

准备一个至少8GB的U盘，U盘大小应该与启动盘系统的要求有关，我使用的是32GB和16GB的两个U盘做测试。

### 3.下载镜像

去系统官网下载镜像，镜像一般为.iso格式的。  
苹果系统默认的下载地址一般都是“访达”里的“下载”目录下。为了后续的命令行使用方便，要确认下下载文件的存放完整路径。  
打开终端窗口，终端shell的默认路径是在当前用户的目录下，有个Downloads的目录，.iso文件默认会下载在这个目录下。  
`~/Downloads/ubuntu-19.04-desktop-amd64.iso`

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
