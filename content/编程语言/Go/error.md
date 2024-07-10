---
title: 处理错误
draft: 
aliases:
  - 处理错误
date: 2024-07-02
tags:
  - Golang
description: Go 语言中的错误处理
cssclasses:
  - none
---
在 Go 语言中，一种约定是在调用可能出现问题的方法或函数时，返回一个类型为错误的值。这意味着如果出现问题，函数通常不会引发异常，而让调用者决定如何处理错误。

读取文件时处理错误
```go
package main
import(
	"fmt"
	"io/ioutil"
)
func main(){
	file,err := ioutil.ReadFile("filename.txt")
	if err != nil{
		fmt.Println(err)
		return
	}
	fmt.Println("%s",file)
}
```
输出（`filename.txt` 确实文件不存在）：
```go
open filename.txt: no such file or directory
```
这个示例包含的代码不多，却展示了Go语言对错误的众多看法。
•  使用标准库中 `io/ioutil` 包内的函数 `ReadFile` 读取文件。
•  如果有错误，就意味着返回的错误值不为 `nil`。
•  打印错误，程序就此结束。
•  如果没有错误，就打印文件的内容。
要理解 Go 语言处理错误的方式，最重要的是明白函数 `ReadFile`接受一个字符串参数，并返回一个字节切片和一个错误值。这个函数的定义如下。
```go
// 接收(一个字符串参数)      返回(字节切片, 错误值)
func ReadFile(filename string) ([]byte, error)
```
这意味着函数 `ReadFile` 总是会返回一个错误值，可对其进行检查。在前述示例的 `main` 函数中，将方法 `ReadFile` 的返回值存储到了两个变量（`file` 和 `err`）中，这是 `Go` 代码中常见的模式，您经常会见到。
```go
file, err := ioutil.ReadFile("filename.txt")
```

语法 `:=` 是Go语言中的简短赋值语句，只能在函数中使用。Go编译器会自动推断出变量的类型，而无须显式地声明，因此这里无须告诉编译器 `file` 是一个字节切片，而 `err` 是一个错误。这提供了极大的便利，前述代码与下面的代码等价。
```go
var file []byte
var err error
file, err = ioutil.Readfile("filenaem.txt")
```
在Go语言中，有一种约定是，如果没有发生错误，返回的错误值将为 `nil`。这让程序员调用方法或函数时，能够检查它是否像预期那样执行完毕。
```go
if err != nil {
　　// something went wrong
}
```
在 Go 程序中，这种做法很常见。有些开发人员认为，这种做法很繁琐，因为它要求调用每个方法或函数时都检查错误，导致代码重复。

这说得也许没错，但 Go 语言处理错误的方式比其他语言更灵活，因为可像其他类型一样在函数之间传递错误。这通常意味着代码要简短得多。如果您要更深入地了解这一点，可阅读 Rob Pike 的博文[《Errors are Values》](https://go.dev/blog/errors-are-values)。[[../../杂文/Errors are values|错误就是值]]

# 理解错误类型
在Go语言中，错误是一个值。标准库声明了接口 error，如下所示。
```go
type error interface {
　　Error() string
}
```
这个接口只有一个方法——Error，它返回一个字符串。

# 创建错误
创建并打印错误
```go
package main
import(
	"fmt"
	"errors"
)
func main(){
	err := errors.New("出现了一些错误")
	if err != nil{
		fmt.Println(err)}
}
```
输出：
```error
出现了一些错误
```

# 设置错误的格式
除 errors 包外，标准库中的 fmt 包还提供了方法 Errorf，可用于设置返回的错误字符串的格式。这能够让您将多个值合并成更有意义的错误字符串，从而动态地创建错误字符串。

使用fmt包设置错误字符串的格式
```go
package main
import "fmt"
func main(){
	name,role := "Richard Jupp","Drummer"
	err := fmt.Errorf("The %v %v quit",role,name)
	if err != nil{
		fmt.Println(err)
	}
}
```
输出：
```error
The Drummer Richard Jupp quit
```

# 从函数返回错误
```go
package main
import "fmt"
func Half(numberToHalf int)(int, error){
	if numberToHalf % 2 != 0{
		return -1, fmt.Errorf("Cannot half %v",numberToHalf)
	}
	return numberToHalf / 2,nil
}
func main(){
	n, err := Half(19)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(n)
}
```
输出：
```go
Cannot half 19
```
>[!NOTE]
>这个示例演示了Go语言错误处理方式的一个优点：错误处理不是在函数中，而是在调用函数的地方进行的。这在错误处理方面提供了极大的灵活性，而不是简单地一刀切。

# 错误和可用性
## 慎用 panic
panic 是 Go 语言中的一个内置函数，它终止正常的控制流程并引发恐慌（panicking），导致程序停止执行。出现普通错误时，并不提倡这种做法，因为程序将停止执行，并且没有任何回旋余地。
```go
package main
import "fmt"
func main(){
	fmt.Println("正在运行...")
	panic("我出错了")
	fmt.Println("没有运行了")
}
```
输出：
```go
正在运行...
panic: 我出错了
goroutine 1 [running]:
main.main()
/Users/caoyang/Desktop/GitHub/Learning-Coding/go/project/main.go:5 +0x68
exit status 2
```
>[!WARNING]
>f程序出现错误，进而导致崩溃

在Go代码中，常常滥用下面的做法，这实际是说：朋友，咱们无路可走，只能让程序崩溃了。在有些情况下，这样做是合适的，但通常不应这样做。
```go
if err != nil {
　　panic(err)
}
```

在下面的情形下，使用panic可能是正确的选择。
•  程序处于无法恢复的状态。这可能意味着无路可走了，或者再往下执行程序将带来更多的问题。在这种情况下，最佳的选择是让程序崩溃。
•  发生了无法处理的错误。

>[!TIP]
>“可对值进行编程，而错误是值，因此可对错误进行编程。错误不像异常，因为错误没什么特别之处，而未处理的异常可能导致程序崩溃。”
>
>-- Rob Pike
