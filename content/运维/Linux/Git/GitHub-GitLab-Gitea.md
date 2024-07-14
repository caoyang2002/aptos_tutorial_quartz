---
title: 配置同时使用 Gitlab、Github、Gitee(码云) 共存的开发环境
---
# 配置同时使用 Gitlab、Github、Gitee(码云) 共存的开发环境

## 确认版本

首先确认已安装 `Git`，可以通过 `git –version` 命令可以查看当前安装的版本。

可以通过命令 `git clone https://github.com/git/git` 进行更新

Git共有三个级别的 `config` 文件，分别是 `system`、`global` 和 `local`

在当前环境中，分别对应
```bash
/etc/gitconfig # 系统配置文件
~/.gitconfig # 全局配置文件
your_repo/config # 仓库配置文件
```

所以 system 配置**整个系统**只有一个，global 配置**每个账户**只有一个，而 local 配置和**git仓库**的数目相同，并且只有在仓库目录才能看到该配置。

建立两个密钥，不同账号配置不同的密钥，不同仓库配置不同密钥。

## 更改 git 的全局设置（针对已安装 git）

>  新安装 git 跳过。



若之前对 git 设置过全局的 `user.name` 和 `user.email`

用 `git config --global --list` 进行查看你是否设置

```bash
git config --global user.name "name"
git config --global user.email  "youremail@domain.com"
```

必须删除该设置

```bash
git config --global --unset user.name "name"
git config --global --unset user.email "youremail@domain.com"
```

2. 生成新的 SSH keys

    1. GitHub 的密钥

        指定文件路径，方便后面操作：`~/.ssh/id_rsa.github`

        ```bash
        ssh-keygen -t rsa -f ~/.ssh/id_rsa.github -C "youremail@domain.com"
        ```

        直接回车3下，什么也不要输入，就是默认没有密码。

        注意 `github` 和 `gitlab` 和 `gitee` 的文件名是不同的。

    1. GitLab 的密钥
    
        ```bash
        ssh-keygen -t rsa -f ~/.ssh/id_rsa.gitlab -C "youremail@domain.com"
        ```
    
        
    
    1. Gitee 的密钥
    
        ```bash
        ssh-keygen -t rsa -f ~/.ssh/id_rsa.gitee -C "youremail@domain.com"
        ```
    
    完成后会在 `~/.ssh /` 目录下生成以下文件
    
    ```bash
    id_rsa.github
    id_rsa.github.pub
    id_rsa.gitlab
    id_rsa.gitlab.pub
    ```

3. 添加识别 SSH keys 新的私钥

    默认只读取 `id_rsa`，为了让 SSH 识别新的私钥，需要将新的私钥加入到 SSH agent 中

    ```bash
    ssh-agent bash
    ssh-add ~/.ssh/id_rsa.github
    ssh-add ~/.ssh/id_rsa.gitlab
    ssh-add ~/.ssh/id_rsa.gitee
    ```

    

4. 多账号必须配置 `config` 文件(重点)
    若无 config 文件，则需创建 config 文件

  1. 创建config文件

    ```bash
    touch ~/.ssh/config   
    ```


​    

  2. config 里需要填的内容如下

      ```bash
      #Default gitHub user Self
      Host github.com
          HostName github.com
          User git 
          IdentityFile ~/.ssh/id_rsa.github
          
      #Add gitLab user 
          Host git@gitlab.com
          HostName gitlab.com
          User git
          IdentityFile ~/.ssh/id_rsa.gitlab
          
      # gitee
      Host gitee.com
          Port 22
          HostName gitee.com
          User git
          IdentityFile ~/.ssh/id_rsa.gitee
          
      # 其他自己搭建的
      Host git@git.startdt.net
          Port 22
          HostName http://git.startdt.net
          User git
          IdentityFile ~/.ssh/lab_rsa.startdt
      ```

      下面对上述配置文件中使用到的配置字段信息进行简单解释：

      - `Host`

          - 它涵盖了下面一个段的配置，我们可以通过他来替代将要连接的服务器地址。

          - 这里可以使用任意字段或通配符。
          - 当ssh的时候如果服务器地址能匹配上这里Host指定的值，则Host下面指定的HostName将被作为最终的服务器地址使用，并且将使用该Host字段下面配置的所有自定义配置来覆盖默认的/etc/ssh/ssh_config配置信息。

      - `Port`

          - 自定义的端口。默认为22，可不配置

      - `User`

          - 自定义的用户名，默认为git，可不配置

      - `HostName`

          - 真正连接的服务器地址

      - `PreferredAuthentications`

          - 指定优先使用哪种方式验证，支持密码和秘钥验证方式

      - `IdentityFile`

          - 指定本次连接使用的密钥文件

