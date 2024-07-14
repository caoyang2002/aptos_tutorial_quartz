# 同步工具

# rsync 命令详解

https://developer.aliyun.com/article/504368

Rsync是linux/Unix文件同步和传送工具。用于替代rcp的一个工具，rsync可以通过rsh或ssh使用，也能以daemon模式去运行，在以daemon方式运行时rsync server会开一个873端口，等待客户端去连接。连接时，rsync server会检查口令是否相符，若通过口令查核，则可以通过进行文件传输，第一次连通完成时，会把整份文件传输一次，以后则就只需进行增量备份.

**安装：**

```bash
wget http://rsync.samba.org/ftp/rsync/src/rsync-3.0.9.tar.gz
tar xf rsync-3.0.9.tar.gz
cd rsync -3.0.9
./configure && make && make install`
```



**参数：**

```bash
-v, --verbose 详细模式输出   
-q, --quiet 精简输出模式   
-c, --checksum 打开校验开关，强制对文件传输进行校验   
-a, --archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD   
-r, --recursive 对子目录以递归模式处理   
-R, --relative 使用相对路径信息   
-b, --backup 创建备份，也就是对于目的已经存在有同样的文件名时，将老的文件重新命名为~filename。可以使用--suffix选项来指定不同的备份文件前缀。   
--backup-dir 将备份文件(如~filename)存放在在目录下。   
-suffix=SUFFIX 定义备份文件前缀   
-u, --update 仅仅进行更新，也就是跳过所有已经存在于DST，并且文件时间晚于要备份的文件。(不覆盖更新的文件)
-l, --links 保留软链结   
-L, --copy-links 想对待常规文件一样处理软链结   
--copy-unsafe-links 仅仅拷贝指向SRC路径目录树以外的链结   
--safe-links 忽略指向SRC路径目录树以外的链结   
-H, --hard-links 保留硬链结   
-p, --perms 保持文件权限   
-o, --owner 保持文件属主信息   
-g, --group 保持文件属组信息   
-D, --devices 保持设备文件信息   
-t, --times 保持文件时间信息   
-S, --sparse 对稀疏文件进行特殊处理以节省DST的空间   
-n, --dry-run现实哪些文件将被传输   
-W, --whole-file 拷贝文件，不进行增量检测   
-x, --one-file-system 不要跨越文件系统边界   
-B, --block-size=SIZE 检验算法使用的块尺寸，默认是700字节   
-e, --rsh=COMMAND 指定使用rsh、ssh方式进行数据同步   
--rsync-path=PATH 指定远程服务器上的rsync命令所在路径信息   
-C, --cvs-exclude 使用和CVS一样的方法自动忽略文件，用来排除那些不希望传输的文件   
--existing 仅仅更新那些已经存在于DST的文件，而不备份那些新创建的文件   
--delete 删除那些DST中SRC没有的文件   
--delete-excluded 同样删除接收端那些被该选项指定排除的文件   
--delete-after 传输结束以后再删除   
--ignore-errors 及时出现IO错误也进行删除   
--max-delete=NUM 最多删除NUM个文件   
--partial 保留那些因故没有完全传输的文件，以是加快随后的再次传输   
--force 强制删除目录，即使不为空   
--numeric-ids 不将数字的用户和组ID匹配为用户名和组名   
--timeout=TIME IP超时时间，单位为秒   
-I, --ignore-times 不跳过那些有同样的时间和长度的文件   
--size-only 当决定是否要备份文件时，仅仅察看文件大小而不考虑文件时间   
--modify-window=NUM 决定文件是否时间相同时使用的时间戳窗口，默认为0   
-T --temp-dir=DIR 在DIR中创建临时文件   
--compare-dest=DIR 同样比较DIR中的文件来决定是否需要备份   
-P 等同于 --partial   
--progress 显示备份过程  
-z, --compress 对备份的文件在传输时进行压缩处理   
--exclude=PATTERN 指定排除不需要传输的文件模式   
--include=PATTERN 指定不排除而需要传输的文件模式   
--exclude-from=FILE 排除FILE中指定模式的文件   
--include-from=FILE 不排除FILE指定模式匹配的文件   
--version 打印版本信息   
--address 绑定到特定的地址   
--config=FILE 指定其他的配置文件，不使用默认的rsyncd.conf文件   
--port=PORT 指定其他的rsync服务端口   
--blocking-io 对远程shell使用阻塞IO   
-stats 给出某些文件的传输状态   
--progress 在传输时现实传输过程   
--log-format=formAT 指定日志文件格式   
--password-file=FILE 从FILE中得到密码   
--bwlimit=KBPS 限制I/O带宽，KBytes per second   
-h, --help 显示帮助信息
```


## rsync 的几种用法
 

1. 拷贝本地文件，将/home/coremail目录下的文件拷贝到/cmbak目录下

```bash
rsync -avSH /home/coremail/ /cmbak/
```

2. 拷贝本地机器的内容到远程机器

```bash
 rsync -av /home/coremail/ 192.168.11.12: /home/coremail/
```

3. 拷贝远程机器的内容到本地机器

```bash
rsync -av 192.168.11.11: /home/coremail/ /home/coremail/

