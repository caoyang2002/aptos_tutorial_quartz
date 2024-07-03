---
title: 第一个程序 hello world
---
第一个 go 程序
```go
package main
import "fmt"
func main(){
	fmt.Print("Hello World!")
}
```

运行程序：
```bash
go run main.go 
```
>输出：
>`Hello World!`

>[!TIP]
>类似的，你可以使用另一种生成可执行文件的方式运行这个程序
>
>```bash
>go build main.go
>./main
>rm main
>```
>
>

