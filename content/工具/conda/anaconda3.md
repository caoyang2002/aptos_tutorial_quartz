---
title: 安装 anaconda3
---

# 安装

https://docs.anaconda.com/anaconda/install/mac-os/

## MAC
### 安装 Anaconda3

```bash
brew install --cask anaconda
```

> 安装的是 `anaconda3`，只是包叫 `anaconda` 而已，这里安装的是桌面版的，接下来需要配置命令行，否则无法使用，（在桌面版内调用命令行是可以的）

打开桌面版本的 anaconda，创建一个终端环境，会看到这样的输出：
```bash
. /opt/homebrew/anaconda3/bin/activate && conda activate /opt/homebrew/anaconda3;
```
1. `. /opt/homebrew/anaconda3/bin/activate`: 这是一个点命令（`.`），它用于执行当前目录之外的脚本。这里它被用来执行 `/opt/homebrew/anaconda3/bin/activate` 脚本，该脚本是Anaconda安装的一部分，用于初始化Anaconda环境。
    
2. `conda activate /opt/homebrew/anaconda3`: 这是 `conda` 命令行工具的 `activate` 子命令，用于激活指定的Anaconda环境。在这个例子中，它被用来激活 `/opt/homebrew/anaconda3` 路径下的Anaconda环境。
### 配置环境
首先确定你确实没有配置环境：
```bash
conda --version
```

提示找不到这条命令。

开始配置：

方法一：

使用 anaconda 的自动初始化程序

```bash
source ~/anaconda3/bin/activate 
conda init
```

方法二：

在 bash 的配置文件`.zshrc` 或 `.profile` 添加：

```bash
if [ -f /opt/homebrew/anaconda3/etc/profile.d/conda.sh ]; then
    . /opt/homebrew/anaconda3/etc/profile.d/conda.sh
fi
```

方法三：

在 bash 的配置文件`.zshrc` 或 `.profile` 添加：
```bash
. /opt/homebrew/anaconda3/bin/activate
```

### 验证 Anaconda 安装 

```bash
conda --version
conda list
```



## Linux

下载安装包： https://www.anaconda.com/download/success

安装方法： https://docs.anaconda.com/anaconda/install/linux

```bash
bash <conda-installer-name>-latest-Linux-x86_64.sh
```


```bash
# 初始化
conda config --set auto_activate_base false
You can undo this by running `conda init --reverse $SHELL`? [yes|no]

yes
```

然后关闭 `shell` 重新打开

`conda` 是 Anaconda 的命令行界面工具，用于管理 Anaconda 环境中的包和环境。以下是一些常用的 `conda` 命令及其用法：

1. **激活 Conda 初始化**：
   ```bash
   source ~/anaconda3/bin/activate
   conda init
   ```

2. **查看 Conda 版本**：
```bash
conda --version
```



# 无法启动？
## 可能需要配置的路径

```
#Anacanda
export PATH="/root/anaconda3/bin:$PATH"
```

