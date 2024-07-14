```bash
#!/bin/bash
# 这是一个 Bash 脚本的 shebang 行，告诉系统使用哪个解释器来执行脚本。

# include this boilerplate
# 这里包含了一个自定义函数的定义。

function jumpto
{
    # 定义一个名为 jumpto 的函数，它接受一个参数 label。
    label=$1  # label 参数是要跳转的标签名称。
    
    # 使用 sed 从脚本文件本身中提取标签后的所有命令，直到遇到另一个标签或文件末尾。
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    
    # eval 执行提取的命令字符串。
    eval "$cmd"
    
    # 退出脚本。
    exit
}

start=${1:-"start"}
# 定义 start 变量，默认为 "start"，如果命令行提供了参数，则使用该参数。

jumpto $start
# 调用 jumpto 函数，传入 start 变量作为参数，开始脚本执行。

# 下面是脚本的标签定义区域。

start:
# 定义了一个名为 start 的标签。
# 你的脚本逻辑从这里开始...
x=100
# 在 start 标签下设置变量 x 的值为 100。

jumpto foo
# 调用 jumpto 函数，跳转到 foo 标签。

mid:
# 定义了一个名为 mid 的标签。
x=101
# 在 mid 标签下设置变量 x 的值为 101，但这个标签不会被执行，因为脚本会跳转到 foo。
echo "This is not printed!"

foo:
# 定义了一个名为 foo 的标签。
x=${x:-10}
# 在 foo 标签下，设置变量 x 的值为 10，如果 x 已经有值，则保持不变。
echo x is $x
# 打印变量 x 的值。

# 脚本的执行流程是：
# 1. 初始化 start 变量并调用 jumpto 函数。
# 2. 跳转到 start 标签，设置 x=100。
# 3. 跳转到 foo 标签，设置 x=10（如果之前没有设置）并打印 x 的值。
```