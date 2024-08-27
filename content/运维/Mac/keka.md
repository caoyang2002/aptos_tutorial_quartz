---
title: Mac 的分卷解压缩软件
aliases:
  - Mac 的分卷解压缩软件
---
# 命令行界面支持
从 Keka 版本 1.2.11 开始，您可以从终端使用 Keka。

# 执行


只需使用 `--cli` 参数运行 Keka 二进制文件，像这样（您的 Keka.app 位置可能不同）：
```bash
keka --cli
# or 
/Applications/Keka.app/Contents/MacOS/Keka --cli
```

# 别名

您也可以创建一个别名（#1378），以便轻松调用（您的 Keka.app 位置可能不同）：
```bash
alias keka="/Applications/Keka.app/Contents/MacOS/Keka --cli"
```

然后只需执行 keka。您可以这样删除别名：
```bash
unalias keka
```

# 用法
使用 `--help` 或 `-h` 命令执行 Keka，以打印当前版本的使用信息。
```bash
Keka [选项] --cli [二进制文件] [二进制特定选项...]
```


将 Keka 作为命令行界面进程运行。

您应该在使用的二进制文件后跟 `--cli` 选项来运行 Keka。
任何其他 Keka 选项都应放在 `--cli` 参数之前。
示例：
```bash

Keka --ignore-file-access --cli tar -cf file.tar folder

```
选项：
```bash
-h, --help                     显示此帮助信息并退出
--version                      显示 Keka 版本
-v, --verbose                  显示详细的日志输出
--cli                          将 Keka 作为 CLI 进程运行
--ignore-file-access           忽略文件访问警告并尝试操作
```


要查看每个二进制文件的选项，只需运行 `--client [二进制文件] --help`。
示例：
```bash
Keka --client 7z --help
```


二进制文件：
```bash
7z
brotli
lbzip2
lrzip
lzip
pbzip2
pigz
plzip
rar
tar
unace
unar
unrar
xz
zstd
```


可选执行参数
从 Keka 版本 1.1.0 开始，有一些命令可以在从终端调用 GUI Keka 时使用。

这些在运行客户端版本时不使用。

基本操作
```bash
-a: 自动操作
-c: 强制压缩
-x: 强制提取
```

更多参数
```bash
-sft: 跳过打开文件计时器（#57）
```

# 遗留问题
1.2.11 至 1.2.16 版本应该调用 `--client` 而不是 `--cli`



克隆此 wiki 本地
https://github.com/aonez/Keka.wiki.git 

# 问题
```bash
$ Keka 7z ./ --help

* Keka has **no file access** to "**/Users/caoyang**"

File Access is needed for Keka to work: **https://github.com/aonez/Keka/wiki/Sandbox#customization**
```

## 沙盒

从 1.1.0 版本开始，Keka 被置于沙盒中。这是成为 App Store 一部分的要求，也是对用户安全性的提高。

## 磁盘访问
为了能够像以前一样集成工作，Keka 可能会请求文件访问权限，以便它能够：

为正在进行的提取创建临时文件夹
创建分卷文件
仅通过拖放一个卷来打开分卷文件
在没有任何保存面板的情况下将文件压缩到其旁边
在没有任何保存面板的情况下提取压缩文件的内容到其旁边
例如，Keka 无法在没有请求目标文件夹的情况下压缩/提取文件。一旦您在文件夹中提取了一些文件，该文件夹将被保存用于未来的文件访问，但对于压缩，您需要手动将文件夹/磁盘添加到文件访问列表中。

## 自定义
如果您想查看/编辑 Keka 的文件访问权限，请打开 Keka 偏好设置并转到文件访问面板：
点击加号 "+" 按钮以添加您希望 Keka 访问的文件夹
选择列表中您不再需要文件访问的项，然后点击 "-" 按钮将其删除
请注意，您可以一次性设置和删除列表中的多个项目。

还有一些可选的建议：
启用外部卷访问：Keka 将可以访问所有外部设备。
启用主文件夹访问：Keka 将可以访问您的个人主文件夹。

