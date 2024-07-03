---
title: 使用包实现代码重用
draft: 
aliases:
  - go 包
---
# 导入包
```go
package main
import "fmt"
func main(){
	fmt.Println("Hello World")
}
```
Go程序以 `package` 语句打头。`main` 包是一种特殊的包，其特殊之处在于不能导入。**对 `main` 包的唯一要求是，必须声明一个 `main` 函数，这个函数不接受任何参数且不返回任何值**。简而言之，`main` 包是程序的入口。

在`main` 包中，可使用 `import` 声明来导入其他包。导入包后，就可使用其中被导出的（即公有的）标识符。在Go语言中，标识符可以是变量、常量、类型、函数或方法。这让包能够通过接口提供各种功能。例如，`math` 包提供了常量 `Pi`

访问math包中的Pi
```go
package mian
import (
	"fmt"
	"math"
)
func main(){
	fmt.Println(mat.Pi)
}
```
举一个函数导出的例子，`strings` 包导出了函数 `ToLower`，可用于将字符串转换为小写

将字符串转换为小写
```go
package main
import (
	"fmt"
	"string"
)
func main(){
	fmt.Println(string.ToLower("STOP SHOUTIING"))
}
```
导入包并使用其中导出的标识符，是重用标准库和其他第三方代码的基本方式。这种方式虽然简单，但您必须理解，灵活性和代码重用在很大程度上都是通过这种方式实现的。

# 理解包的用途
要了解如何使用包，先得知道该使用哪个包。在标准库中，Go语言设计者采用了一致的命名约定，以帮助程序员明白包是如何组织的。在Go语言中，包名短小精悍又含义丰富。`strings` 包包含用于处理字符串的函数，`bytes` 包包含用于处理字节的函数。随着Go语言的使用经验越来越丰富，您就会知道哪些包是用于完成哪些任务的；如果实在记不起来，还可参阅直观而组织良好的文档。

假设您要在程序中操作字符串，那么通过阅读标准库包清单，您可能发现有一个 `strings` 包。您可在程序中导入并使用这个包！但如何知道它提供了哪些功能呢？Go 语言的文档很完善，而对于标准库中的包，都有卓越的文档。对于 `strings` 包，其文档可在 Go 语言官网找到。

在这个文档中，列出了所有被导出的标识符。假设您需要在程序中将字符串转换为小写，通过查看文档可知，有一个名为 `ToLower` 的函数。文档还指出这个函数将一个字符串作为参数，并返回一个字符串。
```go
func ToLower(s string) string
```
文档简单地描述了这个函数的作用，还包含一些演示其用法的示例代码。对于这些示例代码，您可直接在浏览器中执行它们。如果您要更深入地了解这个函数，还可查看 `strings` 包的源代码。

# 使用第三方包
标准库提供了很多功能，但Go语言的设计理念是确保核心标准库小巧而稳定，因此标准库没有提供连接到数据库、分析文件格式以及实现身份验证协议的功能。不用多久，标准库就无法满足您编写程序的需求了。在这种情况下，程序员有两种选择。
- 自己编写解决问题的代码。
- 寻找能够解决问题的包（或库代码）。
大部分程序员很可能选择第二种做法。然而，在程序中添加额外的依赖要三思而行，因为这可能影响程序的稳定性和可维护性。考虑使用第三方库时，您应自问如下几个问题。
- 我明白了这些代码是做什么的吗？
- 这些代码值得信任吗？
- 这些代码的维护情况如何？
- 我真的需要这个库吗？
回答这些问题时，请考虑如下几点。
- 明白包的作用至关重要。优秀的第三方包都有卓越的文档，这些文档通常遵循Go语言文档约定，指出了它们导出了哪些标识符。通过阅读文档，可确定包是否提供了您所需的功能。
- 确定第三方包值得信任很重要。别忘了，将包导入程序后，它就能访问底层的操作系统。要确定第三方包的可信任程度，可了解还有多少人在使用它、是否有同事推荐，还可阅读其源代码。
- 考虑到软件的特征，第三方包不可避免地存在Bug。不要选择几年都没有更新的包，而应选择开发方积极维护的第三方包，因为这意味着随着时间的推移，这样的包会越来越稳定。
- 导入第三方包会增加程序的复杂性。很多时候导入一个包只为了使用其中的一个函数，在这种情况下，可复制这个函数，而不导入整个包。

