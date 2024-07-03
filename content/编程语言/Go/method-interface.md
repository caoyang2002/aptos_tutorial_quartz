---
title: 创建方法和接口
draft: 
aliases:
  - Go方法和接口
date: 2024-07-02
description: Go语言中的方法和接口
tags:
  - Golang
---
# 方法
Go 语言中同时有函数和方法。一个方法就是一个包含了接受者的函数，接受者可以是命名类型或者结构体类型的一个值或者是一个指针。所有给定类型的方法属于该类型的方法集。语法格式如下：
```go
// func (变量名 变量数据结构) 方法名() 返回类型{}
func (variable_name variable_data_type) function_name() [return_type]{
   /* 函数体*/
}
```

方法类似于函数，但有一点不同：在关键字 func 后面添加了另一个参数部分，用于接受单个参数。
```go
func (m *Person) summary() string{
// code 
}
```
请注意，在方法声明中，关键字 `func` 后面多了一个参数 —— `接收者`。严格地说，方法接收者是一种类型，这里是指向结构体 `Person` 的指针。接下来是 `方法名`、`参数` 以及 `返回类型`。除多了包含接收者的参数部分外，方法与函数完全相同。可将接收者视为与方法相关联的东西。通过声明方法 `summary`，让结构体 `Person` 任何实例都可使用它。为何要使用方法，而不直接使用函数呢？例如，下面的函数与前面的方法声明等价。
```go
type Person struct {
　　Name string
　　hight float64
}

func summary(man *Person) string {
　　//code
}
```
函数 `summary` 和结构体 `Person` 相互依赖，但它们之间没有直接关系。例如，如果不能访问结构体 `Person` 的定义，就无法声明函数 `summary`。如果使用函数，则在每个使用函数或结构体的地方，都需包含函数和结构体的定义，这会导致代码重复。另外，函数发生任何改变，都必须随之修改多个地方。这样看来在函数与结构体关系密切时，使用方法更合理。

方法 `summary` 的实现将 `float64` 等级制转换为字符串并设置其格式。使用方法的优点在于，只需编写方法实现一次，就可对结构体的任何实例进行调用。
```go
func (man *Person) summary() string {
　　h := strconv.FormatFloat(man.Hight, 'f', 1, 64)
　　return m.Name + ", " + r
}
```
声明并调用方法
```go
package main
import(
	"fmt"
	"strconv"
)
type Person struct {
	Name string
	Hight float64
}
// 方法
func (man *Person) summary() string{
	h := strconv.FormatFloat(man.Hight,'f',1,64)
	return man.Name + ", " + h
}
func main(){
	man := Person{
		Name: "lisa",
		Hight: 175.2,
	}
	fmt.Println(man.summary())
}
```
输出：
```go
lisa, 175.2
```

示例：
```go
package main

import (
   "fmt"  
)

/* 定义结构体 */
type Circle struct {
  radius float64
}

func main() {
  var c1 Circle
  c1.radius = 10.00
  fmt.Println("圆的面积 = ", c1.getArea())
}

//该 method 属于 Circle 类型对象中的方法
func (c Circle) getArea() float64 {
  //c.radius 即为 Circle 类型对象中的属性
  return 3.14 * c.radius * c.radius
}
```
输出：
```go
圆的面积 =  314
```


# 方法集
方法集是可对特定数据类型进行调用的一组方法。

在Go语言中，任何数据类型都可有相关联的方法集，这让您能够在数据类型和方法之间建立关系，如前面的结构体 `Person` 示例所示。方法集可包含的方法数量不受限制，这是一种封装功能和创建库代码的有效方式。

处理球体时，假设您要计算其表面积和体积。在这种情况下，非常适合使用结构体和方法集。通过使用方法集，您只需创建一次计算代码，就可将其重用于任何球体。要创建这个方法集，可声明结构体 
 `Sphere`，再声明两个将结构体 `Sphere` 作为接收者的方法。

