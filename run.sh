# nohup npx quartz build --serve >> output.log 2 >> error.log &


#!/bin/bash

# 定义变量
COMMAND="npx quartz build --serve"
OUTPUT_LOG="output.log"
ERROR_LOG="error.log"
PID_FILE="quartz.pid"

# 函数：检查命令是否存在
check_command() {
    if ! command -v npx &> /dev/null; then
        echo "Error: 'npx' is not installed or not found in PATH."
        exit 1
    fi
}

# 函数：检查 PID 文件是否存在
check_pid_file() {
    if [ -f "$PID_FILE" ]; then
        if kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "Error: Process is already running with PID $(cat "$PID_FILE")."
            exit 2
        else
            # 如果进程已不在运行，删除 PID 文件
            rm -f "$PID_FILE"
        fi
    fi
}

# 函数：启动命令并记录 PID
start_command() {
    echo "Starting command: $COMMAND"
    nohup $COMMAND >> "$OUTPUT_LOG" 2>> "$ERROR_LOG" &
    local pid=$!
    echo $pid > "$PID_FILE"
    echo "Command started successfully with PID: $pid"
}

# 函数：检查命令是否成功启动
check_startup() {
    local pid=$(cat "$PID_FILE")
    if kill -0 $pid 2>/dev/null; then
        echo "The process is running."
    else
        echo "Failed to start the process."
        # 如果启动失败，清理 PID 文件
        rm -f "$PID_FILE"
        exit 3
    fi
}

# 主逻辑
check_command
check_pid_file
start_command
check_startup

# 后台运行结束
exit 0
