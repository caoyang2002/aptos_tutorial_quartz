---
title: Go 语言命名约定
---
# Go 代码格式设置
代码格式设置指的是如何在文件中设置代码的格式。具体地说，它指的是如何缩进代码以及如何使用回车。在代码格式设置方面，Go语言没有强制的约定，但存在被整个Go社区广泛采用并遵循的事实标准。

这些Go代码完全合法，能够编译并执行，但您觉得它们易于阅读吗？
```go
package main　　　 ; import "fmt";
func main() { fmt.Println("Hello World")}
```
代码格式设置风格是一个常常在程序员之间引起争论的主题，在大多数情况下，这些争论都让人专注于格式而不是代码。另外，对使用不同风格编写的代码库进行维护时，可能导致代码晦涩难懂、在合并请求方面出现争议甚至引入错误。例如，JavaScript在语法方面非常宽松，常常在该如何编写代码方面引发争议。在Node.js中，下述导入模块的方式都合法。
```js
var http = require("http");
var crypto = require("crypto");

var http = require("http")
　, crypto = require("crypto")

var http = require("http"),
　　crypto = require("crypto");
```
虽然Node.js社区进行了一些标准化，但经常能在项目中同时看到这3种风格。在很多情况下，给开源项目贡献的代码都没有遵循大家普遍接受的约定，需要重新设置它们的格式。可能令人难以置信的是，这种与代码无关的问题常常会给项目带来麻烦。

在代码格式设置方面，Go语言采取了实用而严格的态度。Go语言指定了格式设置约定，这种约定虽然并非强制性的，但命令gofmt可以实现它。虽然编译器不要求按命令 `gofmt` 指定的那样设置代码格式，但几乎整个Go社区都使用 `gofmt`，并希望按这个命令指定的方式设置代码格式。

对于这种格式设置方面的默认选择，有些程序员最初很不满意，但实际上，在官方代码中做出这样的选择，对大家来说意味着解放，因为这样开发小组就无须花时间去讨论哪种风格是正确的，进而制定风格指南了。强烈建议您按Go语言约定设置代码的格式。

# 使用 gofmt
为确保按要求的约定设置Go代码的格式，Go提供了 `gofmt`。这个工具的优点在于，让您甚至都无须了解代码格式设置约定。通过不断地学习如何设置代码格式，您自然而然地就会遵循代码格式设置约定。

使用工具gofmt来设置其格式，使其遵循代码格式设置约定。对文件运行 `gofmt` 时，将把结果打印到标准输出，但不修改原来的文件。
```bash
go fmt
```
输出（格式化的文件名）：
```go
temperature.go
temperature_test.go
```

# 配置文本编辑器
很多文本编辑器都有第三方Go插件，它们在您保存文件时自动运行 `gofmt` 以校正格式设置。在这些工具中，很多都会正确地配置文本编辑器，使其像Go语言约定要求的那样使用制表符而不是空格来缩进。通过在文本编辑器中使用插件，可自动使用诸如 `gofmt` 等工具。
- Vim(vim-go)
- Emacs(go.mode.el)
- Sublime(GoSublime)
- Atom(go-plus)
- Eclipse(goclipse)
- Visual Studio(vscode-go)
在这些插件中，很多不仅支持简单的格式设置，还能够让开发人员直接在文本编辑器中构建、测试和运行代码。虽然编写Go代码时并非必须使用这些插件，但使用它们可提高效率，因此建议了解有哪些Go插件可用于您使用的文本编辑器。

# 命名约定
据说在计算机科学中，最难的两件事是缓存和命名。虽然这种说话不能当真，但清晰的命名可提高代码的可读性和可维护性。在Go语言中，有些约定是编译器要求必须遵循的，而有些是否遵循由程序员决定。像其他程序员那样遵循Go语言约定有助于您成为Go社区中的良好公民。就命名而言，以大写字母打头的标识符将被导出，而以小写字母打头的不会。
```go
var Name := "bar" // 会被导出
var name := "bar" // 不会被导出
```

