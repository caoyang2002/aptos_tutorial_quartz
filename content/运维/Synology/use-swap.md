---
title: 群晖DS220J 利用SSD做虚拟内存优化
aliases:
  - 群晖DS220J 利用SSD做虚拟内存优化
---
https://www.bilibili.com/read/cv15528962/

# 群晖DS220J 利用SSD做虚拟内存优化

2022年03月05日 16:303524浏览 · 15点赞 · 44评论


群晖的 `ARM` 架构低端 NAS 性能一直非常差，再搭配机械硬盘使用时卡顿非常严重，这点在使用 `download station` 下载PT时最为明显。在帝都联通 500M 宽带下，使用 x86 的 DS718+ ，PT下载速度为 50MB/s，使用 DS220J，下载速度仅为 10MB/s，性能差距非常明显。为了提高 DS220J 的 download station 性能，我做了很多尝试和努力，虽然最终效果提升有限，但是从中还是学会了一些东西，记录下来和大家分享。

需要大家自备一块SSD，我使用的是老电脑上淘汰下来的 SATA 256G SSD

# `ssh` 登录群晖DSM
```bash
ssh username@192.168.1.100 -p 22
```

其中 `ssh` 是命令的名称，`username` 是在 NAS 中的 admin 用户名，`192.168.1.100` 是 NAS 的 IP，22是 ssh 的端口号。

输入回车后提示输入密码，这个密码就是登录 NAS 所需的密码，输入后再次回车登录进入了 NAS。

为了获取到最大权限便于操作，建议输入`sudo -i`回车，输入`账号 密码`后进入 `root` 权限。

至此，不用使用第三方软件，也可以很方便的登录 NAS 的 shell 了。

建议大家对 Linux 的 `top`, `iostat`, `swap` 工具有初步了解，便于分析。前两者也可以使用群晖的性能监控代替。

# 分析卡顿原因

查看 swap 大小

`free -h`

> ```bash
> root@DS220j:/volume1/SWAP# free -h
>               total        used        free      shared  buff/cache   available
> Mem:          484Mi       246Mi        73Mi       1.0Mi       164Mi       136Mi
> Swap:         2.0Gi       556Mi       1.5Gi
> 
> ```

启用 `download station`下载，然后使用 `top`查看，注意 `kswapd0` 进程占用了大量的CPU

