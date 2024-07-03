---
title: 使用 Goroutine
draft: 
aliases:
  - 使用 Goroutine
date: 2024-07-03
description: 使用 Goroutine
tags:
  - Golang
---
# 理解并发

要理解 Goroutine，必须先明白并发的含义。

在最简单的计算机程序中，操作是依次执行的，执行顺序与出现顺序相同。想一想脚本中的代码行吧，这些代码行按出现顺序执行，一行执行完毕后才执行下一行。对很多程序来说，这种行为是可取的，程序员只要知道执行完一行代码后才会执行下一行，就能准确地推断出脚本的逻辑。

这种行为很像餐厅服务员给顾客点菜。服务员必须先将菜单给顾客，然后顾客看过菜单并点菜完毕后，服务员才能将点菜单交给厨师。服务员给顾客提供服务的过程大致如下。
1. 将菜单递给顾客。
2. 接收顾客的点菜单。
3. 将点菜单交给厨师。
4. 从厨师那里取菜。
5. 将菜交给顾客。

为这个过程编写程序时，完全可以认为一个任务完成后才能接着执行下一个任务。这个过程很像按出现顺序执行脚本中的代码 —— 一行代码执行完毕后再执行下一行。

对很多编程任务而言，按顺序执行任务的理念不仅可行，而且效果很显著。下面是一些这样的例子。
- 基于轮次的简单终端游戏。
- 温度转换器。
- 随机数生成器。

另一种理念是不必等到一个操作执行完毕后再执行下一个，编程任务和编程环境越复杂，这种理念就越重要。提出这种理念旨在让程序能够应对更复杂的情形，避免执行完一行代码后再执行下一行，从而提高程序的执行速度。

程序完全按顺序执行时，如果某行代码需要很长时间才能执行完毕，那么整个程序将可能因此而停止，导致用户长时间等待事件的发生。

现代编程必须考虑众多时间不可预测的变数。例如，您无法确定网络调用需要多长时间才能完成，也无法确定读取磁盘文件需要多长时间。

假设程序需要从天气服务那里获取某个地方当前的天气情况时，就需要编写一些代码来执行这种请求并处理 Web 服务器的响应。程序发出请求后，很多因素都可能影响响应返回的速度，如以下几种。
- 查找天气服务地址的DNS的速度。
- 程序和天气服务器之间网络连接的速度。
- 建立与天气服务器连接的速度。
- 天气服务器的响应速度。

鉴于所有这些因素都不是发出请求的程序能够控制的，因此完全有理由认为响应速度是无法预测的。另外，每次请求得到响应的时间都可能不同。面对这样的情形，程序员可选择等待响应 —— 阻塞程序直到响应返回为止，也可继续执行其他有用的任务。大多数现代编程语言都提供了选择空间，让程序员可等待响应，也可继续做其他事情。

回过头来看餐厅服务员给顾客提供服务的过程，完成其中每个步骤的时间都是不确定的。
- 顾客需要多长时间才能入座？
- 顾客需要多长时间才能点好菜？
- 顾客需要多长时间才能下单？
- 厨师需要多长时间才开始做菜？
- 厨师需要多长时间才能将菜做好？
如果按顺序做，服务员能够很好地为顾客服务，但无法同时为其他顾客提供服务！如果每位服务员都专为一位顾客服务，则餐厅的收费将非常高。相反，服务员可并发地执行任务。这意味着在厨师做菜时服务员可以给其他顾客点菜，并在其他顾客点菜期间去取菜。
在现实世界中，很多事情都是同时进行的：乘客在上车的同时听音乐，在排队时读书。鉴于此，编程语言有必要提供模拟这种情形的方式。

随着互联网的日益普及，网络编程越来越常见：程序可能向多个服务请求信息；数据库可能位于另一个完全不同的网络中。鉴于一切都是基于网络的，要可靠地预测任务完成的时间是很难做到的。

# 并发和并行
理解并发后，该讨论 Goroutine 了，但在此之前先来说说并发和并行的差别，这一点很重要。我们将以为生日聚会烘培 100 个蛋挞为例，来说明并发和并行的差别。咱们假设蛋糕粉和烘烤托盘多得不得了，而我们的目标是尽快将蛋挞烤好。

如果采用顺序方式，就意味着每次只能在一个烤箱中烤一个蛋挞。这种做法的效率显然很低，因为这将需要很长时间：烤好一个蛋挞后再将另一个蛋挞放入烤箱。另外，时间上也无法预测，因为有的蛋挞烤得快，有的烤得慢；有的需要的时间短点，有的需要的时间长点。

