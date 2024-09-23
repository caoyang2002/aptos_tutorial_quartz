
# 如何使用 Mac 制作 Windows 10 U 盘启动盘


![如何使用 Mac 制作 Windows 10 U 盘启动盘](https://chinese.freecodecamp.org/news/content/images/size/w2000/2021/12/5f9ca043740569d1a4ca4791.jpeg)

大多数新电脑现在不再配备 DVD 驱动器。因此，在新电脑上安装 Windows 可能会很痛苦。

幸运的是，Microsoft 提供了一个工具，你可以使用它从 USB 存储驱动器（或通常叫作 “U 盘”）安装 Windows。

但是，如果你没有第二台 PC 来设置 USB 存储驱动器，该怎么办？

在本教程中，我们将向你展示如何从 Mac 进行设置。

# 步骤 1：下载 Windows 10 ISO 文件

你可以直接从 Windows 下载 ISO 文件。没错——我们在这里所做的一切都是 100% 合法的，并且得到了微软的认可。

如果你想要关于 Windows 10 最新更新的英文版，可以[在此处下载 ISO](https://www.microsoft.com/en-gb/software-download/windows10ISO)。

如果你有一台相对较新的计算机，你可能需要 64 位版本。如果你不确定，请使用 32 位版本以确保安全。

如果你想要非英语版本的 Windows，或者想要获得较旧的更新版本，请[在此处下载 ISO](https://www.microsoft.com/en-gb/software-download/windows10)。

# 步骤 2：将 U 盘插入 Mac

ISO 文件只有大约 5 GB，但我建议你使用至少有 16 GB 空间的 USB 驱动器，以防 Windows 在安装过程中需要更多空间。

我在沃尔玛只花了 3 美元买了一个 32 GB 的 USB 驱动器，所以这应该不会很贵。

将 USB 驱动器插入 Mac，然后打开你的终端。你可以使用 MacOS Spotlight（聚焦搜索）执行此操作，方法是同时按下 ⌘ 和空格键，然后键入“终端”并按 Enter。

不要被命令行界面吓倒。我将确切地告诉你要输入哪些命令。

# 步骤 3：使用 diskutil 命令确定你的 USB 安装在哪个驱动器上

使用 `⌘ + 空格` 打开 Mac Spotlight，然后输入“终端”，并从下拉列表中选择终端。

将以下命令粘贴到你的终端中并按回车键：

```bash
diskutil list
```

你会看到这样的输出（注意 - 如果你没有自定义，你的 Mac 的终端可能是白底黑字）。

![default_-_default_freeCodeCamp_-_-zsh_-_130-33](https://www.freecodecamp.org/news/content/images/2019/09/default_-_default_freeCodeCamp_-_-zsh_-_130-33.png)

复制我指向此处的文本，它可能是这样的：
```bash
/dev/disk2
```

# 步骤 4：格式化你的 USB 驱动器以与 Windows 一起使用

接下来将你的 USB 驱动器格式化为 Windows FAT32 格式。这是 Windows 10 将识别的格式。

请注意，如果它不是 `disk2`，则应将 `disk2` 替换为步骤 3 中的驱动器名称（它可能是 `disk3` 或 `disk4`）。

使用正确的名称运行此命令：
```bash
diskutil eraseDisk MS-DOS "WIN10" GPT /dev/disk2
```

然后你会看到这样的终端输出。

![default_-_default_freeCodeCamp_-_-zsh_-_130-33-1](https://www.freecodecamp.org/news/content/images/2019/09/default_-_default_freeCodeCamp_-_-zsh_-_130-33-1.png)

这在较新的计算机上可能只需要大约 20 秒，但在较旧的计算机上可能需要更长的时间。

请注意，对于某些硬件，你可能需要运行此命令，该命令使用 MBR 格式而不是 GPT 进行分区。如果第 7 步失败，请返回并尝试此命令，然后重做第 5、6 和 7 步：

```
diskutil eraseDisk MS-DOS "WIN10" MBR /dev/disk2
```

# 步骤 5：使用 `hdiutil` 挂载 Windows 10 文件夹并准备传输

现在我们要准备下载的 ISO 文件，以便我们可以将它复制到 USB 驱动器。

你需要检查下载的 Windows 10 ISO 文件的位置并使用它。你的文件可能位于 `~/Downloads` 文件夹中，名称为：

`Win10_1903_V1_English_x64.iso`.

`hdiutil mount ~/Downloads/Win10_1903_V1_English_x64.iso`

# 步骤 6：将 Windows 10 ISO 复制到你的 USB 驱动器

**2020 年 4 月更新：**Windows 10 ISO 中的一个文件 - install.wim - 现在太大而无法复制到 FAT-32 格式的 USB 驱动器。所以我会告诉你如何单独复制它。

感谢 [@alexlubbock](https://twitter.com/alexlubbock) 提出这个解决方法。

首先运行此命令以复制除该文件之外的所有内容：

`rsync -vha --exclude=sources/install.wim /Volumes/CCCOMA_X64FRE_EN-US_DV9/* /Volumes/WIN10`

然后运行这个命令来安装 Homebrew（如果你的 Mac 上还没有安装它）：

`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

然后使用 Homebrew 使用此终端命令安装名为 wimlib 的工具：

`brew install wimlib`

然后继续创建你要将文件写入的目录：

`mkdir /Volumes/WIN10/sources`

然后运行这个命令。请注意，此过程可能需要几个小时，在完成之前你可能会看到 0% 的进度。不要中止它。它将使用 wimlib 将 install.wim 文件拆分为 2 个小于 4 GB 的文件（我在以下命令中使用 3.8 GB），然后将它们复制到你的 USB：

`wimlib-imagex split /Volumes/CCCOMA_X64FRE_EN-US_DV9/sources/install.wim /Volumes/WIN10/sources/install.swm 3800`

完成后，你可以在 Finder 中从 Mac 中弹出 USB。请注意，Windows 稍后会在你安装时自动重新加入这些文件。

## 步骤 7：将 USB 插入新 PC 并开始加载 Windows

恭喜！你的电脑现在应该直接从你的 U 盘启动了。如果没有，你可能需要检查新 PC 的 BIOS 并将启动顺序更改为从 U 盘启动。

Windows 将弹出一个屏幕并开始安装过程。

享受你的新 PC 和新安装的 Windows 副本吧！

原文：[How to Make a Windows 10 USB Using Your Mac - Build a Bootable ISO From Your Mac's Terminal](https://www.freecodecamp.org/news/how-make-a-windows-10-usb-using-your-mac-build-a-bootable-iso-from-your-macs-terminal/)，作者：[Quincy Larson](https://www.freecodecamp.org/news/author/quincylarson/)



# 可能遇到的问题
> 找不到驱动
> 1. 下载驱动到U盘
> 2. 关闭 bios 中的 vmd


> balenaetcher
> rufus



