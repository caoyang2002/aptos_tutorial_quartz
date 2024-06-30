---
title: sql 语句
---
# 数据库
## 创建数据库

```sql
CREATE DATABASE database_name
```

## 查询数据库
```sql
SHOW DATABASES
```

## 删除数据库
```sql
DROP DATABASE database_name
```

## 使用数据库
```sql
USE database_name
```

---
# DDL 数据定义语言

## 创建表

格式：
```sql
CREATE TABLE 表名 (
   列名 1 类型 [长度] [DEFAULT 默认值] [约束条件]
   列名 2 类型
   ……
);
```

实例：
```
CREATE TABLE userinfo(
   id INT
   username VARCHAR(32)
   password VARCHAR(32)
   nickname VARCHAR(32)
   age INT(3)
);
```

## 查看当前数据库中的所有表

```sql
SHOW TABLES
```

## 显示表的详细信息
> 表的结构定义，包括列名、数据类型、是否允许为空、主键等信息。
```sql
SHOW CREATE TABLE table_name
```