很多其他语言也有有关公有和私有变量方面的约定，如使用下划线表示私有变量。在Go语言中，不应使用这些约定，而应遵循大小写约定。

就如何给变量命名方面，所有程序员达成一致的可能性不大，但只要采用一致的方式，这个答案就不那么重要了。在Go语言中，对于包含多个单词的变量名，约定是使用骆驼拼写法或帕斯卡拼写法，具体使用哪种拼写法，取决于变量是否需要导出。
```go
var fileName // Camel Case
var FileName // Pascal Case
```
在Go程序中，经常使用指出了数据类型的简短变量名，这让程序员能够专注于逻辑而不是变量。在这种情况下，`i` 表示整型（Integer）数据类型，`s` 表示字符串数据类型，等等。一开始，您可能觉得这样做不好，但时间久了就会习惯这种被普遍接受的约定。
```go
var i int = 3
var s string = "hello"
var b bool = true
```
良好的命名还可提高代码的可读性。第4章介绍了函数签名，而第8章介绍了方法。等您熟悉函数签名的工作原理后，使用良好的方式给函数和方法命名可让其代码的含义不言自明。请看下面两个函数签名。
```go
func a(f float64) float64
func (t *Triangle) Area() float64
```
在第一个函数签名中，函数和变量名更简洁，但仅根据函数签名难以确定函数是做什么的。第二个是一个方法，给方法和接收者参数都指定了贴切的名称。显然，这个方法是用于三角形的！方法名也明确地指出了它是做什么的。只需通过接收者参数和方法的名称，您就立即能够知道它计算三角形的面积。

接口是具名的方法签名集合。在Go源代码中，接口名通常是这样得到的：在动词后面加上后缀er，形成一个名词。后缀er通常表示操作，因此这种命名方式表示操作，如Reader、Writer和ByteWriter。在有些情况下，这样生成的接口名可能不是现成的英语单词，如果您在Go源代码中搜索，将找到诸如Twoer这样的接口名。

对于要导出的函数，命名约定是尊重这样的事实，即导入包后，就可通过包名和函数名来访问它。例如，在标准库中，math包就遵守了这样的约定：将计算平方根的函数命名为Sqrt而不是MathSqrt。这合乎情理，因为使用这个函数时，代码为math.Sqrt而不是math.MathSqrt，另外，只要通过这个函数名就能知道它是做什么的。即便不查看函数的实现，程序员也能轻易知道它是做什么的。程序清单14.2使用了math包来计算平方根。Go设计者遵循的约定让这些代码很容易理解。

使用math包计算平方根
```go
package main
import (
	"fmt"
	"math"
)
func main(){
	var f float64 = 9
	fmt.Println(math.Sqrt(f))
}
```
命名总是带有一定的主观性，但花点时间考虑如何命名总是值得的。给变量、函数和接口命名时，需要考虑的一些因素包括以下几点。
- 谁将使用这些代码？只是我自己还是整个团队？
- 是否为当前项目制定了命名约定？
- 不熟悉代码的人是否只需看一眼就能大致知道它是做什么的？
遵循命名约定很重要，但过于教条也是有害的。您需要考虑代码所在的上下文、其他相关人员以及小组的稳定性。在大多数情况下，都应该兼顾约定以及代码所在的上下文。

# 使用 golint
golint是Go语言提供的一个官方工具。`gofmt` 根据指定的约定设置代码的格式，而命令 `golint` 根据Go项目本身的约定查找风格方面的错误。默认不会安装 `golint`，但可像下面这样安装它。
```bash
go get -u github.com/golang/lint/golint
```
要核实是否正确地安装了这个工具，可在终端中执行命令
```bash
go lint --help
```
如果正确地安装了它，您将在终端中看到一些帮助文本。工具golint提供了有关风格方面的提示，还可帮助学习Go生态系统广泛接受的约定。程序清单14.3是一些在风格方面有待改进的Go代码。
在风格方面有待改进的Go代码
```go
package main
import "fmt"
const Foo string = "constant string"
func mian(){
	fmt.Println(Foo)
	a_string := "hello"
	fmt.Println(a_string)
}
```
这些代码能够通过编译，也能通过 `gofmt`的检查。能够通过编译说明这些代码正确无误，能够通过 `gofmt` 的检查说明格式也没有问题。但您可能意识到了，这些代码存在一些风格方面的问题。例如，您可能注意到，有个变量名包含下划线。使用工具 `golint` 可找出这种风格方面的问题。如果对这些代码运行golint，它将提供一些建议，指出从风格方面改进这些代码。
```go
go lint example02.go
example02.go:5:7: exported const Foo should have comment or be unexported
example02.go:9:2: don't use underscores in Go names; var a_string should be aString
```