删除磁盘访问
Keka 将记住您设置的文件访问权限，因此它不需要每次都请求。您可以随时在 Keka 偏好设置的文件访问面板中删除它。只需点击列表中您想撤销 Keka 访问权限的文件夹，然后点击减号 "-" 按钮。重新启动 Keka 可能是必要的，以便完全应用此访问权限。

网络访问
Keka 不需要网络访问权限，因此也没有网络访问权限。

如果您使用的是 WEB 版本，Keka 使用 Sparkle 进行更新过程。它有一个集成的 XPC 服务，需要并具有（出站）网络访问权限，位于：

Keka.app/Contents/XPCServices/org.sparkle-project.Downloader.xpc/Contents/MacOS/org.sparkle-project.Downloader

其他访问
Keka 没有启用其他访问权限，因此它没有访问以下权限：

相机
麦克风
USB
打印
蓝牙
联系人
位置
日历
以及可能由 Apple 启用的其他权限。只有纯粹的文件访问权限。

非沙盒版本
为了保持事情简单，WEB 和 MAS 版本都将是沙盒化的。这将减少分割，并有助于专注于在任何地方都能工作的开发，并更具前瞻性。

如果需要，一些开发版本可能不会被沙盒化。您也可以自行承担风险解除 Keka 的沙盒化。

```bash
$ Keka 7z ./ --help
```


```bash
7-Zip [64] 16.02 : Copyright (c) 1999-2016 Igor Pavlov : 2016-05-21
p7zip Version 16.02 (locale=utf8,Utf16=on,HugeFiles=on,64 bits,8 CPUs LE)
Modified by aONe for Keka

Usage: 7z <command> [<switches>...] <archive_name> [<file_names>...]
       [<@listfiles...>]

<Commands>
  a : Add files to archive
  b : Benchmark
  d : Delete files from archive
  e : Extract files from archive (without using directory names)
  h : Calculate hash values for files
  i : Show information about supported formats
  l : List contents of archive
  rn : Rename files in archive
  t : Test integrity of archive
  u : Update files to archive
  x : eXtract files with full paths

<Switches>
  -- : Stop switches parsing
  -ai[r[-|0]]{@listfile|!wildcard} : Include archives
  -ax[r[-|0]]{@listfile|!wildcard} : eXclude archives
  -ao{a|s|t|u} : set Overwrite mode
  -an : disable archive_name field
  -bb[0-3] : set output log level
  -bd : disable progress indicator
  -bs{o|e|p}{0|1|2} : set output stream for output/error/progress line
  -bt : show execution time statistics
  -i[r[-|0]]{@listfile|!wildcard} : Include filenames
  -m{Parameters} : set compression Method
    -mmt[N] : set number of CPU threads
  -o{Directory} : set Output directory
  -p{Password} : set Password
  -r[-|0] : Recurse subdirectories
  -sa{a|e|s} : set Archive name mode
  -scc{UTF-8|WIN|DOS} : set charset for for console input/output
  -scs{UTF-8|UTF-16LE|UTF-16BE|WIN|DOS|{id}} : set charset for list files
  -scrc[CRC32|CRC64|SHA1|SHA256|*] : set hash function for x, e, h commands
  -sdel : delete files after compression
  -seml[.] : send archive by email
  -sfx[{name}] : Create SFX archive
  -si[{name}] : read data from stdin
  -slp : set Large Pages mode
  -slt : show technical information for l (List) command
  -snh : store hard links as links
  -snl : store symbolic links as links
  -sni : store NT security information
  -sns[-] : store NTFS alternate streams
  -so : write data to stdout
  -spd : disable wildcard matching for file names
  -spe : eliminate duplication of root folder for extract command
  -spf : use fully qualified file paths
  -ssc[-] : set sensitive case mode
  -ssw : compress shared files
  -stl : set archive timestamp from the most recently modified file
  -stm{HexMask} : set CPU thread affinity mask (hexadecimal number)
  -stx{Type} : exclude archive type
  -t{Type} : Set type of archive
  -u[-][p#][q#][r#][x#][y#][z#][!newArchiveName] : Update options
  -v{Size}[b|k|m|g] : Create volumes
  -w[{path}] : assign Work directory. Empty path means a temporary directory
  -x[r[-|0]]{@listfile|!wildcard} : eXclude filenames
  -y : assume Yes on all queries
caoyang@cccy ~ % 
```