```


4. 拷贝远程rsync服务器(daemon形式运行rsync)的文件到本地机。

```bash
rsync -av root@172.16.78.192::www /databack
```

5. 拷贝本地机器文件到远程rsync服务器(daemon形式运行rsync)中。当DST路径信息包含”::”分隔符时启动该模式。
```bash
rsync -av /databack root@172.16.78.192::www
```

6. 显示远程机的文件列表。这类似于rsync传输，不过只要在命令中省略掉本地机信息即可。
```
rsync -v rsync://192.168.11.11 /data
```

7. 指定密码存放文件，无需输入密码，直接执行rsync传输

```bash
rsync -rvzP  --password-file=/etc/rsync.password rsync@$192.168.10.175::imgdata/ /data
```


## rsync配置文件说明：

# `/etc/rsyncd.conf`  内容如下

|   |   |
|---|---|
|1<br><br>2<br><br>3<br><br>4<br><br>5<br><br>6<br><br>7<br><br>8<br><br>9<br><br>10<br><br>11<br><br>12<br><br>13<br><br>14<br><br>15<br><br>16<br><br>17<br><br>18<br><br>19<br><br>20<br><br>21<br><br>22<br><br>23<br><br>24<br><br>25<br><br>26|`port = 873`    `//` `端口号`<br><br>`uid = nobody`   `//` `指定当模块传输文件的守护进程UID`<br><br>`gid = nobody`   `//` `指定当模块传输文件的守护进程GID`<br><br>`use chroot = no`   `//` `使用chroot到文件系统中的目录中`<br><br>`max connections = 10`   `//` `最大并发连接数`<br><br>`strict modes =`  `yes`   `//` `指定是否检查口令文件的权限`<br><br>`pid`  `file`  `=`  `/usr/local/rsyncd/rsyncd` `.pid`   `//` `指定PID文件`<br><br>`lock`  `file`  `=`  `/usr/local/rsyncd/rsyncd` `.lock`   `//` `指定支持max connection的锁文件，默认为` `/var/run/rsyncd` `.lock`<br><br>`motd`  `file`  `=`  `/usr/local/rsyncd/rsyncd` `.motd`   `//` `定义服务器信息的，自己写 rsyncd.motd 文件内容`<br><br>`log`  `file`  `=`  `/usr/local/rsyncd/rsync` `.log`   `//rsync`  `服务器的日志`<br><br>`log`  `format`  `= %t %a %m %f %b`<br><br>`syslog facility = local3`<br><br>`timeout = 300`<br><br>`[conf]`   `//` `自定义模块`<br><br>`path =`  `/usr/local/nginx/conf`   `//` `用来指定要备份的目录`<br><br>`comment = Nginx conf`<br><br>`ignore errors`   `//` `可以忽略一些IO错误`<br><br>`read`  `only = no`   `//` `设置no，客户端可以上传文件，` `yes` `是只读`<br><br>`write only = no`   `//no` `为客户端可以下载，` `yes`  `不能下载`<br><br>`hosts allow = 192.168.2.0` `/24`   `//` `可以连接的IP`<br><br>`hosts deny = *`   `//` `禁止连接的IP`<br><br>`list =`  `false`   `//` `客户请求时，使用模块列表`<br><br>`uid = root`<br><br>`gid = root`<br><br>`auth`  `users`  `= backup`   `//` `连接用户名，和linux系统用户名无关系`<br><br>`secrets`  `file`  `=`  `/etc/rsyncd` `.pass`   `//` `验证密码文件`|












# `rsync` 命令的常见使用方法

`rsync`，全称是 `remote sync`，字面意思是做**远程同步**的，但是 `rsync` 能做的不只是远程同步，还能做：

- 文件拷贝；
- 系统备份；
- 远程文件传输；

等。`rsync` 完全能够替代常见的 `cp` / `mv`/ `scp` (secure copy) 等文件拷贝、移动和远程传输等命令。

**`rsync` 最大的的用途是可以做增量备份，即 `rsync` 在第一次执行备份时，是全量备份（将所有的文件都备份），后面再重新备份时，只会备份哪些修改过的文件。**

`rsync` 命令支持的参数非常多，下面就每一种参数的具体使用情景，做详细的说明。

## 使用

`rsync` 命令的语法如下：

```bash
rsync [options] [source] [target]

```

其中：

- options 表示各种可选参数，是下面要详细介绍的；
- source 表示原文件或者原目录，可以是本地的，也可以是远程的；
- target 表示目标目录，可以是本地的，也可以是远程的。

下面详细介绍各种参数的使用方法。

### `-r` 参数

Linux 中的 `-r` 参数基本都是 `recursively` 的意思，也就是**递归**，**一般是面向目录**，例如 `cp` 命令中的 `-r` 参数，`rm` 命令中的 `-r` 参数。

注意，`-r` 参数虽然能够递归的对一个目录进行拷贝，或者传输，**但是，其只传递文件内容，不传输文件的一些属性信息，如修改时间，文件所有者，文件权限等。比方说，当你使用 `rsync` 传递文件从一个地方到另一个地方之后，文件的所有者不再是原来的所有者，而变成了你。（即文件所有者信息不回被传递）

解释了这么多，来看几个使用 `rsync` 复制文件、传输文件的例子。

1. 拷贝文件到一个本地目标目录
```bash
rsync source.txt ~/target/
```



需要强调的是，**如果目标目录不存在，`rsync` 会自动创建该目录**。

2. 拷贝目录到一个本地目标目录

假设 `test1` 目录下面有两个文件 `a.txt` 和 `b.txt`，现在想将 `test1` 目录拷贝到 `test2` 目录下，形成 `test2/test1` 这种结构，可以这么做：

```bash
rsync -r test1 test2/
```



拷贝完，我们看看 `test2` 的内容：
```bash
ls test2  
# test1
```

但是，如果我们在 `test1` 后面加上 `/`，结果就不一样了：
```bash
rsync -r test1/ test2/

```



结果：
```bash
rsync -r test1/ test2/  && cd test2  && ls  

```


```bash
a.txt b.txt test1
```

也就是说：

- 源目录带有 `/`，将拷贝其**子文件和子目录**，该目录本身不会出现在目标目录；
- 源目录不带 `/`，将拷贝源目录本身。
- 目标目录带 `/` 或者不带 `/` ，均不影响。

