`ipfs` 是基于默克尔有向无环图（merkle dag）的全球性p2p文件系统。
https://ipfs.tech/
# 基础命令
```bash
ipfs [--config=<config> | -c] [--debug=<debug> | -D] 
     [--help=<help>] [-h=<h>] [--local=<local> | -L] 
     [--api=<api>] <command> ...
```

## 命令行选项
`-c`, `--config string` - 配置文件路径
`-D`, `--debug  bool`   - 开启调试模式，默认值：false
--help       bool   - 是否显示完整的命令帮助文档，默认值：false
-h           bool   - 显示简明版的命令帮助文档，默认值：false
-L, --local  bool   - 仅在本地执行命令，不使用后台进程。默认值：false
--api        string - 使用指定的API实例，默认值：`/ip4/127.0.0.1/tcp/5001`

## 基本子命令
```bash
init          初始化ipfs本地配置
add <path>    将指定文件添加到IPFS
cat <ref>     显示指定的IPFS对象数据
get <ref>     下载指定的IPFS对象
ls <ref>      列表显示指定对象的链接
refs <ref>    列表显示指定对象的链接哈希
```


## 数据结构子命令
```bash
block         操作数据仓中的裸块
object        操作有向图中的裸节点
files         以unix文件系统方式操作IPFS对象
dag           操作IPLD文档，目前处于实验阶段
```
## 高级子命令

```bash
daemon        启动后台服务进程
mount         挂接只读IPFS
resolve       名称解析
name          发布、解析IPNS名称
key           创建、列表IPNS名称键值对
dns           解析DNS链接
pin           在本地存储中固定IPFS对象
repo          操作IPFS仓库
stats         各种运营统计
filestore     管理文件仓，目前处于实验阶段
```


## 网络子命令
```bash
id            显示IPFS节点信息
bootstrap     添加、删除启动节点
swarm         管理p2p网络的连接
dht           查询分布哈希表中的值或节点信息
ping          检测连接延时
diag          打印诊断信息
```


## 工具子命令
```bash
config        管理配置信息
version       显示ipfs版本信息
update        下载并应用go-ipfs更新
commands      列表显示全部可用命令
使用ipfs <command> --help来了解特定命令的详细帮助信息。
```

# 本地仓库路径

ipfs使用本地文件系统中的仓库存储内容。默认情况下，本地仓库位于 `~/.ipfs`。你可以设置`IPFS_PATH` 环境变量来定义本地仓库的位置：
```bash
export IPFS_PATH=/path/to/ipfsrepo
```

## 命令行退出状态
命令行的退出码如下：
```bash
0：执行成功
1：执行失败

```

# `ipfs add`  添加文件或目录

```bash
ipfs add 将指定文件或目录添加到IPFS中。
```
## 命令行
```bash
ipfs add [–recursive | -r] [–quiet | -q] [–quieter | -Q]
[–silent] [–progress | -p] [–trickle | -t] [–only-hash | -n]
[–wrap-with-directory | -w] [–hidden | -H] [–chunker= | -s]
[–pin=false] [–raw-leaves] [–nocopy] [–fscache] [–] …
… - 要添加到ipfs中的文件的路径
```


选项
```bash
-r, --recursive bool - 递归添加目录内容，默认值：false
-q, --quiet bool - 安静模式，执行过程中输出显示尽可能少的信息
-Q, --quieter bool - 更安静模式，仅输出最终的结果哈希值
–silent bool - 静默模式，不输出任何信息
-p, --progress bool - 流式输出过程数据
-t, --trickle bool - 使用trickle-dag格式进行有向图生成
-n, --only-hash bool - Only chunk and hash - do not write to disk.
-w, --wrap-with-directory bool - 使用目录对象包装文件
-H, --hidden bool - 包含隐藏文件，仅在进行递归添加时有效
-s, --chunker string - 使用的分块算法
–pin bool - 添加时固定对象，默认值：true
–raw-leaves bool - 叶节点使用裸块，实验特性
–nocopy bool - 使用filestore添加文件，实验特性
–fscache bool - 为已有块检查filestore，实验特性
```


## 说明
将 的内容添加到 ipfs 中。使用 `-r` 来添加目录。目录内容的添加是递归进行的，以便生成 `ipfs` 的默克尔 `DAG` 图。

包装选项 `-w` 将文件包装到一个目录中，该目录仅包含已经添加的文件，这意味着 文件将保留其文件名。例如：
```bash
$ ipfs add example.jpg
added QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH example.jpg
$ ipfs add example.jpg -w  
added QmbFMke1KXqnYyBBWxB74N4c5SBnJMVAiMNRcGu6x1AwQH example.jpg
added QmaG4FuMqEBnQNn3C8XJ5bpW8kLs7zq2ZXgHptJHbKDDVx
```

>[!NOTE] 注意
>现在可以通过网关访问添加的文件，类似于：
>`/ipfs/QmaG4FuMqEBnQNn3C8XJ5bpW8kLs7zq2ZXgHptJHbKDDVx/example.jpg`
https://ipfs.io/ipfs/QmT78tMNRnyThKJYeduFZuQwx2QWSHp4KH2Phduzsookxa/1.jpg

---
示例：

```
ipfs init
ipfs daemon &
echo "hello" >> hello.txt
ipfs add hello.txt
```

>浏览器访问：
> - `https://ipfs.io/ipfs/QmU5PLEGqjetW4RAmXgHpEFL7nVCL3vFnEyrCKUfRk4MSq/hello.txt`
> - `https://ipfs.io/ipfs/QmU5PLEGqjetW4RAmXgHpEFL7nVCL3vFnEyrCKUfRk4MSq/?filename=hello.txt`
> 修改`<CID>`

即可看到 `hello.txt` 文件


---

# 显示对象内容
```bash
ipfs cat
ipfs cat <ipfs-path> ... # 显示IPFS对象数据。
```


```bash
ipfs cat [--] <ipfs-path>...
<ipfs-path>... - 要显示的IPFS对象路径，可指定多个
```

```bash
ipfs cat命令显示指定路径的一个或多个IPFS/IPNS对象的数据内容。
```

# 显示 `ipfs` 所有命令
```bash
ipfs commands
ipfs commands命令用来列出所有可用的ipfs命令。
```

```bash
ipfs commands [--flags | -f]
```

```bash
-f, --flags bool - 是否显示命令的标志，默认值：false
```


```bash
ipfs commands 命令将列表显示所有可用的命令以及子命令，然后退出。
```

```bash
ipfs daemon - ipfs 节点服务进程
ipfs daemon 命令用来启动一个连接网络的IPFS节点。
```

```bash
ipfs daemon [--init] [--routing=<routing>] [--mount] [--writable] 
	    [--mount-ipfs=<mount-ipfs>] [--mount-ipns=<mount-ipns>] 
	    [--unrestricted-api] [--disable-transport-encryption] 
	    [--enable-gc] [--manage-fdlimit=false] [--offline] [--migrate] 
	    [--enable-pubsub-experiment] [--enable-mplex-experiment=false]
```


```bash
--init                         bool   - 是否使用默认设置自动初始化ipfs，默认值：false
--routing                      string - 路由选项，默认值：dht
--mount                        bool   - 是否将IPFS挂载到文件系统，默认值：false
--writable                     bool   - 是否允许使用`POST/PUT/DELETE`修改对象，默认值： false.
--mount-ipfs                   string - 当使用--mount选项时IPFS的挂接点，默认值采用配置文件中的设置
--mount-ipns                   string - 当使用--mount选项时IPNS的挂接点，默认值采用配置文件中的设置
--unrestricted-api             bool   - 是否允许API访问未列出的哈希，默认值：false
--disable-transport-encryption bool   - 是否进制传输层加密，默认值：false。当调试协议时可开启该选项
```


```bash
--enable-gc                    bool   - 是否启用自动定时仓库垃圾回收，默认值：false
--manage-fdlimit               bool   - 是否按需自动提高文件描述符上限，默认值：false
--offline                      bool   - 是否离线运行，即不连接到网络，仅提供本地API，默认值：false
--migrate                      bool   - true对应于mirage提示时输入yes，false对应于输入no
--enable-pubsub-experiment     bool   - 是否启用发布订阅（pubsub）特性，该特性目前尚处于实验阶段
--enable-mplex-experiment      bool   - 是否启用`go-multiplex`流多路处理器，默认值：true
```

