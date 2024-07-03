---
title: 结构体和指针
draft: 
aliases:
  - Go 结构体
date: 2024-07-02
description: Go 语言中的结构体
tags:
  - Golang
---
# 结构体
结构体是一系列具有指定数据类型的数据字段，它能够让您通过单个变量引用一系列相关的值。通过使用结构体，可在单个变量中存储众多类型不同的数据字段。存储在结构体中的值可轻松地访问和修改，这提供了一种灵活的数据结构创建方式。通过使用结构体，可提高模块化程度，还能够让您创建并传递复杂的数据结构。

您还可将结构体视为用于创建数据记录（如员工记录和机票预订）的模板。
```go
package main
import "fmt"
// type关键字 类型名 struct数据类型
type Person struct{ 
	Name string
	Age int
}
func main(){
	man := Person{
		Name: "Lisa",
		Age: 20,
	}
	fmt.Println(man.Name,man.Age)
}
```
输出：
```go
Lisa 20
```
- 关键字 `type` 指定一种新类型。
- 将新类型的名称指定为 `Movie`
- 类型名右边是数据类型，这里为结构体。
- 在大括号内，使用名称和类型指定了一系列数据字段。请注意，此时没有给数据字段赋值。可将结构体视为**模板**。
- 在 main 函数中，使用简短变量赋值声明并初始化了变量 man，给数据字段指定的值为相应的数据类型。
- 使用点表示法访问数据字段并将其打印到控制台。

```go
package main
import "fmt"
type Person struct{
	Name string
	Age int
}
func main(){
	var man  Person
	// 这将创建一个结构体实例，并将各个数据字段设置为相应数据类型的零值。
	//可使用占位符%+v并将其传入结构体，以调试或查看结构体的值。
	fmt.Printf("%+v\n",man)
}
```
输出：
```go
{Name: Age:0}
// 没有给字段赋值，因此它们默认为零值。对于字符串，零值为空字符串" "；对于float32，零值为0。
```
使用点表示法给字段赋值
```go
package main
import "fmt"
type Person struct{
	Name string
	Age int
}
func main(){
	var man  Person
	man.Name = "lisa"
	man.Age = 22
	fmt.Printf("%+v\n",man)
}
```
输出：
```go
{Name:lisa Age:22}
```

也可使用关键字 new 来创建结构体实例。

关键字new创建结构体Movie的一个实例（为其分配内存）；将这个结构体实例赋给变量 man 后，就可像前面那样使用点表示法给数据字段赋值了。
```go 
package main
import "fmt"
type Person struct{
	Name string
	Age int
}
func main(){
	man := new(Person)
	man.Name = "lisa"
	man.Age = 22
	fmt.Printf("%+v\n",man)
}
```
输出：
```go
&{Name:lisa Age:22}
```

还可使用简短变量赋值来创建结构体实例，此时可省略关键字 new。创建结构体实例时，可同时给字段赋值，方法是使用字段名、冒号和字段值。
```go
package main
import "fmt"
type Person struct{
	Name string
	Age int
}
func main(){
	man := Person{Name: "lisa",Age: 22}
	fmt.Printf("%+v\n",man)
}
```

也可以省略字段名
```go
package main
import "fmt"
type Person struct{
	Name string
	Age int
}
func main(){
	man := Person{"lisa",22}
	fmt.Printf("%+v\n",man)
}
```
字段很多时，让每个字段独占一行能够提高代码的可维护性和可读性。请注意，如果您选择这样做，则最后一个数据字段所在的行也必须以逗号结尾。
```go
package main
import "fmt"
type Person struct{
	Name string
	Age int
}
func main(){
	man := Person {
　　Name:　"Lisa",
　　Age:　10,
}
	fmt.Printf("%+v\n",man)
}
```


# 嵌套结构体
```go
package main
import "fmt"
type Superhero struct {
	Name string
	Age int
	Address Address // 嵌套结构体
}
type Address struct{
	Number int
	Street string
	City string
}

func main(){
	man := Superhero{
		Name: "Lisa",
		Age: 22,
		Address: Address{
			Number: 1001,
			Street: "Cheng Long Da Dao",
			City: "Cheng Du",
		},
	}
	fmt.Printf("%+v\n",man)
	fmt.Println(e.Address.Street)
}
```
>要访问内嵌结构体的数据字段，可使用点表示法，这意味着使用结构体变量名、圆点、数据字段名、圆点和内嵌数据字段名。

输出：
```go
{Name:Lisa Age:22 Address:{Number:1001 Street:Cheng Long Da Dao City:Cheng Du}}
Cheng Long Da Dao
```

# 自定义结构体的默认值

| 类型           | 零值    |
| ------------ | ----- |
| Boolean 布尔   | false |
| Integer 整型   | 0     |
| Float 浮点     | 0.0   |
| String 字符串   | ""    |
| Pointer 指针   | nil   |
| Function 函数  | nil   |
| Interface 接口 | nil   |
| Slice 切片     | nil   |
| Channel 通道   | nil   |
| Map 映射       | nil   |

