echo "Checking for processes running on port 8080..."
lsof -i :8080 | grep LISTEN

# 如果找到8080端口上的监听进程，则杀死该进程
if [ $? -eq 0 ]; then
    echo "Port 8080 is in use. Killing the process..."
    lsof -i :8080 | grep LISTEN | awk '{print $2}' | xargs -I {} kill -9 {}
    echo "Process killed."
else
    echo "No process found running on port 8080."
fi
