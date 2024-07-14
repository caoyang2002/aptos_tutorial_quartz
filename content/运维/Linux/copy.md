---
title: 复制文件或目录
---
```bash
sudo rsync -avP .cache/ /home/caoyang/Desktop/delete/.cache/
```
- `-a` 选项表示递归地复制目录，并保持所有权限、符号链接等。
- `-v` 表示显示复制的详细过程。
- `-P` 表示显示复制进度和继续中断的文件传输。

这样可以将 `.cache` 目录及其内容复制到 `/home/caoyang/Desktop/delete/.cache/`

