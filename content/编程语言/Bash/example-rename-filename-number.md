---
title: 重命名文件为数字
---
```bash
#!/bin/bash

# 检查是否提供了一个参数
if [ $# -eq 0 ]; then
  echo "使用方法: $0 文件路径"
  exit 1
fi

directory_path="$1"

# 检查文件路径是否存在
if [ -e "$directory_path" ]; then
  # 检查是否是文件
  if [ -d "$directory_path" ]; then
    echo "提供的路径是一个目录。"
  else
    echo "错误：提供的路径不是一个目录。"
    exit 3
  fi
else
  echo "错误：提供的路径不存在。"
  exit 4
fi

echo "开始查命名该目录的文件"


# 指定目录路径
#directory_path=file_path

# 设置起始编号
counter=1

# 进入目录
cd "$directory_path" || exit

# 遍历目录中的所有文件
for old_name in *; do
  if [ -f "$old_name" ]; then
    # 获取文件扩展名
    extension="${old_name##*.}"
    # 构造新文件名（编号 + 原始扩展名）
    new_name="${counter}.${extension}"
    # 重命名文件
    mv "$old_name" "$new_name"
    echo "重命名: $old_name -> $new_name"
    # 更新编号
    ((counter++))
  fi
done

echo "所有文件已重命名。"

```