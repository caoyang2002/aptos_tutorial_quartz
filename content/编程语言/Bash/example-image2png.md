---
title: 图片转 png
---
```bash
#!/bin/bash

# 定义要处理的目录路径
TARGET_DIR="/path/to/your/directory"

# 检查目录是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo "指定的目录不存在: $TARGET_DIR"
    exit 1
fi

# 进入目录
cd "$TARGET_DIR" || exit

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
    # convert "$new_filename" "${new_filename%.*}.png"
    # magick convert "$new_filename" "${new_filename%.*}.png"
    magick "$new_filename" "${new_filename%.*}.png"
    echo "图片已转换: $new_filename -> ${new_filename%.*}.png"
done

echo "图片转换完成。"
```