服务进程将在指定的端口监听网络连接。使用 `ipfs config Addresses` 命令修改默认端口。

例如，修改网关监听端口：

```bash
ipfs config Addresses.Gateway /ip4/127.0.0.1/tcp/8082
```

同样的方式修改API地址：

```bash
ipfs config Addresses.API /ip4/127.0.0.1/tcp/5002
```


在修改地址后，确保重新启动服务进程以便生效。

默认情况下，网络仅在本地可以访问，如果希望允许其他计算机访问，可以 使用地址0.0.0.0。例如：

```bash
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
```

当开放API访问时请千万小心，这存在一定的安全风险，因为任何人都可以 远程控制你的节点。如果你希望远程控制节点，请使用防火墙、授权代理 或其他服务来保护该API访问地址。

HTTP头
ipfs支持向API和网关传入任意HTTP头信息。你可以使用 `API.HTTPHeaders` 和 `Gateway.HTTPHeaders` 配置项进行配置。例如：
```bash
ipfs config --json API.HTTPHeaders.X-Special-Header '["so special :)"]'
ipfs config --json Gateway.HTTPHeaders.X-Special-Header '["so special :)"]'
```

需要指出的是，值应当是字符串数组，因为 `HTTP` 头可以包含多个值，而且这样也 方面传给其他的库。

对于API而言，可以同样的方式为其设置CORS头：

```bash
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["example.com"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "GET", "POST"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials '["true"]'
```

```bash
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["https://dev.webui.ipfs.io", "http://localhost:3000", "http://127.0.0.1:5001", ,"http://127.0.0.1:5001","https://webui.ipfs.io",]'

ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST"]'
```

停止服务
要停止服务进程，发送SIGINT信号即可，例如，使用Ctrl-C组合键。也可以发送 SIGTERM信号，例如，使用kill命令。服务进程需要稍等一下以便优雅退出，但是你 可以继续发送一次信息来强制服务进程立刻退出。

IPFS_PATH环境变量
ipfs使用本地文件系统建立本地仓库。默认情况下，本地仓库的目录是~/.ipfs， 可以设置IPFS_PATH环境变量来自定义本地仓库路径：

```bash
export IPFS_PATH=/path/to/ipfsrepo
```


# 路由
默认情况下，`ipfs` 使用分布式哈希表（DHT）进行内容的路由。目前有一个尚处于 试验阶段的替代方案，使用纯客户端模式来操作分布式哈希表，可以在启动服务 进程时，使用如下命令启动这一替代路由方案：
```bash
ipfs daemon --routing=dhtclient
```

该选项在实验阶段结束后将转变为一个配置选项。

>[!ERROR] 弃用通知
> ipfs之前使用过环境变量API_ORIGIN：
> ```bash
> export API_ORIGIN="http://localhost:8888/"
> ```
>该环境变量已经被弃用。在当前版本中还可以使用，但在将来的版本中将会删除对 此环境变量的支持。请使用前述HTTP头信息设置方法来取代该环境变量。



# 解析域名
```bash
ipfs dns
ipfs dns <domain-name>命令解析DNS链接。
```

## 命令行
```bash
ipfs dns [--recursive | -r] [--] <domain-name>
<domain-name> - 要解析的域名
```

## 选项
```bash
-r, --recursive bool # 是否递归解析直至结果不再是DNS链接，默认值：false
```

## 说明
ipfs 使用的哈希（multihash）很难记忆，但是域名通常更容易记住。可以 使用DNS的TXT记录为ipfs哈希创建容易记忆的别名，TXT记录可以指向其他的DNS 链接、IPFS对象、IPNS键等等。
```bash
ipfs dns # 命令将指定的DNS链接解析为其目标对象。
```

例如，根据如下DNS TXT记录：
```bash
> dig +short TXT _dnslink.ipfs.io
dnslink=/ipfs/QmRzTuh2Lpuz7Gr39stNr6mTFdqAghsZec1JoUnfySUzcy
```

解析结果如下：
```bash
> ipfs dns ipfs.io
/ipfs/QmRzTuh2Lpuz7Gr39stNr6mTFdqAghsZec1JoUnfySUzcy
```

解析器可以递归解析，例如：
```bash
> dig +short TXT recursive.ipfs.io
dnslink=/ipns/ipfs.io
> ipfs dns -r recursive.ipfs.io
/ipfs/QmRzTuh2Lpuz7Gr39stNr6mTFdqAghsZec1JoUnfySUzcy
```


# 下载文件

```bash
ipfs get
ipfs get <ipfs-path> 命令用来下载指定路径的IPFS对象。
```


## 命令行
```bash
ipfs get [--output=<output> | -o] [--archive | -a] [--compress | -C] [--compression-level=<compression-level> | -l] [--] <ipfs-path>
<ipfs-path> - IPFS对象路径
```

## 选项
```bash
-o, --output string - 对象内容输出路径
-a, --archive bool - 是否输出为TAR包，默认值：false
-C, --compress bool - 是否使用GZIP算法压缩输出文件，默认值：false
-l, --compression-level int - 压缩等级，1-9，默认值：-1
```
## 说明
```bash
ipfs get命令将指定路径的IPFS/IPNS对象的数据下载到磁盘。
```


默认情况下，输出文件将保存在 `./`，可以使用 `–output` 或 `-o` 选项来指定一个其他路径。

使用 `–archive` 或 `-a` 选项输出 `tar` 包。

使用 `–compress` 或 `-C` 选项来压缩输出结果，格式为 `GZIP`。可以同时使用 `-l=<1-9>` 来指定压缩等级。

# 显示ipfs节点信息
```bash
ipfs id
ipfs id [<peerid>] - 显示ipfs节点的信息
```

## 命令行
```bash
ipfs id [--format=<format> | -f] [--] [<peerid>]
[<peerid>] - 要查看的节点id
```
## 选项
```bash
-f, --format string - 输出格式，可选
```

## 说明
显示输出指定对端节点旳信息。如果不指定节点，则显示输出本地 节点信息。

`ipfs id` 命令的 `--format` 或 `-f` 选项支持一下输出格式键：
```bash
<id> : 节点id
<aver>: 代理版本
<pver>: 协议版本
<pubkey>: 公钥
<addrs>: 地址，采用换行符分隔多个地址
```

## 示例

显示id为Qmece2RkXhsKe5CRooNisBTh4SK119KrXXGmoK6V3kb8aH的节点旳地址：
```bash
ipfs id Qmece2RkXhsKe5CRooNisBTh4SK119KrXXGmoK6V3kb8aH -f="<addrs>\n"
```

# 初始化配置文件
```bash
ipfs init
ipfs init [<default-config>]命令初始化ipfs配置文件。
```

## 命令行
```bash
ipfs init [--bits=<bits> | -b] [--empty-repo | -e] [--] [<default-config>]
[<default-config>] - 使用该指定配置进行初始化
```

## 选项
```bash
-b, --bits       int  - 生成的RSA私钥位数，默认值：2048
-e, --empty-repo bool - 是否不在本地存储中添加、固定帮助文件。默认值：false
```

## 说明
```bash
ipfs init 命令负责初始化ipfs配置文件并生成新的密钥对。
```

ipfs 使用本地文件系统中的仓库。默认情况下，本地仓库的路径为 `~/.ipfs`。可以使用 `IPFS_PATH` 环境变量来自定义本地仓库路径。例如：
```bash
export IPFS_PATH=/path/to/ipfsrepo
```

# 显示目录内容

```bash
ipfs ls
ipfs ls <ipfs-path>... 命令列表显示目录内容。
```

## 命令行
```bash
ipfs ls [--headers | -v] [--resolve-type=false] [--] <ipfs-path>...
<ipfs-path>... - 要列举其链接的IPFS对象路径
```

## 选项
```bash
-v,           --headers bool - 是否显示表头（哈希、大小、名称），默认值：false
--resolve-type          bool - 是否解析所链接对象的类型，默认值：true
```

## 说明

显示指定路径的IPFS或IPNS对象的内容，格式如下：

JSON 输出中包含有类型信息。

## 挂载ipfs

```bash
ipfs mount
ipfs mount 命令以只读方式将ipfs挂接到文件系统。
```

