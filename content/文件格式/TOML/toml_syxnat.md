---
title: TOML 语法
---
# 基本结构

1. **键值对**：
   - 格式：`key = "value"`
   - 示例：`name = "John Doe"`

2. **字符串**：
   - 双引号字符串：`key = "value"`
   - 单引号字符串（不允许转义字符）：`key = 'value'`
   - 多行字符串：使用三个双引号（`"""`）括起来的内容，可以保留换行符和空格。
     ```toml
     description = """
     This is a
     multiline string.
     """
     ```

3. **整数和浮点数**：
   - 整数：`key = 42`
   - 浮点数：`key = 3.14`

4. **布尔值**：
   - `true` 或 `false`

5. **日期和时间**：
   - 格式：`key = 1979-05-27T07:32:00Z`
   - 支持日期、时间和时区。

# 表

1. **表（Table）**：
   - 格式：`[table]`
   - 示例：
     ```toml
     [owner]
     name = "Alice"
     age = 30
     ```

2. **嵌套表**：
   - 格式：`[parent.child]`
   - 示例：
     ```toml
     [database]
     name = "mydatabase"

     [database.connection]
     user = "admin"
     password = "password"
     ```

3. **数组**：
   - 数组可以是任意类型的列表，格式：`key = [value1, value2, value3]`
   - 示例：
     ```toml
     colors = ["red", "green", "blue"]
     ```

4. **字典（Table Arrays）**：
   - 格式：
     ```toml
     [[table]]
     key1 = "value1"
     key2 = "value2"

     [[table]]
     key1 = "value3"
     key2 = "value4"
     ```
   - 示例：
     ```toml
     [[servers]]
     name = "server1"
     ip = "192.168.1.1"

     [[servers]]
     name = "server2"
     ip = "192.168.1.2"
     ```

### 示例

```toml
# 这是一个注释

[owner]
name = "Alice"
age = 30
is_active = true

[database]
name = "mydatabase"
host = "localhost"
port = 5432

[database.connection]
user = "admin"
password = "password"

[[servers]]
name = "server1"
ip = "192.168.1.1"

[[servers]]
name = "server2"
ip = "192.168.1.2"

# 多行字符串示例
description = """
This is a
multiline string
with several lines.
"""

# 数组示例
colors = ["red", "green", "blue"]

# 日期和时间示例
release_date = 2024-09-09T12:00:00Z
```

TOML 文件通常以 `.toml` 扩展名保存。它的设计使得配置文件更加清晰和可读，特别是在处理复杂的配置结构时。