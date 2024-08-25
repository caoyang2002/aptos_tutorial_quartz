---
title: LInux 设置 Swap 分区
---
# Linux设置虚拟内存（Swap 分区设置教程）

# 1、查看 Linux 当前分区情况

```bash
free -h
```


# 2、增加swap分区
关闭所有分区

```bash
swapoff -a
```

创建要作为 Swap 分区文件
```bash
dd if=/dev/zero of=/var/swapfile bs=1M count=4096
```

其中 `/var/swapfile` 是文件位置，`bs*count` 是文件大小，例如`bs=1M count=4096`就会创建一个 4G 的文件）

Swap 合理的大小是与云服务器的物理内存有关的其中：

- 云服务器的内存 <= 4g：Swap 至少 4G

- 云服务器的内存 4~16G：Swap 至少 8G

- 云服务器的内存 16G~64G：Swap 至少 16G

- 云服务器的内存 64G~256G：Swap 至少 32G

建立 Swap 的文件系统（格式化为 Swap 分区文件）
```bash
mkswap /var/swapfile
```

启用 Swap 分区
```bash
swapon /var/swapfile
```

查看 Linux 当前分区
```bash
free -m
```

设置开机启动
```bash
echo '/var/swapfile swap swap defaults 0 0' >> /etc/fstab
```

swap 优化积极使用交换空间占比
```bash
/etc/sysctl.conf
```

添加
```bash
vm.swappiness=60
```


如果内存够大，应当告诉 linux 不必太多的使用 SWAP 分区， 可以通过修改 swappiness 的数值。swappiness=0的时候表示最大限度使用物理内存，然后才是 swap空间，swappiness＝100的时候表示积极的使用swap分区，并且把内存上的数据及时的搬运到swap空间里面。使用太大的交换空间占比，可能会使程序运行缓慢，我自己设置的是60

重启云服务器
```bash
reboot
```

查看内存
```bash
free -m
#看看是否swappiness修改是否生效
cat /proc/sys/vm/swappiness  
```
