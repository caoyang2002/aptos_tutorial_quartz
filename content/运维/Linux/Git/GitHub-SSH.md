---
title: GitHub 配置 SSH 密钥
---
参考：

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/about-ssh

https://blog.csdn.net/weixin_42310154/article/details/118340458

https://blog.csdn.net/cxwtsh123/article/details/79194263

在github上配置ssh key很容易，网上一大堆教程，但基本没有详细解释其原理的，为什么要配？每使用一台主机都要配？配了为啥就不用密码了？下面将简单通俗地解释一下。

我们在往github上push项目的时候，如果走 `https` 的方式，每次都需要输入账号密码，非常麻烦，（2021年开始 GitHub 已经不支持 账号密码验证了）。而采用 `ssh` 的方式，就不再需要输入，只需要在 `github` 自己账号下配置一个ssh key即可。

# 配置SSH

git使用SSH配置， 初始需要以下三个步骤

使用秘钥生成工具生成 `rsa` 秘钥和公钥
将 `rsa` 公钥添加到代码托管平台
将rsa秘钥添加到 `ssh-agent` 中，为 `ssh client` 指定使用的秘钥文件
具体操作如下：

## 第一步：检查本地主机是否已经存在 `ssh key`
```bash
ls ~/.ssh  # 看是否存在 id_rsa 和 id_rsa.pub文件，如果存在，说明已经有SSH Key
```

如下图所示，则表明已经存在

```bash
config id_rsa id_rsa.pub known_hosts known_hosts.old
```