![](https://i0.hdslb.com/bfs/article/aa5cabf6539ddab10cad95d3e35120a9ff7b49ba.png@1256w_276h_!web-article-pic.avif)

`top`

> ```bash
> root@DS220j:/# top
> 
> top - 00:47:56 up 2 days,  9:15,  2 users,  load average: 6.23, 9.38, 9.89 [IO:
> Tasks: 328 total,   2 running, 326 sleeping,   0 stopped,   0 zombie
> %Cpu(s):  0.8 us,  2.5 sy,  0.2 ni,  7.0 id, 89.1 wa,  0.0 hi,  0.5 si,  0.0 st
> GiB Mem :    0.473 total,    0.089 free,    0.241 used,    0.143 buff/cache
> GiB Swap:    2.000 total,    1.464 free,    0.536 used.    0.133 avail Mem 
> 
>   PID USER      PR  NI    VIRT    RES  %CPU  %MEM     TIME+ S COMMAND          
> 19451 root      10 -10   89.5m  21.5m 4.000 4.432   0:00.11 D synoscgi_SYNO.Co+
>   305 root       0 -20    0.0m   0.0m 3.500 0.000  13:56.42 R [kswapd0:0]      
> 19017 root      20   0   33.3m   2.1m 1.500 0.428   0:01.34 R top              
> 29032 root      20   0 1681.6m  24.1m 1.000 4.966   0:27.52 S /var/packages/Co+
> 29057 root      20   0 1456.5m  13.2m 1.000 2.733   0:09.59 S containerd --con+
>   724 Downloa+  20   0   51.1m   0.7m 0.500 0.138   0:30.89 S /var/packages/Do+
>  1938 root       0 -20    0.0m   0.0m 0.500 0.000   0:08.28 S [kworker/3:1H]   
>  6255 root      20   0   58.5m   1.0m 0.500 0.205   5:24.01 S /usr/bin/redis-s+
>  8445 root      20   0   53.8m   1.5m 0.500 0.304   7:25.97 S /var/packages/Sy+
>  8479 root      30  10  621.0m   4.0m 0.500 0.818  11:45.74 S /var/packages/Sy+
>  8557 root      20   0  209.8m   3.7m 0.500 0.766   4:15.83 S /var/packages/Sy+
> 13092 root      20   0   66.3m   2.9m 0.500 0.599   0:10.12 S /var/packages/Sc+
> 13536 root      20   0  710.6m   4.1m 0.500 0.841  10:30.38 S /usr/syno/bin/sc+
> 13797 root      20   0    0.0m   0.0m 0.500 0.000   0:00.48 S [kworker/3:1]    
> 14652 postgres  20   0   97.3m   0.8m 0.500 0.159   0:02.89 S postgres: backgr+
> 18942 root      20   0   90.6m  16.4m 0.500 3.392   0:00.04 D synoscgi_SYNO.Sy+
> 19479 root      20   0  703.0m   4.1m 0.500 0.845   0:00.04 S /volume1/@appsto+
> ```
>
> > 解析
>
> `top` 命令在 Linux 系统中提供了一个实时的动态视图，展示系统中的进程和资源使用情况。输出的信息包括了 CPU、内存、交换空间的使用情况，以及当前运行的进程列表。下面是对您提供的 `top` 命令输出的解释：
>
> 1. **系统运行时间**：`00:47:56` 表示系统已经运行了 47 分钟 56 秒。
> 2. **用户数量**：`2 users` 表示有两个用户登录系统。
> 3. **负载平均值**：`6.23, 9.38, 9.89` 分别表示过去 1 分钟、5 分钟和 15 分钟的平均负载。这些数值表示单位时间内运行的进程数，高负载可能表明系统资源紧张。（ 6.23：这个数值表示在最近 1 分钟内，平均每秒钟有 6.23 个进程在 CPU 上执行或者等待执行。这个数字包括正在运行的进程、等待运行的进程以及在等待 I/O 操作完成的进程。）
> 4. **CPU 使用情况**：
>     - `us`：用户空间占用 CPU 的百分比。
>     - `sy`：系统空间占用 CPU 的百分比。
>     - `ni`：优先级较高的用户进程占用 CPU 的百分比。
>     - `id`：CPU 空闲的百分比。
>     - `wa`：CPU 等待 I/O 操作的百分比。
>     - `hi`：硬件中断请求占用 CPU 的百分比。
>     - `si`：软件中断请求占用 CPU 的百分比。
>     - `st`：虚拟机占用的 CPU 时间。
> 5. **内存使用情况**：
>     - `GiB Mem`：总内存、已用内存、空闲内存和缓存/缓冲区内存的使用情况。
>     - `GiB Swap`：交换空间的使用情况。
>
> 6. **进程列表**：列出了当前系统中的进程信息，包括：
>     - `PID`：进程 ID。
>     - `USER`：运行进程的用户。
>     - `PR`：进程的优先级。
>     - `NI`：进程的 nice 值，影响进程的优先级。
>     - `VIRT`：进程使用的虚拟内存总量。
>     - `RES`：进程使用的物理内存总量。
>     - `%CPU`：进程占用 CPU 的百分比。
>     - `%MEM`：进程占用内存的百分比。
>     - `TIME+`：进程占用 CPU 的总时间。
>     - `S`：进程的状态（R 运行，S 睡眠，D 等待 I/O，Z 僵尸进程等）。
>     - `COMMAND`：启动进程的命令。
>
> 7. **特定进程信息**：例如，`19451 root` 表示进程 ID 为 19451 的进程由 root 用户运行，占用了较多的 CPU 和内存资源。
>
> > 注意事项：
>
> - 系统负载平均值较高可能表明系统资源紧张，需要进一步调查原因。
> - CPU 等待 I/O（`wa`）的百分比较高可能表明磁盘 I/O 较慢，影响了系统性能。
> - 内存和交换空间的使用情况可以提供系统内存压力的线索。
> - 进程列表可以帮助识别占用资源最多的进程。
>
> `top` 命令是一个实时更新的工具，提供了对系统性能和资源使用情况的即时了解。如果需要更详细的信息或历史数据，可能需要使用其他工具或命令。


查看 cpu 核心数 `lscpu` 或 `nproc` 或 `cat /proc/cpuinfo `

DS220J 使用的是四核 CPU，满载应该在 4.0 左右，看 CPU 小于 4，45.3 的 `id` 也有余力（idle）。主要消耗在 `wa` 也就是硬盘读写等待(iowait)。因此推测硬盘可能是瓶颈。

使用 `iostat -x 1` 查看硬盘读写状况

![](https://i0.hdslb.com/bfs/article/9cfcdea13faa60fa82b6fa9b55968a2358643cf1.png@1256w_154h_!web-article-pic.avif)

`iostat -x 1`

> ```bash
> Linux 4.4.302+ (DS220j) 	07/31/24 	_aarch64_	(4 CPU)
> 
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            1.63    0.07    1.08    2.99    0.00   94.23
> 
> Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz  aqu-sz  %util
> sdb             28.40    852.40     8.78  23.62   59.51    30.01    5.03     79.80    11.54  69.65  295.39    15.86    0.00      0.00     0.00   0.00    0.00     0.00    3.21   5.50
> md0             14.86    361.74     0.00   0.00   53.71    24.35    0.91      8.80     0.00   0.00   57.11     9.70    0.00      0.00     0.00   0.00    0.00     0.00    0.85   3.99
> md1             17.51     70.06     0.00   0.00   24.66     4.00   14.65     58.60     0.00   0.00  548.81     4.00    0.00      0.00     0.00   0.00    0.00     0.00    8.50   3.74
> md2              7.73    420.58     0.00   0.00  201.15    54.42    0.81     11.53     0.00   0.00  106.14    14.30    0.00      0.00     0.00   0.00    0.00     0.00    1.65   3.16
> dm-0             0.00      0.00     0.00   0.00    8.89    19.56    0.00      0.00     0.00   0.00    7.27     1.45    0.00      0.00     0.00   0.00    0.00     0.00    0.00   0.00
> dm-1             7.57    420.57     0.00   0.00  200.45    55.55    0.75     11.53     0.00   0.00  112.53    15.46    0.00      0.00     0.00   0.00    0.00     0.00    1.61   3.16
> 
> ```
>
> `iostat` 命令是` I/O statistics` 的缩写，它用于监视系统输入/输出设备负载。这个命令提供了关于 CPU 和输入/输出（I/O）的使用情况的统计信息。下面是对您提供的 `iostat -x 1` 命令输出的详细解释：
>
> 1. **系统信息**：
>    
>    ```
>    Linux 4.4.302+ (DS220j)     07/31/24    _aarch64_    (4 CPU)
>    ```
>    - 这行显示了操作系统版本（Linux 内核 4.4.302+），主机名（DS220j），日期（07/31/24），架构（_aarch64_，表示是 64 位架构），以及 CPU 核心数（4 CPU）。
>    
> 2. **CPU 使用情况**：
>    
>    ```
>    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>              1.63    0.07    1.08    2.99    0.00   94.23
>    ```
>    - 这些列分别表示 CPU 在不同模式下的使用百分比：
>      - `%user`：用户空间占用 CPU 的百分比（1.63%）。
>      - `%nice`：调整过优先级的用户进程占用 CPU 的百分比（0.07%）。
>      - `%system`：系统空间占用 CPU 的百分比（1.08%）。
>      - `%iowait`：CPU 等待 I/O 操作完成的百分比（2.99%）。
>      - `%steal`：虚拟化环境下，被偷取的时间百分比（0.00%）。
>      - `%idle`：CPU 空闲的百分比（94.23%）。
>    
> 3. **设备 I/O 使用情况**：
>    - 接下来的表格显示了每个 I/O 设备的使用情况，包括磁盘和内存设备。
>    - 列的含义如下：
>      - `Device`：设备名称。
>      - `r/s`：每秒读取操作数。
>      - `rkB/s`：每秒读取的千字节数。
>      - `rrqm/s`：每秒合并的读取请求数。
>      - `%rrqm`：读取请求合并的百分比。
>      - `r_await`：读取操作的平均等待时间（毫秒）。
>      - `w/s`：每秒写入操作数。
>      - `wkB/s`：每秒写入的千字节数。
>      - `wrqm/s`：每秒合并的写入请求数。
>      - `%wrqm`：写入请求合并的百分比。
>      - `w_await`：写操作的平均等待时间（毫秒）。
>      - `wareq-sz`：写请求的平均大小（千字节）。
>      - `d/s`：每秒删除的 I/O 请求数。
>      - `dkB/s`：每秒删除的千字节数。
>      - `drqm/s`：每秒合并的删除请求数。
>      - `%drqm`：删除请求合并的百分比。
>      - `d_await`：删除操作的平均等待时间（毫秒）。
>      - `dareq-sz`：删除请求的平均大小（千字节）。
>      - `aqu-sz`：请求的平均队列长度。
>      - `%util`：设备使用率的百分比。
>
> 4. **具体设备**：
>    - `sdb`、`md0`、`md1`、`md2`、`dm-0`、`dm-1`：这些是系统中的存储设备，包括物理磁盘和可能的 RAID 逻辑卷或 LVM 逻辑卷。
>    - 每个设备的列显示了该设备的 I/O 活动，例如读取和写入操作的数量、请求的大小、等待时间等。
>
> > 注意事项：
>
> - `iostat -x 1` 命令每 1 秒刷新一次数据，提供了详细的 I/O 和 CPU 使用情况。
> - 高 `%iowait` 可能表明 I/O 操作是系统性能的瓶颈。
> - `%util` 列显示了设备的使用率，如果这个值很高，可能表明设备在满负荷运行。
> - 合并的请求（`rrqm/s`、`wrqm/s`、`drqm/s`）表示多个 I/O 请求被合并为一个操作，这可以提高性能。
>
> 通过分析 `iostat` 命令的输出，您可以了解系统的 I/O 性能和 CPU 使用情况，从而帮助您识别性能瓶颈和优化系统配置。



sdb 是一块东芝 6TB 硬盘，其中写入速度 11MB/s 导致基本和 PT 下载速度持平，但是好几兆的读取是怎么回事？我在下载 PT 种子时特意选取了上传人数多，下载人数少的，看网速监控上传速度也只有几百 KB/s,  留意 `top` 是出现了 `kswap`，可能是由于物理内存不足，频繁和虚拟内存交换，导致硬盘读写负荷增加。可以看到 sdb 的占用率已经接近`100%`，不堪重负了。

# 解决方案

既然机械硬盘的负荷不堪重负，导致 download station 下载速度下降，那么使用 SSD 应该可以减少硬盘的瓶颈。

手头上有一块 256GB 的 SSD ，直接安装到群晖上使用，这里可以直接选择将 download station 的暂存位置修改到SSD上，来降低磁盘瓶颈。

![](https://i0.hdslb.com/bfs/article/aa1e7060b75debdce9508a0a3809e142c2a3817d.png@1256w_714h_!web-article-pic.avif)

## 选择暂存位置

这里面存储空间 1 是 SSD，选择确定后下载时就可以将数据临时保存在 SSD 上。由于 SSD 的容量一般有限，PT 有保种需求，因此文件长期还是会保存在机械硬盘上。

切换到 SSD 后，下载速度会显著提高，大概能到 25MB/s 左右。但是这样仍然会存在问题：

首先，下载完毕后 download station 会自动将数据从 SSD 拷贝到 HDD，拷贝的速率比较慢，这样总的下载时间仍然会比较慢。

其次，如果暂存目录和文件保存目录不在同一个存储空间，会造成两倍的下载容量使用。SSD 空间容量不足需要经常删除 download station 中的任务来节省空间，不利于 PT 长期保种。

为此还需要其他解决方法。

既然虚拟内存 swap 会抢占机械硬盘资源，可以考虑将 SWAP 完全放在 SSD 上来降低机械硬盘的压力。

linux 上的 swap 可以通过文件的方式实现。在 SSD 上创建一个共享文件夹 SWAP，然后在 ssh 上通过命令创建 swap

看下 SSD 所在的物理路径  

![](https://i0.hdslb.com/bfs/article/3fee638f87edc29db6a14a0368f5eadd33883af2.png@!web-article-pic.avif)

`df -h`

> ```bash
> caoyang@DS220j:~$ df -h
> Filesystem         Size  Used Avail Use% Mounted on
> /dev/md0           7.9G  1.3G  6.5G  16% /
> devtmpfs           225M     0  225M   0% /dev
> tmpfs              243M   76K  243M   1% /dev/shm
> tmpfs              243M   21M  223M   9% /run
> tmpfs              243M     0  243M   0% /sys/fs/cgroup
> tmpfs              243M  1.5M  241M   1% /tmp
> /dev/vg1/volume_1  3.6T  212G  3.4T   6% /volume1
> ```



看到存储空间 1 挂载到 `/volume1`

进入到 SWAP 目录（需要预先创建 SWAP 共享文件夹）

```bash
sudo mkdir -p /volume1/SWAP && cd /volume1/SWAP
```

> `-sh: cd: SWAP/: Permission denied`
>
> 解决：
>
> ```bash
> sudo -i &&  cd /volume1/SWAP
> ```
>
> 

![](https://i0.hdslb.com/bfs/article/bd31a8bd46224dd1f15c55cf11de01ea6c83575c.png@!web-article-pic.avif)

创建 `swapfile`

```bash
touch swapfile
```

创建一个大小为 2 GB 的交换文件

```bash
dd if=/dev/zero of=/volume1/SWAP/swapfile bs=1024 count=2097152
```

> `dd` 是 Linux 中一个非常强大的命令行工具，用于转换和复制文件。在你提供的命令中，`dd` 被用来创建一个大小为 2 GB 的交换文件（swap file）：
>
> ```sh
> dd if=/dev/zero of=/volume1/SWAP/swapfile bs=1024 count=2097152
> ```
>
> 下面是命令各部分的详细解释：
>
> - `if=/dev/zero`：`if` 指定输入文件，`/dev/zero` 是一个特殊的文件，它提供无限的字节流，每个字节都是 0。这意味着 `dd` 将从 `/dev/zero` 读取数据。
>
> - `of=/volume1/SWAP/swapfile`：`of` 指定输出文件，这里指定了 `/volume1/SWAP/swapfile` 作为输出路径和文件名。这将创建一个名为 `swapfile` 的文件，位于 `/volume1/SWAP` 目录下。
>
> - `bs=1024`：`bs` 代表 "block size"，即块大小。这里设置为 1024 字节，意味着 `dd` 一次读取或写入 1024 字节。
>
> - `count=2097152`：`count` 指定要复制的块数量。由于块大小是 1024 字节，`2097152` 块将总共产生 2 GB 的数据（因为 1024 * 2097152 = 2147483648，即 2 GB）。
>
> 命令执行的输出信息：
>
> - `2097152+0 records in`：表示输入端正确读取了 2,097,152 个数据块。
>
> - `2097152+0 records out`：表示输出端也正确写入了 2,097,152 个数据块。
>
> - `2147483648 bytes (2.1 GB, 2.0 GiB) copied`：表示总共复制了 2,147,483,648 字节，即 2.1 GB（千兆字节）或 2.0 GiB（吉字节，其中 iB 表示国际单位制中的字节）。
>
> - `66.663 s`：表示 `dd` 命令执行的总时间，这里是 66.663 秒。
>
> - `32.2 MB/s`：表示数据传输的平均速度，这里是每秒 32.2 兆字节。
>
> 创建交换文件后，你可以通过以下命令来启用它：
>
> ```sh
> sudo swapon /volume1/SWAP/swapfile
> ```
>
> 请注意，每次系统启动时，交换文件都需要手动启用，或者你可以将它添加到 `/etc/fstab` 文件中，以便在启动时自动启用。
>
> > 注意事项：
>
> - 使用 `dd` 创建大文件时，确保目标磁盘有足够的空间。
> - 交换文件对于 Linux 系统来说是重要的资源，用于在物理内存不足时扩展可用内存。但过多地依赖交换空间可能会降低系统性能，因为磁盘 I/O 速度通常比 RAM 慢。
> - 在生产环境中，建议使用专门的分区来作为交换空间，而不是文件。

![](https://i0.hdslb.com/bfs/article/6f444316f7de8c44120d50bf210028b920f89e1f.png@1256w_28h_!web-article-pic.avif)

回车等待一段时间后，数据就创建好了，下述命令格式化为 `swap` 类型

```bash
mkswap /volume1/SWAP/swapfile
```

> 您使用 `mkswap` 命令成功地在文件 `/volume1/SWAP/swapfile` 上设置了交换空间（swap space）。以下是命令输出的详细解释：
>
> 1. **设置交换空间**：
>    `mkswap /volume1/SWAP/swapfile` 命令将指定的文件设置为交换文件。交换文件是磁盘上的一部分，操作系统可以用它来扩展物理内存，即当系统的 RAM 被充分使用时，可以将一些不常用的内存页面移动到交换空间。
>
> 2. **输出信息**：
>    - `Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)`：这表明交换空间的设置已经开始，版本是 1，大小是 2 Gibibytes（GiB），相当于 2147479552 字节。
>
> 3. **交换空间的属性**：
>    - `no label`：表示这个交换空间没有设置标签（label）。标签是交换空间的描述性名称，有助于识别。
>    - `UUID=f57495b3-e49b-421c-a4a8-ff055aef711c`：为交换空间分配了一个唯一的通用唯一识别码（UUID）。这可以在配置文件 `/etc/fstab` 中用来引用交换空间，以便在系统启动时自动启用。
>
> > 启用交换空间：
>
> 设置交换空间后，你需要启用它。可以使用以下命令立即启用交换空间：
>
> ```sh
> swapon /volume1/SWAP/swapfile
> ```
>
> 这将使 `/volume1/SWAP/swapfile` 立即生效，作为系统的交换空间使用。
>
> > 使交换空间在启动时自动启用：
>
> 要使交换空间在每次系统启动时自动启用，你可以将它添加到 `/etc/fstab` 文件中。使用文本编辑器编辑 `/etc/fstab` 文件，例如：
>
> ```sh
> nano /etc/fstab
> ```
>
> 然后添加以下行：
>
> ```sh
> /volume1/SWAP/swapfile none swap sw 0 0
> ```
>
> 保存并关闭文件后，你可以通过以下命令来测试 `/etc/fstab` 文件的配置是否正确：
>
> ```sh
> sudo mount -a
> ```
>
> 如果没有错误消息，那么配置就是正确的。
>
> > 注意事项：
>
> - 确保在添加交换文件到 `/etc/fstab` 之前测试配置，以避免系统无法启动。
> - 交换空间的性能通常不如物理内存，因此它应该被适当地配置，以补充而不是替代 RAM。
> - 对于生产系统，建议监控交换空间的使用情况，并根据需要调整其大小。



## 添加计划任务

![](https://i0.hdslb.com/bfs/article/296aca619f7a5e16626f0627103690ec311d6c6f.png@!web-article-pic.avif)

选择出发的任务，用户自定义脚本

![](https://i0.hdslb.com/bfs/article/eb4edec8d06bf77635ba48a5bc51dede26bb475b.png@!web-article-pic.avif)

一定要选择 `root` 账号，保障权限，事件选择开机。任务名称可以随意填写，我写的 `swap`

任务设置  

![](https://i0.hdslb.com/bfs/article/42673f4955333d875aa29e6fe95873af04e91a3a.png@!web-article-pic.avif)

```bash
swapon -p 1 /volume1/SWAP/swapfile
```



这里增加了一个参数 `-p 1` 来设置 `swap` 优先级

![](https://i0.hdslb.com/bfs/article/53b4d60380cc6a3407ca188933f2d1bc8f8168cf.png@1256w_196h_!web-article-pic.avif)

最终将这个脚本选中，点击应用。重启 NAS

重启 NAS 后再次通过 ssh 登录

输入`free -h`

![image](https://i0.hdslb.com/bfs/article/f205b808d915715df86d0ce2c69a4480a2502ed8.png@1256w_124h_!web-article-pic.avif)

`free -h`

```bash
caoyang@DS220j:~$ free -h
              total        used        free      shared  buff/cache   available
Mem:          484Mi       260Mi        73Mi       1.0Mi       150Mi       122Mi
Swap:         4.0Gi       550Mi       3.5Gi
```



可以看到 swap 虚拟内存容量已经变为 4GB，比之前默认的虚拟内存 2GB 变大了。

输入 `swapon -s`

![](https://i0.hdslb.com/bfs/article/b00ad90556742b0eb4bc95836431d04e323995c7.png@1256w_122h_!web-article-pic.avif)

可以看到所有的虚拟内存都在SSD上使用，解放了机械硬盘的压力。

最终 download station 在下载热门种子时，暂存目录保存在机械硬盘上，速率也提高到了`15MB/s~20MB/s`，比没修改前好一点吧，目的达成，收工。

此外这里也记录一个 download station 中用于设置内存缓存大小的位置

![](https://i0.hdslb.com/bfs/article/9cdd25eb7f37739dcdf8e84b95c33740703c5b07.png@1256w_90h_!web-article-pic.avif)

在 `/var/packages/DownloadStation/etc/` 下，有一个 settings.conf

vi修改文件

![](https://i0.hdslb.com/bfs/article/103c34578aaee8404da155577194a45dfbb415db.png@!web-article-pic.avif)

download_bt_cache_limit，说的是数据缓存多少后写入磁盘，默认为8。我尝试过修改为128，在套件中心内关闭download station在启动，进行测试会发现由于内存太少，缓存设置大后swap更加频繁，导致下载速度更低了。因此对于 ARM 机型这个值默认就好。

在 DS718+ 中，我也尝试设置为128MB/s，虽然没有内存瓶颈，但是会使得一次性写入到硬盘的数据变多，硬盘在写入过程中卡住的时间变长，对下载性能提高有限。

  

以上就是我折腾群晖 ARM 机型虚拟内存的经历，祝大家玩的开心哟~

  

这里再补充一下，群晖在双硬盘时，会将系统盘设置为 RAID1。在 download station 下载时常常会读取系统盘数据。由于 raid1 会默认同时读取2个盘，导致下载 PT 的硬盘 IO 加重，影响速度。我希望读取系统盘时只读取 SSD 的，不读取机械硬盘的以降低机械硬盘的效率。  

在 DS220J 上，`/dev/md0` 是群晖系统的 RAID1，`/dev/sda1` 是 SSD 对应分区，`/dev/sdb1` 是机械硬盘对应分区，下面的操作非常危险，如果不清楚 `mdadm` 是做什么的请一定要慎重 

1. 将机械硬盘的系统分区置为故障 

    ```bash
    mdadm /dev/md0 -f /dev/sdb1  
    ```

    

2. 剔除机械硬盘系统分区 

    ```bash
    mdadm /dev/md0 -r /dev/sdb1  
    ```

3. 以只写入不读取的方式，将机械硬盘加入回系统分区 
    ```bash
     mdadm /dev/md0 -a -W /dev/sdb1 
    ```
   
4. 检查添加是否正确 
    ```bash
    mdadm -D /dev/md0  
    ```
    
    > ```bash
    > Number Major Minor RaidDevice State  
    > 0 8 17 0 active sync writemostly /dev/sdb1  
    > 1 8 1 1 active sync /dev/sda1  
    > ```

这里 `/dev/sdb1` 被设置为了 `wirtemostly`，只写入不读取，SSD 是读写都有。这样系统读取就不会影响到机械硬盘了，改造完成~



