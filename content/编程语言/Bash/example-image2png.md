---
title: 图片转 png
---
```bash
#!/bin/bash

# 检查是否提供了一个参数
if [ $# -eq 0 ]; then
  echo "使用方法: $0 文目录路径"
  exit 1
fi

# 定义要处理的目录路径
TARGET_DIR="$1"
echo "目录名是：$TARGET_DIR"

# 检查文件路径是否存在
if [ -e "$TARGET_DIR" ]; then
  # 检查是否是文件
  if [ -d "$TARGET_DIR" ]; then
    echo "提供的路径是一个目录。"
  else
    echo "错误：提供的路径不是一个目录。"
    exit 3
  fi
else
  echo "错误：提供的路径不存在。"
  exit 4
fi

# 定义要处理的目录路径
TARGET_DIR= "$1"

# 进入目录
cd "$TARGET_DIR" || exit
# 创建 png 文件
mkdir -p png

# 找到目录中所有图片文件
# 这里使用了常见的图片文件扩展名，你可以根据需要添加或删除扩展名
find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.tiff" \) | while read -r file; do
    # 构造新的文件名，将大写转换为小写
    new_filename=$(echo "$file" | tr '[:upper:]' '[:lower:]')
    # 检查新文件名是否与原文件名不同
    if [ "$file" != "$new_filename" ]; then
        # 重命名文件
        mv "$file" "$new_filename"
        echo "文件名已更改: $file -> $new_filename"
    fi
    # 使用 ImageMagick 转换图片格式为 PNG
    magick "$new_filename" "${new_filename%.*}.png"
    echo "图片已转换: $new_filename -> ${new_filename%.*}.png"
    # 移动文件
    echo "移动文件 $TARGET_DIR/""${new_filename%.*}.png"
    # original="$TARGET_DIR""/""${new_filename%.*}.png"
    original="${new_filename%.*}.png"
    png_dir="png/"
    echo "源文件：$original  目标目录：$png_dir"
    mv "$original" "$png_dir" #2>/dev/null
    echo "----------------------------------------------------"
done

echo "图片转换完成。"

```