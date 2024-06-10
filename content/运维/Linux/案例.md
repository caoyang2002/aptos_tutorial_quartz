
在Bash中，你可以使用`find`命令来遍历当前文件夹及其所有子文件夹中的所有文件。以下是一些基本的命令示例：

1. **基本的文件遍历**：
```bash
   find .
```
   这个命令将列出当前目录（`.`）及其所有子目录中的所有文件和目录。

2. **只列出文件**：
   ```bash
   find . -type f
   ```
   `-type f` 选项告诉 `find` 命令只匹配文件。

3. **按修改时间筛选文件**：
   ```bash
   find . -type f -mtime -7
   ```
   `-mtime -7` 选项将匹配过去7天内修改过的文件。

4. **使用通配符搜索特定类型的文件**：
   ```bash
   find . -type f -name "*.txt"
   ```
   这个命令将查找所有扩展名为 `.txt` 的文件。

5. **排除特定目录**：
   ```bash
   find . -type f -path "./somedir/*" -prune -o 
   ```
   `-path "./somedir/*" -prune` 将排除搜索结果中的 `somedir` 目录及其内容。

6. **打印文件路径和最后修改时间**：
   ```bash
   find . -type f -exec stat --format="%y %n" {} \;
   ```
   这个命令将打印每个文件的最后修改时间（人类可读的格式）和文件路径。

7. **对找到的每个文件执行命令**：
   ```bash
   find . -type f -exec echo "File found: {}" \;
   ```
   `-exec` 选项允许你对每个找到的文件执行指定的命令，`{}` 是一个占位符，代表当前文件的路径。

8. **递归地遍历目录**：
   ```bash
   find . -type f -print0 | xargs -0 some_command
   ```
   `-print0` 和 `xargs -0` 的组合允许安全地处理文件名，即使它们包含空格或特殊字符。

请根据你的具体需求选择合适的命令和选项。这些命令可以组合使用，以实现更复杂的文件遍历和处理逻辑。


# 查找最近一个小时内修改的文件

```bash
#!/bin/bash
# 检查是否提供了目录路径作为参数

if [ "$#" -ne 1 ]; then
    echo "使用方法: $0 <目录路径>"
    exit 1
fi

TARGET_DIR="$1"

# 检查提供的路径是否存在且是目录
if [ ! -d "$TARGET_DIR" ]; then
    echo "错误：提供的路径不存在或不是一个目录。"
    exit 1
fi

echo "进入路径: $TARGET_DIR"
# 进入目标目录
cd "$TARGET_DIR"


# 使用stat命令查找最近修改的文件
# -f "%Sm %N" 表示打印文件最后修改时间（以秒为单位）和文件名
# 然后使用sort和head命令获取最新的文件

recent_file_and_time=$(stat -f "%Sm %N" . | sort -r | head -n 1)

  

# 分割文件最后修改时间和文件路径

#IFS=' ' read -r file_mod_time file_path <<< "$recent_file_and_time"

  

# 将文件最后修改时间转换为易读的格式

#readable_date=$(date -r "$file_mod_time" '+%Y-%m-%d %H:%M:%S')

  

echo "检查文件 $file_path"

# 检查是否找到最近修改的文件

if [ -z "$file_path" ]; then
    echo "在$TARGET_DIR目录下没有找到文件。"
    exit 0
fi



# 输出文件的最后修改时间和相对路径
echo "最近修改的文件路径：$file_path"

echo "最后修改时间（易读格式）：$readable_date"
```



# 获取文件路径

```bash
#!/bin/bash

# 初始化一个空数组
file_paths=()

# 使用find命令查找当前目录及其子目录下的所有文件，并将其路径添加到数组中
while IFS= read -r file; do
    file_paths+=("$file")
done < <(find . -type f)

# 打印所有文件路径
for path in "${file_paths[@]}"; do
    echo "$path"
done
```

`< <(command)` 是 Bash 中的进程替换（process substitution）语法。这种语法允许你将一个命令的输出当作另一个命令的输入来使用，就像使用文件一样。进程替换在概念上类似于命名管道（FIFO），但它是临时的，并且不需要你手动创建管道文件。

在具体的例子 `< <(find . -type f)` 中：

- `find . -type f`：这个 `find` 命令查找当前目录（`.`）及其所有子目录中的所有类型为普通文件（`-type f`）的文件。
- `< <`：这部分是进程替换的开始标记。
- `(command)`：这里的 `command` 就是 `find . -type f`，进程替换将这个命令的输出创建为一个临时文件。

进程替换的工作原理如下：