# 安装第三方包
要使用第三方库，必须像使用标准库一样使用 `import` 语句导入它。

在下面的示例中，将使用Go小组开发的 `stringutil` 包。这是一个简单的第三方包，只有一个函数被导出 —— `Reverse`。这个函数将一个字符串作为参数，将该字符串反转并返回结果。

要使用第三方包，必须先使用命令 `go get` 安装它。这个命令默认随Go一起安装了，它将指向远程服务器中包的路径作为参数，并在本地安装指定的包。
```go
go get github.com/golang/example/stringutil
```
这个包被安装到环境变量 `GOPATH` 指定的路径中，因此可在程序中使用它。要查看这个包的源代码，可打开目录 `src` 中的文件。包的安装目录如下。
```path
// OSX and Linux
GOPATH/src/github/golang/example/stringutil
// Windows
GOPATH%\src\github\golang\example\stringutil
```
使用第三方包
```go
package main
import(
	"fmt"
	"github.com/golang/example/stringutil"
)
func main(){
	s :=  "ti esrever dna ti pilf nwod gniht ym tup I"
	fmt.Println(stringutil.Reverse(s))
}
```
输出：
```go
I put my thing down flip it and reverse it
```
>[!TIP]
>通常，第三方包依赖于其他第三方包。命令go get很聪明，它会下载依赖的第三方包，让您无须手工安装每个包依赖的第三方包。

# 管理第三方依赖
很多语言都有包管理器，可简化使用第三方包的工作：Python有pip、.NET有Nuget、Ruby有RubyGems、Node.js有npm。
本章前面介绍了如何安装远程包，但使用第三方包时，还需考虑众多不同的因素。
•  如何更新包以修复缺陷？
•  如何指定版本？
•  如何与其他开发人员分享依赖清单？
•  如何在构建服务器中安装依赖？
使用命令 `go get`可更新文件系统中特定的包或所有的包。要更新项目的依赖，可在项目文件夹中执行如下命令。
```go 
go get -u
```
也可只更新特定的包。
```go
go get -u github.com/spf13/hugo
```

还可更新文件系统中所有的包。
```go
go get -u all
```

命令 `go get` 从与本地分支匹配的远程分支中获取源代码，例如，如果本地分支为master，则这个命令将从远程分支master获取最新的源代码。

go module 是go官方自带的go依赖管理库。go module可以将某个项目(文件夹)下的所有依赖整理成一个 go.mod 文件,里面写入了依赖的版本等，使用go module之后我们可不需要关心GOPATH，也不用将代码放置在src下了。

项目第一次使用 GO MODULE(项目中还没有go.mod文件) ，cd进入项目文件夹，初始化 MODULE

```bash
go mod init Seckill  	#Seckill是项目名
```

此时项目根目录会出现一个 go.mod 文件，此时的 go.mod 文件只标识了项目名和go的版本,这是正常的,因为只是初始化了。 go.mod 文件内容如下：

```mod
module SecKill 
go 1.13
```

### 检测依赖

```bash
go mod tidy
```

tidy 会检测该文件夹目录下所有引入的依赖,写入 go.mod 文件，写入后会发现 go.mod 文件有所变动：

```mod
module SecKill 
go 1.13 
require (	
	github.com/gin-contrib/sessions v0.0.1	
	github.com/gin-gonic/gin v1.5.0	
	github.com/jinzhu/gorm v1.9.11	
	github.com/kr/pretty v0.1.0 // indirect	gopkg.in/yaml.v2 v2.2.2
)
```

此时依赖还是没有下载的。

 下载依赖

我们需要将依赖下载至本地，但不使用 `go get`，而是使用以下命令

```bash
go mod download
```

然而如果你没有设置 GOPROXY 为国内镜像,这步百分百会卡死。

设置镜像的语句（最好把他们写进 ~/.bashrc 中，不然每次打开Terminal都要执行一次）：

```bash
export GO111MODULE=onexport GOPROXY=https://goproxy.io
```

此时会将依赖全部下载至 GOPATH 下的 pkg/mod 文件夹中，同时会在项目根目录下生成 go.sum 文件, 该文件是依赖的详细依赖。但是我们开头说了,我们的项目是没有放到 GOPATH 下的,那么我们下载至 GOPATH 下是无用的,照样找不到这些包

似乎项目是可以找到放在GOPATH 下的依赖包的。

导入依赖

```go
go mod vendor
```

