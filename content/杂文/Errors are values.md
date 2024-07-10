---
title: 错误也是值
draft: 
aliases:
  - Errors are values
  - 错误就是值
date: 2024-07-02
description: "Rob Pike: Errors are values"
---
# 错误就是值
作者：Rob Pike
发布时间：2015年1月12日

在Go语言程序员中，尤其是那些新接触这门语言的程序员，如何处理错误是一个常见的讨论话题。这种讨论经常转变为对以下序列出现次数的哀叹：
```go
if err != nil {
    return err
}
```

我们最近扫描了我们能找到的所有开源项目，发现这个片段每两页才出现一次，比一些人想象的要少。尽管如此，如果人们坚持认为必须一直输入
```go
if err != nil
```
那么一定有问题，而明显的靶子就是 Go 语言本身。

这是不幸的，误导的，并且容易纠正。可能发生的情况是，新接触 Go 的程序员会问：“一个人如何处理错误？”，了解这种模式，然后就此打住。在其他语言中，人们可能会使用 `try-catch` 块或其他类似的机制来处理错误。因此，程序员会想，当我在旧语言中会使用 `try-catch` 时，我只需在 Go 中输入 `if err != nil`。随着时间的推移，Go 代码中积累了许多这样的片段，结果感觉笨拙。

不管这种解释是否合适，显然这些Go程序员错过了关于错误的一个基本点：**错误就是值**。

值可以被编程，既然错误是值，错误也可以被编程。

当然，涉及错误值的一个常见语句是测试它是否为 `nil`，但是人们还可以用错误值做无数其他事情，应用这些其他事情可以使你的程序更好，消除了许多如果每个错误都通过机械的if语句进行检查所产生的样板代码。

以下是一个来自 `bufio` 包的 `Scanner` 类型的简单例子。它的 `Scan` 方法执行底层的 `I/O` 操作，这当然可能导致错误。然而，`Scan` 方法根本没有暴露错误。相反，它返回一个布尔值，并且在扫描结束时，一个单独的方法报告是否发生了错误。客户端代码看起来像这样：
```go
scanner := bufio.NewScanner(input)
for scanner.Scan() {
    token := scanner.Text()
    // 处理token
}
if err := scanner.Err(); err != nil {
    // 处理错误
}
```

当然，有一个错误 `nil` 检查，但它只出现并执行一次。Scan方法本可以这样定义：
```go
func (s *Scanner) Scan() (token []byte, error)
```
然后示例用户代码可能是（取决于如何检索token），
```go
scanner := bufio.NewScanner(input)
for {
    token, err := scanner.Scan()
    if err != nil {
        return err // 或者可能是break
    }
    // 处理token
}
```
这并没有太大的不同，但有一个重要的区别。在这段代码中，客户端必须在每次迭代中检查错误，但在真正的 `Scanner API` 中，错误处理与关键 API 元素抽象开来，即遍历 token。有了真正的 API，客户端的代码因此感觉更自然：循环直到完成，然后担心错误。错误处理没有掩盖控制流。

在背后发生的事情当然是，一旦 `Scan` 遇到 `I/O` 错误，它就记录下来并返回 `false`。一个单独的方法，`Err`，当客户端询问时报告错误值。虽然这是微不足道的，但这并不同于到处放置
```go
if err != nil
```
或者要求客户端在每个 token 之后检查错误。这是用错误值编程。简单的编程，是的，但仍然是编程。

值得强调的是，无论设计如何，程序都必须检查它们暴露的错误。这里的讨论不是关于如何避免检查错误，而是关于用语言优雅地处理错误。

我在2014年秋天参加东京 GoCon 时，重复性错误检查代码的话题出现了。一位热情的 gopher，他在Twitter 上的名字叫 `@jxck_`，回应了关于错误检查的熟悉抱怨。他有一些代码，看起来大概是这样的：
```go
_, err = fd.Write(p0[a:b])
if err != nil {
    return err
}
_, err = fd.Write(p1[c:d])
if err != nil {
    return err
}
_, err = fd.Write(p2[e:f])
if err != nil {
    return err
}
// 以此类推
```
这非常重复。在真正的代码中，更长的代码中有更多事情发生，所以不容易使用辅助函数重构，但在这个理想化的形式中，一个闭包字面量封闭错误变量会有帮助：
```go
var err error
write := func(buf []byte) {
    if err != nil {
        return
    }
    _, err = w.Write(buf)
}
write(p0[a:b])
write(p1[c:d])
write(p2[e:f])
// 以此类推
if err != nil {
    return err
}
```
这种模式效果很好，但需要在执行写操作的每个函数中使用闭包；一个单独的辅助函数使用起来更笨拙，因为需要在调用之间维护 err 变量（试试）。

我们可以通过借鉴上面提到的 Scan 方法的思想，使这个更干净、更通用、更可重用。我在讨论中提到了这种技术，但 `@jxck_` 没有看到如何应用它。经过长时间的交流，部分受到语言障碍的阻碍，我问他是否可以借用他的笔记本电脑，通过输入一些代码来向他展示。

我定义了一个叫做errWriter的对象，类似于这样：
```go
type errWriter struct {
    w   io.Writer
    err error
}
```

并给它一个方法，Write 。它不需要有标准的Write签名，部分原因是为了强调区别。写方法调用底层Writer的Write方法，并记录第一个错误以供将来参考：
```go
func (ew *errWriter) write(buf []byte) {
    if ew.err != nil {
        return
    }
    _, ew.err = ew.w.Write(buf)
}
```

一旦发生错误，写方法就变成了一个空操作，但错误值被保存了。

鉴于 errWriter 类型及其写方法，上述代码可以重构为：
```go
ew := &errWriter{w: fd}
ew.write(p0[a:b])
ew.write(p1[c:d])
ew.write(p2[e:f])
// 以此类推
if ew.err != nil {
    return ew.err
}
```

这比使用闭包更干净，也使实际执行的写入序列在页面上更容易看到。不再有杂乱。用错误值（和接口）编程使代码更美观。

很可能，同一包中的其他代码可以在这个想法上构建，甚至直接使用 errWriter。

另外，一旦 errWriter 存在，它可以做得更多来提供帮助，特别是在不那么人为的例子中。它可以累积字节计数。它可以将写入合并到一个单一的缓冲区中，然后可以原子地传输。等等。

事实上，这种模式在标准库中经常出现。`archive/zip` 和 `net/http` 包使用它。更与这次讨论相关的是，`bufio` 包的 `Writer` 实际上是 `errWriter` 思想的实现。尽管 `bufio.Writer.Write` 返回一个错误，这主要是为了尊重 `io.Writer` 接口。`bufio.Writer` 的 `Write` 方法的行为就像我们上面的 `errWriter.write` 方法一样，用Flush报告错误，所以我们的例子可以这样写：
```go
b := bufio.NewWriter(fd)
b.Write(p0[a:b])
b.Write(p1[c:d])
b.Write(p2[e:f])
// 以此类推
if b.Flush() != nil {
    return b.Flush()
}
```
这种方法至少对于一些应用来说有一个显著的缺点：没有办法知道在发生错误之前完成了多少处理。如果这些信息很重要，就需要更细粒度的方法。通常，最终的全有或全无检查就足够了。

我们只看了一种避免重复错误处理代码的技术。请记住，使用errWriter或bufio.Writer不是简化错误处理的唯一方法，这种方法并不适用于所有情况。关键的教训是，错误是值，Go编程语言的全部力量都可以用于处理它们。

用语言简化你的错误处理。

但记住：无论你做什么，总是检查你的错误！

