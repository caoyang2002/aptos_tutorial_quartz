---
title: 理解变量
draft: 
aliases:
  - 理解变量
date: 2024-07-02
description: Go 语言中的变量
tags:
  - Golang
cssclasses:
  - none
---
# 声明变量
## 声明 string 变量时赋值
```go
package main
import "fmt"
func main(){
	var str string = "hello world" // 使用关键字 var 声明一个变量，类型为 string
	fmt.Pringln(str)
}
```
> `=` 赋值，将右边的值赋给左边
## 声明 string 变量后赋值
```go
package main
import "fmt"
func main(){
	var str string 
	str = "hello world" 
	fmt.Pringln(str)
}
```
## 变量的类型和值的类型时对应的
```go
package main
import "fmt"
func main(){
	var str string // 变量为 string
	str = 1 // 值为 int
	fmt.Pringln(str)
}
```
> 输出
> ```error
> ./main.go:5:8: cannot use 1 (untyped int constant) as string value in assignment
> /main.go:6:6: undefined: fmt.Pringln
> ```

## 快捷变量声明
### 相同类型的变量
```go
package main
import "fmt"
func main(){
	var name,nikename string = "Lisa","alice"
	fmt.Println(name)
	fmt.Println(nikename)
}
```
输出：
```go
Lisa
alice
```

### 不同类型的变量
```go
package main
import "fmt"
func main(){
	var (
		name string = "lisa"
		age int = 18)
	fmt.Println(name)
	fmt.Println(age)
}
```
输出：
```go
lisa
18
```
## 变量声明后就不能再次声明它
```go
var str string = "string"
var str int = 2 // 这是不允许的
```

## 理解变量和零值
在Go语言中，声明变量时如果没有给它指定值，则变量将为默认值，这种默认值被称为零值。
```go
package main
import "fmt"
func main(){
	var name string
	var age int
	var purse float32
	var condition bool
	fmt.Printf("%v %v %v %q\n",name,age,purse,condition)
}
```
输出：
```go
"" 0 0 %!q(bool=false)
```

### 检查变量是否为零值
```go
package main
import "fmt"
func main(){
	var name string
	if name == ""{
		fmt.Println("变量 name 为零值")
	}
}
```
输出：
```go
变量 name 为零值
```
>[!NOTE]
>- Go 禁止将变量初始化为 `nil` 值，因为这样会导致编译错误
>- `nil` 标识符可以作为多种数据结构的零值，通常我们会将 nil 就认为是空的意思，就像 C 语言里面的 NULL 一样
>- `nil` 和 `true` / `false` 一样，不是 Golang 的关键字

## 简短变量声明
> 不需要使用关键字 `var`，也不用指定变量的`类型`。同时这还意味着应将 `:=` 右边的值赋给变量

**只能在函数中使用简短变量声明**
```go
package main
import "fmt"
func main(){
	name := "Lisa"
	fmt.Println(name)
}
```
输出：
```go
Lisa
```

# 变量的声明方式
```go
 //方法一
 var name string = "lisa"
 // 方法二
 var name = "lisa"
 // 方法三
 var name string
 name = "lisa"
 // 方法四 （这种方法不能在函数外使用）
 name := "lisa"
```
>[!NOTE]
>在函数内使用简短变量声明：
>
>```go
>name := "lisa"
>```
>
>在函数外省略类型声明：
>
>```go
>var name = "string"
>```

惯用的变量声明
```go
package main
import "fmt"
var name = "lisa"
func main(){
	age := 22
	fmt.Println(name)
	fmt.Println(age)
}
```
输出：
```go
lisa
22
```

# 理解变量的作用域
**作用域**：指的是变量在什么地方可以使用，而不是变量是在什么地方声明的。

**词法**：一个形容词，意思与语言的词汇表相关。

Go 语言使用基于块的词法作用域。这意味着 Go 定义了变量在什么地方可以引用，在什么地方无法引用。对编程来说，这很有必要，因为这样可根据引用变量的位置，确定引用的是哪个变量。在Go语言中，块是位于一对大括号内的一系列声明和语句，但可以是空的。

可使用通俗的语言前述概念做如下诠释：
•  在 Go 语言中，一对大括号 `{}` 表示一个块。
•  对于在大括号 `{}` 内声明的变量，可在相应块的任何地方访问。
•  大括号内的大括号定义了一个新块 —— **内部块**。
•  在内部块中，可访问外部块中声明的变量。
•  在外部块中，不能访问在内部块中声明的变量。