## 命令行
```bash
ipfs mount [--ipfs-path=<ipfs-path> | -f] [--ipns-path=<ipns-path> | -n]
```

## 选项

```bash
-f, --ipfs-path string - The path where IPFS should be mounted.
-n, --ipns-path string - The path where IPNS should be mounted.
```

## 说明

ipfs mount 命令在操作系统中的只读挂接点挂载IPFS。

默认情况下使用配置文件中设定的 `/ipfs` 和 `/ipns` 挂接点，可以使用上述选项 自定义挂接点。

挂接后该目录中的所有 IPFS 对象都是可以访问的。需要指出的是，由于根目录 是虚拟的，因此不可列表查看其内容，只能直接访问指定的路径。

需要在使用 `ipfs mount` 命令之前创建 `/ipfs` 和 `/ipns` 目录：
```bash
> sudo mkdir /ipfs /ipns
> sudo chown `whoami` /ipfs /ipns
> ipfs daemon &
> ipfs mount
```
# 示例
下面的代码将创建目录foo和文件foo/bar，然后将目录foo添加到ipfs中：

# setup
```bash
> mkdir foo
> echo "baz" > foo/bar
> ipfs add -r foo
added QmWLdkp93sNxGRjnFHPaYg8tCQ35NBY3XPn6KiETd3Z4WR foo/bar
added QmSh5e7S6fdcu75LAbXNZAFY2nGyZUJXyLCJDvn2zRkWyC foo
> ipfs ls QmSh5e7S6fdcu75LAbXNZAFY2nGyZUJXyLCJDvn2zRkWyC
QmWLdkp93sNxGRjnFHPaYg8tCQ35NBY3XPn6KiETd3Z4WR 12 bar
> ipfs cat QmWLdkp93sNxGRjnFHPaYg8tCQ35NBY3XPn6KiETd3Z4WR
baz
```

下面的代码将foo对应的IPFS对象挂接到/ipfs目录，并访问其中的 bar文件：

# mount

```bash
> ipfs daemon &
> ipfs mount
IPFS mounted at: /ipfs
IPNS mounted at: /ipns
> cd /ipfs/QmSh5e7S6fdcu75LAbXNZAFY2nGyZUJXyLCJDvn2zRkWyC
> ls
bar
> cat bar
baz
> cat /ipfs/QmSh5e7S6fdcu75LAbXNZAFY2nGyZUJXyLCJDvn2zRkWyC/bar
baz
> cat /ipfs/QmWLdkp93sNxGRjnFHPaYg8tCQ35NBY3XPn6KiETd3Z4WR
baz
```


# 测试节点连通性

```bash
ipfs ping
ipfs ping … - 向指定的ipfs主机发送回显请求包
```


## 命令行
```bash
ipfs ping [–count= | -n] [–] …
… - 要ping的对端节点id
```


## 选项
```bash
-n, --count int - 要发送的ping包数量，默认值：10
```

## 说明

ipfs ping命令是一个测试向其他节点发送数据能力的工具，它利用路由系统 找到指定的节点，发送ping包，等待pong包，然后输出显示包往返的延迟信息。

# 名称解析

```bash
ipfs resolve
ipfs resolve 命令用来解析指定名称对应的目标值。
```


## 命令行
```bash
ipfs resolve [–recursive | -r] [–]
- 要解析的名称The name to resolve.
```


## 选项
```bash
-r, --recursive bool - 是否递归解析直至获得IPFS名称，默认值：false
```
## 说明

有许多可变名称协议彼此链接或链接到IPNS。例如IPFS引用（目前）可以指向一个IPFS对象， DNS链接可以指向其他DNS链接、IPNS实体或IPFS对象。

`ipfs resolve` 命令支持将以上格式的标识符解析为其指向的目标。

## 示例
解析指定id对应的值：
```bash
$ ipfs resolve /ipns/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
/ipfs/Qmcqtw8FfrVSBaRmbWwHxt3AuySBhJLcvmFYi3Lbc4xnwj
```

解析另一个名称的值：

```bash
$ ipfs resolve /ipns/QmbCMUZw6JFeZ7Wp9jkzbye3Fzp2GGcPgC3nmeUjfVF87n
/ipns/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
```

递归协议另一个名称的值：
```bash
$ ipfs resolve -r /ipns/QmbCMUZw6JFeZ7Wp9jkzbye3Fzp2GGcPgC3nmeUjfVF87n
/ipfs/Qmcqtw8FfrVSBaRmbWwHxt3AuySBhJLcvmFYi3Lbc4xnwj
```

解析IPFS有向图路径的值：
```bash
$ ipfs resolve /ipfs/QmeZy1fGbwgVSrqbfh9fKQrAWgeyRnj7h8fsHS1oy3k99x/beep/boop
/ipfs/QmYRMjyvAiHKN9UTi8Bzt1HUspmSRD8T8DwxfSMzLgBon1
```

# 显示ipfs版本信息
```bash
ipfs version
ipfs version命令显示ipfs版本信息。
```


## 命令行
```bash
ipfs version [–number | -n] [–commit] [–repo] [–all]
```


## 选项
```bash
-n, --number bool - Only show the version number. Default: false.
–commit bool - Show the commit hash. Default: false.
–repo bool - Show repo version. Default: false.
–all bool - Show all version information. Default: false.
```
## 说明

ipfs version命令在屏幕显示ipfs的当前版本，然后退出。

# 操作 bitswap 代理

```
ipfs bitswap - bitswap操作接口
ipfs bitswap用来操作bitswap代理。
```

## 命令行
```bash
ipfs bitswap
```


## 子命令
```bash
ipfs bitswap ledger <peer>   - 显示指定节点旳当前账本
ipfs bitswap stat            - 显示bitswap代理的诊断信息
ipfs bitswap unwant <key>... - 从期望列表（wantlist）中删除指定的块
ipfs bitswap wantlist        - 显示期望列表中的块
```

# 使用 `ipfs bitswap --help` 查看具体子命令的帮助信息。

```bash
ipfs bitswap ledger - 显示指定节点的账本
ipfs bitswap ledger 用来显示指定节点旳当前账本。
```

## 命令行
```bash
ipfs bitswap ledger [–]
- 要查看账本的节点ID（B58）
```


说明
Bitswap决策引擎跟踪IPFS节点间交换的字节数量，并保存该信息作为账本集合。这个 命令可以打印指定节点旳账本。
```bash
ipfs bitswap stat - 显示诊断信息
ipfs bitswap stat # 返回关于 Bitswap 模块当前状态的信息
```

- **提供者（Providers）**：当前节点提供给其他节点的数据块数量。
- **想要的块（Want-Blocks）**：当前节点需要但尚未收到的数据块数量。
- **有需求的块（Wantlist）**：一个列表，包含了当前节点想要获取的所有数据块的哈希值。
- **合作伙伴（Partners）**：当前节点与之交换数据块
```bash
ipfs bitswap stat
```


ipfs bitswap unwant - 从需求列表移除块
ipfs bitswap unwant …命令用来从需求列表（wantlist）中移除指定的块。

命令行
ipfs bitswap unwant [–] …
… - 要从需求列表中移除的块，可以指定多个

ipfs bitswap wantlist - 显示需求列表中的块
ipfs bitswap wantlist命令用来显示当前期望列表中的块。

命令行
ipfs bitswap wantlist [–peer= | -p]

选项
-p, --peer string - 指定要显示需求列表的节点，默认值：self

说明
ipfs bitswap wantlist命令打印输出当前节点bitswap需求列表中的所有块。

ipfs block - IPFS裸块操作接口
ipfs block命令用来操作IPFS裸块。

命令行
ipfs block

说明
ipfs block命令用于操作IPFS裸块，它可以读取标准输入stdin或写入标准输出 stdout，是base58编码的哈希（multihash）。

子命令
ipfs block get <key>    - 读取IPFS裸块
ipfs block put <data>   - 将输入数据存入IPFS块
ipfs block rm <hash>... - 移除指定的IPFS块
ipfs block stat <key>   - 打印指定IPFS裸块的信息
1
2
3
4
使用ipfs block --help获取子命令的详细信息。

ipfs block get - 读取IPFS裸块
ipfs block get 命令读取指定的IPFS裸块。

命令行
ipfs block get [–]
- 要读取的块的base58哈希（multihash）

