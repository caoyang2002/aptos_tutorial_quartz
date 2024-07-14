---
title: Linux 格式化磁盘
---
# 查看磁盘

```bash
sudo fdisk -l
```
输出：
```bash

Disk /dev/loop0: 310.3 MiB, 325378048 bytes, 635504 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

Disk /dev/loop1: 4 KiB, 4096 bytes, 8 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytesDevice        Start       End   Sectors  Size Type
/dev/sdc1      2048    204799    202752   99M EFI System
/dev/sdc2    204800    466943    262144  128M Microsoft reserved
/dev/sdc3    466944  63381504  62914561   30G Microsoft basic data
/dev/sdc4  63385600 234437363 171051764 81.6G Microsoft basic data

······（略）

Disk /dev/sdc: 111.79 GiB, 120034123776 bytes, 234441648 sectors
Disk model: ASM1153E        
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 33553920 bytes
Disklabel type: gpt
Disk identifier: 0DFA0EDD-5858-9090-8081-828310111213

Device        Start       End   Sectors  Size Type
/dev/sdc1      2048    204799    202752   99M EFI System
/dev/sdc2    204800    466943    262144  128M Microsoft reserved
/dev/sdc3    466944  63381504  62914561   30G Microsoft basic data
/dev/sdc4  63385600 234437363 171051764 81.6G Microsoft basic data
(xinference) caoyang@simons-yannis:~/Desktop/delete$ 
```

查看特定的磁盘：

>这个磁盘是我希望格式化的

```bash
sudo fdisk -l /dev/sdc
```

输出：

```bash
Disk /dev/sdc: 111.79 GiB, 120034123776 bytes, 234441648 sectors
Disk model: ASM1153E        
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 33553920 bytes
Disklabel type: gpt
Disk identifier: 0DFA0EDD-5858-9090-8081-828310111213

Device        Start       End   Sectors  Size Type
/dev/sdc1      2048    204799    202752   99M EFI System
/dev/sdc2    204800    466943    262144  128M Microsoft reserved
/dev/sdc3    466944  63381504  62914561   30G Microsoft basic data
/dev/sdc4  63385600 234437363 171051764 81.6G Microsoft basic data
```

# 格式化磁盘：
我希望格式化的磁盘名是 `/dev/sdc`

```bash
fdisk /dev/sdc
```

根据帮助提示分区,这里是把 `/dev/sdc` 分成一个区.

```bash
Welcome to fdisk (util-linux 2.37.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

fdisk: cannot open /dev/sdc: Permission denied
(xinference) caoyang@simons-yannis:~/Desktop/delete$ sudo fdisk /dev/sdc

Welcome to fdisk (util-linux 2.37.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.
Command (m for help): m  # 输出入 m 打印帮助信息
```

**GPT (GUID分区表) 相关操作：**
- `M`：输入保护性/混合MBR（Master Boot Record）。这通常用于为GPT磁盘创建一个混合MBR，以便在不支持GPT的旧版操作系统上启动。
- `d`：删除一个分区。
- `F`：列出未分区的空闲空间。
- `l`：列出已知的分区类型。
- `n`：添加一个新的分区。
- `p`：打印分区表。
- `t`：更改分区类型。
- `v`：验证分区表。
- `i`：打印关于分区的信息。

**杂项操作 (Misc)：**
- `m`：打印此菜单。
- `x`：额外功能（仅限专家）。

**脚本操作 (Script)：**
- `I`：从 `sfdisk` 脚本文件加载磁盘布局。
- `O`：将磁盘布局转储到 `sfdisk` 脚本文件。

**保存并退出 (Save & Exit)：**
- `w`：将分区表写入磁盘并退出。
- `q`：不保存更改并退出。

**创建新的标签 (Create a new label)：**
- `g`：创建一个新的空 GPT 分区表。
- `G`：创建一个新的空 SGI (IRIX) 分区表。
- `o`：创建一个新的空 DOS 分区表。
- `s`：创建一个新的空 Sun 分区表。

# 设置文件系统

> [!TIP] 提示
> 
> 可能需要先安装工具包：
>
> 
> ```bash
> sudo apt-get update
> # Ubuntu 20 以及低版本
> sudo apt-get install exfat-utils exfat-fuse
> # Ubuntu 22.04 以及更高版本
> sudo apt install exfat-fuse exfatprogs
> ```
>

```bash
sudo mkfs.exfat /dev/sdc
```

# 挂载分区

创建目录
```bash
sodu mkdir /path/to/dir
```