一种并发方式是，使用烘烤托盘每次烤多个蛋挞。这样做的效率要高得多，但还是不能同时烤好所有的蛋挞。例如，根据蛋挞的大小和所处烤箱的位置，烤好每个蛋挞的时间可能不同。相比于顺序方法，这种做法的速度更快，快多少取决于可同时烘烤多少个蛋挞。

并发方法的速度受制于众多因素，其中一个是烤箱的尺寸。如果有位朋友家也有烤箱，就可两家同时烤，从而进一步提高效率。同时烤多个蛋挞被称为并发；而将烤蛋挞的任务分为两部分，由两家分别烤，烤好后再放在一起，这被称为并行。以并行的方式执行任务时，可利用并发性，也可不利用；它相当于将工作分成多个部分，各部分的工作完成后再将结果合并。

这好像很复杂（涉及复杂的计算机科学），但Go语言的设计者之一 Rob Pike 很好地总结了并发和并行的差别：

并发就是同时处理很多事情，而并行就是同时做很多事情。
在现代编程中，并发是不可或缺的部分。对有些程序来说，并发至关重要（在确保性能方面尤其如此）。下面是一些这样的程序。
•  聊天程序。
•  多玩家游戏。
•  Web服务器。
•  从磁盘读取数据。
Google日常工作的并发需求是催生出Go的动力之一，因为使用传统的系统语言难以编写高效的并发代码。

