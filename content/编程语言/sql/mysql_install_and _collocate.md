---
title: mysql 安装与配置
---
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


学习 [[SQL 语句]]

# 备份数据库

```bash
mysql -u root -p database_naem < database_namebackup.sql
```

# 导入数据库
```bash
mysqldump -u root -p database_name > database_name_backup.sql
```