1. 当脚本执行到 `< <(find . -type f)` 时，Bash 会启动一个新的子shell来运行 `find . -type f` 命令。
2. Bash 为 `find` 命令的输出创建一个临时文件（对于 `< <`，Bash 会创建一个类型为文件的临时文件）。
3. 脚本中的 `while` 循环或其他命令会从这个临时文件读取数据，就像从一个普通的文件读取一样。
4. 一旦数据被读取完毕或脚本命令完成，临时文件会被自动删除。

进程替换通常用于以下情况：

- 当你需要将一个命令的输出作为另一个命令的输入，但输出太多，不适合直接在命令行上使用管道（`|`）时。
- 当你想在循环中逐行处理一个命令的输出时。

进程替换有几种形式：

- `< <(command)`：将命令的标准输出用作输入。
- `> >(command)`：将命令的标准输入用作输出。

在你的例子中，进程替换允许 `while` 循环逐行读取 `find` 命令的输出，而不需要一次性将所有输出加载到内存中，这在处理大量文件时特别有用。



```bash
#!/bin/bash

last_file=""
last_time=""


if [ "$#" -ne 1 ]; then
    echo "使用方法: $0 <目录路径>"
    exit 1
fi

TARGET_DIR="$1"

# 检查提供的路径是否存在且是目录
if [ ! -d "$TARGET_DIR" ]; then
    echo "错误：提供的路径不存在或不是一个目录。"
    exit 1
fi

echo "进入路径: $TARGET_DIR"
# 进入目标目录
cd "$TARGET_DIR"


# 初始化一个空数组
# file_paths=()

# 使用find命令查找当前目录及其子目录下的所有文件，并将其路径添加到数组中
# while IFS= read -r file; do
#     file_paths+=("$file")
# done < <(find $TARGET -type f)

# 初始化一个空数组
file_paths=()

# 使用find 命令查找目标目录及其子目录下的所有文件，
# 并排除 .get、.vscode、.next、node_modules 文件夹
while IFS= read -r file; do
    file_paths+=("$file")
done < <(find "$TARGET_DIR" -type f \
    \( -path "*/.get/*" -prune -o \
       -path "*/.vscode/*" -prune -o \
       -path "*/.next/*" -prune -o \
       -path "*/node_modules/*" -prune \) -print)

# 打印所有文件路径
for path in "${file_paths[@]}"; do
    echo "$path"
done

# 打印所有文件路径
for path in "${file_paths[@]}"; do
    echo "检查文件 $path"
    current_file=$(stat -f "%Sm %N" "$path")
    mod_time=$(echo "$current_file" | cut -d' ' -f1)
    file_name=$(echo "$current_file" | cut -d' ' -f2)
    echo "$mod_time"
    echo "$file_name"
    
    # 字符串比较需要使用双括号
    if (( mod_time > last_time )); then
        last_time=$mod_time  # 更新 last_time 变量
        last_file="$file_name"  # 更新 last_file 变量，并用双引号括起来
        echo "最后修改的文件是：$last_file"
        echo "最后修改的时间是：$last_time"
    fi
done

# 打印最后修改的文件和时间
if [ -n "$last_file" ]; then
    echo "最后修改的文件是：$last_file"
    echo "最后修改时间是：$last_time"
else
    echo "没有找到文件。"
fi
```



# 查找文件，并排除指定文件或路径

```bash
#!/bin/bash

# 检查是否至少提供了一个参数：目录路径和至少一个排除项
if [ "$#" -lt 2 ]; then
    echo "使用方法: $0 <目录路径> <排除项1> [<排除项2> ...]"
    exit 1
fi

TARGET_DIR="$1"
shift  # 将脚本参数列表中的目录路径移除，剩下的是排除项

# 初始化一个空数组，用于存储文件路径
file_paths=()

# 构建find命令的排除条件
exclude_opts=()
for exclude_item in "$@"; do
    exclude_opts+=(-not -path "*/$exclude_item" -prune)
done

echo "$exlude_opts"

# 使用find命令查找目标目录及其子目录下的所有文件和目录
# 排除指定的文件或目录名称
find_cmd="find \"$TARGET_DIR\" \( ${exclude_opts[@]} \) -print"

# 执行find命令，并将输出添加到数组中
eval "$find_cmd" | while IFS= read -r file; do
    file_paths+=("$file")
done

# 打印所有找到的文件和目录路径（可选）
for path in "${file_paths[@]}"; do
    echo "$path"
done
```