golint可能指出代码的哪些地方（行号和位置）需要注意。如果您使用的文本编辑器是Vim，这些信息还将集成到快速修复菜单中。这些改进建议不是强制性的，因为代码能够通过编译，但鉴于这个Go项目使用了这个工具，所以最好尽力消除这些警告并学习相关的约定。使用工具golint还是一种学习以Go语言惯用方式编写代码的绝妙途径。工具golint涵盖了很多约定，包括命名、风格和一般性约定，建议在您的Go项目中使用它。很多文本编辑器插件都让您能够在保存项目时运行golint，对项目运行测试时您可能应该考虑这样做，或通过定期地运行golint来强化学习。

# godoc 文档生成工具
godoc 是一款官方工具，可以通过分析 Go 语言源代码及其注释来生成文档，由于文档是根据源代码生成的，这很大程度上避免了文档不同步的问题。

安装
```go
go get golang.org/x/tools/cmd/godoc
```
检查是否安装成功
```go
go doc -h
```

## 使用
```go
// Package example03 shows how to use the godoc tool.
package example03

import (
　　"errors"
)
// Animal specifies an animal
type Animal struct {
　　Name string // Name holds the name of a thing.
  
　　// Age holds the name of a thing.
　　Age int
}
// ErrNotAnAnimal is returned if the name field of the Animal struct is Human.
var ErrNotAnAnimal = errors.New("Name is not an animal")
// Hello sends a greeting to the animal.
func (a Animal) Hello() (string, error) {
　　if a.Name == "Human" {
　　　　return "", ErrNotAnAnimal
　　}
　　s := "Hello " + a.Name
　　return s, nil
}
```
考虑到本章的目标，这个示例中的代码不如给它们添加注释的方式重要。请注意，每行都以它注释的类型的名称打头。注释是以大写字母打头的完整句子，以点结束。如果对这些代码运行工具 godoc，将生成有关这个包的文档。
```go
godoc ./example03
PACKAGE DOCUMENTATION

package example03
　　import "./example03"

　　Package example03 shows how to use the godoc tool.
VARIABLES

var ErrNotAnAnimal = errors.New("Name is not an animal")

　　ErrNotAnAnimal is returned if the name field of the Animal struct is
　　Human.

TYPES

type Animal struct {
　　Name string // Name holds the name of an Animal.
　　
  // Age holds the name of an Animal.
　　Age int
}
Animal specifies an animal

func (a Animal) Hello() (string, error)
　　Hello sends a greeting to the animal.
```


# 工作流程化
```shell
all: check-gofmt
check-gofmt:
@if [ -n "$(shell gofmt -l .)"]; then \
	echo 1>&2 'The fllllowing files need to be formatted:'; \
	go fmt -l .; \
	exit 1; \
fi
```


# 访问命令行
```go title="main.go"
package main
import (
	"fmt"
	"os"
)
func main(){
	for i,arg := range os.Args {
		fmt.Println("argument",i,"is",arg)
	}
}
```

```bash
go build main.go
./main
```
使用
```go
caoyang@cccy project % ./main 
argument 0 is ./main
caoyang@cccy project % ./main 1 2 3 4 5
argument 0 is ./main
argument 1 is 1
argument 2 is 2
argument 3 is 3
argument 4 is 4
```