###  `-a` 参数

前面说了，`-r` 参数不会将 `modified time` ，`owner`，`permition` 等属性拷贝到目标文件，那如果想要保持这些信息呢？那就用 `-a` 参数！

实际上，如果是用 `rsync` 做文件备份，基本只会用 `-a` 参数，而不会使用 `-r` 参数。

`-a` 参数可以在拷贝单个文件时用，也可以在拷贝目录时用。拷贝目录时，使用 `-a` 就不需要再用 `-r` 了。

1. 拷贝单个文件
```bash
rsync -a source.txt ~/target/
```



2. 拷贝一个目录
```bash
rsync -a test1 test2/
```

上面的拷贝会形成 `test2/test1` 的目录结构。如果不想拷贝该目录本身，可以在 `test1` 后面加上 `/` :
```bash
rsync -a test1/ test2/
```

### `-v` 参数

在 Linux 中，`-v` 在很多情况下，表示 `verbose`，也就是**在命令执行过程中会输出很多信息**。在 `rsync` 命令中，`-v` 会将拷贝的整个过程打印在屏幕上。

```bash
rsync -av test1/ test2  
```

```text
building file list ... done  
./  
a.txt  
b.txt  
  
sent 196 bytes  received 70 bytes  532.00 bytes/sec  
total size is 0  speedup is 0.00
```



### `-z` 参数

在 Linux 中，`-z` 参数一般表示压缩的意思（想想 `tar` 命令中的 `z` 参数表示用 `gzip` 压缩和解压缩）。

使用这个参数，`rsync` 会首先将需要拷贝或传输的数据压缩，到了 destination，进行解压缩，整个过程中用户不需要手动做压缩和解压，`rsync` 全帮用户做好了，这样就能减少需要传输的文件大小。

```bash
rsync -az test1/ test2/
```


### `--progress` 或者 `-P` (大写) 参数

使用这个参数，可以将文件拷贝或者传输的过程给显示出来，看下面例子的执行结果就知道了：

```bash
rsync -a --progress pytorch-cifar test2/  
```

输出：
```
building file list ...  
64 files to consider  
pytorch-cifar/  
pytorch-cifar/LICENSE  
        1065 100%    0.00kB/s    0:00:00 (xfer#1, to-check=62/64)  
pytorch-cifar/README.md  
        1324 100%    1.26MB/s    0:00:00 (xfer#2, to-check=61/64)  
pytorch-cifar/main.py  
        4518 100%    4.31MB/s    0:00:00 (xfer#3, to-check=60/64)  
pytorch-cifar/utils.py  
        3446 100%    3.29MB/s    0:00:00 (xfer#4, to-check=59/64)  
pytorch-cifar/.git/  
pytorch-cifar/.git/HEAD  
          23 100%   11.23kB/s    0:00:00 (xfer#5, to-check=57/64)  
pytorch-cifar/.git/config  
         311 100%  151.86kB/s    0:00:00 (xfer#6, to-check=56/64)  
pytorch-cifar/.git/description  
          73 100%   35.64kB/s    0:00:00 (xfer#7, to-check=55/64)  
pytorch-cifar/.git/index  
        1818 100%  887.70kB/s    0:00:00 (xfer#8, to-check=54/64)  
pytorch-cifar/.git/packed-refs  
         321 100%  104.49kB/s    0:00:00 (xfer#9, to-check=53/64)  
# <后面省略...>
```

### `-e` 参数

`-e` 参数后面接 `ssh` 表示我现在想要在本地和远程服务器之间，通过 ssh 协议来相互传输文件。

1. 将本地文件传递到远程
```bash
rsync -a -e ssh source.txt <username>@<hostname>
```



2. 将本地目录传递到远程
```bash
rsync -a -e ssh test1/ <username>@<hostname>
```

同样的，将远程文件或者目录拉取到本地，只需要将 `[source]` 和 `[target]` 参数调换一下位置即可。

有时候 ssh 为了安全起见，不是使用默认的 22 端口，改成了， 例如 1213 端口（为了安全起见防止攻击），这时候还想使用 `rsync` 在本地和远程之间传输文件，也不难。

- 将本地文件传输到服务器
```bash
rsync -a -e 'ssh -p 1213' source.txt <username>@<hostname>
```



- 将服务器目录拉取到本地
```bash
rsync -a -e 'ssh -p 1213' test2 . # 将 test2 目录拉取到当前目录，形成 ./test2/ 的目录结构
```



###  其它

`rsync` 其实还有很多其他的参数：

- `--include` : 包含指定文件；
- `--exclude`：不包含指定类型文件或目录；
- `--dry-run`：模拟 `rsync` 的执行，看看执行后会发生什么，但实际上 `rsync` 并没有执行；
- **`--delete`**：在做备份时使用。如果我们的目标目录只想做源目录的一个**镜像**，即目标目录中**不包含**源目录中没有的文件，这时候，在使用 `rsync` 时带上 `--delete` 参数，就可以将目标目录中，那些不在源目录中的文件删除掉。

### 增量备份

`rsync` 最强大的功能就是做增量备份了，即第一次执行备份时，是做全量备份，后面再执行 `rsync` 做备份时，就是做增量备份了。

我们可以使用 `crontab` 来帮助我们做定时备份。

首先 `crontab -e` 来新建一个例行性工作：

会自动调用 vim 编辑器打开 `crontab` 文件，接着在里面按照 `crontab` 的时间格式，写入一行，例如下面的：
```bash
00 00 * * * rsync -avz /home/tanjuntao/Documents /media/tanjuntao/WestData/backups/
```