```bash
#!/bin/bash

# 检查参数数量
if [ "$#" -lt 2 ]; then
    echo "使用方法: $0 <目录路径> [<排除项1> [<排除项2> ...]]"
    exit 1
fi

TARGET_DIR="$1"
shift  # 移除目录路径参数

# 初始化 file_paths 数组
file_paths=()

# 构建 find 命令
find_cmd="find \"$TARGET_DIR\""

# 添加排除条件
for exclude_item in "$@"; do
    # 对于每个排除项，添加 -not -path 选项
    find_cmd+=" -not -path '*/$exclude_item'"
done

# 添加 -print 以打印匹配的文件
find_cmd+=" -print"

# 执行 find 命令并读取输出
eval "$find_cmd" | while IFS= read -r file; do
    file_paths+=("$file")
done

# 打印所有找到的文件路径
for path in "${file_paths[@]}"; do
    echo "$path"
done
```















# 可以使用的
```bash
#!/bin/bash:wq;

last_file=""

last_time=""

  

if [ "$#" -ne 1 ]; then

    echo "使用方法: $0 <目录路径>"

    exit 1

fi

  

TARGET_DIR="$1"

  

# 检查提供的路径是否存在且是目录

if [ ! -d "$TARGET_DIR" ]; then

    echo "错误：提供的路径不存在或不是一个目录。"

    exit 1

fi

  

echo "进入路径: $TARGET_DIR"

# 进入目标目录

#cd "$TARGET_DIR"

  

# 初始化一个空数组

file_paths=()

  

echo "find '$TARGET_DIR' -type f"

# 使用find命令查找当前目录及其子目录下的所有文件，并将其路径添加到数组中

while IFS= read -r -d '' file; do

    file_paths+=("$file")

done < <(find "$TARGET_DIR" -type f -print0)

  

# 打印所有文件路径

for path in "${file_paths[@]}"; do

    echo "检查文件 $path"

    # 获取文件的修改时间，并转换为 UNIX 时间戳

    mod_time=$(stat -f "%m" "$path")

    echo "修改时间：$mod_time"

    # 字符串比较需要使用双括号

    if (( mod_time > last_time )); then

        last_time=$mod_time  # 更新 last_time 变量

        last_file="$path"   # 更新 last_file 变量

    fi

done

  

# 打印最后修改的文件和时间

if [ -n "$last_file" ]; then

    echo "最后修改的文件是：$last_file"

    echo "最后修改时间是：$(date -r "$last_time" +"%Y-%m-%d %H:%M:%S")"

else

    echo "没有找到文件。"

fi
```


## 找到当前文件夹下最新的文件，并提交到 GitHub

```bash
#!/bin/bash

last_file=""
last_time=""

if [ "$#" -ne 1 ]; then
    echo "使用方法: $0 <目录路径>"
    exit 1
fi

TARGET_DIR="$1"

# 检查提供的路径是否存在且是目录
if [ ! -d "$TARGET_DIR" ]; then
    echo "错误：提供的路径不存在或不是一个目录。"
    exit 1
fi

# echo "进入路径: $TARGET_DIR"
# 进入目标目录
# cd "$TARGET_DIR"

# 初始化一个空数组
file_paths=()

# 使用find命令查找当前目录及其子目录下的所有文件，并将其路径添加到数组中
while IFS= read -r -d '' file; do
    file_paths+=("$file")
done < <(find "$TARGET_DIR" -type f -print0)

# 打印所有文件路径
for path in "${file_paths[@]}"; do
    # echo "检查文件 $path"
    # 获取文件的修改时间，并转换为 UNIX 时间戳
    mod_time=$(stat -f "%m" "$path")
    # echo "修改时间：$mod_time"
    # 字符串比较需要使用双括号
    if (( mod_time > last_time )); then
        last_time=$mod_time  # 更新 last_time 变量
        last_file="$path"   # 更新 last_file 变量
    fi
done

# 打印最后修改的文件和时间
if [ -n "$last_file" ]; then
    echo "最后修改的文件是：$last_file"
    echo "最后修改时间是：$(date -r "$last_time" +"%Y-%m-%d %H:%M:%S")"
else
    echo "没有找到文件。"
fi

cd "$TARGET_DIR"
# 使用 basename 命令获取文件名
#filename=$(basename "$last_file")
filename=$(echo "$last_file" | sed 's/^[^/]*\///')
echo "basename is $filename"
git add "$filename"
git commit -m "update file $last_file"
git push
```




# 启动两个网站并检查是否启动成功

