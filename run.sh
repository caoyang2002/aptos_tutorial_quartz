#!/bin/bash

# 定义变量
COMMAND="npx quartz build --serve"
OUTPUT_LOG="output.log"
ERROR_LOG="error.log"
PID_FILE="quartz.pid"
PORT=8080

# 函数：输出带有颜色的文本
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}"
}

# 函数：检查端口是否正在使用
check_port() {
    if  lsof -i :$PORT > /dev/null; then
        print_color "\033[31m" "Error: Port $PORT is not in use. Program may not be running."
        exit 1
    else
        print_color "\033[32m" "Success: Port $PORT is active. Program is running."
    fi
}

# 函数：检查命令是否存在
check_command() {
    if ! command -v $COMMAND &> /dev/null; then
        echo "Error: '$COMMAND' is not installed or not found in PATH."
        exit 1
    fi
}

# 函数：检查 PID 文件是否存在
check_pid_file() {
    if [ -f "$PID_FILE" ]; then
        if ps -p $(cat "$PID_FILE") > /dev/null; then
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
    nohup $COMMAND > "$OUTPUT_LOG" 2> "$ERROR_LOG" &
    local pid=$!
    echo $pid > "$PID_FILE"
    echo "Command started successfully with PID: $pid"
    
    echo "sleep 2" 
    # 短暂等待，确保服务有足够的时间启动并监听端口
    sleep 2

    #检查端口状态，确保服务已启动并监听指定端口
    check_port
}

# 主逻辑
check_command
check_pid_file
start_command

print_color "\033[39m" "EXIT"

# 后台运行结束
exit 0