上面的命令，就会每天在 `00:00` 时刻，将我的 Documents 文件夹备份到外接的硬盘 `WestData` 的 `backups` 文件夹中。

### [](https://tanjuntao.github.io/2020/10/26/Linux%E5%AD%A6%E4%B9%A0%E8%AE%B0%E5%BD%95%EF%BC%9Arsync%E4%BD%BF%E7%94%A8%E6%96%B9%E6%B3%95%E6%80%BB%E7%BB%93/#4-References "4. References")4. References

`rsync` 的具体使用细节，可以参考前三篇文章；`rsync` 用来备份系统，可以参考阮一峰文章中的增量备份一节，和引用列表最后那一篇文章。

- [【阮一峰】rsync 用法教程](http://www.ruanyifeng.com/blog/2020/08/rsync.html)
- [Rsync (Remote Sync): 10 Practical Examples of Rsync Command in Linux](https://www.tecmint.com/rsync-local-remote-file-synchronization-commands/)
- [How to Sync Files/Directories Using Rsync with Non-standard SSH Port](https://www.tecmint.com/sync-files-using-rsync-with-non-standard-ssh-port/)
- [How to Back Up Your Linux System](https://www.howtogeek.com/427480/how-to-back-up-your-linux-system/)

Donate comment here

打赏

- **本文作者：** Juntao Tan
- **本文链接：** [http://tanjuntao.github.io/2020/10/26/Linux学习记录：rsync使用方法总结/](http://tanjuntao.github.io/2020/10/26/Linux%E5%AD%A6%E4%B9%A0%E8%AE%B0%E5%BD%95%EF%BC%9Arsync%E4%BD%BF%E7%94%A8%E6%96%B9%E6%B3%95%E6%80%BB%E7%BB%93/ "Linux学习记录：rsync使用方法总结")
- **版权声明：**









# rsync 用法教程

作者： [阮一峰](https://www.ruanyifeng.com/)

日期： [2020年8月26日](https://www.ruanyifeng.com/blog/2020/08/)

## 一、简介

rsync 是一个常用的 Linux 应用程序，用于文件同步。

它可以在本地计算机与远程计算机之间，或者两个本地目录之间同步文件（但不支持两台远程计算机之间的同步）。它也可以当作文件复制工具，替代`cp`和`mv`命令。

![](https://cdn.beekka.com/blogimg/asset/202008/bg2020082602.jpg)

它名称里面的`r`指的是 remote，rsync 其实就是"远程同步"（remote sync）的意思。与其他文件传输工具（如 FTP 或 scp）不同，rsync 的最大特点是会检查发送方和接收方已有的文件，仅传输有变动的部分（默认规则是文件大小或修改时间有变动）。

## 二、安装

如果本机或者远程计算机没有安装 rsync，可以用下面的命令安装。

> ```bash
> 
> # Debian
> $ sudo apt-get install rsync
> 
> # Red Hat
> $ sudo yum install rsync
> 
> # Arch Linux
> $ sudo pacman -S rsync
> ```

注意，传输的双方都必须安装 rsync。

## 三、基本用法

### 3.1 `-r` 参数

本机使用 rsync 命令时，可以作为`cp`和`mv`命令的替代方法，将源目录同步到目标目录。

> ```bash
> 
> $ rsync -r source destination
> ```

上面命令中，`-r`表示递归，即包含子目录。注意，`-r`是必须的，否则 rsync 运行不会成功。`source`目录表示源目录，`destination`表示目标目录。

如果有多个文件或目录需要同步，可以写成下面这样。

> ```bash
> 
> $ rsync -r source1 source2 destination
> ```

上面命令中，`source1`、`source2`都会被同步到`destination`目录。

### 3.2 `-a` 参数

`-a`参数可以替代`-r`，除了可以递归同步以外，还可以同步元信息（比如修改时间、权限等）。由于 rsync 默认使用文件大小和修改时间决定文件是否需要更新，所以`-a`比`-r`更有用。下面的用法才是常见的写法。

> ```bash
> 
> $ rsync -a source destination
> ```

目标目录`destination`如果不存在，rsync 会自动创建。执行上面的命令后，源目录`source`被完整地复制到了目标目录`destination`下面，即形成了`destination/source`的目录结构。

如果只想同步源目录`source`里面的内容到目标目录`destination`，则需要在源目录后面加上斜杠。

> ```bash
> 
> $ rsync -a source/ destination
> ```

上面命令执行后，`source`目录里面的内容，就都被复制到了`destination`目录里面，并不会在`destination`下面创建一个`source`子目录。

### 3.3 `-n` 参数

如果不确定 rsync 执行后会产生什么结果，可以先用`-n`或`--dry-run`参数模拟执行的结果。

> ```bash
> 
> $ rsync -anv source/ destination
> ```

上面命令中，`-n`参数模拟命令执行的结果，并不真的执行命令。`-v`参数则是将结果输出到终端，这样就可以看到哪些内容会被同步。

### 3.4 `--delete` 参数

默认情况下，rsync 只确保源目录的所有内容（明确排除的文件除外）都复制到目标目录。它不会使两个目录保持相同，并且不会删除文件。如果要使得目标目录成为源目录的镜像副本，则必须使用`--delete`参数，这将删除只存在于目标目录、不存在于源目录的文件。

> ```bash
> 
> $ rsync -av --delete source/ destination
> ```

上面命令中，`--delete`参数会使得`destination`成为`source`的一个镜像。

## 四、排除文件

### 4.1 `--exclude` 参数

有时，我们希望同步时排除某些文件或目录，这时可以用`--exclude`参数指定排除模式。

> ```bash
> 
> $ rsync -av --exclude='*.txt' source/ destination
> # 或者
> $ rsync -av --exclude '*.txt' source/ destination
> ```

上面命令排除了所有 TXT 文件。

注意，rsync 会同步以"点"开头的隐藏文件，如果要排除隐藏文件，可以这样写`--exclude=".*"`。

如果要排除某个目录里面的所有文件，但不希望排除目录本身，可以写成下面这样。

> ```bash
> 
> $ rsync -av --exclude 'dir1/*' source/ destination
> ```

多个排除模式，可以用多个`--exclude`参数。

> ```bash
> 
> $ rsync -av --exclude 'file1.txt' --exclude 'dir1/*' source/ destination
> ```

多个排除模式也可以利用 Bash 的大扩号的扩展功能，只用一个`--exclude`参数。

> ```bash
> 
> $ rsync -av --exclude={'file1.txt','dir1/*'} source/ destination
> ```

如果排除模式很多，可以将它们写入一个文件，每个模式一行，然后用`--exclude-from`参数指定这个文件。

> ```bash
> 
> $ rsync -av --exclude-from='exclude-file.txt' source/ destination
> ```

### 4.2 `--include` 参数

`--include`参数用来指定必须同步的文件模式，往往与`--exclude`结合使用。

> ```bash
> 
> $ rsync -av --include="*.txt" --exclude='*' source/ destination
> ```

上面命令指定同步时，排除所有文件，但是会包括 TXT 文件。

## 五、远程同步

### 5.1 SSH 协议

rsync 除了支持本地两个目录之间的同步，也支持远程同步。它可以将本地内容，同步到远程服务器。

> ```bash
> 
> $ rsync -av source/ username@remote_host:destination
> ```

也可以将远程内容同步到本地。

> ```bash
> 
> $ rsync -av username@remote_host:source/ destination
> ```

rsync 默认使用 SSH 进行远程登录和数据传输。

由于早期 rsync 不使用 SSH 协议，需要用`-e`参数指定协议，后来才改的。所以，下面`-e ssh`可以省略。

> ```bash
> 
> $ rsync -av -e ssh source/ user@remote_host:/destination
> ```

但是，如果 ssh 命令有附加的参数，则必须使用`-e`参数指定所要执行的 SSH 命令。

> ```bash
> 
> $ rsync -av -e 'ssh -p 2234' source/ user@remote_host:/destination
> ```

上面命令中，`-e`参数指定 SSH 使用2234端口。

### 5.2 rsync 协议

除了使用 SSH，如果另一台服务器安装并运行了 rsync 守护程序，则也可以用`rsync://`协议（默认端口873）进行传输。具体写法是服务器与目标目录之间使用双冒号分隔`::`。

> ```bash
> 
> $ rsync -av source/ 192.168.122.32::module/destination
> ```

注意，上面地址中的`module`并不是实际路径名，而是 rsync 守护程序指定的一个资源名，由管理员分配。

如果想知道 rsync 守护程序分配的所有 module 列表，可以执行下面命令。

> ```bash
> 
> $ rsync rsync://192.168.122.32
> ```

rsync 协议除了使用双冒号，也可以直接用`rsync://`协议指定地址。

> ```bash
> 
> $ rsync -av source/ rsync://192.168.122.32/module/destination
> ```

## 六、增量备份

rsync 的最大特点就是它可以完成增量备份，也就是默认只复制有变动的文件。

除了源目录与目标目录直接比较，rsync 还支持使用基准目录，即将源目录与基准目录之间变动的部分，同步到目标目录。

具体做法是，第一次同步是全量备份，所有文件在基准目录里面同步一份。以后每一次同步都是增量备份，只同步源目录与基准目录之间有变动的部分，将这部分保存在一个新的目标目录。这个新的目标目录之中，也是包含所有文件，但实际上，只有那些变动过的文件是存在于该目录，其他没有变动的文件都是指向基准目录文件的硬链接。

`--link-dest`参数用来指定同步时的基准目录。

> ```bash
> 
> $ rsync -a --delete --link-dest /compare/path /source/path /target/path
> ```

上面命令中，`--link-dest`参数指定基准目录`/compare/path`，然后源目录`/source/path`跟基准目录进行比较，找出变动的文件，将它们拷贝到目标目录`/target/path`。那些没变动的文件则会生成硬链接。这个命令的第一次备份时是全量备份，后面就都是增量备份了。

下面是一个脚本示例，备份用户的主目录。

> ```bash
> 
> #!/bin/bash
> 
> # A script to perform incremental backups using rsync
> 
> set -o errexit
> set -o nounset
> set -o pipefail
> 
> readonly SOURCE_DIR="${HOME}"
> readonly BACKUP_DIR="/mnt/data/backups"
> readonly DATETIME="$(date '+%Y-%m-%d_%H:%M:%S')"
> readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
> readonly LATEST_LINK="${BACKUP_DIR}/latest"
> 
> mkdir -p "${BACKUP_DIR}"
> 
> rsync -av --delete \
>   "${SOURCE_DIR}/" \
>   --link-dest "${LATEST_LINK}" \
>   --exclude=".cache" \
>   "${BACKUP_PATH}"
> 
> rm -rf "${LATEST_LINK}"
> ln -s "${BACKUP_PATH}" "${LATEST_LINK}"
> ```

上面脚本中，每一次同步都会生成一个新目录`${BACKUP_DIR}/${DATETIME}`，并将软链接`${BACKUP_DIR}/latest`指向这个目录。下一次备份时，就将`${BACKUP_DIR}/latest`作为基准目录，生成新的备份目录。最后，再将软链接`${BACKUP_DIR}/latest`指向新的备份目录。

## 七、配置项

`-a`、`--archive`参数表示存档模式，保存所有的元数据，比如修改时间（modification time）、权限、所有者等，并且软链接也会同步过去。

`--append`参数指定文件接着上次中断的地方，继续传输。

`--append-verify`参数跟`--append`参数类似，但会对传输完成后的文件进行一次校验。如果校验失败，将重新发送整个文件。

`-b`、`--backup`参数指定在删除或更新目标目录已经存在的文件时，将该文件更名后进行备份，默认行为是删除。更名规则是添加由`--suffix`参数指定的文件后缀名，默认是`~`。

`--backup-dir`参数指定文件备份时存放的目录，比如`--backup-dir=/path/to/backups`。

`--bwlimit`参数指定带宽限制，默认单位是 KB/s，比如`--bwlimit=100`。

`-c`、`--checksum`参数改变`rsync`的校验方式。默认情况下，rsync 只检查文件的大小和最后修改日期是否发生变化，如果发生变化，就重新传输；使用这个参数以后，则通过判断文件内容的校验和，决定是否重新传输。

`--delete`参数删除只存在于目标目录、不存在于源目标的文件，即保证目标目录是源目标的镜像。

`-e`参数指定使用 SSH 协议传输数据。

`--exclude`参数指定排除不进行同步的文件，比如`--exclude="*.iso"`。

`--exclude-from`参数指定一个本地文件，里面是需要排除的文件模式，每个模式一行。

`--existing`、`--ignore-non-existing`参数表示不同步目标目录中不存在的文件和目录。

`-h`参数表示以人类可读的格式输出。

`-h`、`--help`参数返回帮助信息。

`-i`参数表示输出源目录与目标目录之间文件差异的详细情况。

`--ignore-existing`参数表示只要该文件在目标目录中已经存在，就跳过去，不再同步这些文件。

`--include`参数指定同步时要包括的文件，一般与`--exclude`结合使用。

`--link-dest`参数指定增量备份的基准目录。

`-m`参数指定不同步空目录。

`--max-size`参数设置传输的最大文件的大小限制，比如不超过200KB（`--max-size='200k'`）。

`--min-size`参数设置传输的最小文件的大小限制，比如不小于10KB（`--min-size=10k`）。

`-n`参数或`--dry-run`参数模拟将要执行的操作，而并不真的执行。配合`-v`参数使用，可以看到哪些内容会被同步过去。

`-P`参数是`--progress`和`--partial`这两个参数的结合。

`--partial`参数允许恢复中断的传输。不使用该参数时，`rsync`会删除传输到一半被打断的文件；使用该参数后，传输到一半的文件也会同步到目标目录，下次同步时再恢复中断的传输。一般需要与`--append`或`--append-verify`配合使用。

`--partial-dir`参数指定将传输到一半的文件保存到一个临时目录，比如`--partial-dir=.rsync-partial`。一般需要与`--append`或`--append-verify`配合使用。

`--progress`参数表示显示进展。

`-r`参数表示递归，即包含子目录。

`--remove-source-files`参数表示传输成功后，删除发送方的文件。

`--size-only`参数表示只同步大小有变化的文件，不考虑文件修改时间的差异。

`--suffix`参数指定文件名备份时，对文件名添加的后缀，默认是`~`。

`-u`、`--update`参数表示同步时跳过目标目录中修改时间更新的文件，即不同步这些有更新的时间戳的文件。

`-v`参数表示输出细节。`-vv`表示输出更详细的信息，`-vvv`表示输出最详细的信息。

`--version`参数返回 rsync 的版本。

`-z`参数指定同步时压缩数据。

## 八、参考链接

- [How To Use Rsync to Sync Local and Remote Directories on a VPS](https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps), Justin Ellingwood
- [Mirror Your Web Site With rsync](https://www.howtoforge.com/mirroring_with_rsync), Falko Timme
- [Examples on how to use Rsync](https://linuxconfig.org/examples-on-how-to-use-rsync-for-local-and-remote-data-backups-and-synchonization), Egidio Docile
- [How to create incremental backups using rsync on Linux](https://linuxconfig.org/how-to-create-incremental-backups-using-rsync-on-linux), Egidio Docile

（完）

### 文档信息

- 版权声明：自由转载-非商用-非衍生-保持署名（[创意共享3.0许可证](http://creativecommons.org/licenses/by-nc-nd/3.0/deed.zh)）
- 发表日期： 2020年8月26日

## 相关文章

- **2024.05.29: [分布式数据库入门：以国产数据库 TDSQL 为例](https://www.ruanyifeng.com/blog/2024/05/tdsql.html)**
    
    一、简介 今天，跟大家分享一些企业级的互联网技术。
    
- **2024.03.26: [2024最流行的网站架构----边缘平台架构：概念与产品](https://www.ruanyifeng.com/blog/2024/03/edge-platform.html)**
    
    互联网开发的核心是什么？
    
- **2023.08.08: [《TypeScript 教程》发布了](https://www.ruanyifeng.com/blog/2023/08/typescript-tutorial.html)**
    
    长话短说，我写了一本《TypeScript 教程》，已经发布在网道，欢迎大家访问。
    
- **2023.03.21: [运维的未来是平台工程](https://www.ruanyifeng.com/blog/2023/03/platform-engineering.html)**
    
    互联网公司有一个重要工种，叫做"运维"。
    

## 留言（41条）

AlbertWei 说：

学习了，很实用

2020年8月26日 15:09 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421736) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用AlbertWei的这条留言")

pasiso 说：

3.2 -a 参数 这一节里面疑似rsync笔误  
-----------------------------------------------  
目标目录destination如果不存在，rsyce 会自动创建。

2020年8月27日 00:22 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421766) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用pasiso的这条留言")

阮一峰 说：

@pasiso：

谢谢指出，已经更正。

2020年8月27日 08:48 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421767) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用阮一峰的这条留言")

cnfczn 说：

有个地方rsync拼错了,打成了rsyce

2020年8月27日 08:50 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421768) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用cnfczn的这条留言")

dykingdy 说：

rsync + inotify结合使用，可以实现两台机器的文件同步

2020年8月27日 15:44 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421779) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用dykingdy的这条留言")

Kevin 说：

正要用，阮老师就发出来了，太及时了。

2020年8月28日 09:15 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421787) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用Kevin的这条留言")

Jerry 说：

学习了 ~

2020年9月 1日 09:49 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421876) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用Jerry的这条留言")

田鹏 说：

"上面脚本中，上一次备份的目录${BACKUP_DIR}/${DATETIME}是基准目录，每一次同步都会生成一个新目录，然后将${BACKUP_DIR}/latest指向这个新目录，作为下一次的基准目录，再删除上一次的基准目录"

这里描述有点问题：

删除的不是上一次的基准目录，是latest软连接，然后重建latest到本次建立目录，每次的目录都会保留，只有latest会不断变化。

2020年9月 1日 12:04 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421890) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用田鹏的这条留言")

阮一峰 说：

@田鹏：

谢谢指出，已经更正了。

2020年9月 1日 14:58 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421893) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用阮一峰的这条留言")

noah_ 说：

Mac好像自带的，刚才复制15000多张图片和视频到Nas上，Finder怎么也搞不定，等很久也没反应。cp和mv和提示数量太多。结果rsync一下就搞定...

2020年9月 1日 22:55 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421902) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用noah_的这条留言")

大李子 说：

如果是同步到远程（比如用rsync协议） ，--link-dest 该怎么设置呢？ 试了好久都提示 --link-dest arg does not exist:

2020年9月 4日 18:00 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-421983) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用大李子的这条留言")

usiantein 说：

谢谢阮老师，非常实用。

2020年10月21日 14:36 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-423344) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用usiantein的这条留言")

马丁2003 说：

请问windows下有无推荐的rsync客户端？

2020年11月 7日 00:12 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-423696) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用马丁2003的这条留言")

大鱼 说：

在A、B两个服务器之间相互保持图片文件夹的同步，假如A服务器现在增加了一个图片，同步给B服务器，B服务器上的监听服务发现B的图片多了，又会同步给A。这种岂不是循环了，请问是如何解决的？

2020年11月15日 23:36 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-423816) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用大鱼的这条留言")

冰翼 说：

Ubuntu 18.04 测试，直接 rsync -a --delete 是可以增量同步的，第二次执行同步会打印 sending incremental file list，并且只有修改或新增的文件被同步了。所以增量备份应该不需要使用 --link-dest 参数。

我使用的完整命令是 sudo rsync -a --delete --exclude=".cache" --progress -v source dest  

2020年12月24日 17:39 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-424460) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用冰翼的这条留言")

liwf 说：

--remove-source-files这个参数有问题  
比如我要同步a目录下有b这个子目录，b里面有文件1  
加上这个参数会把文件1同步到远端  
但是源里面的这个b目录还在，而只是删掉了b里面的文件1，也就是说保留了空目录b

2021年4月28日 09:47 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-426622) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用liwf的这条留言")

