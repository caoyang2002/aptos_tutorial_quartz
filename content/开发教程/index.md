---
title: 开发教程
---
[GitHub](https://github.com/caoyang2002/aptos_mvoe-learning)

# Move
- [[从hello_world开始]]【完成】
- [[basic-syntax-of-the-Move-language.]]【编辑中】
- [[控制流]]【编辑中】
- [[源码学习]]【未编辑】
- [[待整理]]【编辑中】

# TypeScript


# React

Aptos 提供了一个[[Aptos-TS-模板]]

[[无密钥账户]]




[[错误解析]]


# 附录

## 前端

### Node.js

安装：

```bash
# Linux
sudo apt install nodejs
# or
sudo yum install nodejs

# Mac
brew install nodejs
```

推荐使用 [nvm](https://github.com/nvm-sh/nvm)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

```bash
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```
运行上述任一命令都会下载一个脚本并运行它。该脚本会克隆nvm仓库到`~/.nvm`，并尝试将下面的代码片段中的源代码行添加到正确的配置文件中（`~/.bash_profile`、`~/.zshrc`、`~/.profile`或`~/.bashrc`）。

```bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

重新加载文件

```bash
source ./profile # 你刚才写入的文件
```

查看是否成功安装并配置

```bash
nvm -v  
```

>示例输出：
>
>0.39.7
>
>​        v18.14.2
>->   v20.0.0
>​        v22.1.0
>​         system
>default -> 20.0.0 (-> v20.0.0)
>iojs -> N/A (default)
>unstable -> N/A (default)
>node -> stable (-> v22.1.0) (default)
>stable -> 22.1 (-> v22.1.0) (default)
>
>**lts/*** -> **lts/iron** (-> N/A)
>**lts/argon** -> v4.9.1 (-> N/A)
>**lts/boron** -> v6.17.1 (-> N/A)
>**lts/carbon** -> v8.17.0 (-> N/A)
>**lts/dubnium** -> v10.24.1 (-> N/A)
>**lts/erbium** -> v12.22.12 (-> N/A)
>**lts/fermium** -> v14.21.3 (-> N/A)
>**lts/gallium** -> v16.20.2 (-> N/A)
>**lts/hydrogen** -> v18.20.2 (-> N/A)
>**lts/iron** -> v20.13.0 (-> N/A)


```bash
node -v
```

> 示例输出：
> 
> v20.0.0

Node 安装之后会自动安装 npm

```bash
npm -v
```

> 示例输出：
> 
> 9.6.4