```bash
#!/bin/bash

COMMAND="pnpm dev"
OUTPUT_LOG="output.log"
ERROR_LOG="error.log"
JSON="simons/aptos-developer-docs/apps/nextra/package.json"
APTOS_GIT="aptos-labs/developer-docs"
APTOS_GIT_REPO="https://github.com/aptos-labs/developer-docs.git"
SIMONS_GIT="simons/aptos-developer-docs"
TARGET_APP="apps/nextra"
PID_FILE="site.pid"
APTOS_PORT=3030
SIMONS_PORT=3031

echo "update json $JSON"
jq '.scripts.dev = "next -p 3031"' $JSON  > temp.json && mv temp.json $JSON
  

  

# 函数：启动命令并记录 PID

start_site() {

cd $APTOS_GIT

git pull $APTOS_GIT_REPO

cd $TARGET_APP

echo "current path is `pwd`"

    echo "Starting command: $COMMAND"

    nohup $COMMAND > "$OUTPUT_LOG" 2> "$ERROR_LOG" &

    local pid=$!

    echo $pid > "$PID_FILE"

    echo "Command started successfully with PID: $pid"

    echo "sleep 2" 

    # 短暂等待，确保服务有足够的时间启动并监听端口

    sleep 2

    #检查端口状态，确保服务已启动并监听指定端口

    check_port "$APTOS_PORT"

    # --------------------------

    cd ../../../..
    # --------------------------
    cd $SIMONS_GIT
	cd $TARGET_APP

	echo "current path is `pwd`"
    echo "Starting command: $COMMAND"
    nohup $COMMAND > "../../../$OUTPUT_LOG" 2> "../../../$ERROR_LOG" &
    local pid=$!
    echo $pid > "$PID_FILE"
    echo "Command started successfully with PID: $pid"
    echo "sleep 2" 
    # 短暂等待，确保服务有足够的时间启动并监听端口
    sleep 2
    check_port "$SIMONS_PORT"
}

# 函数：检查端口是否正在使用

check_port() {

    local PORT="$1"

    echo "checking $PORT"

    if  lsof -i :$PORT > /dev/null; then

        print_color "\033[31m" "Error: Port $PORT is not in use. Program may not be running."

        exit 1

    else

        print_color "\033[32m" "Success: Port $PORT is active. Program is running."

    fi

}

  

# 函数：输出带有颜色的文本

print_color() {

    local color=$1

    local message=$2

    echo -e "${color}${message}"

}

  

start_site  

  

print_color "\033[39m" "EXIT"
```





```bash
#!/bin/bash
# 定义变量
COMMAND="pnpm dev"
OUTPUT_LOG="output.log"
ERROR_LOG="error.log"
PID_FILE="site.pid"
APTOS_PORT=3030
SIMONS_PORT=3031

# 函数：输出带有颜色的文本
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}"
}

# 函数：检查端口是否正在使用
check_port() {
    local PORT="$1"
    echo "checking $PORT"
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
    check_port "$APTOS_PORT"
    check_port "$SIMONS_PORT"
}

# 主逻辑
check_command
check_pid_file
start_command

print_color "\033[39m" "EXIT"

# 后台运行结束
exit 0

```



lsof -i :3030

# 启动 Aptos 中英文网站