如果存在，直接跳到[第三步：获取ssh key公钥内容（id_rsa.pub）](#第三步：获取ssh key公钥内容（id_rsa.pub）)

## 第二步：生成ssh key

如果不存在 ssh key，使用如下命令生成

```bash
ssh-keygen -t rsa -C "emailname@domain.com" # 你的邮箱
```

- `-t`：指定密钥类型。常用的类型包括 `rsa` 和 `dsa`。RSA 是目前最常用的类型，支持更大的密钥长度，提供更强的安全性。
- `-C`：指定一个注释，通常用于描述密钥的用途或所有者。这个注释将被附加到公钥中，方便你识别。
- `-b`：指定密钥的位数。例如，`-b 2048` 表示生成一个 2048 位的 RSA 密钥。密钥长度越长，安全性越高，但生成和处理的速度也会变慢。
- `-N`：指定一个新密码短语（passphrase）。密码短语用于保护私钥文件，防止未授权访问。
- `-P`：指定旧密码短语，用于更改现有私钥的密码短语。
- `-f`：指定生成的密钥文件的名称和路径。如果不指定，`ssh-keygen` 会在默认位置生成密钥。
- `-F`：指定一个文件，从中读取 SSH 已知主机信息，用于在生成新密钥时跳过主机名检查。
- `-q`：安静模式，不显示进度信息。
- `-R`：从 SSH 已知主机文件中删除指定的主机名。

生成的密钥对包括：

- 私钥文件：默认位于 `~/.ssh/id_rsa`。
- 公钥文件：默认位于 `~/.ssh/id_rsa.pub`。

公钥需要被复制到需要 SSH 访问的服务器上，而私钥则保留在本地，用于身份验证。

生成完以后再用第二步命令，查看ssh key

## 第三步：获取 `ssh key` 公钥内容（id_rsa.pub）
```bash
cat ~/.ssh/id_rsa.pub
```

输出（类似于这样的）：

```bash
ssh-rsa ExampleOOOOONzaC1yc2EaafdsafasdaAHJBsfdafHFGVGJVdafretghfjskfjglnknnmklbbGHJKGHVJmbjkafdsfadfdanjfdjbsajbzkjgfkdavhcangaodoisatenmdfhagirtawrrteqwgfbsfhHJKLHHKJJGKHJGJHKgsfsbvcfdartreafAAAAB3NzaC1yc2EaafdsafasdaAHJBsfdafHFGVGJVdafretghfjskfjglnknnmklbbGHJKGHVJmbjkafdsfadfdanjfdjbavhcangaodoisatenmdfhagirtawrrteqwgfbsfhHJKLHHKJJGKHJGJHKgsfsbvcfdartreafAAAAB3NzaC1yc2EaafdsafasdaAHJBsfdafHFGVGJVdafretghfjskfjglnknnmklbbGHJKGHVJmbjkafds+fdf= emailname@domain.com
```

复制该内容

## 第四步：Github账号上添加公钥


进入`Settings` （设置）

添加 `ssh key`，把刚才复制的内容粘贴上去保存即可


## 第五步：验证是否设置成功

```bash
ssh -T git@github.com
```

显示如下信息表明设置成功

```bash

```

设置成功后，即可不需要账号密码 `clone` 和 `push` 代码

注意之后在 `clone` 仓库的时候要使用 `ssh` 的 `url` ，而不是 `https` ！

# 更换私钥
```bash
ssh-keygen -p -f ~/.ssh/id_ed25519
```


# 验证原理

`SSH` 登录安全性由非对称加密保证，产生密钥时，一次产生两个密钥，一个公钥，一个私钥，在 `ssh` 中一般命名为 `id_rsa.pub`, `id_rsa`。

那么如何使用生成的一个私钥一个公钥进行验证呢？

本地生成一个密钥对，其中公钥放到远程主机，私钥保存在本地
当本地主机需要登录远程主机时，本地主机向远程主机发送一个登录请求，远程收到消息后，随机生成一个字符串并用公钥加密，发回给本地。本地拿到该字符串，用存放在本地的私钥进行解密，再次发送到远程，远程比对该解密后的字符串与源字符串是否等同，如果等同则认证成功。

通俗解释！！

重点来了：一定要知道 `ssh key` 的配置是针对每台主机的！，比如我在某台主机上操作 `git` 和我的远程仓库，想要 `push` 时不输入账号密码，走 `ssh` 协议，就需要配置 `ssh key` ，放上去的 `key` 是当前主机的 `ssh` 公钥。那么如果我换了一台其他主机，想要实现无密登录，也就需要重新配置。

下面解释开头提出的问题：

1. 为什么要配？

	配了才能实现 `push` 代码的时候不需要反复输入自己的 `github` 账号密码，更方便
	
2. 每使用一台主机都要配？

	是的，每使用一台新主机进行 `git` 远程操作，想要实现无密，都需要配置。并不是说每个账号配一次就够了，而是每一台主机都需要配。

3.  配了为啥就不用密码了？

	因为配置的时候是把当前主机的公钥放到了你的 `github` 账号下，相当于当前主机和你的账号做了一个关联，你在这台主机上已经登录了你的账号，此时此刻 `github` 认为是该账号主人在操作这台主机，在配置 `ssh` 后就信任该主机了。所以下次在使用 `git` 的时候即使没有登录 `github`，也能直接从本地 `push` 代码到远程了。当然这里不要混淆了，你不能随意 `push` 你的代码到任何仓库，你只能`push` 到你自己的仓库或者其他你有权限的仓库！


# 错误
```bash
fatal: Could not read from remote repository. Please make sure you have the correct access rights and the repository exists.
```

出现该错误原因在于没有在 `github` 上的设置中 填写公钥信息 `SSH key`，需要自行生成并填入

### 方法一：

2. 首先在 `termital` 终端输入

```bash
ssh-keygen -t rsa -C "username" (注：username为你git上的用户名)
```

3. 对于提示信息全部按下Enter键

最后会出现下面的信息图

```bash
Your identification has been saved in /Users/username/.ssh/id_rsa.
Your public key has been saved in /Users/username/.ssh/id_rsa.pub.
The key fingerprint is:
58:42:8b:58:ad:4b:b5:b9:6d:79:bf:8c:f9:e2:2b:ed
username
The key’s randomart image is:
±-[ RSA 2048]----+
| … |
| o oo. |
| . .ooo. |
| o o+ |
| . …oS. |
| . . + . |
| . o . |
| . o+. |
| +E++. |
±----------------+
```


4. 这说明SSH key就已经生成了。文件目录就是：`/Users/username/.ssh/id_rsa.pub`

也有可能这个 `id_rea.pub` 不在这个目录下，需要自己找一下

5. 可以使用这段代码来查看一下
```bash
cat /User/username/.ssh/id_rsa.pub
```

6. 此时会看见显示的代码
```bash
ssh-rsa AAAAB3NzaC1yc2...----more
```


`ssh-rsa`后面的字符串就是你的秘钥

把显示出来的 `SSH keys` 直接添加到 `github` 账户设置里边的 `SSH keys`

注意 `ssh-rsa` 也需要加进去，加在顶部

最后再执行 `git clone` 命令就可以了

### 方法二

怎么解决：

先查看当前的账号和邮箱，

git config user.name

git config user.email

如果有误的话可以切换用户名和邮箱：

git config --global user.name "xxx"

git config --global user.email "xxx"

如果没错的话，很可能就是不同设备上的ssh公钥不同，比如我有两台电脑，其中git仓库用的是其中一台电脑产生的ssh公钥（）但不同设备产生的公钥是不能互用的，所以如果要克隆git上的代码到另一台设备上，就需要让另一台设备产生的公钥也添加到git上

生成公钥的命令：

`ssh-keygen -t rsa -C "xxxxx@xxxxx.com"`


---
 将SSH key 添加到 ssh-agent
   使用 ssh-add ~/.ssh/id_rsa 将产生的新ssh key添加到ssh-agent中：

补充： 如果出现“Could not open a connection to your authentication agent.”的错误可以使用以下两种方式解决：

eval "$(ssh-agent -s)"
1
或者：

eval `ssh-agent`
1
然后再次执行 ssh-add ~/.ssh/id_rsa 指令。
————————————————

                            版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。
                        
原文链接：https://blog.csdn.net/weixin_40922744/article/details/107576748

