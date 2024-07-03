---
title: 控制流
draft: 
aliases:
  - 控制流
date: 2024-07-02
description: Go 语言中的控制流
tags:
  - Golang
---
# if
```go 
package main
import "fmt"
func main(){
	condition := true
	if condition{ // 判断变量 condition 是否为 true
		fmt.Println("condition is true")
	}
}
```
输出：
```go
condition is true
```

# if  else
```go
package main
import "fmt"
func main(){
	condition := false
	if condition {
		fmt.Println("condition is true")
	} else {
		fmt.Println("condition is false")
	}
}
```
输出：
```go
condition is false
```

# if  else if
```go
package main
import "fmt"
func main(){
	age := 22
	if age == 18{
		fmt.Println("age is 18")
	} else if age == 18 {
		fmt.Println("age is 22")
	}
}
```
输出：
```go
age is 22
```

# switch
`switch` 语句可用来替代冗长的 `if else` 布尔比较。

出于对代码可读性的考虑，很多程序员都喜欢使用 switch 语句（而不使用 if else 语句），从编译层面上说，这样的代码效率也可能更高。除少量的 if else 比较外，其他的都可替换为 switch 语句，这样不仅可提高代码的可读性，还可**提高其性能**。

比较的变量类型必须一致
```go
package main
import "fmt"
func main(){
	age := 2
	switch age {
		case 1:
			fmt.Println("one")
		case 2:
			fmt.Println("two")
		case 3:
			fmt.Println("three")
	}
}
```
输出：
```go
two
```
相比于 `else if` 条件，`switch` 语句更简洁，它还支持在其他 `case` 条件都不满足时将执行的 `default case` 。在 `switch` 语句中，可使用关键字 `default` 来指定其他 `case` 条件都不满足时要执行的代码。`default case` 通常放在 `switch` 语句末尾，但也可将其放在任何其他地方。

在switch语句中使用default case
```go
package main
import "fmt"
func main(){
	age := 4
	switch age {
		case 1:
			fmt.Println("one")
		case 2:
			fmt.Println("two")
		case 3:
			fmt.Println("three")
		default:
			fmt.Println("No!")
	}
}
```
输出：
```go
No!
```

# for
```go
package main
import "fmt"
func main(){
	age := 16
	for age < 20{
		fmt.Println(age)
		age++
	}
}
```
输出：
```go
16
17
18
19
```


## 包含初始化语句和后续语句的 for
```go
package main
import "fmt"
func main(){
	for age := 16; age < 20; i++{
		fmt.Println(age)
	} 
}
```
输出：
```go
16
17
18
19
```
## 包含 range 子句的 for
`for` 语句也可用来遍历数据结构。
```go
package main
import "fmt"
func main(){
	numbers := []int{1,2,3,4} // 声明变量 numbers，并将一个包含 4 个整数的数组赋给它。
	for i,n := range numbers{ 
	// for语句指定了迭代变量 i，用于存储索引值。这个变量将在每次迭代结束后更新。
	// for语句指定了迭代变量 n，用于存储来自数组中的值。它也将在每次迭代结束后更新。
		fmt.Println("The index of the loop is ",i) // 在循环中，打印这两个变量的值。
		fmt.Println("The value from the slice is ",n)}
}
```

输出：
```go
The index of the loop is  0
The value from the slice is  1
The index of the loop is  1
The value from the slice is  2
The index of the loop is  2
The value from the slice is  3
The index of the loop is  3
The value from the slice is  4
```
>在Go语言中，可使用包含 range 子句的 for 语句来遍历大多数数据结构，且无须知道数据结构的长度。
>
>迭代变量从 0 开始，且每次都加 1。要在特定的迭代中执行操作，务必从0而不是1开始计算迭代数！

# defer 
`defer` 是一个很有用的 Go 语言功能，它能够让您**在函数返回前执行另一个函数（defer）**。函数在遇到return语句或到达函数末尾时返回。defer语句通常用于执行清理操作或确保操作（如网络调用）完成后再执行另一个函数。

多条defer语句按相反的顺序执行。这意味着离函数末尾最近的defer语句最先执行。
```go
package main
import "fmt"
func main(){
	defer fmt.Println("I am run after the function completes")
	fmt.Println("Helle World!")
}
```
- 使用一条defer语句，在它所在的函数执行完毕后执行另一个函数（defer）。defer 被认为是一个内部函数。
- 向终端打印 Hello World!，外部函数就此结束。
- 外部函数结束后，执行 defer 语句指定的函数。

输出：
```go
Helle World!
I am run after the function completes
```

多个 defer
```go
package main
import "fmt"
func main(){
	defer fmt.Println("I am run first the function completes")
	defer fmt.Println("I am run second the function completes")
	defer fmt.Println("I am run third the function completes")
	fmt.Println("Helle World!")
}
```
外部函数执行完毕后，按与defer语句出现顺序相反的顺序执行它们指定的函数。
> 输出
```go
　Hello World!
　I am the third defer statement
　I am the second defer statement
　I am the first defer statement
```