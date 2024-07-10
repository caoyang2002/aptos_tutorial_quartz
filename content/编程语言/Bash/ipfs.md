在后台运行 `ipfs daemon` 并能够启动、停止以及检查进程是否在后台运行

```bash
#!/bin/bash

# 定义 IPFS 进程名称
IPFS_PROCESS_NAME="ipfs"

# 启动 IPFS 守护进程
start_ipfs() {
    echo "启动 IPFS 守护进程..."
    ipfs daemon > /dev/null 2>&1 &
    echo "IPFS 守护进程已启动并置于后台."
}

# 停止 IPFS 守护进程
stop_ipfs() {
    echo "停止 IPFS 守护进程..."
    pkill -f "ipfs daemon"
    echo "IPFS 守护进程已停止."
}

# 检查 IPFS 守护进程是否在后台运行
check_ipfs() {
    local count=$(pgrep -f "ipfs daemon" | wc -l)
    if [ "$count" -gt 0 ]; then
        echo "IPFS 守护进程正在运行."
    else
        echo "IPFS 守护进程不在后台运行."
        start_ipfs  # 如果不在后台运行，则自动重启
    fi
}

# 主脚本逻辑
case "$1" in
    start)
        start_ipfs
        ;;
    stop)
        stop_ipfs
        ;;
    status)
        check_ipfs
        ;;
    restart)
        stop_ipfs
        sleep 2  # 等待2秒再重启，以确保停止完成
        start_ipfs
        ;;
    *)
        echo "使用方法: $0 {start|stop|status|restart}"
        exit 1
        ;;
esac

exit 0
```

保存这段代码到一个文件中，例如 `manage_ipfs.sh`，然后给予执行权限：

```sh
chmod +x manage_ipfs.sh
```

你可以使用以下命令来管理 IPFS 守护进程：

- 启动 IPFS 守护进程：
  ```sh
  ./manage_ipfs.sh start
  ```

- 停止 IPFS 守护进程：
  ```sh
  ./manage_ipfs.sh stop
  ```

- 检查 IPFS 守护进程状态：
  ```sh
  ./manage_ipfs.sh status
  ```

- 重启 IPFS 守护进程：
  ```sh
  ./manage_ipfs.sh restart
  ```

请注意，这个脚本使用 `pkill -f "ipfs daemon"` 来停止 IPFS 进程，这将匹配当前用户下所有包含 `ipfs daemon` 字符串的进程。如果需要更精确地控制或检查特定 IPFS 实例，请根据实际情况调整脚本中的命令和逻辑。