说明
ipfs block get用来提取指定IPFS裸块的信息并输出到标准输出设备stdout。 参数是一个base58编码的哈希（multihash）。

ipfs block put - 写入IPFS裸块
ipfs block put <data>命令将输入数据写入IPFS块。
1
命令行
ipfs block put [--format=<format> | -f] [--mhtype=<mhtype>] 
	       [--mhlen=<mhlen>] [--] <data>
1
2
- 要存入IPFS块的数据

选项
-f,     --format string - 要创建的块格式，默认值：v0
--mhtype         string - multihash哈希函数，默认值: sha2-256.
--mhlen          int    - multihash哈希长度，默认值： -1
1
2
3
说明
ipfs block put用于将数据存入IPFS裸块，它从标准输入设备stdin读取数据。
1
ipfs block rm
ipfs block rm …命令删除指定的IPFS块，可以删除多个。

命令行
ipfs block rm [–force | -f] [–quiet | -q] [–] …
… - 要删除的块的multihash哈希，Bash58编码

选项
-f, --force bool - 是否忽略不存在的块，默认值：false
-q, --quiet bool - 是否使用安静模式显示最少量输出信息，默认值：false

说明
ipfs block rm命令用来删除ipfs裸块。可以指定一组base58编码的待删除块的哈希值。

ipfs block stat - 显示块信息
ipfs block stat 命令用来显示一个ipfs裸块的信息。

命令行
ipfs block stat [–]
- 块的哈希值，base58编码

说明
ipfs block stat用来提取IPFS裸块的信息，它在标准输出设备stdout 上输出如下信息：

Key - base58编码的哈希（multihash）
Size - 块字节数
ipfs bootstrap - 管理启动引导节点
ipfs bootstrap命令用来显示或编辑引导节点列表。

命令行
ipfs bootstrap

子命令
ipfs bootstrap add []… - 将一个或多个节点添加到引导列表
ipfs bootstrap list - 显示引导列表中的节点
ipfs bootstrap rm []… - 从引导列表中删除一个或多个节点

说明
运行无参数的ipfs bootstrap等价于运行ipfs bootstrap list。

安全警告 SECURITY WARNING:
bootstrap命令操作的引导列表中包含引导节点旳地址，这些节点是网络中的 可信节点，通过它们来获取其他节点旳信息。在编辑引导列表之前，请务必 了解添加或删除节点旳风险。

使用ipfs bootstrap --help获取子命令的详细帮助信息。

ipfs bootstrap add
ipfs bootstrap add []…命令将一个或多个节点添加到引导列表。

命令行
ipfs bootstrap add [–default] [–] […]
[]… - 要添加的节点，格式为/

选项
–default bool - 是否添加默认的引导节点。该选项已废弃，请使用default子命令。
说明
该命令将输出新添加的节点列表，即之前不在引导列表中的新节点。

安全警告
bootstrap命令操作的引导列表中包含引导节点旳地址，这些节点是网络中的 可信节点，通过它们来获取其他节点旳信息。在编辑引导列表之前，请务必 了解添加或删除节点旳风险。

子命令
ipfs bootstrap add default - 将默认节点添加到引导列表
使用ipfs bootstrap add --help命令获取子命令的详细帮助信息。

ipfs bootstrap list - 显示引导节点列表
ipfs bootstrap list命令显示引导列表中的节点。

命令行
ipfs bootstrap list
说明
输出的节点格式为：/。

ipfs bootstrap rm - 删除引导节点
ipfs bootstrap rm []…命令从引导列表中移除一个或多个节点。

命令行
ipfs bootstrap rm [–all] [–] […]
[]… - 要移除的节点，格式为：/

###　选项

–all bool - 删除所有的引导节点。该选项已废弃，请使用all子命令
说明
ipfs bootstrap rm命令输出被移除的节点列表。

安全警告
bootstrap命令操作的引导列表中包含引导节点旳地址，这些节点是网络中的 可信节点，通过它们来获取其他节点旳信息。在编辑引导列表之前，请务必 了解添加或删除节点旳风险。

子命令
ipfs bootstrap rm all - 删除引导列表中的所有节点
使用ipfs bootstrap rm --help获取子命令的详细帮助信息。

ipfs config - 配置管理
ipfs config []命令族用来读取或写入ipfs的配置信息。

命令行
ipfs config [–bool] [–json] [–] []
- 配置项的键，例如Addresses.API
[] - 要写入的配置项的值

选项
–bool bool - 是否设置布尔值，默认值：false
–json bool - 是否解析 字符串化的JSON对象，默认值：false

说明
ipfs config命令用来操控配置变量。它非常类似于git config。配置值 保存在IPFS本地仓库中的配置文件。

示例
读取Datastore.Path配置项的值：

$ ipfs config Datastore.Path
设置Datastore.Path配置项的值：

$ ipfs config Datastore.Path ~/.ipfs/datastore

子命令
ipfs config edit - 在环境变量$EDITOR指定的编辑器中编辑配置文件
ipfs config replace - 使用<file>指定的文件替代当前配置文件
ipfs config show - 显示当前配置文件的内容
使用ipfs config --help获取子命令的详细帮助信息。

ipfs config edit - 编辑配置文件
ipfs config edit命令在环境变量$EDITOR指定的编辑器中打开配置文件。

命令行
ipfs config edit

说明
使用ipfs config edit命令之前，需要先设置$EDITOR环境变量，使其指向 你喜欢的文本编辑器。

ipfs config replace - 替换配置文件
ipfs config replace 命令使用指定的文件替换当前的配置文件。

命令行
ipfs config replace [–]
- 新的配置文件

说明
在执行ipfs config replace命令之前，请保存当前的配置文件，因为该 命令是不可恢复的。

ipfs config show - 显示配置文件内容
ipfs config show命令用来显示当前配置文件的内容。

命令行
ipfs config show

警告
你的私钥保存在配置文件中，因此在ipfs config show命令的输出内容 里也会包含私钥。

ipfs 诊断系统
ipfs diag
使用ipfs diag命令生成诊断报告。

命令行
ipfs diag

子命令
ipfs diag cmds - 列出当前IPFS节点运行的命令
ipfs diag net  - 生成网络诊断报告
ipfs diag sys  - 打印系统诊断信息
1
2
3
使用ipfs diag --help查看子命令的帮助详情。

ipfs diag cmds
使用ipfs diag cmds命令列表显示当前IPFS节点上运行的命令。

命令行
ipfs diag cmds [–verbose | -v]

选项
-v, --verbose bool - 是否显示详细信息，默认值：false

说明
ipfs diag cmds命令列出当前正在运行以及最近运行的命令。

子命令
ipfs diag cmds clear           - 从日志中清除交互请求
ipfs diag cmds set-time <time> - 设置非活动请求在日志中的保留时长
1
2
使用ipfs diag cmds --help查看子命令的帮助详情。

ipfs diag cmds clear
使用ipfs diag cmds clear命令清理日志中的非活动请求。

命令行
ipfs diag cmds clear

ipfs diag cmds set-time
使用ipfs diag cmds set-time 命令设置非活动请求在日志中的保存时长。

命令行
ipfs diag cmds set-time [–]
- 非活动请求在日志中的保存时长。

ipfs diag sys
使用ipfs diag sys命令显示系统诊断信息。 - Print system diagnostic information.

命令行
ipfs diag sys
说明
ipfs diag sys命令显示计算机的系统信息，以便调试。

ipfs file
ipfs file命令用来与表征unix文件系统的IPFS对象进行交互。

命令行
ipfs file

说明
ipfs file命令为使用IPFS对象表示的文件系统提供了一个与传统 文件系统类似的操作接口，它隐藏了ipfs中的实现细节，例如扇出和切块等。

子命令
ipfs file ls … - 显示指定路径的ipfs对象的目录内容
可以使用ipfs file --help来显示子命令的详细帮助信息。

ipfs file ls
ipfs file ls …命令显示unix文件系统对象的目录内容。

命令行
ipfs file ls [–] …
… - 要显示其目录内容的IPFS对象路径

说明
ipfs file ls命令用来显示指定路径的IPFS或IPNS对象的内容。

JSON输出中包括与大小相关的信息。对于文件，其子对象大小是文件内容的 总大小，对于目录，其子对象大小是IPFS对象链接数。

路径可以使用无前缀引用格式，此时默认使用/ipfs前缀而非/ipns前缀：