```bash
#!/bin/bash

COMMAND="pnpm dev"
OUTPUT_LOG="output.log"
ERROR_LOG="error.log"
JSON="simons/aptos-developer-docs/apps/nextra/package.json"
APTOS_GIT="aptos-labs/developer-docs"
APTOS_GIT_REPO="https://github.com/aptos-labs/developer-docs.git"
SIMONS_GIT="simons/aptos-developer-docs"
TARGET_APP="apps/nextra"
PID_FILE="site.pid"
APTOS_PORT=3030
SIMONS_PORT=3031
SLEEP=5
echo "update json $JSON"
#jq '.scripts.dev = "next -p 3031"' "$JSON"  > temp.json && mv temp.json "$JSON"
jq '.scripts.dev = "next -p 3031"' simons/aptos-developer-docs/apps/nextra/package.json > temp.json && mv temp.json simons/aptos-developer-docs/apps/nextra/package.json
# 函数：启动命令并记录 PID
start_site() {
cd $APTOS_GIT
git pull $APTOS_GIT_REPO
cd $TARGET_APP
echo "current path is `pwd`"
    cat package.json | grep '"dev"'
    echo "Starting command: $COMMAND"
    nohup $COMMAND > "../../../$OUTPUT_LOG" 2> "../../../$ERROR_LOG" &
    local pid=$!
    echo $pid > "../../../$PID_FILE"
    echo "Command started successfully with PID: $pid"
    echo "sleep $SLEEP" 
    # 短暂等待，确保服务有足够的时间启动并监听端口
    sleep "$SLEEP"
    #检查端口状态，确保服务已启动并监听指定端口
    check_port "$APTOS_PORT"
    # --------------------------
    cd ../../../..
    echo "current path is `pwd`"
    # --------------------------
    cd $SIMONS_GIT
cd $TARGET_APP
echo "current path is `pwd`"
    cat package.json | grep '"dev"'
    echo "Starting command: $COMMAND"
    nohup $COMMAND > "../../../$OUTPUT_LOG" 2> "../../../$ERROR_LOG" &
    local pid=$!
    echo $pid > "../../../$PID_FILE"
    echo "Command started successfully with PID: $pid"
    echo "sleep $SLEEP" 
    # 短暂等待，确保服务有足够的时间启动并监听端口
    sleep "$SLEEP"
    check_port "$SIMONS_PORT"
}
# 函数：检查端口是否正在使用
check_port() {
    local PORT="$1"
    lsof -i :"$PORT"
    echo $?
    echo "checking $PORT"
    if  `lsof -i :"$PORT"` > /dev/null; then
        print_color "\033[31m" "Error: Port $PORT is not in use. Program may not be running."
        exit 1
    else
        print_color "\033[32m" "Success: Port $PORT is active. Program is running."
    fi
}
# 函数：输出带有颜色的文本
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}"
}
start_site  
print_color "\033[39m" "EXIT"
```




# 比较两个文件的差异

```bash
diff <(tree -Ci --noreport ./simons/developer-docs/apps/nextra/pages/en/build) <(tree -Ci --noreport ./aptos-labs/developer-docs/apps/nextra/pages/en/build )
```

# 比较两个文件的差异，并输出为易读文本

```bash
#!/bin/bash

# diff <(tree -Ci --noreport ./simons/developer-docs/apps/nextra/pages/en/build) <(tree -Ci --noreport ./aptos-labs/developer-docs/apps/nextra/pages/en/build )
#!/bin/bash
# 定义两个目录路径
dir1="./simons/developer-docs/apps/nextra/pages/en/build"
dir2="./aptos-labs/developer-docs/apps/nextra/pages/en/build"
# 执行 diff 命令，使用 -u 选项获取统一格式的输出
# 同时使用 process substitution 和 tree 命令
diff_output=$(diff -u <(tree -Ci --noreport "$dir1") <(tree -Ci --noreport "$dir2"))
# 检查 diff 输出是否为空
if [ -z "$diff_output" ]; then
    echo "两个目录没有差异。"
    exit 0
fi
# 打印标题
echo "详细目录差异报告："
echo "--------------------------"
# 打印统一格式的 diff 输出
echo "$diff_output"
# 打印结束语
echo "--------------------------"
echo "详细差异报告结束。"
```

# 比较文件的差异

```bash
#!/bin/bash
# 检查是否提供了两个参数
if [ "$#" -ne 2 ]; then
    echo "使用方法：$0 文件1 文件2"
    exit 1
fi
# 读取参数作为文件路径
file1="$1"
file2="$2"
# 检查文件是否存在
if [ ! -f "$file1" ]; then
    echo "错误：文件 $file1 不存在。"
    exit 1
fi
if [ ! -f "$file2" ]; then
    echo "错误：文件 $file2 不存在。"
    exit 1
fi
# 使用 diff -u 命令比较文件，并输出结果

echo "比较文件 $file1 和 $file2 的差异："
diff -u "$file1" "$file2"
```


# 比较两个目录下所有文件的差异