猎魔人 说：

> 引用马丁2003的发言：
> 
> 请问windows下有无推荐的rsync客户端？

装虚拟机

2021年5月29日 15:02 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-427125) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用猎魔人的这条留言")

且夕夕 说：

请问rsync在同步时需要保证源目录中的文件没有在写入吗？

2021年7月22日 16:12 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-428166) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用且夕夕的这条留言")

解子 说：

rsync 怎么能够验证本地和远程服务器的两个文件是否一致，有没有什么命令之类的东西可以直接验证并返回一个可视化的结果

2021年8月 3日 19:48 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-428567) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用解子的这条留言")

Ted Wang 说：

@冰翼：

看说明，作者是使用了 --link-test 生成了类似时光机一样的链式多版本(按日期)备份，基准目录是起到一个压缩存储作用。跟版本库的原理是类似的。与增量同步是不一样的。

2021年8月 8日 16:05 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-428662) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用Ted Wang的这条留言")

从水之道 说：

请问阮老师：  
--exclude="${HOME}/.local/share/Trash/*"  
添加了这项之后，为什么备份的时候还是会备份Trash/下的文件？

2021年9月14日 12:25 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-429550) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用从水之道的这条留言")

0315 说：

--remove-source-files 备份文件夹后，删除src文件，但是src目录结构还存在，这就很蛋疼，不知道src子路径下会不会存在某个文件未同步，为什么不是删掉整个src，却要保留目录结构？