例如，下面两种使用方法是等效的：

> ipfs file ls QmW2WQi7j6c7UgJTarActp7tDNikE4B2qXtFCfLPdsgaTQ
cat.jpg
> ipfs file ls /ipfs/QmW2WQi7j6c7UgJTarActp7tDNikE4B2qXtFCfLPdsgaTQ
cat.jpg
1
2
3
4
注意，ipfs file ls命令已被废弃，在将来的版本中将被移除。可能的情况下 应该使用ipfs ls命令。

ipfs files
ipfs files命令用来操作unixfs文件。

命令行
ipfs files [–f=false]

选项
-f, --flush bool - 是否在写文件后自动刷新目标及其父节点，默认值：true

说明
ipfs files命令族允许我们像操作unix文件系统一样操作IPFS对象。

注意，绝大多数的ipfs files子命令都支持–flush选项，其默认值为true。 如果将该选项设置为false，虽然可以提高大量文件操作时的性能，但代价是 放弃了一致性保证，如果服务进程在运行ipfs files flush命令之前被意外杀掉， 有可能丢失数据。因此请慎重考虑是否将该选项设置为false。

类似的，并发的ipfs repo gc命令如果使用–flush=false也存在潜在 的数据丢失问题。

子命令
ipfs files cp <source> <dest>  - 将文件拷贝到mfs中
ipfs files flush [<path>]      - 将指定路径的数据刷新到磁盘
ipfs files ls [<path>]         - 列表显示本地可变命名空间中的目录
ipfs files mkdir <path>        - 创建目录
ipfs files mv <source> <dest>  - 移动文件
ipfs files read <path>         - 读取指定mfs中的文件
ipfs files rm <path>...        - 删除指定文件
ipfs files stat <path>         - 显示文件状态
ipfs files write <path> <data> - 写入指定文件系统中的可变文件
1
2
3
4
5
6
7
8
9
可以使用ipfs files --help来获取子命令的详细帮助信息。

ipfs files cp
ipfs files cp 命令将指定的文件拷贝到mfs中。

命令行
ipfs files cp [–]

参数：
- 要拷贝的源对象 - 拷贝目标
ipfs files flush
ipfs files flush [ ]命令将指定路径的数据刷新到磁盘。

命令行
ipfs files flush [–] [ ]
[ ] - 要刷新的数据的路径，默认值：/。

说明
ipfs files flush命令负责将指定的路径刷新到磁盘。仅当其他ipfs files 命令以–flush=false选项执行时才需要使用该命令。

ipfs files ls
ipfs files ls [ ]命令列表显示本地可变命名空间中的目录内容。

命令行
ipfs files ls [-l] [–] [ ]
[ ] - 要显示其目录列表的路径，默认值：/

选项
-l bool - 是否使用加长显示格式。

说明
ipfs files ls命令用来显示本地可变命名空间中的目录内容。

例如，以下代码显示/welcome/docs目录的内容：

$ ipfs files ls /welcome/docs/
about
contact
help
quick-start
readme
security-notes
1
2
3
4
5
6
7
类似的，以下代码列表显示/myfiles/a/b/c/d目录的内容：

$ ipfs files ls /myfiles/a/b/c/d
foo
bar
1
2
3
ipfs files mkdir
ipfs files mkdir 命令用来创建指定的目录。

命令行
ipfs files mkdir [–parents | -p] [–]
- 要创建的目录路径。

选项
-p, --parents bool - 是否根据需要自动创建父目录

说明
ipfs files mkdir命令可以创建指定路径的目录，如果该目录不存在的话。

注意，必须使用绝对路径。

例如：

$ ipfs mfs mkdir /test/newdir
$ ipfs mfs mkdir -p /test/does/not/exist/yet
1
2
ipfs files mv
ipfs files mv 命令用来移动指定文件到目标路径。

命令行
ipfs files mv [–]

参数：
- 要移动的源文件
- 目标路径
说明
ipfs files mv命令的作用是移动文件，类似于传统的unix命令mv。

例如，将文件/myfs/a/b/c更名为/myfs/foo/newc：

$ ipfs files mv /myfs/a/b/c /myfs/foo/newc
1
ipfs files read
ipfs files read 命令读取指定文件的内容。

命令行
ipfs files read [–offset= | -o] [–count= | -n] [–]
- 要读取文件的路径

选项
-o, --offset int - 读取起始位置相对于文件头的字节偏移量
-n, --count int - 要读取的字节数

说明
ipfs files read命令可以读取文件指定偏移位置开始、指定数量的数据。默认 情况下，该命令将读取整个文件的内容，类似于unix中的cat命令。

示例：

$ ipfs files read /test/hello
hello

ipfs files rm
ipfs files rm …命令删除指定的文件。

命令行
ipfs files rm [–recursive | -r] [–] …
… - 要删除的文件

选项
-r, --recursive bool - 是否递归删除目录

说明
ipfs files rm命令可以删除指定的文件或目录。

例如：

$ ipfs files rm /foo
$ ipfs files ls /bar
cat
dog
fish
$ ipfs files rm -r /bar
1
2
3
4
5
6
ipfs files stat
ipfs files stat <path>命令显示指定文件的统计信息。
1
命令行
ipfs files stat [--format=<format>] [--hash] [--size] [--] <path>
<path> - 要显示其统计信息的文件路径
1
2
选项
--format string - 统计信息的显示格式，支持以下字段标志：`<hash> <size> <cumulsize> <type> <childs>`。默认值为：`<hash>`
--hash   bool   - 是否只显示哈希，该选项自动启用`--format=<hash>`，默认值：false
--size   bool   - 是否只显示哈希，该选项自动启用`--format=<cumulsize>`，默认值：false
1
2
3
ipfs files write
ipfs files write 命令将数据写入指定的文件。

命令行
ipfs files write [–offset= | -o] [–create | -e] [–truncate | -t] [–count= | -n] [–]

参数：
- 要写入的文件路径
- 要写入的数据内容

选项
-o, --offset int - 开始写入的文件内字节偏移量
-e, --create bool - 如果目标文件不存在，是否自动创建
-t, --truncate bool - 是否在写入数据之前将文件清零
-n, --count int - 要写入的最大字节数

说明
ipfs files write命令将指定的数据写入指定的文件。该命令允许指定数据写入位置。

如果使用了–create选项，那么当目标文件不存在时将自动创建，但该命令无法自动创建 目标文件路径中不存在的中间路径部分。

如果在执行ipfs files write命令时设置–flush=false选项，那么对文件的修改将 不会传播到有向图的根节点，当执行大量写操作或写入深层目录时可以明显提升速度。

示例：

echo “hello world” | ipfs files write --create /myfs/a/b/file
echo “hello world” | ipfs files write --truncate /myfs/a/b/file
警告：

使用–flush=false选项时，在树刷新之前将无法保证数据一致性。可以在文件或其父 对象上执行ipfs files flush命令来执行刷新操作。

管理名称密钥
ipfs key
ipfs key命令用来管理IPNS名称密钥对。

命令行
ipfs key

说明
使用ipfs key gen命令创建一个新的密钥对，一边用于IPNS和ipfs name publish命令。

例如：

ipfs key gen --type=rsa --size=2048 mykey
ipfs name publish --key=mykey QmSomeHash
使用ipfs key list显示当前可用的密钥。例如：
ipfs key list
self
mykey
子命令
ipfs key gen - 创建新的密钥对
ipfs key list - 列表显示本地保存的所有密钥对
使用ipfs key --help查看子命令的详细帮助信息。

ipfs key gen
ipfs key gen <name>命令用来创建新的密钥对。
1
命令行
ipfs key gen [--type=<type> | -t] [--size=<size> | -s] [--] <name>
<name> - 要创建的密钥对的名称
1
2
选项
-t, --type string - 密钥类型，支持：rsa和ed25519
-s, --size int    - 密钥的位数
1
2
ipfs key list
ipfs key list命令列表显示本地所有密钥对。

命令行
ipfs key list [-l]

选项
-l bool - 是否显示密钥详情

ipfs 日志管理
ipfs log
使用ipfs log命令管理ipfs服务进程的日志输出。

命令行
ipfs log

说明
ipfs log命令系列用来管理服务进程日志的生成与读取。

