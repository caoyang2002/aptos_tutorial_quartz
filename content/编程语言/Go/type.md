---
title: 理解类型
description: go 语言中的数据类型
draft: 
aliases:
  - go 类型
date: 2024-07-02
tags:
  - Golang
banner: "static/go.jpg"
sticker: lucide//file-code
---
# 概述
Go 语言是一种静态类型语言，Python、JavaScript 则是动态类型

> **静态类型与动态类型**
> 
> 所谓强（静态）类型语言，指的是错误地使用了类型时，编译器将引发错误；所谓弱类型（也叫松散类型或弱类型）语言，指的是为了执行程序，运行时会将一种类型转换为另一种类型，或者编译器没有实现类型系统。

# 静态类型
```go title="main.go"
package main
import "fmt"
func sayHello(s string) string{ // 接受一个 string 类型的参数，返回一个 string 类型的值
	return "Hello " + s
}
func main(){
	fmt.Println(sayHello("Lisa"))
}
```
运行：
```go
go run main
```
输出：
>`Hello Lisa`

类似的，我们看一个 JavaScript 的例子
```js
var addition = function (a,b){
	return  a + b;
}
addition(1,3)
```
[去运行 JS 代码](https://runjs.app/play)
输出：
> `4`
我们换成数字和字符串的“加法”
```python title="python.py"
var addition = function (a,b){
	return  a + b;
}
addition(2,"Lisa")
```
输出：
> `'2Lisa'`

返回了一个字符串，怎么会这样呢？虽然 JavaScript 有类型的概念，但其类型使用规则非常宽松。
在这个示例中，JavaScript对数字值执行类型转换，将其转换为字符串，因此返回字符串。
JavaScript提供的这种灵活性虽然很有吸引力，但可能导致微妙乃至灾难性的Bug。
假设有个程序使用上述addition函数来接受输入并将其存储到数据库中。数据库通常有数据类型的概念，很多还有整数的概念。整数是没有小数部分的数字，可正可负。如果数据库将字段定义成了整型，就会要求提供给该字段的值为整数。
前述JavaScript函数addition可能返回一个字符串，也可能返回一个整数。如果传递给它的值至少有一个字符串，返回的就是字符串。如果这个返回值被插入到需要整数的数据库字段中，将引发错误。更糟糕的是，这种错误发生在运行阶段，这意味着它将影响使用程序的用户。这种错误除非得到妥善处理，否则可能导致程序崩溃。
而在使用Go语言编写的函数中，对参数和返回值的类型都做了声明。

```go
package main
import "fmt"
func addition(x int, y int) int{
    return x + y
}
func main(){
    fmt.Println(addition(2,4))
}
```
运行：
```bash
go run main.go
```
输出：
>`6`

改为数字和字符串的“加法”
```go
package main
import "fmt"
func addition(x int, y int) int{
    return x + y
}
func main(){
    var str string = "Lisa"
    fmt.Println(addition(2,str))
}
```
输出：
```error
# command-line-arguments
./main.go:9:28: cannot use str (variable of type string) as int value in argument to addition
```


# 数据类型
## 布尔类型
```go
// 变量标记为 var
// 变量 变量名 变量类型
var b bool
```
不赋值默认为 `false`
```go 
package main
import "fmt"
func main(){
    var b bool
    fmt.Println(b)
}
```
输出：
> `false`

赋值
```go
package main
import "fmt"
func main(){
    var b bool
    fmt.Println(b)
    b = true
    fmt.Println(b)
}
```
输出：
> `true`

## 数值类型
### 有符号与无符号
4 位的无符号整数

| 二进制  | 十进制 |
| ---- | --- |
| 0000 | 0   |
| 0001 | 1   |
| 0010 | 2   |
| 0011 | 3   |
| 0100 | 4   |
| 0101 | 5   |
| 0110 | 6   |
| 0111 | 7   |
| 1000 | 8   |
| 1001 | 9   |
| 1010 | 10  |
| 1011 | 11  |
| 1100 | 12  |
| 1101 | 13  |
| 1110 | 14  |
| 1111 | 15  |
4 位的有符号整数

| 二进制  | 十进制 |
| ---- | --- |
| 0000 | 0   |
| 0001 | 1   |
| 0010 | 2   |
| 0011 | 3   |
| 0100 | 4   |
| 0101 | 5   |
| 0110 | 6   |
| 0111 | 7   |
| 1000 | -8  |
| 1001 | -7  |
| 1010 | -6  |
| 1011 | -5  |
| 1100 | -4  |
| 1101 | -3  |
| 1110 | -2  |
| 1111 | -1  |

### 整形
```go 
// 变量 变量名 变量类型 = 值
var number int = 3
```
### 浮点数
```go
var price float32 = 5.5
```
### 字符串
```go
var name string = "lisa"
```
字符串变量可以为空，这种变量非常适合用来累积其他变量中的数据以及存储临时数据。
```go
var name string = ""
```
创建字符串变量后，可将其与其他数据相加，但不能修改原来的值。下面的代码创建一个空字符串，再将字符串 google 附加到末尾，这在Go语言中是合法的。
```go
var company string = ""
company += "google"
```
不能对字符串执行数学运算，即便它看起来像个数字。要想对看起来像数字的字符串执行数学运算，必须先将其转换为数字类型。

### 数组
```go
// [数字长度]数组元素类型
var family [4]string
```
为数组的每一个元素赋值
```go
family[0] = "boy" // 数组的索引从零开始
family[1] = "girl"
family[2] = "dad"
family[3] = "mom"
```

## 检查变量类型
使用标准库中的 `reflect` 包检查

```go
package main
import (
    "fmt"
    "reflect"
)
func main(){
    var str string = "string"
    var number int = 10
    var float_number float32 = 2.3
    var b bool = true
    fmt.Println(reflect.TypeOf(str))
    fmt.Println(reflect.TypeOf(number))
    fmt.Println(reflect.TypeOf(float_number))
    fmt.Println(reflect.TypeOf(b))
}
```

输出：

```go
string
int
float32
bool
```

## 类型转换
需要的包 `strconv`
将一个车字符串变量转为 Bool
```go
var str string = 'true'
// := 短声明，会自动推倒变量类型如下 
// 变量名 ：= 变量值或表达式
b,err := strconv.ParseBool(str)
```
Bool 转为字符串
```go
str := strconv.FormatBool(True)
fmt.Println(str)
```
将 Bool 转为字符串的程序
```go
package main
import (
	"fmt"
	"strconv"
	"reflect"
)
func main(){
	var b bool = true
	fmt.Println(reflect.TypeOf(b))
	var str string = strconv.FormatBool(True)
	fmt.Println(reflect.TypeOf(str))
}
```
输出：
```go
bool
string
```