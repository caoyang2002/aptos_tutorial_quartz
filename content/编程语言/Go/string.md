---
title: 使用字符串
draft: 
aliases:
  - 使用字符串
date: 2024-07-02
description: Go语言中使用字符串
tags:
  - Golang
---
# 创建字符串字面量
```go
package mian
import "fmt"
func main(){
	s := "I am an interpreted string literal"
	fmt.Println(s)
}
```


| rune字面量 | Unicode字符                         |
| ------- | --------------------------------- |
| `\a`    | U+0007 alert or bell              |
| `\b`    | U+0008（退格）                        |
| `\f`    | U+000C（换页符）                       |
| `\n`    | U+000A（换行符）                       |
| `\r`    | U+000D（回车）                        |
| `\t`    | U+0009（水平制表符）                     |
| `\v`    | U+000b（垂直制表符）                     |
| `\\`    | U+005c（反斜杠）                       |
| `\'`    | U+0027（单引号，这个转义序列只能包含在 rune 字面量中） |
| `\\"`   | U+0022（双引号，这个个转义序列只能包含在 字符串字面量中）  |
# 理解 rune 字面量
通过使用rune字面量，可将解释型字符串字面量分成多行，还可在其中包含制表符和其他格式选项。在程序清单9.2中，使用rune字面量添加换行符和制表符，虽然字符串声明位于一行中。

使用rune字面量
```go
package main
import "fmt"
func main(){
	s := "这是一段使用了换行符的字符串\n你可以在任何\n地方\n使\n用换行符，这中间添加了\t制表符"
	fmt.Println(s)
}
```
输出：
```go
这是一段使用了换行符的字符串
你可以在任何
地方
使
用换行符，这中间添加了 制表符
```
原始字符串使用反引号
```go
package main
import "fmt"
func main(){
	s := `原始 字符 串
使用反引号
	会按照原样
输出`
	fmt.Println(s)
}
```
输出：
```go
原始 字符 串
使用反引号
	会按照原样
输出
```

# 拼接字符串
可将运算符 `+` 用于字符串变量。字符串是使用解释型字符串字面量还是原始字符串字面量创建的无关紧要。运算符 `+` 将它左边和右边的字符串合并成一个字符串。
```go
package main
import "fmt"
func main(){
	str := "hello " + "world"
	fmt.Println(str)
}
```
输出：
```go
hello world
```
使用复合赋值运算符拼接字符串
```go
package main
import "fmt"
func main(){
	str := "这是一段字符串"
	str += "\n这也是一段字符串"
	fmt.Println(str)
}
```
输出：
```go
这是一段字符串
这也是一段字符串
```
>[!NOTE]
>只能拼接相同的类型

```go
package main
import "fmt"
func main(){
	var age int = 10
	var name string = "lisa"
	var breakfast string = name + age
	fmt.Println(breakfast)
}
```
输出：
```go
# command-line-arguments
./main.go:6:25: invalid operation: name + age (mismatched types string and int)
```
>[!TIP]
>使用 `strconv` 包转换为字符串后拼接
```go
package main
import (
	"fmt"
	"strconv"
	)
func main(){
	var age int  = 1;
	var name string = "lisa"
	intToString := strconv.Itoa(age)
	var breakfast string = intToString + name
	fmt.Println(breakfast)
}
```
输出：
```go
1lisa
```

# 使用缓冲区拼接字符串
```go
package main
import (
	"fmt"
	"bytes"
	)
func main(){
	var buffer bytes.Buffer
	for i := 0; i < 50; i++{
		buffer.WriteString("z")
	}
	fmt.Println(buffer.String())
}
```
输出：
```go
zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
```

# 理解字符串
要理解字符串是什么，必须明白计算机是如何显示和存储字符的。计算机将数据解读为数字，另外，虽然您根本看不到，但计算机实际上是将字符存储为数字的。
历史上有很多编码标准，最后大家就如何将字符映射到数字达成了一致。ASCII（美国信息交换标准码）曾经是最重要的编码标准，它就如何使用数字来表示英语字母表中的字符进行了标准化。
ASCII编码标准定义了如何使用7位的整数（通俗地说是数字）来表示128个字符。表9.2列出了ASCII字符集中的一些字符，如果您看不懂，也不用担心，只要知道数字映射到字符就可以了。
表9.2　ASCII字符集中的一些字符