子命令
ipfs log level - 修改日志等级
ipfs log ls - 列举日志子系统
ipfs log tail - 读取事件日志
使用ipfs log --help查看子命令的帮助详情。

ipfs log level
使用ipfs log level 命令修改日志等级。

命令行
ipfs log level [–]

参数：
- 子系统日志标识符，all表示所有子系统
- 日志等级，debug将显示最多的信息，critical将显示最少的信息。 可选以下值之一：debug, info, warning, error, critical。

说明
ipfs log level修改指定的一个或全部子系统的日志输出等级。该命令不影响事件日志。

ipfs log tail
使用ipfs log tail命令跟踪读取并显示事件日志。

命令行
ipfs log tail

说明
ipfs log tail命令可以在事件生成时输出显示事件日志消息。

ipfs log ls
使用ipfs log ls命令列出所有的日志子系统。

命令行
ipfs log ls

说明
ipfs log ls命令用来列出一个运行中的服务进程的所有日志 子系统。

管理inps名称
ipfs name
使用ipfs name命令管理IPNS名称的发布和解析。

命令行
ipfs name

说明
IPNS是一个PKI名称空间， IPNS名称是公钥的哈希，私钥则用来发布签名的名称。 当发布或解析名称时，默认情况下总是使用发布者自身的节点ID，也就是节点 公钥的哈希。

可以使用ipfs key命令显示密钥列表、创建更多可用的名称及对应的密钥。

示例
使用节点默认名称发布一个：

> ipfs name publish /ipfs/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
Published to QmbCMUZw6JFeZ7Wp9jkzbye3Fzp2GGcPgC3nmeUjfVF87n: /ipfs/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
1
2
使用ipfs key命令创建一对新的密钥，然后用另一个名称发布一个 ：

> ipfs key gen --type=rsa --size=2048 mykey
> ipfs name publish --key=mykey /ipfs/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
Published to QmbCMUZw6JFeZ7Wp9jkzbye3Fzp2GGcPgC3nmeUjfVF87n: /ipfs/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
1
2
3
解析默认名称：

> ipfs name resolve
/ipfs/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
1
2
解析指定的名称：

> ipfs name resolve QmaCpDMGvV2BGHeYERUEnRQAwe3N8SzbUtfsmvsqQLuvuJ
/ipfs/QmSiTko9JZyabH56y2fussEt1A5oDqsFXB3CkvAqraFryz
1
2
解析DNS域名：

> ipfs name resolve ipfs.io
/ipfs/QmaBvfZooxWkrv7D3r8LS9moNjzD2o525XMZze69hhoxf5
1
2
子命令
ipfs name publish - 发布IPNS名称
ipfs name resolve [] - 解析IPNS名称
使用ipfs name --help查看子命令的详细帮助信息。

ipfs name publish
使用ipfs name publish 命令发布IPNS名称。

命令行
ipfs name publish [–resolve=false] [–lifetime= | -t] [–ttl=] [–key= | -k] [–]
-要发布的ipfs对象的路径

选项
–resolve bool - 是否在发布前解析指定的路径，默认值：true
-t, --lifetime string - 名称记录的有效时长，默认值：24h
可以使用不同的计时单位，例如300s, 1.5h 或 2h45m，有效的时间单位包括：
“ns”, “us” (or “µs”), “ms”, “s”, “m”, “h”.
–ttl string - 名称记录允许缓存的时长。注意，这是一个实验阶段的特性
-k, --key string - 要使用的密钥对名称，可以使用ipfs key list查看可用的密钥对。默认值：self

说明
IPNS是一个PKI名称空间， IPNS名称是公钥的哈希，私钥则用来发布签名的名称。 当发布或解析名称时，默认情况下总是使用发布者自身的节点ID，也就是节点 公钥的哈希。

可以使用ipfs key命令显示密钥列表、创建更多可用的名称及对应的密钥。

示例
使用节点默认名称发布一个：

ipfs name publish /ipfs/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
Published to QmbCMUZw6JFeZ7Wp9jkzbye3Fzp2GGcPgC3nmeUjfVF87n: /ipfs/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
使用ipfs key命令创建一对新的密钥，然后用另一个名称发布一个 ：
ipfs key gen --type=rsa --size=2048 mykey
ipfs name publish --key=mykey /ipfs/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
Published to QmbCMUZw6JFeZ7Wp9jkzbye3Fzp2GGcPgC3nmeUjfVF87n: /ipfs/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
ipfs name resolve
使用ipfs name resolve []解析IPNS名称。

命令行
ipfs name resolve [–recursive | -r] [–nocache | -n] [–] []
[] - 要解析的IPNS名称，默认值为节点ID

选项
-r, --recursive bool - 是否递归解析直至结果不再是IPNS名称。默认值： false
-n, --nocache   bool - 是否不使用缓存进行解析，默认值： false
1
2
说明
IPNS是一个PKI名称空间， IPNS名称是公钥的哈希，私钥则用来发布签名的名称。 当发布或解析名称时，默认情况下总是使用发布者自身的节点ID，也就是节点 公钥的哈希。

可以使用ipfs key命令显示密钥列表、创建更多可用的名称及对应的密钥。

示例
解析默认名称：

> ipfs name resolve
/ipfs/QmatmE9msSfkKxoffpHwNLNKgwZG8eT9Bud6YoPab52vpy
1
2
解析指定名称：

> ipfs name resolve QmaCpDMGvV2BGHeYERUEnRQAwe3N8SzbUtfsmvsqQLuvuJ
/ipfs/QmSiTko9JZyabH56y2fussEt1A5oDqsFXB3CkvAqraFryz
1
2
解析DNS名称：

> ipfs name resolve ipfs.io
/ipfs/QmaBvfZooxWkrv7D3r8LS9moNjzD2o525XMZze69hhoxf5
1
2
管理ipfs对象
ipfs object
使用ipfs object命令操作IPFS对象。

命令行
ipfs object

说明
ipfs object命令用来直接操作DAG对象。 directly.

子命令
ipfs object data <key>           - 输出ipfs对象的裸数据
ipfs object diff <obj_a> <obj_b> - 显示两个ipfs对象的差异
ipfs object get <key>            - 读取名称为`<key>`的DAG节点并进行序列化
ipfs object links <key>          - 输出指定对象指向的链接
ipfs object new [<template>]     - 使用给定的ipfs模版创建一个新的对象
ipfs object patch                - 基于现有对象创建一个新的DAG对象
ipfs object put <data>           - 将输入保存为DAG对象，并输出显示生成的密钥
ipfs object stat <key>           - 读取名称为`<key>`的DAG节点旳统计信息
1
2
3
4
5
6
7
8
使用ipfs object --help查看子命令的详细帮助信息。

ipfs object data
使用ipfs object data 命令输出指定ipfs对象的原始字节流。

命令行
ipfs object data [–]
- 要读取对象的键，base58编码，multihash格式

说明
ipfs object data命令用来读取DAG节点中保存的原始数据，并输出到 标准输出设备。参数是base58编码的multihash哈希。

注意，–encoding选项不会影响输出，因为输出的是对象的原始数据。

ipfs object diff
使用ipfs object diff <obj_a> <obj_b>命令显示两个ipfs对象的差异。

命令行
ipfs object diff [–verbose | -v] [–] <obj_a> <obj_b>
参数：

<obj_a> - 参与比较的对象a
<obj_b> - 参与比较的对象b
选项
-v, --verbose bool - 是否显示详细信息
说明
ipfs object diff命令可以显示两个ipfs对象的差异。

示例:
> ls foo
bar baz/ giraffe
> ipfs add -r foo
...
Added QmegHcnrPgMwC7tBiMxChD54fgQMBUecNw9nE9UUU4x1bz foo
> OBJ_A=QmegHcnrPgMwC7tBiMxChD54fgQMBUecNw9nE9UUU4x1bz
> echo "different content" > foo/bar
> ipfs add -r foo
...
Added QmcmRptkSPWhptCttgHg27QNDmnV33wAJyUkCnAvqD3eCD foo
> OBJ_B=QmcmRptkSPWhptCttgHg27QNDmnV33wAJyUkCnAvqD3eCD
> ipfs object diff -v $OBJ_A $OBJ_B
Changed "bar" from QmNgd5cz2jNftnAHBhcRUGdtiaMzb5Rhjqd4etondHHST8 to QmRfFVsjSXkhFxrfWnLpMae2M4GBVsry6VAuYYcji5MiZb.
1
2
3
4
5
6
7
8
9
10
11
12
13
ipfs object get
使用ipfs object get 命令读取并序列化指定的DAG节点。