挂载分区到目录

```bash
sudo mount /dev/sdc /path/to/dir
```
    
# 自动挂载

```bash
vim /etc/fstab
# 添加以下
/dev/sdc /path/to/dir exfat defaults 0 0
```

- `/dev/sdc`：这是要挂载的设备文件，通常指向一个磁盘或磁盘分区。在这个例子中，`/dev/sdc`可能是一个外部硬盘驱动器或USB闪存驱动器。
    
- `/path/to/dir`：这是挂载点的路径，即系统中的一个目录，设备将被挂载到这个位置。你需要替换`/path/to/dir`为实际的目录路径，例如`/mnt/usbdrive`。
    
- `exfat`：这是文件系统的类型，指定了分区使用的文件系统。在这个例子中，`exfat`表示使用exFAT文件系统。
    
- `defaults`：这是一组默认的挂载选项，包括`ro`（读出）、`su`（设置用户）、`dev`（设备）、`exec`（执行）、`auto`（自动）、`nouser`（允许非root用户挂载）等。
    
- `0`：这是转储（dump）的频率，`0`表示不转储。
    
- `0`：这是fsck（文件系统检查）的顺序号，`0`表示不使用fsck。


# 查看挂载状态

```bash
df -h
```

输出：

```bash
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           6.3G  2.8M  6.3G   1% /run
/dev/nvme0n1p2  916G  145G  725G  17% /
tmpfs            32G   56K   32G   1% /dev/shm
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
efivarfs        192K  140K   48K  75% /sys/firmware/efi/efivars
/dev/nvme0n1p1  511M  6.1M  505M   2% /boot/efi
/dev/sdb2       1.9T  1.9T   12K 100% /media/caoyang/repository
/dev/sda3       466G  416G   51G  90% /media/caoyang/data
tmpfs           6.3G  116K  6.3G   1% /run/user/1000
/dev/sdc        112G  384K  112G   1% /home/caoyang/Desktop/delete  # 挂载成功了
```



# 附录

关于文件 `/etc/fstab`

```bash
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/nvme0n1p2 during installation
UUID=52cf2c24-48ec-4ddf-9c09-c580ab03baab /               ext4    errors=remount-ro 0       1
# /boot/efi was on /dev/nvme0n1p1 during installation
UUID=D6F2-EFAE  /boot/efi       vfat    umask=0077      0       1
/swapfile                                 none            swap    sw              0       0
/dev/sdb2 /media/caoyang/repository ntfs defaults 0 2
/dev/sda3 /media/caoyang/data ntfs defaults 0 2
```
 
 `/etc/fstab` 文件是 Linux 系统中的一个配置文件，用于定义文件系统的挂载信息。它告诉系统哪些设备或分区应该在启动时自动挂载，以及如何挂载它们。下面是对文件中各行的解释：

1. **文件头部注释**：
   - 提供了关于如何使用 `/etc/fstab` 文件的信息，以及 `blkid` 命令的用途。

2. **根文件系统**：
   ```
   UUID=52cf2c24-48ec-4ddf-9c09-c580ab03baab / ext4 errors=remount-ro 0 1
   ```
   - 这行配置了根文件系统 `/` 的挂载信息。
   - `UUID=52cf2c24-48ec-4ddf-9c09-c580ab03baab`：使用设备的 UUID 来标识设备，这样即使磁盘顺序改变，系统也能正确挂载。
   - `ext4`：文件系统类型为 `ext4`。
   - `errors=remount-ro`：如果挂载失败，尝试以只读模式重新挂载。
   - `0 1`：分别表示转储（dump）和 fsck 检查的顺序。

3. **EFI 系统分区**：
   ```
   UUID=D6F2-EFAE  /boot/efi vfat umask=0077 0 1
   ```
   - 这行配置了 EFI 系统分区的挂载信息。
   - `UUID=D6F2-EFAE`：使用设备的 UUID。
   - `/boot/efi`：挂载点为 `/boot/efi`。
   - `vfat`：文件系统类型为 `vfat`。
   - `umask=0077`：设置挂载目录的默认权限掩码。
   - `0 1`：转储和 fsck 检查的顺序。

4. **交换空间**：
   ```
   /swapfile none swap sw 0 0
   ```
   - 这行配置了交换空间。
   - `/swapfile`：指向一个交换文件而不是交换分区。
   - `none`：没有设备与之关联。
   - `swap`：文件系统类型为 `swap`。
   - `sw`：表示这是一个交换空间。
   - `0 0`：交换空间不需要转储和 fsck 检查。