简而言之，每个内部块都可访问其外部块，但外部块不能访问内部块。

```go
package main
import "fmt"
var name = "lisa"
func main(){
	fmt.Printf("变量 name 在外部块（文件也视为一个块），内部块可以访问 %v\n",name)
	condition := true
	if condition {
		fmt.Printf("变量 condition 在外部块，可以在内部块访问 %v\n", condition)
		age := 22
		if condition != false {
			fmt.Printf("变量 age 在外部块，可以在内部块访问 %v\n",age)
		}
	}
}
```
输出：
```go
变量 name 在外部块（文件也视为一个块），内部块可以访问 lisa
变量 condition 在外部块，可以在内部块访问 true
变量 age 在外部块，可以在内部块访问 22
```
> 大括号定义的程序结构和变量作用域。每对大括号都表示一个块。
> 
> 代码的缩进程度反映了块作用域的层级。在每个块中，代码都被缩进。
> 
> 在内部块中，可引用外部块中声明的变量。


# 使用指针
指针是另一个与变量相关且必须掌握的要素。

在Go语言中声明变量时，将在计算机内存中给它分配一个地址，以便能够存储、修改和获取变量的值。要获取变量在计算机内存中的地址，可在变量名前加上 `&` 字符。

将一个变量的内存地址打印到终端：
```go
package main
import "fmt"
func main(){
	name := "lisa"
	fmt.Println(&name)
}
```
输出（类似于这样）：
```go
0x14000112020
```
> 这是内存地址的十六进制表示。如果您不知道十六进制为何物，也不用担心，您只需知道每个变量的值都存储在不同的内存地址中就够了。

将一个整型变量传递给了一个函数，并打印了两个变量的内存地址
```go
package main
import "fmt"
func showMemoryAddress(age int){
	fmt.Println(&age)
	return
}
func main(){
	height := 100
	fmt.Println(&height)
	showMemoryAddress(height) // 将变量传递给函数
}
```
输出：
```go
0x14000120018
0x14000120030
```
将变量传递给函数时，会分配新内存并将变量的值复制到其中。这样将有两个变量实例，它们位于不同的内存单元中。一般而言，这不可取，因为这将占用更多的内存，同时由于存在变量的多个副本，很容易引入Bug。考虑到这一点，Go提供了指针。

指针是Go语言中的一种类型，指向变量所在的内存单元。要声明指针，可在变量名前加上星号字符。

使用指针传递变量
```go
package main
import "fmt"
func showMemoryAddress(age *int){ // 在类型前加星号，表示这是一个指针类型
	fmt.Println(age)
	return
}
func main(){
	height := 100
	fmt.Println(&height)
	showMemoryAddress(&height) // 使用指针将变量传递给函数
}
```
输出
```go
0x14000120018
0x14000120018
```
- 将传递给showMemoryAddress的值从i改成了&i。i前面的和号&意味着引用的是变量i的值所在的内存地址。
- 将函数showMemoryAddress的第一个参数的类型从int改成了*int。加上星号意味着参数的类型为指向整数的指针，而不是整数。
- 在函数showMemoryAddress中打印变量时，不需要使用和号，因为它本来就是指针。
如果要使用指针指向的变量的值，而不是其内存地址，该怎么办呢？可在指针变量前加上星号。
```go
package main
import "fmt"
func showMemoryAddress(age *int){
	fmt.Println(* age) // 在指针变量前加星号
	return
}
func main(){
	height := 100
	fmt.Println(&height)
	showMemoryAddress(&height) // 使用指针将变量传递给函数
}
```
输出：
```go
100
```
使用星号后，打印的是值而不是内存地址。

# 声明常量
常量指的是在整个程序生命周期内都不变的值。常量初始化后，可以引用它，但不能修改它。
```go
package main
import "fmt"
cont name string = "lisa" // 声明一个常量
func main(){
	fmt.Println(name)
}
```
输出：
> `lisa`

常量不可修改
```go
package main
import "fmt"
cont name string = "lisa" // 声明一个常量
func main(){
	name = "simons"
	fmt.Println(name)
}
```
输出
```error
./main.go:3:1: syntax error: non-declaration statement outside function body
```