```bash
#!/bin/bash

# 脚本使用方法
if [ "$#" -ne 3 ]; then
    echo "使用方法：$0 源目录 目标目录 需要比较的路径"
    echo "例如：$0 origin/dir double/dir dir/text/folder"
    exit 1
fi

# 读取参数作为文件路径
orig_dir="$1"
doub_dir="$2"
path="$3"

# 先去 aptos 下面去 pull 一下
cd "$orig_dir"
git pull
cd ../.. 

# 拼接完整的路径
ab_path_orig="$orig_dir/$path"
ab_path_doub="$doub_dir/$path"

# 确保目标子路径存在
if [ ! -d "$ab_path_orig" ] || [ ! -d "$ab_path_doub" ]; then
    echo "错误：指定的源目录或目标目录下的子路径不存在。"
    exit 1
fi

# 获取源路径和目标路径下的所有文件
existence_orig=($(find "$ab_path_orig" -type f))
existence_doub=($(find "$ab_path_doub" -type f))

# 创建输出目录和文件
output_dir="diff"
mkdir -p "$output_dir"
output_file="$output_dir/$(date +%Y-%m-%d).md"

# 创建 diff_file 函数，比较两个文件的差异
function diff_file() {
    local orig_file="$1"
    local doub_file="$2"
    local relative_file="${orig_file#$ab_path_orig}"

    if [ ! -f "$doub_file" ]; then
        echo "# 文件 \`$relative_file\` 仅存在于源目录中。" >> "$output_file"
        return
    fi
   
    if diff -q "$orig_file" "$doub_file" > /dev/null; then
        echo "# 文件 \`$relative_file\` 在两个目录中相同。" >> "$output_file"
    else
        echo "# 文件 \`$relative_file\` 在两个目录中存在差异：" >> "$output_file"
        echo "\`\`\`\`">> "$output_file"
        diff -u "$orig_file" "$doub_file" >> "$output_file"
        echo "\`\`\`\`">> "$output_file"
    fi
}

# 比较文件内容差异，并输出到文件
for orig_file in "${existence_orig[@]}"; do
    doub_file="${ab_path_doub}${orig_file#$ab_path_orig}"
    diff_file "$orig_file" "$doub_file"
done

echo "比较完成。结果已保存到 '$output_file'。"

```



```bash
#!/bin/bash

# 脚本使用方法
if [ "$#" -ne 3 ]; then
    echo "使用方法：$0 源目录 目标目录 需要比较的路径"
    echo "例如：$0 origin/dir double/dir dir/text/folder"
    exit 1
fi

# 读取参数作为文件路径
orig_dir="$1"
doub_dir="$2"
path="$3"

# 先去 aptos 下面去 pull 一下
cd "$orig_dir"
git pull
cd ../.. 

# 拼接完整的路径
ab_path_orig="$orig_dir/$path"
ab_path_doub="$doub_dir/$path"

# 确保目标子路径存在
if [ ! -d "$ab_path_orig" ] || [ ! -d "$ab_path_doub" ]; then
    echo "错误：指定的源目录或目标目录下的子路径不存在。"
    exit 1
fi

# 获取源路径和目标路径下的所有文件
existence_orig=($(find "$ab_path_orig" -type f))
existence_doub=($(find "$ab_path_doub" -type f))

# 创建输出目录和文件
output_dir="diff"
mkdir -p "$output_dir"
output_file="$output_dir/$(date +%Y-%m-%d).md"

# 创建数组用于存放不同的文件 
diff_files=() 
same_files=() 
only_origin=()

# 创建 diff_file 函数，比较两个文件的差异
function diff_file() {
    local orig_file="$1"
    local doub_file="$2"
    local relative_file="${orig_file#$ab_path_orig}"

    if [ ! -f "$doub_file" ]; then
        echo "# 文件 \`$relative_file\` 仅存在于源目录中。" >> "$output_file"
        only_origin+=("$relative_file")
        (在这里，把文件添加到 same_file 数组中)
        return
    fi
   
    if diff -q "$orig_file" "$doub_file" > /dev/null; then
        echo "# 文件 \`$relative_file\` 在两个目录中相同。" >> "$output_file"
        (在这里，把文件添加到 same_file 数组中)
    else
        echo "# 文件 \`$relative_file\` 在两个目录中存在差异：" >> "$output_file"
        echo "\`\`\`\`">> "$output_file"
        diff -u "$orig_file" "$doub_file" >> "$output_file"
        echo "\`\`\`\`">> "$output_file"
        （在这里格式化输出为md中的标题和代码块）
	例如：
	# 不同的文件
	## 文件名.md
	这里是文件内容的代码块
        
    fi
}
function outputfile(){
(在这里遍历数组，以覆盖模式输出到diff/当前时间.md 文件夹中)
}

# 比较文件内容差异，并输出到文件
for orig_file in "${existence_orig[@]}"; do
    doub_file="${ab_path_doub}${orig_file#$ab_path_orig}"
    diff_file "$orig_file" "$doub_file"
    output_file
done

echo "比较完成。结果已保存到 '$output_file'。"
```





# 比较文件并输出到文件