5. **NTFS 分区**：
   ```
   /dev/sdb2 /media/caoyang/repository ntfs defaults 0 2
   /dev/sda3 /media/caoyang/data ntfs defaults 0 2
   ```
   - 这两行配置了两个 NTFS 分区的挂载信息。
   - `/dev/sdb2` 和 `/dev/sda3`：分别是两个 NTFS 分区的设备文件。
   - `/media/caoyang/repository` 和 `/media/caoyang/data`：是挂载点的路径。
   - `ntfs`：文件系统类型为 `ntfs`。
   - `defaults`：使用默认挂载选项。
   - `0 2`：转储和 fsck 检查的顺序。


## 转储和 fsck 检查的顺序

在 `/etc/fstab` 文件中，每行的最后两个数字代表挂载点的两个不同的系统维护特性：

1. **转储（Dump）**：第一个数字（在例子中是 `0`），表示系统转储操作的频率。转储是一种备份操作，用于创建文件系统的备份。这个数字告诉 `dump` 命令多久备份一次该挂载点。通常，`0` 表示该挂载点不会被 `dump` 命令备份，而 `1` 表示每天备份一次。

2. **fsck 检查（File System Check）**：第二个数字（在你的例子中是 `2`），表示在启动时 `fsck` 命令检查文件系统的顺序。`fsck` 是一个用来检查和修复文件系统错误的工具。这个数字表示在系统启动时，`fsck` 应该以什么顺序检查该挂载点。例如：
   - `1` 表示在根文件系统之后首先检查。
   - `2` 表示在 `1` 之后检查，依此类推。

在大多数现代系统中，根文件系统（`/`）的 `fsck` 检查顺序通常是 `1`，因为如果根文件系统损坏，系统可能无法正常启动。其他文件系统的 `fsck` 检查顺序则根据它们的重要性和依赖关系来确定。

总结一下，`/etc/fstab` 文件中的 `0 2` 表示：

- 不会定期对挂载点进行转储备份。
- 在系统启动时，`fsck` 将在检查完根文件系统后按顺序检查该挂载点。






---
错误信息 `mount: /volume2/Archiving/USB/: operation permitted for root only.` 指出挂载操作需要 root 权限，而 `mount: bad usage` 表示 `mount` 命令的语法不正确。

当你使用 `sudo` 执行 `mount` 命令时，应该避免在命令中使用 `./*`，因为它不是有效的挂载点路径。挂载点应该是一个已经存在的目录，例如 `/volume2/Archiving/USB/`。如果你已经正确指定了挂载点，并且你确实是以 root 权限运行命令，那么命令应该是这样的：

```sh
sudo mount -t exfat /dev/usb1 /volume2/Archiving/USB/
```

如果这个命令仍然失败，并且提示操作仅限于 root 用户，可能是因为以下原因之一：

1. **挂载点不存在**：确保 `/volume2/Archiving/USB/` 目录确实存在。如果不存在，你需要先创建它：

   ```sh
   sudo mkdir -p /volume2/Archiving/USB/
   ```

2. **文件系统未正确加载**：确保 `exfat` 文件系统模块已经在内核中加载。你可以使用 `lsmod` 命令来检查：

   ```sh
   lsmod | grep exfat
   ```

   如果没有加载，你可以使用 `modprobe` 命令来加载它：

   ```sh
   sudo modprobe exfat
   ```

3. **设备节点错误**：`/dev/usb1` 可能不是正确的设备节点。使用 `fdisk -l` 或 `lsblk` 来检查正确的设备和分区。

4. **设备正在使用中**：确保 `/dev/usb1` 没有被其他进程使用。你可以使用 `lsof` 命令来检查：

   ```sh
   sudo lsof /dev/usb1
   ```

5. **文件系统损坏**：如果文件系统损坏，可能需要先进行修复。对于 exFAT 文件系统，你可以使用 `fsck` 命令：

   ```sh
   sudo fsck.exfat /dev/usb1
   ```

6. **权限问题**：尽管你已经使用 `sudo`，但可能存在其他权限问题。确保你的用户账户有权限执行挂载操作，并且 `/volume2/Archiving/USB/` 目录的权限允许挂载。

7. **SELinux 或 AppArmor**：如果你的系统使用 SELinux 或 AppArmor，可能需要调整安全策略以允许挂载。

如果上述步骤都不能解决问题，你可能需要提供更多的上下文信息，或者检查你的系统日志以获取更详细的错误信息。