| 二进制      | 八进制 | 十进制 | 十六进制 | 字符  |
| -------- | --- | --- | ---- | --- |
| 10000001 | 101 | 65  | 41   | A   |
| 1000010  | 102 | 66  | 42   | B   |
| 1110100  | 164 | 116 | 74   | t   |

虽然 ASCII 在英语字符标准化的道路上迈出了重要的一步，但它不包含其他任何语言的字符集。简而言之，它支持使用英语说 “hello”，但不支持使用中文说 “您好”。

鉴于此，Unicode 编码方案于 1987 年应运而生，它支持全球各地的大多数字符集。最新的版本支持 128000 个字符，涵盖 135 种或现代或古老的语言。更重要的是，Unicode 涵盖了 ASCII 标准，其开头的 128 个字符就是 ASCII 字符。

很多字符编码方案都实现了 Unicode 标准，其中最著名的是 UTF-8。更巧的是，Go 语言的两位设计者 Rob Pike 和 Ken Thompson 也是 UTF-8 的联合设计者。可见，Go 语言支持 UTF-8 和国际字符集，而 Go 源代码也是 UTF-8 的。

要更深入地理解字符串以及如何操作它们，必须首先知道 Go 语言中的字符串实际上是只读的字节切片。要获悉字符串包含多少个字节，可使用 Go 语言的内置函数 len。
```go 
package main
import "fmt"
func main(){
	s := "hello"
	fmt.Print(len(s))
}
```
输出：
```go
5
```
西语字符（如a、b、c）通常映射到单个字节。单词hello为5个字节，由于Go字符串为字节切片，因此可输出字符串中特定位置的字节值。在下面的示例中，输出了字符串“hello”的第一个字节。
```go
import "fmt"
func main(){
	s := "hello"
	fmt.Print(s[0]
}
```
输出：
```go
104
```
您可能认为结果应为字符h，但由于通过索引访问字符串时，访问的是字节而不是字符，因此显示的是以十进制表示的字节值。

|     | h       | e       | l       | o       |
| --- | ------- | ------- | ------- | ------- |
| 十进制 | 104     | 101     | 108     | 111     |
| 二进制 | 1101000 | 1100101 | 1101100 | 1101111 |
Go语言中，可使用格式设置将十进制值转换为字符和二进制表示。
```go
s := "hello"
fmt.Println("%q", s[0]) // 字符串
// 输出 'h'
fmt.Println("%b", s[0])  // 二进制
// 输出 1101000
```

很多国际字符都不止1字节，在下面的示例中，每个字符的长度都是3字节。
```go
s := "               "
fmt.Println(len(s))
// 输出 15
```

即便不完全明白二进制、字节和字符字面量，也没有关系。请注意，在Go语言中，字符串实际上是字节切片，这意味着可以像操作其他字节切片一样操作字符串。

# 处理字符串
给字符串变量赋值后，就可使用标准库中的strings包提供的任何方法。这个包提供了一套完备的字符串处理函数，其文档非常详尽。下面介绍几个字符串处理示例，但要全面了解strings包提供的函数，建议您阅读文档。
1．将字符串转换为小写
函数ToLower接受一个字符串，并将其中所有的大写字符都转换为小写，如程序清单9.9所示。
程序清单9.9　将字符串转换为小写
```go
package main
import (
	"fmt"
	"strings"
	)
func main(){
	fmt.Println(strings.ToLower("VERY GOOD"))
}
```
输出：
```go
very good
```
# 在字符串中查找子串
处理字符串时，另一个常见的任务是在字符串中查找子串。方法 `Index` 提供了这样的功能，它接受的第二个参数是要查找的子串。如果找到，就返回第一个子串的索引号；如果没有找到，就返回-1。别忘了，索引从0开始！
```go
package main
import (
	"fmt"
	"strings"
)
func main(){
	fmt.Println(strings.Index("surface","face"))
	fmt.Println(strings.Index("moon","aer"))
}
```
输出：
```go
3
-1 // 表示没有找到
```

# 删除字符串中的空格
strings包提供了很多将字符串的某些部分删除的方法。处理来自用户或数据源的输入时，一种常见的任务是确保开头和末尾没有空格。方法TrimSpace提供了这样的功能。
删除开头和末尾的空白
```go
package main
import(
	"fmt"
	"strings"
)
func main(){
fmt.Println(strings.TrimSpace(" 空格 space "))
}
```
输出：
```go
空格 space
```

> [!WARNING]
> 字符串是不可变的，意味着创建字符串不可更改， 