执行此命令,会将刚才下载至 GOPATH 下的依赖转移至该项目根目录下的 vendor(自动新建) 文件夹下，此时我们就可以使用这些依赖了。然而实际不导入也是完全ok的。导入了反而更麻烦。

在协作中使用 GOMODULE时要注意的是, 在项目管理中,如使用 git,请将 vendor 文件夹放入白名单,不然项目中带上包体积会很大。

git设置白名单方式为在git托管的项目根目录新建 .gitignore 文件

设置忽略即可。但是 go.mod 和 go.sum 不要忽略，另一人clone项目后在本地进行依赖更新(同上方依赖更新)即可。


### GOMODULE常用命令

```bash
go mod init  # 初始化go.mod
go mod tidy  # 更新依赖文件
go mod download  # 下载依赖文件
go mod vendor  # 将依赖转移至本地的vendor文件
go mod edit  # 手动修改依赖文件
go mod graph  # 打印依赖图
go mod verify  # 校验依赖
```

模块的`go.mod`文件记录它需要哪些版本的依赖项。这些依赖项的源代码存储在本地缓存中。

`go get`更新`go.mod`文件中列出的要求。它还确保这些需求是自洽的，并根据需要添加新的需求，以便您在命令行中指定的包导入的每个包都由需求中的某个模块提供。

作为更新和添加需求的副作用，`go get`还将包含命名包(及其依赖项)的模块下载到本地模块缓存中。

相反，`go mod download`不添加新需求或更新现有需求。(最多可以确保现有的需求是自洽的，如果您手工编辑了`go.mod`文件，就会发生这种情况。)它只下载您所请求的特定模块版本(如果您请求特定版本)，或者下载出现在您的需求中的模块版本。


# 创建包

除使用第三方包外，有时还可能需要创建包。本节将创建一个示例包，并将其发布到Github以便与人分享。这是一个处理温度的包，提供了在不同温度格式之间进行转换的函数。
```bash
go mod init temperature
```
请创建一个名为temperature.go的文件
```go
package temperature
func CtoF(c float64) float64{
	return (c * 9 / 5) + 32
}
func FtoC(f float64) float64{
	return (f-32) * 5 / 9
}
```

>[!NOTE]
>别忘了，导入这个包后，就可使用其中所有以大写字母打头的标识符了。要创建私有标识符（变量、函数等），可让它们以小写字母打头。

为测试这个包，可创建一个测试文件 temperature_test.go
```go
package temperature
import ("testing")
type  temperatureTest struct{
	i float64
	expected float64
}
var CtoFTests = []temperatureTest{
	{4.1, 39.38},
	{10, 50},
	{-10, 14},
}
var FtoCTests =  []temperatureTest{
	{32, 0},
	{50, 10},
	{5, -15},
}
func TestCtoF(t *testing.T){
	for _,tt := range CtoFTests{
		actual := CtoF(tt.i)
		if actual != tt.expected{
			t.Errorf("expected %v, actual %v",tt.expected,actual)
		}
	}
}
func TestFtoC(t *testing.T){
	for _,tt := range FtoCTests{
		actual := FtoC(tt.i)
		if actual != tt.expected{
			t.Errorf("expected %v, actual %v",tt.expected,actual)
		}
	}
}
```
输出：
```go
PASS
ok  test 0.440s
```

对于要发布到网上的包，从用户的角度考虑问题很重要。因此，推荐在包中包含如下3个文件。
- 指出用户如何使用代码的LICENSE文件。
- 包含有关包的说明信息的README文件。
- 详细说明包经过了哪些修改的Changelog文件。

作为代码的创建者，如何授权由您决定。有很多开源许可方式，有些要求宽松，有些要求严格。

在README文件中，应包含有关包的信息、如何安装包以及如何使用包。您可能还想在其中包含有关如何参与改进项目的信息。如果要将包发布到Github，应考虑使用Markdown格式编写，因为Github会自动设置markdown文件的格式。

在Changelog文件中，应列出对包所做的修改，这可能包含功能添加情况和API删除情况。通常，使用git标签来指示发布情况，能够让用户轻松地下载特定版本。
>[!NOTE]
>以大写字母打头的标识符会被导出，这意味着导入包后就可使用它们；以小写字母打头的标识符不会被导出，这意味着即便导入包也无法使用它们。简而言之，以大写字母打头的标识符是公有的，而以小写字母打头的标识符是私有的。