```bash
#!/bin/bash

  

# 脚本使用方法

if [ "$#" -ne 3 ]; then

    echo "使用方法：$0 源目录 目标目录 需要比较的路径"

    echo "例如：$0 origin/dir double/dir dir/text/folder"

    exit 1

fi

  

# 读取参数作为文件路径

orig_dir="$1"

doub_dir="$2"

path="$3"

  

# 先去 aptos 下面去 pull 一下

cd "$orig_dir"

git pull

cd ../.. 

  

# 拼接完整的路径

ab_path_orig="$orig_dir/$path"

ab_path_doub="$doub_dir/$path"

  

# 确保目标子路径存在

if [ ! -d "$ab_path_orig" ] || [ ! -d "$ab_path_doub" ]; then

    echo "错误：指定的源目录或目标目录下的子路径不存在。"

    exit 1

fi

  

# 获取源路径和目标路径下的所有文件

existence_orig=($(find "$ab_path_orig" -type f))

existence_doub=($(find "$ab_path_doub" -type f))

  

# 创建输出目录和文件

output_dir="diff"

mkdir -p "$output_dir"

output_file="$output_dir/$(date +%Y-%m-%d).md"

  

# 创建数组用于存放不同的文件

diff_files=()

same_files=()

only_origin=()

  

# 创建 diff_file 函数，比较两个文件的差异

function diff_file() {

    local orig_file="$1"

    local doub_file="$2"

    local relative_file="${orig_file#$ab_path_orig}"

  

    if [ ! -f "$doub_file" ]; then

        # echo "# 文件 \`$relative_file\` 仅存在于源目录中。" >> "$output_file"

        only_origin+=("$relative_file")

        return

    fi

    if diff -q "$orig_file" "$doub_file" > /dev/null; then

        # echo "# 文件 \`$relative_file\` 在两个目录中相同。" >> "$output_file"

        same_files+=("$relative_file")

    else

        # echo "# 文件 \`$relative_file\` 在两个目录中存在差异：" >> "$output_file"

        # echo "\`\`\`\`">> "$output_file"

        diff -u "$orig_file" "$doub_file" >> "$output_file"

        # echo "\`\`\`\`">> "$output_file"

  

        # 首先，执行 diff 命令并将其输出存储在变量 diff_output 中

        diff_output=$(diff -u "$orig_file" "$doub_file")

  

        # 然后，将格式化的文本和 diff 命令的输出一起作为数组的一个元素

        # echo "relative_file is $relative_file"

        diff_content="\`$relative_file\`

  

- [ ] 完成

  

\`\`\`\`diff

$diff_output

\`\`\`\`"

  

        # echo "$diff_content"

        # 将 diff_content 添加到 diff_files 数组中

        #diff_files+=("$diff_content")

        diff_files+=("$diff_content")

    fi

}

# 创建 outputfile 函数，输出不同文件、仅存在于源目录的文件和相同文件的列表

  

function outputfile() {

    # 清空输出文件，以覆盖模式开始写入

    > "$output_file"

  

    # 遍历不同的文件数组并输出

    if [ ${#diff_files[@]} -ne 0 ]; then

        echo "# 不同的文件" >> "$output_file"

        for file in "${diff_files[@]}"; do

            echo "## $file" >> "$output_file"

            # echo "```diff" >> "$output_file"

            # diff -u "${ab_path_orig}$file" "${ab_path_doub}$file" >> "$output_file"

            # echo "$?"

            # echo "```" >> "$output_file"

            # echo -e "\n" >> "$output_file"

        done

    fi

  

    # 遍历仅存在于源目录的文件数组并输出

    if [ ${#only_origin[@]} -ne 0 ]; then

        echo "# 仅存在于源目录中的文件" >> "$output_file"

        for file in "${only_origin[@]}"; do

            echo "## \`$file\`" >> "$output_file"

        done

    else

         echo "# 没有仅存在于目录中的文件" >> "$output_file"

    fi

  

    # 遍历相同的文件数组并输出

    if [ ${#same_files[@]} -ne 0 ]; then

        echo "# 相同的文件" >> "$output_file"

        for file in "${same_files[@]}"; do

            echo "## \`$file\`" >> "$output_file"

        done

    fi

}

  

  

# 比较文件内容差异，并输出到文件

for orig_file in "${existence_orig[@]}"; do

    doub_file="${ab_path_doub}${orig_file#$ab_path_orig}"

    diff_file "$orig_file" "$doub_file"

    outputfile

done

  

echo "比较完成。结果已保存到 '$output_file'。"
```


```bash
# 创建输出目录和文件
output_dir="diff"
mkdir -p "$output_dir"
output_file="$output_dir/$(date +%Y-%m-%d).md"

# 创建数组用于存放不同的文件
diff_files=()
same_file=()
only_origin=()
# 创建 diff_file 函数，比较两个文件的差异
function diff_file() {
    local orig_file="$1"
    local doub_file="$2"
    local relative_file="${orig_file#$ab_path_orig}"

    if [ ! -f "$doub_file" ]; then
        (在这里，把文件添加到 same_file 数组中)
        return
    fi
   
    if diff -q "$orig_file" "$doub_file" > /dev/null; then
        (在这里，把文件添加到 same_file 数组中)
    else
    
    （在这里格式化输出为md中的标题和代码块）
	例如：
	# 不同的文件
	## 文件名.md
	这里是文件内容的代码块

    fi
}
```


# case 的使用
```bash
#!/bin/bash
old_dir="./simons/developer-docs/apps/nextra/pages/en/build/cli/setup-cli/install-move-prover.mdx "
new_dir="./aptos-labs/developer-docs/apps/nextra/pages/en/build/cli/setup-cli/install-move-prover.mdx"
# 检查参数数量并执行不同的方法
case "$#" in
    0)
        echo "没有提供参数。将使用默认目录"
        echo "ru"
        ;;  # ;; 表示语句的结束，类似于 break
    1)
        echo "提供了一个参数：$1"
        ;;
    2)
        echo "提供了两个参数：$1 和 $2"
        ;;
    *) # 任意数量的参数，大于2
        echo "提供了多个参数："
        for arg in "$@"; do
            echo "  - $arg"
        done
        ;;
