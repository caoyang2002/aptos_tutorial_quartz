---
title: 通道
---
# 通道
如果说 Goroutine 是一种支持并发编程的方式，那么通道就是一种与 Goroutine 通信的方式。通道让数据能够进入和离开 Goroutine，可方便 Goroutine 之间进行通信。《Effective Go》有一句话很好地说明了Go语言的并发实现理念：

> “不要通过共享内存来通信，而通过通信来共享内存。”


这句话说明了 Go 语言并发实现方式的不同之处，这部分有必要做进一步解释。

在其他编程语言中，并发编程通常是通过在多个进程或线程之间共享内存实现的。共享内存能够让程序同步，确保程序以合乎逻辑的方式执行。在程序执行过程中，进程或线程可能对共享内存加锁，以禁止其他进程或线程修改它。这合乎情理，因为如果在操作期间共享内存被其他进程修改，可能会带来灾难性后果——引发 Bug 或导致程序崩溃。通过这种方式给内存加锁，可确保它是独占的 —— 只有一个进程或线程能够访问它。

这听起来可能太过抽象，我们来看一个例子：两个人持有一个联名账户，他们要同时从这个账户支付费用，但这两笔交易的总额超过了账户余额。如果两个交易同时进行且不加锁，则余额检查可能表明资金充足，但实际上资金不够；然而，如果第一个交易将账户加锁，则直到交易完成，都可避免这样的情况发生。对于简单的并发而言，这种方式看似合理，但如果联名账户有 20 个持有人，且他们经常使用这个账户进行交易呢？在这种情况下，加锁管理工作可能非常复杂。

共享内存和锁的管理工作并非那么容易，很多编程语言要求程序员对内存和内存管理有深入认识。即便是久经沙场的程序员也会遇到这样的情形，即为找出进程或线程争用共享内存而引发的Bug，需要花费数天时间。在使用共享内存的并发环境中，如果不能始终知道程序的哪部分将先更新数据，那么将难以推断其中发生的情况。

虽然使用共享内存有其用武之地，但 Go 语言使用通道在 Goroutine 之间收发消息，避免了使用共享内存。严格地说，Goroutine 并不是线程，但您可将其视为线程，因为它们能够以非阻塞方式执行代码。在前面关于两人持有一个联合账户的例子中，如果使用 Goroutine，将在账户持有人之间打开一个通信通道，让他们能够通信并采取相应的措施。例如，一个交易可能向通道发送一条消息，而通道可能限制后续交易或另一个账户持有人的行为。通过收发消息，使得能够以推送方式协调并发事件。事件发生时，可将触发的消息推送给接收者。使用共享内存时，程序必须检查共享内存。在变化频繁的并发编程环境中，很多人都认为使用消息是一种更佳的通信方式。

使用 Goroutine 来执行运行速度缓慢的函数
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
	fmt.Println("I am not show until slowFunc completes")
	time.Sleep(time.Second * 3)
}
```
# 创建通道
```go
 channel := make(chan string) 
```
> 关键字 chan 后面的 string 指出这个通道将用于存储字符串数据，这意味着这个通道只能用于收发字符串值。
# 向通道发送消息的语法
```go
c <- "Hello world"
```
请注意其中的 `<-`，这表示将右边的字符串发送给左边的通道。如果通道被指定为收发字符串，则只能向它发送字符串消息，如果向它发送其他类型的消息将导致错误。

# 从通道接收消息的语法
```go
msg := <-c
```
要从通道那里接收消息，需要在<-后面加上通道名。可使用简短变量赋值，将来自通道的消息直接赋给变量。箭头向左表示数据离开通道（接收），箭头向右表示数据进入通道（发送）。

使用通道进行通信
```go
package main
import (
	"fmt"
	"time"
)
func slowFunc(c chan string){
	time.Sleep(time.Second * 2)
	c <- "slowFunc() finished"
}
func main(){
	c := make(chan string)
	go slowFunc(c)
	msg := <- c
	fmt.Println(msg)
}
```
输出：
```go
slowFunc() finished
```
- 创建一个存储字符串数据的通道，并将其赋给变量 c
- 使用一个 Goroutine 来执行函数 slowFunc
- 函数 slowFunc 将通道当作参数。
- slowFunc 函数的单个参数指定了一个通道和一个字符串的数据类型
- 声明变量 msg，用于接收来自通道 c 的消息。这将阻塞进程直到收到消息为止，从而避免进程过早退出
- 函数 slowFunc 执行完毕后向通道 c 发送一条消息
- 接收并打印这条消息
- 由于没有其他的语句，因此程序就此退出
# 使用缓冲通道
通常，通道收到消息后就可将其发送给接收者，但有时候可能没有接收者。在这种情况下，可使用缓冲通道。缓冲意味着可将数据存储在通道中，等接收者准备就绪再交给它。要创建缓冲通道，可向内置函数 `make` 传递另一个表示缓冲区长度的参数。
```go
messages := make(chan string, 2)
```
这些代码创建一个可存储两条消息的缓冲通道。现在可在这个通道中添加两条消息了——虽然没有接收者。请注意，缓冲通道最多只能存储指定数量的消息，如果向它发送更多的消息将导致错误。
```go
messages <- "hello"
messages <- "world"
```
消息将存储在通道中，直到接收者准备就绪。

在一个缓冲通道中添加了两条消息，并在接收者准备就绪后接收了这些消息。
```go
package main
import (
	"fmt"
	"time"
)
func receiver(c chan string){
	for msg := range c {
		fmt.Println(msg)
	}
}
func main(){
	messages := make(chan string, 2)
	messages <- "hello"
	messages <- "world"
	close(messages) // 关闭通道，禁止再向通道发送消息。

	fmt.Println("Pushed two messages onto Channel with no receivers")
	time.Sleep(time.Second * 1)
	receiver(messages)
}
```
输出：
```go
Pushed two messages onto Channel with no receivers