命令行
ipfs object get [–]
- 要读取对象的键，base58编码，multihash格式

说明
ipfs object get命令用来提取指定DAG节点旳内容。使用–encoding 选项声明序列化的格式。该命令在标准输出设备stdout上显示输出，参数 是base58编码的multihash哈希。

ipfs object get支持以下序列化编码格式：

“protobuf”
“json”
“xml”
使用–encoding或–enc选项来声明上述编码格式。
ipfs object links
使用ipfs object links 命令输出指定对象的链接对象。

命令行
ipfs object links [–headers | -v] [–]
- 对象的键，base58编码，multihash格式

选项
-v, --headers bool - 是否打印表头，例如哈希、大小、名称，默认值：false

说明
ipfs object links命令用来提取一个指定DAG节点旳链接对象，并将结果 在标准输出设备上列表显示，参数为base58编码。

ipfs object new
使用ipfs object new [<template>]命令可以基于模板创建一个新的ipfs对象。
1
命令行
ipfs object new [--] [<template>]
[<template>] - 要使用的模板，可选
1
2
说明
ipfs object new命令用来创建新的DAG节点。默认情况下它创建并返回一个空的节点， 但是可以传入一个可选的模板来创建有预定格式的节点。

目前可用的模板为：

unixfs-dir
ipfs object patch
使用ipfs object patch命令可以基于已有的对象创建一个新的DAG对象。

命令行
ipfs object patch

说明
ipfs object patch 命令用来创建定制DAG对象。该 命令修改已有的对象，然后得到一个新的对象，可以认为它是DAG版本的ipfs对象 修改方法。

子命令
ipfs object patch add-link <root> <name> <ref> - 为指定对象添加一个链接
ipfs object patch append-data <root> <data>    - 向DAG节点旳数据段追加数据
ipfs object patch rm-link <root> <link>        - 删除对象的指定链接
ipfs object patch set-data <root> <data>       - 设置IPFS对象的数据字段
1
2
3
4
使用ipfs object patch --help查看子命令的详细帮助信息。

ipfs object patch add-link
使用ipfs object patch add-link 命令为指定对象添加一个新的链接。

命令行
ipfs object patch add-link [–create | -p] [–]
参数：

- 要修改的节点哈希
- 要创建的链接名称
- 要链接的IPFS对象

选项
-p, --create bool - 是否创建中间节点，默认值：false

说明
ipfs object patch add-link命令为指定对象添加一个默克尔链接，并返回结果哈希。

示例
下面代码创建一个新的空目录，然后再其中添加一个名为foo的链接，该链接 指向一个内容为bar的文件，然后返回新对象的哈希：

$ EMPTY_DIR=$(ipfs object new unixfs-dir)
$ BAR=$(echo “bar” | ipfs add -q)
$ ipfs object patch $EMPTY_DIR add-link foo $BAR

ipfs object patch append-data
使用ipfs object patch append-data 命令向DAG节点旳数据段追加数据。

命令行
ipfs object patch append-data [–]
参数：

- 要修改的节点哈希
- 要追加的数据

说明
ipfs object patch append-data命令向指定对象的数据段追加新的数据。

示例
$ echo “hello” | ipfs object patch $HASH append-data
注意，上面的命令不会将数据写入文件 —— 它直接修改DAG对象的裸数据。一个对象 最多可保存1MB的数据，大于该尺寸的对象不会被网络接受。

ipfs object patch rm-link
使用ipfs object patch rm-link 方法移除一个对象的指定链接。

命令行
ipfs object patch rm-link [–]
参数：

- 要修改的节点
- 要移除的链接
说明
ipfs object patch rm-link命令从节点移除一个指定的链接。

ipfs object patch set-data
使用ipfs object patch set-data 命令修改指定IPFS对象的数据字段。

命令行
ipfs object patch set-data [–]
参数：

- 要修改的节点
- 要设置的新数据
说明
ipfs object patch set-data命令读取标准输入stdin，然后用输入内容更新节点。

例如：

$ echo “my data” | ipfs object patch $MYHASH set-data

ipfs object put
使用ipfs object put 命令将输入内容保存为DAG对象，并输出该对象的键。

命令行
ipfs object put [–inputenc=] [–datafieldenc=] [–]
- 要保存的数据

选项
–inputenc string - 输入数据的编码类型，有以下可选值：protobuf、 json，默认值： json
–datafieldenc string - 数据字段的编码类型，可以是text或base64，默认值：text

说明
ipfs object put命令利用输入创建一个新的对象，输出为base58编码的multihash值。

使用–inputenc选项设置输入数据的编码格式，可选以下值：

“protobuf”
“json” (default)
示例：

$ echo ‘{ “Data”: “abc” }’ | ipfs object put
如上命令使用数据abc创建一个新的不包含链接的节点。要创建一个包含链接的 对象，需要先创建一个文件，例如node.json，内容如下：

{
    "Data": "another",
    "Links": [ {
	"Name": "some link",
	"Hash": "QmXg9Pp2ytZ14xgmQjYEiHjVjMFXzCVVEcRTWJBmLgR39V",
	"Size": 8
    } ]
}
1
2
3
4
5
6
7
8
然后执行以下命令：

$ ipfs object put node.json
1
ipfs object stat
使用ipfs object stat 命令读取指定DAG节点旳统计信息。

命令行
ipfs object stat [–]
- 要读取统计信息的节点的键，base58编码，multihas格式

说明
ipfs object stat命令可以输出显示DAG节点旳统计信息。 参数为base58编码的哈希，格式为multihash。该命令输出到 标准输出设备stdout，内容如下：

NumLinks        int - 链接表中的链接数
BlockSize       int - 数据块大小
LinksSize       int - 链接段大小
DataSize        int - 数据段大小
CumulativeSize  int - 数据及链接的累计大小
1
2
3
4
5
# 管理ipfs 固定和解除固定

```bash
ipfs pin
```

使用ipfs pin命令在本地仓库中固定（或解除固定）ipfs对象。

# 命令行
```bash
ipfs pin
```

子命令
```bash
ipfs pin add … - 将指定ipfs对象固定在本地存储中
ipfs pin ls []… - 列表显示本地存储中被固定的ipfs对象
ipfs pin rm … - 从本地存储中移除被固定的ipfs对象
使用ipfs pin --help查看子命令的详细帮助信息。
```

```bash
ipfs pin add
```

# 使用ipfs pin add …命令将ipfs对象固定在本地存储中。

## 命令行
```bash
ipfs pin add [–recursive=false] [–progress] [–] …
… - 要固定的ipfs对象的路径
```

## 选项
```bash
-r, --recursive bool - 是否递归固定指定的ipfs对象，默认值：true
–progress bool - 是否显示命令执行进度
```

## 说明

ipfs pin命令将指定路径的IPFS对象固定在本地磁盘存储中。

```bash
ipfs pin ls
使用ipfs pin ls []…命令列表显示本地存储中已固定的ipfs对象。
```

## 命令行
```bash
ipfs pin ls [–type= | -t] [–quiet | -q] [–] […]
[]… - 要列举其被固定内容的ipfs对象路径
```

## 选项
```bash
-t, --type string - 要显示的被固定密钥的类型，可以是"direct", “indirect”, “recursive”, 或者 “all”。默认值：all
-q, --quiet bool - 是否仅显示被固定对象的哈希，默认值：false
```

## 说明

ipfs pin ls 命令返回一组本地固定的 ipfs 对象。默认情况下，该命令将返回 所有被固定的对象，不过可以使用 –type 选项来限定要求仅返回特定类型的 被固定对象，或使用路径参数来限定仅返回指定ipfs对象所链接的被固定对象。

使用 –type= 选项来指定要显示的密钥类型。可选值如下：
```bash
“direct”: 选中指定对象
“recursive”: 选中指定对象及其后代对象
“indirect”: 被祖先对象间接选中，类似于refcount
“all”： 全部对象
```

当使用路径参数时，如果该路径所指向的对象不是被固定对象，ipfs pin ls 命令将失败。同时，如果使用–type=选项指定一个与该路径对象不符 的类型，命令也会失败。

