#!/bin/bash

# 获取当前时间
current_time=$(date +"%Y-%m-%d %H:%M:%S")

# 添加所有更改
git add .

# 提交更改，commit 消息为当前时间
git commit -m "Update: $current_time"

git push
