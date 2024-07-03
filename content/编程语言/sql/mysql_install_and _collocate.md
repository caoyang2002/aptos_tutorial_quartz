---
title: MySQL 安装与配置
aliases:
  - MySQL 安装与配置
draft: 
description: MySQL 安装与配置
tags:
  - mysql
date: 2024-07-01
cssclasses:
  - "1"
---
# Mac
参考：[macOS下MySQL 8.0 安装与配置教程](https://www.cnblogs.com/kentalk/p/macos-mysql8-install-config-tutorial.html)
```bash 
# 安装 mysql
brew install mysql
# 添加 homebrew/services 仓库到Homebrew
brew tap homebrew/services 
# 使用Homebrew的服务管理功能来启动MySQL服务
brew services start mysql
# 修改root密码
mysqladmin -u root password 'your-password'
# 登陆 mysql
mysql -u root -p # 之后会要求输入 root 的密码，也就是上面设置的

# 退出
exit
```


学习 [[SQL_statement]]

# 备份数据库

```bash
mysql -u root -p database_naem < database_namebackup.sql
```

# 导入数据库
```bash
mysqldump -u root -p database_name > database_name_backup.sql
```



# Armbian 
在 Armbian 上安装 MySQL（MariaDB）与在通用的 Debian 或 Ubuntu 系统上类似，但可能会有一些小的区别。Armbian 是专门为 ARM 架构的单板计算机设计的 Linux 发行版，因此在安装软件时可能需要考虑到硬件平台的特定性。

1. **更新软件包列表和系统**

   在安装之前，首先确保更新系统软件包列表和已安装软件的版本：

   ```bash
   sudo apt update
   sudo apt upgrade
   ```

2. **安装 MySQL 服务**

   在 Armbian 上，您可以选择安装 MySQL 或者 MariaDB。MariaDB 是 MySQL 的一个兼容分支，通常在许多 Linux 发行版中默认提供。

   ```bash
   sudo apt install mariadb-server
   ```

   如果您明确需要安装 MySQL 8.0 版本，可以使用类似以下的命令（前提是有适合您系统的 MySQL 8.0 软件源）：

   ```bash
   sudo apt install mysql-server-8.0
   ```

3. **配置 MySQL 或 MariaDB**

   安装完成后，MySQL 或 MariaDB 通常会自动启动。如果没有自动启动，您可以手动启动服务：

   ```bash
   sudo systemctl start mariadb   # 对于 MariaDB
   sudo systemctl start mysql     # 对于 MySQL
   ```

   同时，您可以运行安全性脚本来加固 MySQL 或 MariaDB 的安装：

   ```bash
   sudo mysql_secure_installation
   ```

   这个脚本会引导您完成设置 root 密码、删除匿名用户、禁用远程 root 登录等安全设置。

4. **验证 MySQL 或 MariaDB 是否运行**

   您可以检查 MySQL 或 MariaDB 的运行状态以确保已成功安装和启动：

   ```bash
   sudo systemctl status mariadb   # 对于 MariaDB
   sudo systemctl status mysql     # 对于 MySQL
   ```

   如果服务正在运行，应该会看到类似以下的输出：

   ```
   ● mariadb.service - MariaDB 10.3.29 database server
      Loaded: loaded (/lib/systemd/system/mariadb.service; enabled; vendor preset: enabled)
      Active: active (running) since Tue 2024-07-02 16:28:39 UTC; 3min 42s ago
   ```

5. **连接到 MySQL 或 MariaDB**

   使用 MySQL 或 MariaDB 客户端连接到数据库服务器：

   ```bash
   sudo mysql -u root -p
   ```

   输入安全性脚本中设置的 root 密码，如果一切正常，您应该能够成功登录到 MySQL 或 MariaDB 控制台。

### 注意事项：

- **软件源配置**：在某些情况下，您可能需要添加适合您系统的软件源，以获取最新的 MySQL 或 MariaDB 版本。请参考官方文档或社区指南进行配置。

- **系统资源**：ARM 架构的设备通常资源有限，可能会影响 MySQL 或 MariaDB 的性能。在选择和配置数据库时要特别注意系统资源的使用情况。

通过上述步骤，您应该能够在 Armbian 上成功安装并配置 MySQL 或 MariaDB。如果遇到特定于 Armbian 的问题或者需要进一步的帮助，请随时提供更多详细信息。