创建结构体时，如果没有给其数据字段指定值，它们将为表7.1所示的零值。Go语言没有提供自定义默认值的内置方法，但可使用构造函数来实现这个目标。构造函数创建结构体，并将没有指定值的数据字段设置为默认值。

```go
package main
import "fmt"
type Person struct{
	Name string
	Age int
}
func newPerson(name string) Person{
	man := Person{
		Name: name,
		Age: "22",
	}
	return man
}

func main(){
	fmt.Printf("%+v\n",newPerson("Lisa"))
}
```
输出：
```go
{Name:Lisa Age:22}
```

# 比较结构体
```go
package main
import "fmt"
type Drink struct{
	Name string
	Ice bool
}
func main(){
	lemo1 := Drink{
		Name: "Lemonade",
		Ice: true,
	}
	lemo2 := Drink{
		Name: "Lemonade",
		Ice: true,
	}
	if lemo1 == lemo2 {
		fmt.Println("lemo1 and lemo2 are the same")
	}
	fmt.Printf("%+v\n",lemo1)
	fmt.Printf("%+v\n",lemo2)
}
```
输出：
```go
lemo1 and lemo2 are the same
{Name:Lemonade Ice:true}
{Name:Lemonade Ice:true}
```
>[!WARNING]
>不能对两个类型不同的结构体进行比较，否则将导致编译错误。因此，试图比较两个结构体之前，必须确定它们的类型相同。要检查结构体的类型，可使用Go语言包reflect。在程序清单7.8中，使用了reflect包来检查结构体的类型。

示例：检查结构体的类型
```go
package main
import(
	"fmt"
	"reflect"
)
type Drink struct{
	Name string
	Ice bool
}
func main(){
	lemo1 := Drink{
		Name: "Lemonade",
		Ice: true,
	}
	lemo2 := Drink{
		Name: "Lemonade",
		Ice: true,
	}
	fmt.Println(reflect.TypeOf(lemo1))
	fmt.Println(reflect.TypeOf(lemo2))
}
```
输出：
```go
main.Drink
main.Drink
```

# 理解共有和私有值
如果您熟悉其他编程语言，可能明白公有和私有数据的概念。
- 如果一个值被导出，可在函数、方法或包外面使用，那么它就是公有的；
- 如果一个值只能在其所属上下文中使用，那么它就是私有的。
根据Go语言约定，结构体及其数据字段都可能被导出，也可能不导出。如果一个**标识符的首字母是大写**的，那么它将被**导出**；否则不会导出。
要导出结构体及其字段，结构体及其字段的名称都必须以大写字母开头。

# 区分指针应用和值引用
数据值存储在计算机内存中。指针包含值的内存地址，这意味着使用指针可读写存储的值。创建结构体实例时，给数据字段分配内存并给它们指定默认值；然后返回指向内存的指针，并将其赋给一个变量。使用简短变量赋值时，将分配内存并指定默认值。
```go
a := Drink{}
```

复制结构体时，明确内存方面的差别很重要。将指向结构体的变量赋给另一个变量时，被称为赋值。
```go
a := b
```
赋值后，a 与 b 相同，但它是 b 的**副本**，而不是指向 b 的引用。修改 b 不会影响 a，反之亦然。

## 以值引用的方式复制结构体
```go
package main
import "fmt"
type Drink struct{
	Name string
	Ice bool
}
func main(){
	lemo1 := Drink{
		Name: "Lemonade",
		Ice: true,
	}
	lemo2 := lemo1
	lemo2.Ice = false
	fmt.Printf("%+v\n",lemo1)
	fmt.Printf("%+v\n",lemo2)
	fmt.Printf("%p\n",&lemo1)
	fmt.Printf("%p\n",&lemo2)
}
```
输出：
```go
{Name:Lemonade Ice:true}
{Name:Lemonade Ice:false}
0x1400000c018
0x1400000c030
```
> 修改 lemo2 不会影响 lemo1

要修改原始结构体实例包含的值，必须使用指针。指针是指向内存地址的引用，因此使用它操作的不是结构体的副本而是其本身。要获得指针，可在变量名前加上和号。可对程序清单7.9进行修改，以使用指针引用而不是值引用，如程序清单7.10所示。

## 以指针引用的方式复制结构体
```go
package main
import "fmt"
type Drink struct{
	Name string
	Ice bool
}
func main(){
	lemo1 := Drink{
		Name: "Lemonade",
		Ice: true,
	}
	lemo2 := &lemo1
	lemo2.Ice = false
	fmt.Printf("%+v\n",lemo1)
	fmt.Printf("%+v\n",*lemo2)
	fmt.Printf("%p\n",&lemo1)
	fmt.Printf("%p\n",lemo2)
}
```
输出：
```go
{Name:Lemonade Ice:false}
{Name:Lemonade Ice:false}
0x1400000c018
0x1400000c018
```
>[!NOTE]
>指针和值的差别很微妙，但选择使用指针还是值很容易区分：如果需要修改原始结构体实例，就使用指针；如果要操作一个结构体，但不想修改原始结构体实例，就使用值。