> Concurrency is when two tasks can start, run, and complete in overlapping time periods. Parallelism is when tasks literally run at the same time, eg. on a multi-core processor.  
> 
> Concurrency is the composition of independently executing processes, while parallelism is the simultaneous execution of (possibly related) computations.  
> 
> Concurrency is about dealing with lots of things at once. Parallelism is about doing lots of things at once.  
> 
> An application can be concurrent – but not parallel, which means that it processes more than one task at the same time, but no two tasks are executing at same time instant.  
> 
> An application can be parallel – but not concurrent, which means that it processes multiple sub-tasks of a task in multi-core CPU at same time.  
> 
> An application can be neither parallel – nor concurrent, which means that it processes all tasks one at a time, sequentially.  
> 
> An application can be both parallel – and concurrent, which means that it processes multiple tasks concurrently in multi-core CPU at same time.  
>
>Vipin Jain. [Differences between concurrency vs. parallelism](https://stackoverflow.com/questions/4844637/what-is-the-difference-between-concurrency-parallelism-and-asynchronous-methods)

> 并发是两个任务可以在重叠的时间段内启动，运行和完成。并行是任务在同一时间运行，例如，在多核处理器上。  
> 
> 并发是独立执行过程的组合，而并行是同时执行（可能相关的）计算。  
>
>并发是一次处理很多事情，并行是同时做很多事情。  
>
> 应用程序可以是并发的，但不是并行的，这意味着它可以同时处理多个任务，但是没有两个任务在同一时刻执行。  
> 
> 应用程序可以是并行的，但不是并发的，这意味着它同时处理多核CPU中的任务的多个子任务。  
> 
> 一个应用程序可以即不是并行的，也不是并发的，这意味着它一次一个地处理所有任务。  
> 
> 应用程序可以即是并行的也是并发的，这意味着它同时在多核CPU中同时处理多个任务。

> 并行才是我们通常认为的那个同时做多件事情，而并发则是在线程这个模型下产生的概念。并发表示同时发生了多件事情，通过时间片切换，哪怕只有单一的核心，也可以实现“同时做多件事情”这个效果。根据底层是否有多处理器，并发与并行是可以等效的，这并不是两个互斥的概念。
> 
> 举个我们开发中会遇到的例子，我们说资源请求并发数达到了1万。这里的意思是有1万个请求同时过来了。但是这里很明显不可能真正的同时去处理这1万个请求的吧！如果这台机器的处理器有4个核心，不考虑超线程，那么我们认为同时会有4个线程在跑。也就是说，并发访问数是1万，而底层真实的并行处理的请求数是4。如果并发数小一些只有4的话，又或者你的机器牛逼有1万个核心，那并发在这里和并行一个效果。也就是说，并发可以是虚拟的同时执行，也可以是真的同时执行。而并行的意思是真的同时执行。结论是：并行是我们物理时空观下的同时执行，而并发则是操作系统用线程这个模型抽象之后站在线程的视角上看到的“同时”执行。[原文](https://www.cnblogs.com/bughui/p/7422214.html)

[Rust 解释](https://course.rs/advance/concurrency-with-threads/concurrency-parallelism.html)

# 通过 web 浏览器来理解并发
大家每天都要使用Web浏览器，而网站的加载速度通常很快，这都是拜并发性所赐。为合成网页并将其显示给用户，浏览器背后的技术必须做大量的并发工作。通常，网页由图像和脚本组成，而这些图像和脚本来自网上众多不同的服务器。

为理解并发性，您将进入浏览器的幕后，观看网页的合成过程。为此，可使用浏览器的开发者工具。在Google Chrome中，开发者工具可在菜单 Developer>Network 中找到；如果您使用的是其他浏览器，但不知道如何打开开发者工具，可在Google中输入“开发者工具”和浏览器的名称。

打开开发者工具后，在地址栏中输入BBC主页网址并按回车。在页面加载期间，观看发送的请求。您将能够看到所有的请求。对于每个请求，您可知道它花了多长时间以及这些时间都花在什么地方。就本章的目的而言，开发者提供的信息太过详细了，但这里的要点在于，Web 浏览器不依次发出请求，而是同时发出请求，以尽快渲染页面或其组成部分。这样做的结果是，页面的加载速度在用户看来很快。仅当所有请求都结束后，页面才加载完毕，但在此之前浏览器依然能够做很多有用的事情。例如，图像加载后，浏览器就可将其渲染到页面上。

# 阻塞和非阻塞代码
基于对并发性的大致认识，下面来编写一个程序，模拟函数调用阻塞程序的执行直到操作完成的情形。为模拟缓慢的函数调用，可使用 time.Sleep，它的作用是让程序暂停指定的时间。在实际编程中，这可能是缓慢的函数调用或需要运行很长时间的函数。
```go
package main
import (
	"fmt"
	"time"
)
func slowFunc(){
	time.Sleep(time.Second * 2)
	fmt.Println("sleeper() finished")
}

func main(){
	slowFunc()
	fmt.Print("I am not shown until slowFunc completes")
}
```
输出：
```go
sleeper() finished
I am not shown until slowFunc completes
```

# 使用 Goroutine 处理并发操作
Goroutine使用起来非常简单，只需在要让Goroutine执行的函数或方法前加上关键字go即可。
```go
package main
import(
	"fmt"
	"time"
)
func slowFunc(){
	time.Sleep(time.Second * 2)
	fmt.Println("sleeper() finished")
}
func main(){
	go slowFunc()
	fmt.Println("I am now show straightaway!")
}
```
输出：
```go
I am now show straightaway!
```

使用 goroutine 实现并发执行
```go
package main
import (
	"fmt"
	"time"
)
func slowFunc(){
	time.Sleep(time.Second * 2)
	fmt.Println("sleeper() finished")
}
func main(){
	go slowFunc()
	fmt.Println("I am not shown until slowFunc() completes")
	time.Sleep(time.Second *  3)
}
```
输出：
```go
I am not shown until slowFunc() completes
// 间隔一段时间
sleeper() finished
```

# 定义 Goroutine
如果您使用过其他编程语言，就会知道并发是编程语言提供的一种常见功能。例如，Node.js 使用事件循环来管理并发，而 Java 使用线程。Apache 和 Nginx 等 Web 服务器也使用不同的并发方法，Apache 喜欢使用线程和进程，而 Nginx 使用事件循环。如果您不明白这些术语，也不用担心。这里的重点是，实现并发的方式有很多，它们以不同的方式使用计算机资源，这使得编写可靠的软件或难或易。

与 Java 一样，Go 在幕后使用**线程**来管理并发，但 Goroutine 让程序员无须直接管理线程，它消除了这样做的痛苦。创建一个 Goroutine 只需占用几 KB 的内存，因此即便创建数千个 Goroutine 也不会耗尽内存。另外，创建和销毁 Goroutine 的效率也非常高。

Goroutine 是一个并发抽象，因此开发人员通常无须准确地知道操作系统中发生的情况。

# 附录

如果您有时间，请观看Go语言设计者之一Rob Pike的演讲视频“[Concurrency Is Not Parallelism](https://go.dev/blog/waza-talk)”。这个视频长约30min，它很好地介绍了并发以及Go语言实现并发的方式。