2021年10月22日 11:18 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-430184) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用0315的这条留言")

feasin 说：

很实用，讲解很详细

2021年11月25日 16:37 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-430789) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用feasin的这条留言")

荟八大圣 说：

为什么说 rsync不支持两台远程计算机之间的同步 呢？我理解只要是能找到对应计算机的话都是可以使用rrsync的，远程计算机有什么特殊的地方吗？

2022年1月19日 16:45 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-431842) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用荟八大圣的这条留言")

zjh 说：

> 引用马丁2003的发言：
> 
> 请问windows下有无推荐的rsync客户端？

syncctoy

2022年1月20日 22:45 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-431860) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用zjh的这条留言")

吊车尾 说：

> 引用解子的发言：
> 
> rsync 怎么能够验证本地和远程服务器的两个文件是否一致，有没有什么命令之类的东西可以直接验证并返回一个可视化的结果

我也不知道有没有类似命令，但你说的怎么能够验证本地和远程文件是否一致：博主开头就说了“默认规则是文件大小或修改时间有变动”，我记得这个规则是可以手动调整配置的，你可以了解了解！

2022年1月23日 01:46 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-431931) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用吊车尾的这条留言")

Joey 说：

rsync -av --include="*.txt" --exclude='*' source/ destination  
这个名只会同步第一层目录下的 txt 文件，不会递归同步

