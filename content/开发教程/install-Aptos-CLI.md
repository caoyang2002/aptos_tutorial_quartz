---
title: 安装-Aptos-CLI
---
```yaml
original: 原创
note: 可以运行的安装方法
status: 已完成
```

[aptos 开发手册](https://aptos.dev/tools/aptos-cli/)

# 一、Mac

> 如果没有安装 `brew `执行以下代码
>
> ```bash
> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
> ```

 

1. 检查是否安装了 brew

```bash
brew --version
# Homebrew 4.2.14  
# 如果没有安装就执行上方引用块中的命令
```

2. 更新 Homebrew 自身以及本地存储库中的软件包信息

```bash
 brew update
```

3. 安装 aptos

```bash
 brew install aptos
```

4. 检查是否安装成功

```bash
 aptos --version
 # aptos 3.1.0
```

5. 更新 aptos

```bash
brew update
brew upgrade aptos
```





# 二、Windows

## 1. 二进制文件安装

https://github.com/aptos-labs/aptos-core/releases

 [aptos-cli-v3.1.0](https://github.com/aptos-labs/aptos-core/releases/tag/aptos-cli-v3.1.0)



## 2. 使用脚本安装

> 

- 方法一

```bash
iwr "https://aptos.dev/scripts/install_cli.py" -useb | Select-Object -ExpandProperty Content | python3
```

- 方法二

    > `不霁何虹`

```bash
iex (iwr "https://gist.githubusercontent.com/WGB5445/fb268ade52ea717c02bfb253e09c7ef5/raw" ).Content
```

> 可能的问题
>
> ```bash
> ModuleNotFoundError: No module named packaging
> ```
> 你可以通过运行 `pip3 install packaging` 来安装 packaging 模块，然后重复安装步骤。
>
> ```cmd
> aptos : 无法将“aptos”项识别为 cmdlet、函数、脚本文件或可运行程序的名称。请检查名称的拼写，如果包括路径，请确保路径正确，
> 然后再试一次。
> 所在位置 行:1 字符: 1
> ```
>
> 可选的解决办法：
>
> - 将 `aptos.exe` 添加到  `C:\Windos\System32` 目录下
>
> - 添加`aptos.exe`所在的目录到环境变量（未测试）
>
>     ```cmd
>     setx PATH "%PATH%;C:\Users\<your_account_name>\.aptoscli\bin"
>     ```
>
>     



验证是否安装成功：

```cmd
aptos --version
```

更新

```cmd
aptos update
```



# 三、Linux

## 1. 使用 python 脚本安装

```bash
python3 --version
# 确保您安装了Python 3.6+。
```

- 方法一

```bash
curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3
```

- 方法二

```bash
wget -qO- "https://aptos.dev/scripts/install_cli.py" | python3
```

> 如果你收到错误消息 `Couldn't find distutils or packaging. We cannot check the current version of the CLI. We will install the latest version.`，你可以通过运行 `pip3 install packaging` 来修复，然后重复安装步骤。
>

（可选）将Aptos CLI添加到PATH中的文件夹中，或直接将其添加到PATH中可能会有所帮助。将文件夹添加到PATH的步骤取决于shell。

您可以运行`echo $SHELL`来打印机器的默认shell，然后在谷歌上搜索特定步骤将该shell的PATH文件夹添加到您的PATH中。

## 2. 二进制文件安装

1. 转到[Aptos CLI发布页面](https://github.com/aptos-labs/aptos-core/releases?q=cli&expanded=true)。

2. 单击最新版本的“资产”可扩展菜单，以查看预编译的二进制文件。

3. 下载Linux的zip文件。

    1. 它将有一个名称：`aptos-cli-<version>-Ubuntu-x86_64.zip`。
    2. 确保您为您的计算机架构选择了正确的zip文件。
    3. 下载时，您可能不得不忽略这是一个可疑文件的警告。

4. 解压缩下载的文件。

5. 将提取的Aptos二进制文件移动到您的首选文件夹中。

6. 打开一个终端并导航到您的首选文件夹。

7. 通过运行`chmod +x ~/aptos`使`~/aptos`成为可执行文件。

8. 通过运行

    ```bash
    ~/aptos help
    ```

    验证此已安装版本是否有效。

    1. 您应该看到如何使用所有CLI命令的说明。当您试图了解如何使用特定命令时，这些在未来可能会有所帮助。

9. （可选）将Aptos CLI添加到PATH中的文件夹中，或直接将其添加到PATH中可能会有所帮助。将文件夹添加到PATH的步骤取决于shell。

    1. 您可以运行`echo $SHELL`来打印机器的默认shell，然后在谷歌上搜索特定步骤将该shell的PATH文件夹添加到您的PATH中。