```go
type Sphere struct{
	Radius float64
}
func (s * Sphere) SurfaceArea() float64{
	return float64(4) * math.Pi * (s.Radius * s.Radius)
}
func (s *Sphere) volume() float64{
	radiusCubed := s.Radius * s.Radius * s.Radius
	return (float64(4) / float64(3) * math.Pi * radiusCubed)
}
```
这里声明了计算球体表面积和体积的方法，并像通常那样定义函数签名。唯一不同的是**添加了一个表示接收者的参数**，这里是一个指向 `Sphere` 实例的**指针**。就本章而言，方法使用的公式并不重要，它们都是标准的数学公式。然而，需要指出的是，在方法中可以访问结构体的 `Radius` 值，这是使用点表示法访问的。
```go
package main
import (
	"fmt"
	"math"
)
type Sphere struct{
	Radius float64
}
func (s * Sphere) SurfaceArea() float64{
	return float64(4) * math.Pi * (s.Radius * s.Radius)
}
func (s *Sphere) Volume() float64{
	radiusCubed := s.Radius * s.Radius * s.Radius
	return (float64(4) / float64(3) * math.Pi * radiusCubed)
}
func main(){
	s:= Sphere{
		Radius: 5,
	}
	fmt.Println(s.SurfaceArea())
	fmt.Println(s.Volume())
}
```
输出：
```go
314.1592653589793
523.5987755982989
```
相比于使用函数，使用方法集的优点在于，只需编写一次方法 SurfaceArea 和 Volume。例如，如果发现这两个方法中有一个存在 Bug，则只需修改一个地方即可。
# 使用方法和指针
```go
type Triangle struct{
	width float64
	height float64
}
```
计算三角形的面积
```go
func (t *Triangle) area() float64{
	return 0.5 * (t.width * t.height)
}
```

向方法传递指针
```go
package main
import "fmt"
type Triangle struct{
	width float64
	height float64
}
func (t *Triangle) area() float64{
	return 0.5 * (t.width * t.height)
}
func main() {
	t := Triangle{width: 3,height: 1}
	fmt.Print(t.area())
}
```
输出：
```go
1.5
```
为理解将接收者参数声明为指针引用和值引用的差别，我们来看一个简单的示例，它修改结构体中定义的三角形的底值。假设要修改三角形的底值，可使用方法 `changeBase` 来实现。
```go 
func (t Triangle) changeBase(f float64){ // Triangle 前没有 * 号，接受的是参数值而不是指针
	t.base = f
}
```

向方法传递值引用
```go
package main
import "fmt"
type Triangle struct{
	base float64
	height float64
}
func (t Triangle) changeBase(f float64){ // Triangle 前没有 * 号，接受的是参数值而不是指针
	t.base = f
}
func main() {
	t := Triangle{bash: 3,height: 1}
	t.changeBase(4)
	fmt.Print(t.base)
}
```
输出：
```go
3
```
> 之所以打印的是 3，是因为方法 `changeBase` 接受的是一个 `值引用`。这意味着这个方法操作的是结构体 `Triangle` 的**副本**，而原始结构体不受影响。
> 
> 在方法 `changeBase` 中，修改的是原始 `Triangle` 结构体的副本的 `t.base`。


将指针作为接收者的方法能够修改原始结构体的数据字段，这是因为它使用的是指向原始结构体内存单元的指针，因此操作的不是原始结构体的副本。

修改原始结构体的数据字段
```go
package main
import "fmt"
type Triangle struct{
	base float64
	height float64
}
func (t *Triangle) changeBase(f float64){
	t.base = f
	return
}
func main(){
	t := Triangle{base: 3, height: 1}
	t.changeBase(4)
	fmt.Println(t.base)
}
```
输出：
```go
4
```

# 接口
>Go 语言提供了另外一种数据类型即接口，它把所有的具有共性的方法定义在一起，任何其他类型只要实现了这些方法就是实现了这个接口。

接口可以让我们将不同的类型绑定到一组公共的方法上，从而实现多态和灵活的设计。

Go 语言中的接口是隐式实现的，也就是说，如果一个类型实现了一个接口定义的所有方法，那么它就自动地实现了该接口。因此，我们可以通过将接口作为参数来实现对不同类型的调用，从而实现多态。

在Go语言中，接口指定了一个方法集，这是实现模块化的强大方式。您可将接口视为方法集的蓝本，它描述了方法集中的所有方法，但没有实现它们。接口功能强大，因为它充当了方法集规范，这意味着可在符合接口要求的前提下随便更换实现。

接口描述了方法集中的所有方法，并指定了每个方法的函数签名。下面的示例假设需要编写一些控制机器人（Robot）的代码。

>假定有多种类型的机器人，控制这些机器人行为的方式存在细微的差别。
>
>给定这个编程任务，您可能认为需要为每种机器人编写不同的代码。
>
>通过使用接口，可将代码重用于有相同行为的实体。就这个机器人示例而言，下面的接口描述了开关机器人的方式。