esac
```

# 根据不同的参数数量匹配不同的方法

```bash
#!/bin/bash

# 定义一个函数，当没有参数时调用
function no_params() {
    echo "没有参数提供。显示帮助信息或默认操作。"
}
# 定义一个函数，当提供一个参数时调用
function one_param() {
    echo "提供了一个参数：$1"
    # 这里可以添加针对单个参数的处理逻辑
} 
# 定义一个函数，当提供多个参数时调用
function multiple_params() {
    echo "提供了多个参数："
    for arg in "$@"; do
        echo "  - $arg"
    done
    # 这里可以添加针对多个参数的处理逻辑
}
# 主脚本逻辑
main() {
    case "$#" in
        0) # 没有参数
            no_params
            ;;
        1) # 一个参数
            one_param "$1"
            ;;
        *) # 多个参数
            multiple_params "$@"
            ;;
    esac
}
# 调用主函数，并将所有参数传递给它
main "$@"
```






# ai 指令

```bash
这是一段比较指定目录下两个相同路径下的文件的差异的脚本，根据注释，将代码修改正确并补充完整：
脚本使用方法，例如： ./diff origin double dir/text/folder
这个程序会比较 origin 文件夹和 double 文件夹下的 dir/text/folder 目录中的所有文件，例如 double/dir/text/folder/text.md 和 origin/dir/text/folder/text.md 是否存在差异，文件存在什么差异，并输出到控制台和当前时间命名的文件中，例如 diff/2024-06-09.md

# ./diff.sh orig_dir doub_dir path
if [ "$#" -ne 2 ]; then
    echo "使用方法：$0 源目录 副本目录 需要比较的路径"
    echo "例如：./diff origin/dir double/dir text/folder"
    exit 1
fi
# 读取参数作为文件路径
orig_dir="$1"
doub_dir="$2"
path="$3"

# 拼接目录
ab_path_orig="$orig_dir" + "$path"
ab_path_doub="$doub_dir" + "$path"


# 初始化一个空数组保存源路径中所有存在的文件
existence_orig=()
# 初始化一个空数组保存副本路径中所有存在的文件
existence_doub=()

# 初始化一个空数组保存所有存在的文件
all_find=()
# 保存所有不存在的文件
all_not=()

# 获取源文件夹下的所有路径，并放入 existence_orig=() 中
while IFS= read -r -d '' file; do
    existence_orig+=("$file")
done < <(find "$TA" -type f -print0)

# 获取副本文件夹下的所有文件，并放入 existence_doub=() 中
while IFS= read -r -d '' file; do
    existence_doub+=("$file")
done < <(find "$TA" -type f -print0)

# 比较文件内容差异
for path in "${file_paths[@]}"; do
	# 获取文件并赋值给变量
	# 检查文件是否存在
	if [ ! -f "$file" ]; then
    echo "错误：文件 $file 不存在。"
    not_file+=$file
	fi


done
# 创建一个方法，需要传入两个参数，分别是源路径名称和副本路径名称
function diff_file() {
    # 检查路径是否存在
    (请补充)
    # 检查文件是否存在差异
    (请补充)
    # 检查文件差异内容并输出到 diff/当前时间.md的文件中
    (请补充)
} 




```