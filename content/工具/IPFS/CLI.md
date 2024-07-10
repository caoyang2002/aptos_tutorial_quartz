---
title: 命令行工具
---
# Kubo 的基本 CLI 操作

这个简短的指南旨在带您了解“使用 Kubo CLI 的 IPFS 基础知识”。Kubo 是[多种 IPFS 实现之一](https://docs.ipfs.tech/ipfs-implementations/)。它是最古老的 IPFS 实现，并提供了一个 CLI（以及其他内容）。

您将学习如何在 CLI 中添加、检索、读取和删除文件。如果您不确定某些术语的含义，可以查看[词汇表](https://docs.ipfs.tech/concepts/glossary/)。

此处显示的所有说明和示例均在 M1 Mac 上执行和测试。但是，IPFS 命令在 Linux、macOS 和 Windows 上是相同的。您需要知道如何在 CLI 中导航计算机的目录。如果您不确定如何使用 CLI，建议在继续本指南之前学习。

# 安装 Kubo

接下来，我们需要为命令行安装 Kubo。我们有一个很好的指南，将带您了解如何[使用 CLI 安装 Kubo](https://docs.ipfs.tech/install/command-line/)。

安装好 Kubo 后，我们需要启动并运行我们的节点。如果这是您第一次使用 Kubo，您首先需要初始化配置文件：

```shell
ipfs init
```

这将输出类似以下内容：

```plaintext
在 /Users/<用户>/.ipfs 初始化 ipfs 节点
生成 2048 位 RSA 密钥对...完成
对等身份: Qm...
要开始，请输入:

  ipfs cat /ipfs/QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG/readme
```

现在我们准备启动 IPFS 守护进程以使节点上线。运行 `ipfs daemon` 命令：

```bash
ipfs daemon
```

这将输出类似以下内容：

```bash
初始化守护进程...
Kubo 版本: 0.12.0
存储库版本: 12
系统版本: arm64/darwin
[...]
守护进程已准备好
```

此命令将一直运行，直到您告诉它停止；现在不要这样做！只需打开一个新的 CLI 实例并继续本指南！

>[!WARNING] 警告
>
> 不要关闭用于初始化守护进程的 CLI。只有在要使 IPFS 节点离线时才终止守护进程。

# 1. 添加文件

现在我们的 Kubo IPFS 节点已启动并运行，我们准备向 IPFS 添加文件。

1. 在 CLI 中，导航到包含您要共享的文件或文件夹的目录。在此示例中，我们将导航到 `~/Documents` 目录：

    ```shell
    cd ~/Documents
    ```

2. 到达那里后，列出目录的内容以确保我们在正确的位置：

    ```shell
    ls
    ```

    这将输出此文件夹的内容：

    ```plaintext
    hello-ipfs.txt
    ```

3. 接下来，我们将使用 `ipfs add` 命令向 IPFS 添加文件。确保在文件名末尾添加文件扩展名：

    ```shell
    ipfs add hello-ipfs.txt
    ```

    这将输出类似以下内容：

    ```plaintext
    添加 QmRgR7Bpa9xDMUNGiKaARvFL9MmnoFyd86rF817EZyfdGE hello-ipfs.txt
    6 B / 6 B [==========================================================] 100.00
    ```

我们现在已将文件添加到 IPFS，并且可以与网络上的对等节点共享！

# 2. 下载文件

在上一节中，我们介绍了如何将本地文件添加到 IPFS。现在我们将介绍如何从 IPFS 检索远程文件并将其保存到您的计算机。在此示例中，我们将检索一个包含单个文本文件的文件夹。

1. 在 CLI 中，导航到您希望保存文件夹的目录。IPFS 将把文件夹保存到您所在的任何目录。在本例中，我们将把文件夹保存到 `~/Documents` 目录：

    ```shell
    cd ~/Documents
    ```

2. 要通过 IPFS 获取内容，我们需要告诉 `ipfs daemon` 我们想要的 CID。在本例中，我们想要`bafybeif2ewg3nqa33mjokpxii36jj2ywfqjpy3urdh7v6vqyfjoocvgy3a`。

3. 使用命令`ipfs get`，结合我们想要的 CID，来检索文件夹：

    ```shell
    ipfs get bafybeif2ewg3nqa33mjokpxii36jj2ywfqjpy3urdh7v6vqyfjoocvgy3a
    ```

    这将输出类似以下内容：

    ```plaintext
    将文件保存到 bafybeif2ewg3nqa33mjokpxii36jj2ywfqjpy3urdh7v6vqyfjoocvgy3a
    1.76 KiB / 1.76 KiB [==============================================] 100.00% 0s
    ```

    您的 IPFS 节点可能需要一些时间才能找到我们正在寻找的数据。

我们现在已经通过 IPFS 检索了文件夹，并且它的副本已保存到您计算机的本地存储！您现在也正在为其他人托管该文件夹及其内容以供检索。

## 查看文件

您可以使用命令 `ipfs cat` 在 CLI 中查看文件的内容。我们将使用此命令查看我们刚刚检索的文件夹的内容，但您也可以对尚未本地拥有的文件使用“ipfs cat”。

```shell
ipfs cat bafybeif2ewg3nqa33mjokpxii36jj2ywfqjpy3urdh7v6vqyfjoocvgy3a
```

这将输出类似以下内容：

```plaintext
错误: 此 dag 节点是一个目录
```

尝试对上述 CID 运行 `ipfs cat` 会返回错误！CID 指向*目录*，而不是*文件*。要查看目录内容，我们将运行`ipfs refs <CID>`。

```shell
ipfs refs bafybeif2ewg3nqa33mjokpxii36jj2ywfqjpy3urdh7v6vqyfjoocvgy3a
```

这将输出类似以下内容：

```plaintext
bafkreig24ijzqxj3cxdp6yh6ia2ysxzvxsfnd6rzahxxjv6ofcuix52wtq
```

“ref”命令返回指向目录*内*文件的 CID。现在我们可以使用这个新的 CID 与“ipfs cat”一起查看它：

```plaintext
ipfs cat bafkreig24ijzqxj3cxdp6yh6ia2ysxzvxsfnd6rzahxxjv6ofcuix52wtq
```

这将输出类似以下内容：

```plaintext
MMMMMMMMMMN0xo;';ox0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMWXOdoloxkkkxolodOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMN0xdoodkOOOOOOOOOkdoodx0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MKo;;oxOOOOOOOOOOOOOOOOOxo;;oKMMMMMXOKMMMN0kkkkkO0NWMMXOkkkkkkOXMMWKkddddk0NMMMM
Wd...':okOOOOOOOOOOOOOko:'...dWMMMWd.lWMM0,.;ccc:;,oXWd.'clllco0WO:,:loolcckWMMM
Wdckdc,..;lxOOOOOOOxl;..';lo;dWMMMWo.lWMM0''0MMMWK:.oNo.lWMMMMMMX:.dWMMMMMWWMMMM
WdcOKK0ko;'.,:c:c:,..,:oxxxd;dWMMMWo.lWMM0''0MMMMNc.oNo.lNWWWWWMNl.;x0XNWMMMMMMM
WdcOKKKKKKOd:.  .,cdxxxxxxd;dWMMMWo.lWMM0'.cooodkKWMWo.:0K000KWMMMMWNK0xc.,0MMM
WdcOKKKKKKKK0l..:dxxxxxxxxd;dWMMMWo.lWMM0''0MMMMMMMMWo.lWMMMMMMWOdk0KXXKd.,0MMM
WdcOKKKKKKKKK0:,dxxxxxxxxxd:dWMMMWo.lWMM0''0MMMMMMMMWo.lWMMMMMMWOlcccccccdKWMMM
Wd;xKKKKKKKKK0:,dxxxxxxxdc.'kMMMMMO:xWMMKllXMMMMMMMMWk:kWMMMMMMWOlcccccccdKWMMM
MWKkdooxOKKKK0:,dxxxxdlclokKWMMMMMWWWMMMMWWMMMMMMMMMMMWMMMMMMMMMMMWWNNNNWMMMMMM
MMMMWNOxdodk00:,ddoccldONWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMWKkdol'.:lokKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMWKd'.'dKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
```

重要的是要注意，`ipfs cat` 仅适用于纯文本文件。如上所示，尝试对目录进行 `cat` 操作将返回错误。如果您尝试对图像文件或非纯文本的文本文件进行 `cat` 操作，您的终端将充满不可读的行。

## 固定文件

我们可以*固定*我们想要保存到 IPFS 节点的数据，以确保我们不会丢失此数据。

1. 使用 `ipfs pin add` 命令：

    ```shell
    ipfs pin add bafybeif2ewg3nqa33mjokpxii36jj2ywfqjpy3urdh7v6vqyfjoocvgy3a
    ```

    这将输出类似以下内容：

    ```plaintext
    递归固定 bafybeif2ewg3nqa33mjokpxii36jj2ywfqjpy3urdh7v6vqyfjoocvgy3a
    ```

默认情况下，您通过 IPFS 检索的对象未固定到您的节点。如果您希望防止文件被垃圾回收，则需要固定它们。您会注意到您刚刚添加的固定是一个“递归”固定，这意味着它是一个包含其他对象的目录。查看[固定页面以了解更多有关其工作原理](https://docs.ipfs.tech/concepts/persistence/)。

## 删除文件

如果我们决定不再托管文件，我们所要做的就是删除固定。

1. 首先，我们需要获取要取消固定的文件或文件夹的 CID。要查看您已固定的内容列表，请运行“ipfs pin ls”：

    ```shell
    ipfs pin ls
    ```

    这将输出类似以下内容：

    ```plaintext
    QmPZ9gcCEpqKTo6aq61g2nXGUhM4iCL3ewB6LDXZCtioEB 间接
    QmQGiYLVAdSHJQKYFRTJZMG4BXBHqKperaZtyKGmCRLmsF 间接
    QmU5k7ter3RdjZXu3sHghsga1UQtrztnQxmTL22nPnsu3g 间接
    QmUNLLsPACCz1vLxQVkXqqLX5R1X345qqfHbsf67hvA3Nn 递归
    QmYCvbfNbCwFR45HiNP45rwJgvatpiW38D961L5qAhUM5Y 间接
    QmejvEPop4D7YUadeGqYWmZxHhLc4JBUCzJJHWMzdcMe2y 间接
    QmQ5vhrL7uv6tuoN9KeVBwd4PwfQkXdVVmDLUZuTNxqgvm 间接
    QmQPeNsJPyVWPFDVHb77w8G42Fvo15z4bG2X8D2GhfbSXc 递归
    QmQy6xmJhrcC5QLboAcGFcAE1tC8CrwDVkrHdEYJkLscrQ 间接
    ```

2. 如果您确切知道要删除的 CID，那就太好了！但是，如果您不确定哪个是 CID，可以在要删除的文件或文件夹上再次使用“ipfs add”命令来查找。我们将取消固定之前使用的 `hello-ipfs.txt` 文件。

    ```shell
    cd ~/Documents
    ipfs add hello-ipfs.txt
    ```

    这将输出类似以下内容：

    ```plaintext
    添加 QmRgR7Bpa9xDMUNGiKaARvFL9MmnoFyd86rF817EZyfdGE hello-ipfs.txt
    6 B / 6 B [==========================================================] 100.00
    ```

    尽管 IPFS 给我们的输出与之前相同，但我们实际上并未重新添加文件。不过，我们可以从此输出中获取 CID。

3. 现在，我们可以使用 `ipfs pin rm` 命令取消固定文件：

    ```shell
    ipfs pin rm QmRgR7Bpa9xDMUNGiKaARvFL9MmnoFyd86rF817EZyfdGE
    ```

    这将输出类似以下内容：

    ```plaintext
    取消固定 QmRgR7Bpa9xDMUNGiKaARvFL9MmnoFyd86rF817EZyfdGE
    ```

4. `hello-ipfs.txt` 文件现在已取消固定，但尚未从我们的节点完全删除。要完全删除它，我们需要运行垃圾回收。该命令将从您的节点中删除所有未固定的内容：

    ```shell
    ipfs repo gc
    ```

    这将输出类似以下内容：

    ```plaintext
    删除 bafybeif2ewg3nqa33mjokpxii36jj2ywfqjpy3urdh7v6vqyfjoocvgy3a
    删除 bafkreieceevgg2auxo4u3rjgeiqfr4ccxh6ylkgxt2ss6k2leuad5xckxe
    删除 bafkreiblcvcr7letdbp2k2thkbjyunznrwq3y6pyoylzaq4epawqcca2my
    [...]
    ```

目标文件现在已从您的 IPFS 节点完全删除，以及我们未固定的任何其他文件。如果刚刚被垃圾回收的内容已保存到您计算机的本地存储中，它仍然在那里。如果您希望从计算机的本地存储中删除该内容，则需要找到其保存位置并使用常规删除方法将其删除。