# 分析命令行标志
```go
package main
import(
	"fmt"
	"flag"
)
func main(){
	/// flag.String 能够让您声明命令行标志，并指定其名称、默认值和帮助文本。
	s := flag.String("s","hello owrd","String help text") // 返回一个指针
	flag.Parse()
	fmt.Println("value of s:",*s)
}
```
构建：
```go
go build main.go 
```
输出：
```bash
$ caoyang@cccy project % ./main 
value of s: hello owrd
$ caoyang@cccy project % ./main -s Google
value of s: Google
```
>[!TIP]
>flag 包会自动创建一些帮助文本，要显示它们，可使用如下任何标志：`-h` `--h` `-help` `--help`

## 指定标志的类型
```go
package main
import(
	"fmt"
	"flag"
)
func main(){
	s := flag.String("s","字符串","s 的帮助文本")
	i := flag.Int("i",1,"i 的帮助文本")
	b := flag.Bool("b",true,"b 的帮助文本")
	flag.Parse()
	fmt.Println("value of s:",*s)
	fmt.Println("value of i:",*i)
	fmt.Println("value of b:",*b)
}
```

## 自定义帮助文本
```go
flag.Usage = func(){
	fmt.Fprintln(os.Stderr,"hello world")
}
```

创建帮助文本
```go
 package main
 import (
	 "fmt"
	 "flag"
	 "os"
)
func main(){
	flag.Usage = func(){
		usageText := `使用方法 main [选项]
使用案例：
-s, --s 字符串
-i, --i 数字
-b, --b 布尔`
		fmt.Fprintf(os.Stderr,"%s\n",usageText)
	}
	s := flag.String("s","字符串","s 的帮助文本")
	i := flag.Int("i",1,"i 的帮助文本")
	b := flag.Bool("b",true,"b 的帮助文本")
	flag.Parse()
	fmt.Println("value of s:",*s)
	fmt.Println("value of i:",*i)
	fmt.Println("value of b:",*b)
}
```

## 创建子命令
```go
// 例如 git clone
cloneCmd := flag.NewFlagSet("clone",flag.ExitOnError)
```
其中第一个参数为子命令名，而第二个参数则指定了错误处理行为。
- `flag.ContinueOnError`：如果没有分析错误，就继续执行。
- `flag.ExitOnError`：如果有分析错误，就退出并将状态码设置为2
- `flag.PanicOnError`：如果发生分析错误，就引发panic
使用 NewFlagSet 可创建独立的标志集。要根据参数做相应的处理，可使用switch语句。本章开头指出过，os.Args包含原始参数，因此可在switch语句中使用它来处理标志集。请注意，由于索引从0开始，因此这里需要使用索引1。
```go 
switch os.Args[1]{
	case "clone":
		// clone command
	case "branch":
		// branch command
	defaule:
		// 其他命令，例如错误提示
}
```
大小写转换案例
```go
package main

import (
	"flag"
	"fmt"
	"os"
	"strings"
)

func flagUsage() {
	usageText := `example05 is an example cli tool.

Usage:
example05 command [arguments]
The commands are:
uppercase uppercase a string
lowercase lowercase a string
Use "example05 [command] --help" for more information about a command.`
	fmt.Fprintf(os.Stderr, "%s\n\n", usageText)
}

func main() {
	flag.Usage = flagUsage
	uppercaseCmd := flag.NewFlagSet("uppercase", flag.ExitOnError)
	lowercaseCmd := flag.NewFlagSet("lowercase", flag.ExitOnError)
	if len(os.Args) == 1 {
		flag.Usage()
		return
	}
	switch os.Args[1] {
	case "uppercase":
		s := uppercaseCmd.String("s", "", "A string of text to beppercased")
		uppercaseCmd.Parse(os.Args[2:])
		fmt.Println(strings.ToUpper(*s))
	case "lowercase":
		s := lowercaseCmd.String("s", "", "A string of text to beowercased")
		lowercaseCmd.Parse(os.Args[2:])
		fmt.Println(strings.ToLower(*s))
	default:
		flag.Usage()
	}
}
```
构建：
```
go build main.go
```
使用：
```bash
$./main uppercase -s "lisa" 
LISA

$ ./main lowercase -s "NAME"
name
```