2022年2月26日 11:41 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-432400) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用Joey的这条留言")

sappine 说：

有个问题，有没有可能让rsync只覆盖更大的目标文件，忽略从A主机复制到B主机时，发现目标文件已经存在于B，且字节数更大的情况。

2022年3月 2日 16:25 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-432435) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用sappine的这条留言")

魏先生 说：

请教一下：只同步指定目录下的 2022开头的文件该如何实现

2022年3月 7日 18:05 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-432533) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用魏先生的这条留言")

User 说：

@冰翼：

这样你就没办法保存历史版本  

2022年5月 6日 11:23 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-433426) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用User的这条留言")

R 说：

哪位大神知道，如果目标目录存在相同名字的文件夹，就直接覆盖掉 是怎么设置？？

2022年5月30日 15:14 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-433741) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用R的这条留言")

conorzhong 说：

> 引用从水之道的发言：
> 
> 请问阮老师：  
> --exclude="${HOME}/.local/share/Trash/*"  
> 添加了这项之后，为什么备份的时候还是会备份Trash/下的文件？

只能是相对路径

2022年7月25日 10:41 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-434422) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用conorzhong的这条留言")

ssk 说：

正在学习rsync，读了，并试验了最后一段脚本。这似乎就实现了macOS的time machine功能了？

