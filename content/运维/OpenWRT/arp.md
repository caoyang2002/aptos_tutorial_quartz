---
title: 查看连接的主机地址
aliases:
  - 查看连接的主机地址
---
在 OpenWrt 系统上，你可以通过命令行使用多种命令来查看连接的主机地址。以下是一些常用的命令：

1. **`ifconfig` 或 `ip addr`**：
   这些命令用于显示网络接口的配置信息，包括分配给接口的IP地址。

   ```sh
   ifconfig
   ```
   或者
   ```sh
   ip addr
   ```

2. **`arp`**：
   `arp` 命令显示当前的 ARP 缓存表，其中包含了与 IP 地址关联的 MAC 地址。

   ```sh
   arp -n
   ```

3. **`route`**：
   `route` 命令显示路由表，可以帮助你了解数据包是如何在你的网络中路由的。

   ```sh
   route -n
   ```

4. **`netstat`**：
   `netstat` 命令提供了关于网络连接、路由表、接口统计等的信息。

   ```sh
   netstat -nr
   ```

5. **`ss`**：
   `ss` 是 `netstat` 的现代替代品，用于显示套接字统计信息。

   ```sh
   ss -tuln
   ```

6. **`iwinfo`**：
   如果你的 OpenWrt 系统安装了 `iwinfo` 包，它可以用来显示无线网络接口的信息。

   ```sh
   iwinfo wlan0 assoclist
   ```

   这将显示连接到无线网络接口 `wlan0` 的设备列表。

7. **`/etc/config/network` 配置文件**：
   查看 `/etc/config/network` 文件也可以提供有关网络接口配置的信息。

   ```sh
   cat /etc/config/network
   ```

请注意，你可能需要具有相应的权限才能执行上述某些命令，因此在使用时可能需要使用 `sudo`。

此外，OpenWrt 系统可能使用不同的命令或工具来管理网络，具体取决于其版本和配置。如果你不确定如何使用这些命令，或者它们在你的 OpenWrt 系统上不可用，你可以查阅 OpenWrt 的官方文档或社区论坛以获取帮助。