```go
type Robot interface{
	PowerOn() err
}
```
接口 `Robot` 只包含一个方法 —— `PowerOn`。这个接口描述了方法 `PowerOn` 的函数签名：不接受任何参数且返回一种错误类型。从高级层面说，接口还有助于理解代码设计。在无须关心实现的情况下，很容易理解设计是什么样的。

那么如何使用接口呢？接口是方法集的蓝本，要使用接口，必须先实现它。如果代码满足了接口的要求，就实现了接口。要实现接口Robot，可声明一个满足其要求的方法集。
```go
type T850 struct{
	Name string
}
func (a *T850) PowerOn(0) err{
	return nil
}
```
这个实现很简单，但满足了接口 `Robot` 的要求，因为它包含方法 `PowerOn`，且这个方法的函数签名与接口 `Robot` 要求的一致。接口的强大之处在于，它们支持多种实现。例如，您也可以像下面这样来实现接口Robot。
```go
type R2D2 struct {
　　Broken bool
}

func (r *R2D2) PowerOn() err {
　　if r.Broken {
　　　　return errors.New("R2D2 is broken")
　　} else {
　　　　return nil
　　}
}
```

这也满足了接口 Robot 的要求，因为它符合这个方法集的定义——包含方法 `PowerOn`，同时函数签名也相同。请注意，这里与方法集相关联的结构体为 `R2D2`，它包含的数据字段与 `T850` 不同，方法 `PowerOn` 的代码也完全不同，但函数签名一样。

要满足接口的要求，只要实现了它指定的方法集，且函数签名正确无误就可以了。

当前，接口 Robot 有两种实现，虽然有相同的 Robot 定义很有用，但没有可同时用于 `T850` 和 `R2D2` 实例的代码。接口也是一种类型，可作为参数传递给函数，因此可编写可重用于多个接口实现的函数。

例如，编写一个可用于启动任何机器人的函数。
```go
func Boot(r Robot) error {
	return r.PowerOn
}
```
这个函数将接口Robot的实现作为参数，并返回调用方法 `PowerOn` 的结果。这个函数可用于启动任何机器人，而不管其方法 `PowerOn` 是如何实现的。`T850` 和 `R2D2` 都可利用这个方法。

使用接口Robot
```go
package main
import (
	"errors"
	"fmt"
)
type Robot interface{
	PowerOn() error
}
type T850 struct {
	Name string
}
func (a *T850) PowerOn() error{
	return nil
}
type R2D2 struct{
	Broken bool
}
func (r *R2D2) PowerOn() error {
　　if r.Broken {
　　　　return errors.New("R2D2 is broken")
　　} else {
　　　　return nil
　　}
}
func Boot(r Robot) error {
	return r.PowerOn()
}

func main(){
	t := T850{
		Name:"The Terminator",
	}
	r := R2D2{
		Broken: true,
	}
	err := Boot(&r)
	if err != nil{
		fmt.Println(err)
	}else{
		fmt.Println("Robot is powered on!")
	}
	err = Boot(&t)
	if err != nil{
		fmt.Println(err)
	}else{
		fmt.Println("Robot is powered in!")
	}
}
```
输出：
```go
R2D2 is broken
Robot is powered in!
```


使用接口：
```go
package main

import (
    "fmt"
)

type Phone interface {
    call()
}

type NokiaPhone struct {
}

func (nokiaPhone NokiaPhone) call() {
    fmt.Println("I am Nokia, I can call you!")
}

type IPhone struct {
}

func (iPhone IPhone) call() {
    fmt.Println("I am iPhone, I can call you!")
}

func main() {
    var phone Phone

    phone = new(NokiaPhone)
    phone.call()

    phone = new(IPhone)
    phone.call()

}
```
输出：
```go
I am Nokia, I can call you!
I am iPhone, I can call you!
```

使用接口
```go
package main

import "fmt"

type Shape interface {
    area() float64
}

type Rectangle struct {
    width  float64
    height float64
}

func (r Rectangle) area() float64 {
    return r.width * r.height
}

type Circle struct {
    radius float64
}

func (c Circle) area() float64 {
    return 3.14 * c.radius * c.radius
}

func main() {
    var s Shape

    s = Rectangle{width: 10, height: 5}
    fmt.Printf("矩形面积: %f\n", s.area())

    s = Circle{radius: 3}
    fmt.Printf("圆形面积: %f\n", s.area())
}
```
输出：
```go
矩形面积: 50.000000
圆形面积: 28.260000
```