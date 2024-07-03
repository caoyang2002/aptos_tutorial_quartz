---
title: 使用函数
draft: 
aliases:
  - 使用函数
date: 2024-07-02
description: Go 语言的中的函数
tags:
  - Golang
---
> 函数接受输入并返回输出。数据流经函数时，将被变换。一个典型的示例是将两个数相加的简单函数，它接受两个数字，将它们相加并返回结果。在这个简单示例中，接受的两个数字被称为输入，相加得到的结果被称为输出。
```go
func addUp(x int, y int) int {
　　return x + y
}
```

# 函数的结构
有返回值
```go
函数关键字 函数签名(变量名 变量类型 [, 变量名 变量类型]) 返回值类型 {
	函数体
	返回关键字
}
```
没有返回值
```go
函数关键字 函数签名(变量名 变量类型 [, 变量名 变量类型]){
	函数体
}
```

示例：判断奇偶
```go
func isEven(number int) bool {
	return number%2 == 0 // 模运算， number ÷ 2 返回余数
}
```

# 调用函数
```go
package main
import "fmt"

func isEven(number int) bool {
	return number%2 == 0 // 模运算， number ÷ 2 返回余数
}

func main(){
	fmt.Println("%v\n",isEvent(1))
	fmt.Println("%v\n",isEvent(2))
}
```
输出：
```go
%v
 false
%v
 true
```

# 返回多个值
```go
package main
import "fmt"
// 返回多个值的函数
func getPerson() (int, string){
	age := 12
	name := "lisa"
	return age,name
}
func main(){
	age,name := getPerson()
	fmt.Println("My name is %v, and I am %v years old.\n",name,age)
}
```
输出：
```go
My name is lisa, and I am 12 years old.
```

# 定义不定参数函数
定参数函数是参数数量不确定的函数。通俗地说，这意味着它们接受可变数量的参数。在Go语言中，能够传递可变数量的参数，但它们的类型必须与函数签名指定的类型相同。要指定不定参数，可使用3个点 `…` 

函数签名指定函数可接受任意数量的 `int`参数
```go
package main
import "fmt"
// 不定参数函数
func sumNumbers(numbers...int)int{ // 使用 ...
	 total := 0
	 for _,number := range numbers {
		 total += number
	}
	return total
}
func main(){
	result := sumNumbers(1,2,3,4)
	fmt.Printf("The resule is %v\n",result)
}
```

输出：
```go
The resule is 10
```

# 使用具名返回值
具名返回值让函数能够在返回前将值赋给具名变量，这有助于提升函数的可读性，使其功能更加明确。要使用具名返回值，可在函数签名的返回值部分指定变量名。

```go
package main
import "fmt"
func sayHi() (x, y string) {
	x = "hello"
	y = "world"
	return
}
func main(){
	fmt.Println(sayHi())
}
```
这个 `sayHi()` 函数中，在终止语句 `return` 前给具名变量进行了赋值。使用具名返回值时，无须显式地返回相应的变量。这被称为裸（naked）return 语句。

调用 `sayHi()` 函数时，将按声明顺序返回具名变量。


输出：
```go
hello world
```

# 递归函数
递归函数虽然是一个简单的概念，却也是一个功能强大的编程元素。递归函数是不断调用自己直到满足特定条件的函数。要在函数中实现递归，可将调用自己的代码作为终止语句中的返回值。
```go
package main
import "fmt"
func feedMe(portion int, eaten int) int {
    eaten = portion + eaten
    if eaten >= 5 { // 大于等于 5 时结束调用自己
        fmt.Printf("I'm full! I've eaten %d\n", eaten)
        return eaten
    }
    fmt.Printf("I'm still hungry! I've eaten %d\n", eaten)
    return feedMe(portion, eaten) // 没有返回值，而是调用自己
}
func main(){
	feedMe(1,0)
}
```
输出：
```go
I'm still hungry! I've eaten 1
I'm still hungry! I've eaten 2
I'm still hungry! I've eaten 3
I'm still hungry! I've eaten 4
I'm full! I've eaten 5
```

# 将函数作为值传递
Go语言提供了一些函数式编程功能，如能够将一个函数作为参数传递给其他函数。这看起来像《盗梦空间》中的情形，但提供了强大的功能。从本质上说，Go将函数视为一种类型，因此可将函数赋给变量，以后再通过变量来调用它们。在下面的示例中，将一个函数赋给了变量fn。
```go
package main
import "fmt"
func main(){
	fn := func() {
		fmt.Println("function called")
	}
	fn()
}
```
输出：
```go
function called
```
使用简短变量赋值运算符将一个**函数赋给了变量 `fn`**。声明这个函数并将其定义为打印一行文本，让您知道它被调用了。在变量名 `fn` 后使用 `()` 调用这个函数。

别忘了，在 Go 语言中，函数是一种**类型**，因此可将其传递给其他函数。我们可对前一个示例进行扩展，将变量 `fn` 传递给一个函数，并在这个函数中调用它。
```go
package main
import "fmt"
func anotherfunxtion(f func() string) string {// 签名中包含一个子函数签名，这表明这个参数是一个返回字符串的函数。接受函数依然需要声明其返回类型，它可以是任何类型，但这里也是字符串。
	return f()
}
func main(){
	fn := func() string{
		return "function called"
	}
	fmt.Println(anotherFunction(fn))
}

```
输出：
```go
function called
```