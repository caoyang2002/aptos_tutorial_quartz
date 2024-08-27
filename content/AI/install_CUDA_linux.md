---
title: Ubuntu 安装 Nvidia 驱动
aliases:
  - Ubuntu 安装 Nvidia 驱动
---
> 3080 在 Ubuntu 上有一定的几率不能运行，
> case:
> - 24.4 突然黑屏，无法点亮，检查得知是 GPU 自动关闭
> - 22.4 突然黑屏，无法点亮，检查得知是 GPU 自动关闭
> - 20.4 无法开机

怀疑是驱动问题

先看看信息

```bash
nvidia-smi
```

根据[安装手册](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#introduction)安装

# CUDA
```bash
nvcc -V # 没有输出执行下方的命令
sudo apt install nvidia-cuda-toolkit
```

# Ubuntu 可能遇到的驱动问题

```bash
sudo lspci -xx -d 10de:*
```

> 以超级用户权限执行，列出所有NVIDIA公司生产的PCI设备的详细信息，包括那些未被加载驱动的设备，并且显示额外的详细信息。这对于诊断和识别系统中的NVIDIA硬件非常有用。

## GPU 正常状态
> 输出
```
01:00.0 VGA compatible controller: NVIDIA Corporation GA102 [GeForce RTX 3080 Lite Hash Rate] (rev a1)
00: de 10 16 22 07 04 10 00 a1 00 00 03 00 00 80 00
10: 00 00 00 82 0c 00 00 00 40 00 00 00 0c 00 00 10
20: 40 00 00 00 01 60 00 00 00 00 00 00 77 73 0b 12
30: 00 00 00 00 60 00 00 00 00 00 00 00 ff 01 00 00

01:00.1 Audio device: NVIDIA Corporation GA102 High Definition Audio Controller (rev a1)
00: de 10 ef 1a 06 00 10 00 a1 00 03 04 10 00 80 00
10: 00 00 08 83 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 77 73 0b 12
30: 00 00 00 00 60 00 00 00 00 00 00 00 ff 02 00 00
```

## GPU 异常关闭
> 异常关闭
```
01:00.0 VGA compatible controller: NVIDIA Corporation GA102 [GeForce RTX 3080 Lite Hash Rate] (rev ff)
00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

01:00.1 Audio device: NVIDIA Corporation GA102 High Definition Audio Controller (rev ff)
00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
```

## 检查 GPU 是否在运行

### 方法一
```bash
nvidia-smi
```

```bash
Unable to determine the device handle for GPU0000:01:00.0: Unknown Error # 未运行
```

### 方法二
```bash
lspci | grep -i nvidia
```

```bash
01:00.0 VGA compatible controller: NVIDIA Corporation GA102 [GeForce RTX 3080 Lite Hash Rate] (rev ff)
01:00.1 Audio device: NVIDIA Corporation GA102 High Definition Audio Controller (rev ff)
# 未运行
```


### 方法三
```bash
lspci | grep -i vga
```

```bash
01:00.0 VGA compatible controller: NVIDIA Corporation GA102 [GeForce RTX 3080 Lite Hash Rate] (rev ff)
# 未运行
```

## 检查电源

```bash
nvidia-smi -q -d POWER
```


# 安装

## linux 版本需求关系

| Distribution                | Kernel1                  | Default GCC | GLIBC |
| --------------------------- | ------------------------ | ----------- | ----- |
| **x86_64**                  |                          |             |       |
| RHEL 9.y (y <= 4)           | 5.14.0-427               | 11.4.1      | 2.34  |
| RHEL 8.y (y <= 10)          | 4.18.0-553               | 8.5.0       | 2.28  |
| OpenSUSE Leap 15.y (y <= 5) | 5.14.21-150500           | 7.5.0       | 2.31  |
| Rocky Linux 8.y (y<=10)     | 4.18.0-553               | 8.5.0       | 2.28  |
| Rocky Linux 9.y (y<=4)      | 5.14.0-427               | 11.4.1      | 2.34  |
| SUSE SLES 15.y (y <= 5)     | 5.14.21-150500           | 7.5.0       | 2.31  |
| Ubuntu 24.04 LTS            | 6.8.0-31                 | 13.2.0      | 2.39  |
| Ubuntu 22.04.z (z <= 4) LTS | 6.5.0-27                 | 12.3.0      | 2.35  |
| Ubuntu 20.04.z (z <= 6) LTS | 5.15.0-67                | 9.4.0       | 2.31  |
| Debian 12.x (x<=5)          | 6.1.76-1                 | 12.2.0      | 2.36  |
| Debian 11.y (y<=9)          | 5.10.209-2               | 10.2.1      | 2.31  |
| Debian 10.z (z<=13)         | 4.19.0-21                | 8.3.0       | 2.28  |
| Fedora 39                   | 6.5.6-300                | 13.2.1      | 2.38  |
| KylinOS V10 SP2             | 4.19.90-25.14.v2101.ky10 | 7.3.0       | 2.28  |
| Amazon Linux 2023           | 6.1.82-99.168            | 11.4.1      | 2.34  |


##  CUDA Toolkit 12.5 Update 1 Downloads

安装手册：

https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#handle-uninstallation


获取安装命令：

https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_network


## 这是 Ubuntu22.4 x86_64 版本的
```
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-5
```

## 安装 550 驱动

```bash
sudo apt-get install -y nvidia-driver-555-open
sudo apt-get install -y cuda-drivers-555
```


## 记得重启

```bash
sudo reboot
```



检查驱动版本：

```bash
Fri Jul 12 09:38:34 2024       
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 555.42.06              Driver Version: 555.42.06      CUDA Version: 12.5     |
|-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
|                                         |                        |               MIG M. |
|=========================================+========================+======================|
|   0  NVIDIA GeForce RTX 3080        Off |   00000000:01:00.0  On |                  N/A |
| 33%   38C    P8             51W /  320W |     216MiB /  10240MiB |      4%      Default |
|                                         |                        |                  N/A |
+-----------------------------------------+------------------------+----------------------+
                                                                                         
+-----------------------------------------------------------------------------------------+
| Processes:                                                                              |
|  GPU   GI   CI        PID   Type   Process name                              GPU Memory |
|        ID   ID                                                               Usage      |
|=========================================================================================|
|    0   N/A  N/A      2155      G   /usr/lib/xorg/Xorg                             94MiB |
|    0   N/A  N/A      2288      G   /usr/bin/gnome-shell                          105MiB |
+-----------------------------------------------------------------------------------------+
```




在Linux系统中，查看GPU电源策略通常涉及到NVIDIA驱动程序（如果你使用的是NVIDIA GPU）。以下是一些可用于检查GPU电源策略的方法：

1. **使用`nvidia-smi`命令**：
   如果你安装了NVIDIA的专有驱动程序，`nvidia-smi`命令是检查电源策略的主要工具。它可以显示当前的电源状态以及电源管理设置：
   ```bash
   nvidia-smi -q -d POWER
   ```
   这个命令将显示包括电源状态在内的各种GPU状态信息。

2. **检查电源管理设置**：
   使用`nvidia-smi`命令可以查看或设置电源管理的模式：
   ```bash
   nvidia-smi -pm 1   # 启用电源管理
   nvidia-smi -pm 0   # 禁用电源管理
   ```

3. **查看电源使用策略**：
   NVIDIA驱动程序允许你设置电源使用策略，比如`powersave`（省电模式）或`performance`（性能模式）：
   ```bash
   nvidia-smi --auto-boost-default=0   # 设置为默认的电源使用策略
   ```

4. **检查环境变量**：
   对于NVIDIA驱动程序，某些电源策略可能通过环境变量设置。检查`NVIDIA_DEBUG_ENV`环境变量可能有助于了解当前的电源策略：
   ```bash
   echo $NVIDIA_DEBUG_ENV
   ```

5. **查看X服务器日志**：
   GPU的电源状态有时也会记录在X服务器日志中，这个日志通常位于`/var/log/Xorg.0.log`。你可以使用以下命令来查看：
   ```bash
   cat /var/log/Xorg.0.log | grep -i "power"
   ```

6. **使用`/sys`文件系统**：
   在某些Linux发行版中，`/sys`文件系统中可能包含有关电源管理状态的信息。你可以检查`/sys/class/drm`目录下的相关文件。

7. **使用`prime-select`命令**：
   如果你的系统支持NVIDIA的`nvidia-prime`工具，你可以使用它来查看或设置默认的GPU电源策略：
   ```bash
   prime-select query   # 查看当前默认的GPU
   prime-select intel   # 切换到集成显卡
   prime-select nvidia  # 切换到NVIDIA GPU
   ```

8. **检查电源管理工具**：
   如果你的Linux发行版提供了电源管理工具或配置界面，比如`powertop`或GNOME/KDE的电源设置，检查这些工具可能会提供GPU电源策略的相关信息。

请注意，不是所有Linux系统都会提供相同的工具或命令来管理GPU电源策略，具体可用的选项取决于你的系统配置和安装的驱动程序。如果你使用的是开源驱动程序而不是NVIDIA专有驱动程序，可用的工具可能会有所不同。


# 版本不一致

看一下指向

```bash
cd /usr/local
stat cuda 
  File: cuda -> /etc/alternatives/cuda  # 不是指向 /usr/loacl 删除

```



# 重启

```bash
sudo systemctl restart display-manager
```