## 示例
```bash
$ echo “hello” | ipfs add -q
QmZULkCELmmk5XNfCgTnCyFgAVxBRBXyDHGGMVoLFLiXEN
$ ipfs pin ls
QmZULkCELmmk5XNfCgTnCyFgAVxBRBXyDHGGMVoLFLiXEN recursive

now remove the pin, and repin it directly
$ ipfs pin rm QmZULkCELmmk5XNfCgTnCyFgAVxBRBXyDHGGMVoLFLiXEN
unpinned QmZULkCELmmk5XNfCgTnCyFgAVxBRBXyDHGGMVoLFLiXEN
$ ipfs pin add -r=false QmZULkCELmmk5XNfCgTnCyFgAVxBRBXyDHGGMVoLFLiXEN
pinned QmZULkCELmmk5XNfCgTnCyFgAVxBRBXyDHGGMVoLFLiXEN directly
$ ipfs pin ls --type=direct
QmZULkCELmmk5XNfCgTnCyFgAVxBRBXyDHGGMVoLFLiXEN direct
$ ipfs pin ls QmZULkCELmmk5XNfCgTnCyFgAVxBRBXyDHGGMVoLFLiXEN
QmZULkCELmmk5XNfCgTnCyFgAVxBRBXyDHGGMVoLFLiXEN direct
```

# 解除指定ipfs对象的固定。

```bash
ipfs pin rm
使用ipfs pin rm …命令从本地存储中解除指定ipfs对象的固定。
```
## 命令行
```bash
ipfs pin rm [–recursive=false] [–] …

… - 要接触固定的对象路径
```

## 选项

```bash
-r, --recursive bool - 是否递归接触指定对象的固定，默认值：true
```
说明
ipfs pin rm命令用来接触指定对象的固定，以便其可以被垃圾回收机制 所处理。默认情况下，该命令将递归解除指定对象的及其后代的固定，使用 -r=false选项来解除直接固定。

显示对象链接清单
ipfs refs
使用ipfs refs …命令显示一个对象的链接清单。

命令行
ipfs refs [–format=] [–edges | -e] [–unique | -u] [–recursive | -r] [–] …
… - 要显示其引用链接的ipfs对象路径

选项
–format string - Emit edges with given format. Available tokens: . Default: .
-e, --edges bool - Emit edge format: <from> -> <to>. Default: false.
-u, --unique bool - Omit duplicate refs from output. Default: false.
-r, --recursive bool - Recursively list links of child nodes. Default: false.

说明
ipfs refs命令显示一个指定的IPFS或IPNS对象所包含的全部引用链接。格式如下：

注意，可以使用-r选项递归列出所有的引用链接。
子命令
ipfs refs local - 列出所有的本地链接
使用ipfs refs --help显示子命令的详细帮助信息。

ipfs refs local
使用ipfs refs local命令列出所有的本地引用。

命令行
ipfs refs local

说明
显示所有本地对象的哈希。

管理ipfs仓库
ipfs repo
使用ipfs repo命令操作IPFS仓库。

命令行
ipfs repo

说明
ipfs repo命令用来操作ipfs仓库。

子命令
ipfs repo fsck - 移除仓库的锁文件
ipfs repo gc - 在仓库上执行垃圾回收处理
ipfs repo stat - 读取当前使用的仓库的统计信息
ipfs repo verify - 校验仓库中的块是否被破坏
ipfs repo version - 显示仓库版本
使用ipfs repo --help查看子命令的详细帮助信息。

ipfs repo fsck
使用ipfs repo fsck命令移除仓库的锁文件。

命令行
ipfs repo fsck

说明
ipfs repo fsck命令用来删除仓库和level db数据库的锁文件。只有ipfs 服务进程没有启动时，才可以执行该命令。

ipfs repo gc
使用ipfs repo gc命令对仓库执行垃圾回收扫描。
1
命令行
ipfs repo gc [--quiet | -q] [--stream-errors]
1
选项
-q,            --quiet bool - 是否仅输出少量信息，默认值：false
--stream-errors        bool - 是否使用错误流，默认值：false
1
2
说明
ipfs repo gc命令扫描仓库中的对象，并依照先后顺序移除没有固定的对象， 以便回收磁盘空间。
1
ipfs repo stat
使用ipfs repo stat命令获取当前仓库的统计信息。

命令行
ipfs repo stat [--human]
1
选项
--human bool - 是否输出仓库大小，单位MB，默认值：false
1
说明
ipfs repo stat命令扫描仓库中保存的对象并打印统计信息，输出内容如下：

NumObjects      int  - 本地仓库中的对象数
RepoPath        string - 当前仓库的路径
RepoSize        int - 仓库占用的字节数
Version         string - 仓库版本
1
2
3
4
5
6
ipfs repo verify
使用ipfs repo verify命令对仓库的完好性进行校验。

命令行
ipfs repo verify

ipfs repo version
使用ipfs repo version命令显示仓库的版本信息。
1
命令行
ipfs repo version [--quiet | -q]
1
选项
-q, --quiet bool - 是否输出最少的信息
1
说明
ipfs repo version返回当前仓库的版本信息。
1
ipfs状态信息
ipfs stats
使用ipfs stats命令查询ipfs的统计信息。

命令行
ipfs stats

说明
ipfs stats命令系列用来查看ipfs节点旳统计信息。

子命令
ipfs stats bitswap - 显示bitswap代理的诊断信息
ipfs stats bw - 打印ipfs带宽利用信息
ipfs stats repo - 获取当前仓库的统计信息
使用ipfs stats --help命令查看子命令的帮助详情。

ipfs stats bitswap
使用ipfs stats bitswap命令显示bitswap代理的诊断信息。

命令行
ipfs stats bitswap

ipfs stats bw
使用ipfs stats bw命令打印ipfs的带宽利用信息。

命令行
ipfs stats bw [--peer=<peer> | -p] [--proto=<proto> | -t] [--poll] [--interval=<interval> | -i]
1
选项
-p,   --peer     string - 指定一个对端节点
-t,   --proto    string - 指定一个协议
--poll           bool   - 是否定时显示带宽利用信息，默认值：false
-i,   --interval string - 定时显示的间隔时间，仅当使用`--poll`选项时有效
			  可以使用不同的时间单位来指定定时间隔，例如"300s", "1.5h" 或"2h45m"。
			  有效的时间单位包括："ns", "us" (or "µs"), "ms", "s", "m", "h"。
			  默认值: 1s
1
2
3
4
5
6
7
说明
ipfs stats bw命令输出ipfs服务进程的带宽利用信息。显示内容包括：入流量、出流量、入流速和出流速。

默认情况下，显示的是所有协议的带宽利用总量。可以使用–peer选项限定显示与某一 对端节点之间的带宽利用情况。也可以使用–proto选项限定仅显示某一特定协议的带宽 利用情况。这两个选项不可以同时使用。

–proto选项的可选协议如下：

/ipfs/id/1.0.0
/ipfs/bitswap
/ipfs/dht
可以访问libp2p 进一步了解可选协议。
示例
> ipfs stats bw -t /ipfs/bitswap
Bandwidth
TotalIn: 5.0MB
TotalOut: 0B
RateIn: 343B/s
RateOut: 0B/s
> ipfs stats bw -p QmepgFW7BHEtU4pZJdxaNiv75mKLLRQnPi1KaaXmQN4V1a
Bandwidth
TotalIn: 4.9MB
TotalOut: 12MB
RateIn: 0B/s
RateOut: 0B/s
1
2
3
4
5
6
7
8
9
10
11
12
ipfs stats repo
使用ipfs stats repo命令获取当前仓库的统计信息。

命令行
ipfs stats repo [–human]

选项
–human bool - 是否输出仓库大小，单位MiB，默认值：false

说明
ipfs repo stat命令扫描本地仓库中存储的对象并打印统计信息。输出内容 如下：

NumObjects int - 本地仓库中的对象
RepoPath string - 当前仓库的路径
RepoSize int - 当前仓库占用空间的字节数
Version string - 仓库版本
————————————————

                            版权声明：本文为博主原创文章，遵循 CC 4.0 BY 版权协议，转载请附上原文出处链接和本声明。
                        
原文链接：https://blog.csdn.net/jacky128256/article/details/91455218