2022年10月 7日 00:51 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-435435) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用ssk的这条留言")

零一居士 说：

增量备份会全局扫描吗？

2022年11月16日 10:21 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-435965) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用零一居士的这条留言")

CommandNotFound ⚡️ 坑否 说：

rsync 同步大文件的时候，CPU过高，这个有什么参数可以调吗

2023年2月27日 14:16 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-437144) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用CommandNotFound ⚡️ 坑否的这条留言")

刘云飞 说：

阮老师您好，我在使用命令“rsync -avx root@192.168.64.126:/ PCComputer  
”同步A开发板根文件到个人PC电脑的时候，发现有些文件夹拷贝过来是空的，比如/dev，/sys，/proc。这是什么原因导致这个结果呀，谢谢阮老师的回复。

2023年8月24日 10:01 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-439359) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用刘云飞的这条留言")

wuhulamb 说：

> 引用马丁2003的发言：
> 
> 请问windows下有无推荐的rsync客户端？

可以打开windows的sshd服务，然后在linux上用rsync将windows上的文件/文件夹拷到linux上，代码示例如下：

rsync -av username@192.168.1.5:/D/xxx/yyy/ zzz # 将windows上D:\xxx\yyy里面的文件同步到linux的zzz文件夹下

本质上还是利用了OpenSSH在windows和linux之间进行的通信，和在linux上远程登录windows有几分相像。

以上是我个人的理解，如果有误，还望诸君不吝赐教。

2023年12月10日 00:53 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-440666) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用wuhulamb的这条留言")

zen010101 说：

第六小节的代码，似乎不是每次都是增量。我们模拟一下脚本的执行过程：

1. 第一次执行，生成 dir1 为全量文件，latest 链接到 dir1  
2. 第二次执行，生成 dir2 为增量文件，相对于 dir1 , latest 链接到 dir2  
3. 第三次执行，问题来了，生成 dir3 是相对于 dir2 的增量，实际上就是 dir1 + 【实际增量】，而我想原本目的是 dir3 只保存 【实际增量】 吧？  
4. 第四次执行，同第二步，生成的 dir4 是增量，相当于 dir2 + 【实际增量】  
5. 第五次执行，同第三步，又生成了 dir5, 相当于 dir1 + dir3 + 【实际增量】

这个脚本的意义何在呢？

2024年4月13日 13:55 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-442013) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用zen010101的这条留言")

Dov 说：

我的前端Node开发的一个app，要使用rsync进行文件的同步与备份。主管要求安装了app就能使用，用户不需要另外再在自己的电脑上安装rsync命令行工具。请问这种情况有什么好的解决方案吗？

2024年4月15日 11:17 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-442028) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用Dov的这条留言")

刘浩文 说：

> 引用Dov的发言：
> 
> 我的前端Node开发的一个app，要使用rsync进行文件的同步与备份。主管要求安装了app就能使用，用户不需要另外再在自己的电脑上安装rsync命令行工具。请问这种情况有什么好的解决方案吗？

把rsync也打包进软件安装目录下

2024年6月21日 11:52 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-442843) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用刘浩文的这条留言")

刘浩文 说：

如果单独使用--partial，而不搭配--append或--append-verify，会有哪些潜在的风险吗，有人遇到过吗？

2024年6月21日 11:54 | [#](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-442844) | [引用](https://www.ruanyifeng.com/blog/2020/08/rsync.html#comment-text "引用刘浩文的这条留言")

## 我要发表看法

您的留言 （HTML标签部分可用）

您的大名：

 «-必填

电子邮件：

 «-必填，不公开

个人网址：

 «-我信任你，不会填写广告链接

记住个人信息？

 «- 点击按钮

![微信扫描](https://www.wangbase.com/blogimg/asset/202001/bg2020013101.jpg)

[Weibo](http://weibo.com/ruanyf "微博") | [Twitter](https://twitter.com/ruanyf "Twitter") | [GitHub](https://github.com/ruanyf "GitHub")

Email: [yifeng.ruan@gmail.com](mailto:yifeng.ruan@gmail.com "电子邮件")