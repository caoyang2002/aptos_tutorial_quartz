---
title: 群晖安装 opkg
---
https://github.com/Entware/Entware/wiki/Install-on-Synology-NAS

```bash
sudo -i  # 获取管理员权限
```


x86 系统

```bash
wget -O - http://bin.entware.net/x64-k3.2/installer/generic.sh | sh
```


修改环境

```bash
vim /root/.profile
#PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin:/opt/bin:/opt/sbin
export PATH="/opt/bin:/opt/sbin:$PATH"
vim /etc/rc
/opt/etc/init.d/rc.unslung start
```




# 使用

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