5. 在 `github` 、 `gitlab`、`gitee` 网站添加 `ssh`

    1. Github

        1. Github 添加SSH公钥

            直达地址：https://github.com/settings/keys

            过程如下：

            - 登录 Github，点击右上方的头像，点击 settings，选择 SSH key，点击 Add SSH key，在出现的界面中填写 SSH key 的名称，填一个你自己喜欢的名称即可。

            - 将上面拷贝的 `~/.ssh/id_rsa.xxx.pub` 文件全部内容粘帖到 key 一栏，在点击 “add key” 按钮就可以了。
            - 添加过程 github 会提示你输入一次你的 github 密码 ，确认后即添加完毕。

    2. Gitlab

        1. Gitlab 添加SSH公钥

            直达地址：https://gitlab.com/profile/keys

            - 登录 Gitlab，点击右上方的头像，点击 settings，后续步骤如 Github

    3. Gitee / 码云

        码云 添加SSH公钥

        直达地址：https://gitee.com/profile/sshkeys

        - 登录 Gitee，点击右上方的头像，点击 设置，后续步骤如 Github
        - 添加过程 码云 会提示你输入一次你的 Gitee 密码 ，确认后即添加完毕。

6. 测试是否连接成功

    由于每个托管商的仓库都有唯一的后缀，比如 Github 的是 git@github.com😗。

    所以可以这样测试：

    ```bash
    ssh -T git@github.com
    ssh -T git@gitlab.com
    ssh -T git@gitee.com
    ```

    如果能看到一些 Welcome 信息，说明就是 OK 的了，如：

    ```bash
    # chenfl@DESKTOP-VFEC2HJ MINGW64 ~/.ssh
    $ ssh -T git@github.com
    The authenticity of host 'github.com (20.205.243.166)' can't be established.
    ECDSA key fingerprint is SHA256:p2QAMXNIC1TJYWeIOttrVc98/R1BUFWu3/LiyKgUfQM.
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    Warning: Permanently added 'github.com,20.205.243.166' (ECDSA) to the list of known hosts.
    Hi cfl1! You've successfully authenticated, but GitHub does not provide shell access.
    
    # chenfl@DESKTOP-VFEC2HJ MINGW64 ~/.ssh
    $ ssh -T git@gitee.com
    The authenticity of host 'gitee.com (180.97.125.228)' can't be established.
    ECDSA key fingerprint is SHA256:FQGC9Kn/eye1W8icdBgrQp+KkGYoFgbVr17bmjey0Wc.
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
    Warning: Permanently added 'gitee.com,180.97.125.228' (ECDSA) to the list of known hosts.
    Hi chenfl! You've successfully authenticated, but GITEE.COM does not provide shell access.
    ```

    结果如果出现这个就代表成功：

    ```bash
    GitHub -> successfully
    GitLab -> Welcome to GitLab
    Gitee -> successfully
    ```

7. 其他说明

    有的时候github拉去速度十分慢可以使用国内镜像，目前已知 `Github` 国内镜像网站有 `github.com.cnpmjs.org` 和 `git.sdut.me`。速度根据各地情况而定，在 `clone` 某个项目的时候将 `github.com` 替换为 `github.com.cnpmjs.org` 即可。

https://blog.csdn.net/weixin_43979341/article/details/124880032



# 配置文件

查看配置文件操作选项

```bash
git config
```

创建配置文件


```bash
sudo git config --system --global core.editor "vim"
```

在 Git 中，确实有三个级别的配置文件，它们分别对应不同的配置作用域：

1. **system** - 这个配置文件影响所有用户在系统上的所有 Git 仓库。在 Linux 系统中，`system` 配置文件通常位于：

   ```
   /etc/gitconfig
   ```

2. **global** - 这个配置文件只影响当前用户。对于每个用户，`global` 配置文件位于用户的主目录下，但不是直接以 `gitconfig` 命名。它是一个隐藏文件：

   ```
   ~/.gitconfig
   ```

   注意，`~` 代表当前用户的主目录。

3. **local** - 这个配置文件只影响当前仓库。`local` 配置文件位于 Git 仓库的 `.git` 目录下，文件名为：

   ```
   .git/config
   ```

每个级别的配置文件都可以包含不同的设置，它们按照 `local` -> `global` -> `system` 的顺序进行合并。如果在多个级别上存在相同的配置项，优先级从高到低依次是 `local`、`global` 和 `system`。

要查看或编辑这些配置文件，你可以使用文本编辑器，例如：

- 查看全局配置文件：

  ```bash
  cat ~/.gitconfig
  ```

- 查看系统配置文件：

  ```bash
  cat /etc/gitconfig
  ```

- 查看当前仓库的配置文件：

  ```bash
  cat /path/to/your/repo/.git/config
  ```

请将 `/path/to/your/repo/` 替换为你的 Git 仓库的实际路径。如果你需要编辑这些文件，可以使用 `nano` 或 `vim` 等编辑器。例如：

- 编辑全局配置文件：

  ```bash
  nano ~/.gitconfig
  ```

- 编辑系统配置文件（需要 root 权限）：

  ```bash
  sudo nano /etc/gitconfig
  ```

请注意，编辑系统配置文件可能会影响到系统中所有用户的 Git 配置，因此请谨慎操作。