hello

world
```
创建一个长度为 2 的缓冲通道。
- 向通道发送两条消息。此时没有可用的接收者，因此消息被缓冲。
- 关闭通道，这意味着不能再向它发送消息。
- 程序打印一条消息，指出通道包含两条消息，再休眠1s。
- 将通道作为参数传递给函数receiver。
- 函数receiver使用range迭代通道，并将通道中缓冲的消息打印到控制台。
在知道需要启动多少个Goroutine或需要限制调度的工作量时，缓冲通道很有效。

# 阻塞和流程控制
Goroutine是Go语言提供的一种并发编程方式。速度缓慢的网络调用或函数会阻塞程序的执行，而Goroutine能够让您对此进行管理。在并发编程中，通常应避免阻塞式操作，但有时需要让代码处于阻塞状态。例如，需要在后台运行的程序必须阻塞，这样才不会退出。
Goroutine会立即返回（非阻塞），因此要让进程处于阻塞状态，必须采用一些流程控制技巧。例如，从通道接收并打印消息的程序需要阻塞，以免终止。
给通道指定消息接收者是一个阻塞操作，因为它将阻止函数返回，直到收到一条消息为止。

通道和流程控制
```go
package main
import (
	"fmt"
	"time"
)
func pinger(c chan string){
	t := time.NewTicker(1 * time.Second)
	for {
		c <- "ping"
		<- t.C
	}
}
func main(){
	messages := make(chan string)
	go pinger(messages)
	msg := <-messages
	fmt.Println(msg)
}
```
输出：
```go
ping
```
如果您认为这个程序将在打印消息ping后退出，那么您说对了。收到一条消息后，阻塞操作将返回，而程序将退出。那么，如果创建不断监听通道中消息的监听器呢？这与通道的关系不大，而主要是与Go运行环境和执行流程相关。第5章介绍了Go语言控制流程，您学习了for语句。通过使用for语句，可永久性地阻塞进程，也可让阻塞时间持续特定的迭代次数。

添加一条for语句，可不断从通道那里接收消息并将其打印到控制台
```go
package main
import (
	"fmt"
	"time"
)
func pinger(c chan string){
	t := time.NewTicker(1 * time.Second)
	for {
		c <- "ping"
		<- t.C
	}
}
func main(){
	messages := make(chan string)
	go pinger(messages)
	for {
		msg := <-messages
		fmt.Println(msg)
	}
}
```
输出（一直输出）：
```go
ping
ping
ping
ping
ping
ping
ping
ping
...
```
接收指定数量的消息后结束
```go
for i:= 0; i < 5; i++ {
	msg := <-messages
	fmt.Println(msg)
}
```
Goroutine是非阻塞的，因此如果程序要阻塞，以接收大量的消息或不断地重复某个过程，必须使用其他流程控制技术。

# 将通道用作函数参数
您已在前面的示例中了解过，可将通道作为参数传递给函数，并在函数中向通道发送消息。要进一步指定在函数中如何使用传入的通道，可在传递通道时将其指定为只读、只写或读写的。指定通道是只读、只写、读写的语法差别不大。
```go
func channelReader(messages <-chan string) { // 只读
　　msg := <-messages
　　fmt.Println(msg)
}

func channelWriter(messages chan<- string) { // 只写
　　messages <- "Hello world"
}

