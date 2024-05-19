---
title: has 后面的能力的作用
---
# Question

This one was inspired by questions about:

"What does key mean? What does store mean?"

It was inspired by many of the existing NFT Marketplace's mailbox systems for sending Legacy Digital Assets to other users

# English

Ever wonder which structs have which capabilities in Move? What does key, copy, drop, store mean?

I'll show you how these work in a normal everyday use case of a Mailbox.

Let's dive into it this session of

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

As with all of these examples, we will use an object to store the main resource for the Mailbox. I call this MailboxRouter, which has a single place for all users' mailboxes.

We can see that it has the key capability, which allows it to be stored as a resource at an address.

[https://pbs.twimg.com/media/GEzgthRaMAAYzqT?format=jpg&name=medium](https://pbs.twimg.com/media/GEzgthRaMAAYzqT?format=jpg&name=medium)

What does this key mean though? It means that it can be borrowed from the global state, which is a _key_ concept in Move. The global state you can think of as a large map of every address, and every resource in that map.

In this case, the mailbox_router_address and MailboxRouter

[https://pbs.twimg.com/media/GEzg7kvaIAAuMrj?format=jpg&name=large](https://pbs.twimg.com/media/GEzg7kvaIAAuMrj?format=jpg&name=large)

But, how do we put mail in the mailbox? The router has a SmartTable with two inputs MailboxId and Mailbox. The MailboxId must have the _store_ capability. This allows it to be stored natively in another object, traditionally a table or vector. The Mailbox has it as well.

[https://pbs.twimg.com/media/GEzhdsKaoAA0kFb?format=jpg&name=medium](https://pbs.twimg.com/media/GEzhdsKaoAA0kFb?format=jpg&name=medium)

But, it's also _copy_ and _drop_

Copy allows you to copy the internals directly. Think of something like an address there's not only one of, but something like a NFT, or a number of coins, you can't copy that.

All structs that are _copy_ require all internal fields to be copy as well.

_Drop_ also let's you drop that value, at any point. Something you might not want for your favorite NFT to just disappear from the blockchain.

[https://pbs.twimg.com/media/GEzh280aIAAgQDy?format=png&name=medium](https://pbs.twimg.com/media/GEzh280aIAAgQDy?format=png&name=medium)

Let's get to the envelopes that we're putting in the mailbox. These only have _store_ and that's because the types Coin and Token do not have _copy_ or _drop_ .

But, you may be thinking, how do I destroy the envelope after reading mail? In the real world, I take letter out, and throw away the envelope. Let's look at it.

[https://pbs.twimg.com/media/GEzicVEaoAAf0Fj?format=jpg&name=medium](https://pbs.twimg.com/media/GEzicVEaoAAf0Fj?format=jpg&name=medium)

Structs like Envelope can be decomposed into their parts. This meaning we can split it into it's parts, and drop the parts we don't need, and distribute the parts elsewhere we need to keep.

Just like you might tear open an envelope, and throw it away with your hard earned paycheck in it.

[https://pbs.twimg.com/media/GEzi-QvaUAEGMtZ?format=jpg&name=medium](https://pbs.twimg.com/media/GEzi-QvaUAEGMtZ?format=jpg&name=medium)

But, Greg I just want to send mail already.

The envelope can be built up, with each of the pieces inside.

When a user then wants to claim it, they are authorized to claim it based on their mailbox. But, the sender is kept in the mail too. A safeguard for canceling the mail if it's sent to the wrong person (if only USPS could do this for me too).

[https://pbs.twimg.com/media/GEzjZNUaIAA_REx?format=jpg&name=900x900](https://pbs.twimg.com/media/GEzjZNUaIAA_REx?format=jpg&name=900x900)

[https://pbs.twimg.com/media/GEzjgK9bsAI2kU_?format=jpg&name=large](https://pbs.twimg.com/media/GEzjgK9bsAI2kU_?format=jpg&name=large)

Opening mail and viewing mail is simple enough, because the capabilities allowed us to store the mail and transfer its components to others. You can even view the mail while it's in the mailbox, similar to my 1k emails that I always forget to delete.

[https://pbs.twimg.com/media/GEzj9xFbQAAq4nn?format=jpg&name=medium](https://pbs.twimg.com/media/GEzj9xFbQAAq4nn?format=jpg&name=medium)

Thanks for reading and hopefully you learned a little bit about Move struct capabilities.

All the source code is available daily here: [](https://t.co/QmMRWWBR5L)[https://github.com/aptos-labs/daily-move/tree/main/snippets/struct-capabilities](https://github.com/aptos-labs/daily-move/tree/main/snippets/struct-capabilities)

# 问题

这个问题的灵感来自于对以下问题的提问：

key 是什么意思？ store 是什么意思？”

它的灵感来自于许多现有的 NFT 市场的邮箱系统，用于将遗留数字资产发送给其他用户。

# 中文

你是否想过 Move 中的哪些结构具有哪些功能？键、复制、删除、存储分别代表什么？

我将向你展示这些是如何在一个普通的邮箱使用案例中工作的。

让我们深入研究这个问题，这是本期

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

与所有这些示例一样，我们将使用一个对象来存储邮箱的主要资源。我称之为 MailboxRouter，它有一个单一的地方存放所有用户的邮箱。

我们可以看到它具有键功能，这使得它可以作为资源存储在地址上。

![https://pbs.twimg.com/media/GEzgthRaMAAYzqT?format=jpg&name=medium](https://pbs.twimg.com/media/GEzgthRaMAAYzqT?format=jpg&name=medium)

但是，这个 `key` 到底是什么意思呢？这意味着它可以从全局状态中借出，这是 Move 中一个 `Key` 的概念。全局状态可以想象成一个包含每个地址和该地址上每个资源的大型映射。

在这个情况下，`mailbox_router_address` 和 `MailboxRouter`

![https://pbs.twimg.com/media/GEzg7kvaIAAuMrj?format=jpg&name=large](https://pbs.twimg.com/media/GEzg7kvaIAAuMrj?format=jpg&name=large)

但是，我们如何把信放进邮箱呢？路由器有一个 SmartTable，有两个输入 MailboxId 和 Mailbox。MailboxId 必须具有 _存储_ 功能。这允许它在另一个对象中本地存储，传统上是一个表或向量。Mailbox 也具有此功能。

![https://pbs.twimg.com/media/GEzhdsKaoAA0kFb?format=jpg&name=medium](https://pbs.twimg.com/media/GEzhdsKaoAA0kFb?format=jpg&name=medium)

但它也是 `copy` 和 `drop`

`copy` 允许直接复制内部。想象一下像地址这样的东西不只有一个，而像 NFT 或一些硬币的数量，你不能复制。

所有具有 `copy` 功能的结构都要求所有内部字段也是复制的。

`drop` 也允许您随时删除该值。这可能不是您想要的，因为您的最喜爱的 NFT 只是从区块链中消失了。

![https://pbs.twimg.com/media/GEzh280aIAAgQDy?format=png&name=medium](https://pbs.twimg.com/media/GEzh280aIAAgQDy?format=png&name=medium)

让我们来看看我们要放入邮箱的信封。这些只有 `store`，因为类型 Coin 和 Token 没有 `copy` 或 `drop`。

但是，你可能会想，我如何在阅读信后销毁信封呢？在现实世界中，我拿出信，扔掉信封。让我们看看。

![https://pbs.twimg.com/media/GEzicVEaoAAf0Fj?format=jpg&name=medium](https://pbs.twimg.com/media/GEzicVEaoAAf0Fj?format=jpg&name=medium)

像 Envelope 这样的结构可以分解为它的各个部分。这意味着我们可以将其拆分为各个部分，并且扔掉我们不需要的部分，并将部分分发到我们需要保留的其他地方。

就像你可能会撕开一个信封，并将其中放着你辛苦赚来的工资的部分扔掉一样。

![https://pbs.twimg.com/media/GEzi-QvaUAEGMtZ?format=jpg&name=medium](https://pbs.twimg.com/media/GEzi-QvaUAEGMtZ?format=jpg&name=medium)

但是，Greg，我只是想寄信而已。

信封可以逐步构建，每个部分都在里面。

![https://pbs.twimg.com/media/GEzjZNUaIAA_REx?format=jpg&name=900x900](https://pbs.twimg.com/media/GEzjZNUaIAA_REx?format=jpg&name=900x900)

![https://pbs.twimg.com/media/GEzjgK9bsAI2kU_?format=jpg&name=large](https://pbs.twimg.com/media/GEzjgK9bsAI2kU_?format=jpg&name=large)

当用户想要领取信时，他们根据自己的邮箱被授权领取信。但是，发件人也会留在信中。这是一种保护措施，以防止邮件发送到错误的人（如果只有美国邮政也能为我做到这一点就好了）。

打开邮件和查看邮件非常简单，因为功能允许我们存储邮件并将其组件转移到其他地方。你甚至可以在邮件在邮箱中的时候查看邮件，就像我总是忘记删除的 1k 封电子邮件一样。

![https://pbs.twimg.com/media/GEzj9xFbQAAq4nn?format=jpg&name=medium](https://pbs.twimg.com/media/GEzj9xFbQAAq4nn?format=jpg&name=medium)

感谢阅读，希望你对 Move 结构功能有所了解。

所有源代码都可以在这里找到： [https://github.com/aptos-labs/daily-move/tree/main/snippets/struct-capabilities](https://github.com/aptos-labs/daily-move/tree/main/snippets/struct-capabilities)