func channelReaderAndWriter(messages chan string) { // 可读写
　　 msg := <-messages
　　 fmt.Println(msg)
　　 messages <- "Hello world"
}
```
`<-` 位于关键字 `chan` 左边时，表示通道在函数内是只读的；`<-` 位于关键字 `chan` 右边时，表示通道在函数内是只写的；没有指定 `<-` 时，表示通道是可读写的。

通过指定通道访问权限，有助于确保通道中数据的完整性，还可指定程序的哪部分可向通道发送数据或接收来自通道的数据。

# 使用 select 语句
假设有多个 Goroutine，而程序将根据最先返回的 Goroutine 执行相应的操作，此时可使用 select 语句。 select 语句类似于 switch 语句，它为通道创建一系列接收者，并执行最先收到消息的接收者。

select语句看起来和switch语句很像：
```go
channel1 := make(chan string)
channel2 := make(chan string)

select {
　　case msg1 := <-channel1:
　　　　fmt.Println("received", msg1)
　　case msg2 := <-channel2:
　　　　fmt.Println("received", msg2)
}
```
如果从通道 `channel1` 那里收到了消息，将执行第一条 `case` 语句；如果从通道 `channel2` 那里收到了消息，将执行第二条 `case` 语句。具体执行哪条 `case` 语句，取决于消息到达的时间，哪条消息最先到达决定了将执行哪条 `case` 语句。通常，接下来收到的其他消息将被丢弃。收到一条消息后，`select` 语句将不再阻塞。
```go
package main
import (
	"fmt"
	"time"
)
func ping1(c chan string){
	time.Sleep(time.Second * 2)
	c <- "ping on channel1"
}
func ping2(c chan string){
	time.Sleep(time.Second * 2)
	c <- "ping on channel2"
}
func main(){
	channel1 := make(chan string)
	channel2 := make(chan string)
	go ping1(channel1)
	go ping2(channel2)
	select {
		case msg1 := <- channel1:
			fmt.Println("received",msg1)
		case msg2 := <- channel2:
			fmt.Println("received",msg2)}
}
```
输出：
```go
received ping on channel1
```
- 创建两个用于存储字符串数据的通道。
- 创建两个向这些通道发送消息的函数。为模拟函数的执行速度，第一个函数休眠了1s，而第二个休眠了2s。
- 启动两个Goroutine，分别用于执行这些函数。
- select语句创建了两个接收者，分别用于接收来自通道channel1和channel2的消息。
- 1s后，函数ping1返回，并向通道channel1发送一条消息。
- 收到来自通道channel1的消息后，执行第一条case语句——向终端打印一条消息。
- 整个select语句就此结束，不再阻塞进程，因此程序退出。

从这个示例可知，要根据最先收到的消息采取相应的措施，select 语句是一个不错的选择。但如果没有收到消息呢？

为此可使用超时时间。这让 select 语句在指定时间后不再阻塞，以便接着往下执行。可添加一个超时case语句，指定在0.5s内没有收到消息时将采取的措施。
```go
select {
　　case msg1 := <-channel1:
　　　　fmt.Println("received", msg1)
　　case msg2 := <-channel2:
　　　　fmt.Println("received", msg2)
　　case <-time.After(500 * time.Millisecond):
　　　　fmt.Println("no messages received．giving up.")
}
```

# 退出通道
来看这样一种情形：程序需要使用select语句实现无限制地阻塞，但同时要求能够随时返回。通过在select语句中添加一个退出通道，可向退出通道发送消息来结束该语句，从而停止阻塞。可将退出通道视为阻塞式select语句的开关。对于退出通道，可随便命名，但通常将其命名为stop或quit。在下面的示例中，在for循环中使用了一条select语句，这意味着它将无限制地阻塞，并不断地接收消息。通过向通道stop发送消息，可让select语句停止阻塞：从for循环中返回，并继续往下执行。
```go
messages := make(chan string)
stop := make(chan bool)

for {
　　select {
　　case <-stop:
　　　　return
　　case msg := <-messages:
　　　　fmt.Println(msg)
　　}
}
```

退出通道：
```go
package main
import (
	"fmt"
	"time"
)
func sender(c chan string){
	t := time.NewTicker(1 * time.Second)
	for {
		c <- "I am sending a message"
		<- t.C
	}
}
func main(){
	messages := make(chan string)
	stop := make(chan bool)
	go sender(messages)
	go func(){
		time.Sleep(time.Second * 2)
		fmt.Println("Time's up!")
		stop <- true
	}()
	for {
		select {
			case <- stop:
				return 
			case msg := <- messages:
				fmt.Println(msg)
		}
	}
}
```
输出：
```go
I am sending a message
I am sending a message
I am sending a message
Time's up!
```
>[!TIP]
>关闭缓冲通道意味着不能再向它发送消息。缓冲的消息会被保留，可供接收者读取。

