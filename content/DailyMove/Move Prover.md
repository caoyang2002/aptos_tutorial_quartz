---
title: Move Prover
---
```yaml
original: 
  author: Greg
  url: 
note: 纯机翻、未核对
```
# English

People asked me about the Move Prover previously for Aptos and what makes it special.

I'll go into a short dive about the Prover with a Venmo like escrow contract on [#DailyMov](https://twitter.com/hashtag/DailyMove?src=hashtag_click)e

On [@Aptos](https://twitter.com/Aptos), the Move prover allows you to formally verify your code, to ensure that certain properties hold in all situations.

Let's talk about our project requirements:

1. A user should be able to send funds to another
2. The sender can reject the payment before acceptance
3. The receiver can accept or reject the payment

Diving into some code, we want a Escrow object, keeping track of coins, and the original sender.

Below you can see, there are **struct invariants**, which apply for the struct over all cases. In this case, we ensure that the escrow should never be empty.

[https://pbs.twimg.com/media/GIrGVDSaMAAG1Qg?format=jpg&name=medium](https://pbs.twimg.com/media/GIrGVDSaMAAG1Qg?format=jpg&name=medium)

We can add formal verification specs to ensure that the code is valid.

1. The right amount of coins are transferred
2. The sender is always tracked
3. And that we have the delete ref for that actual object to delete it later

[https://pbs.twimg.com/media/GIrHHS0bsAE_WBU?format=jpg&name=medium](https://pbs.twimg.com/media/GIrHHS0bsAE_WBU?format=jpg&name=medium)

We can see that when we run the prover, it verifies those properties.

Especially, the one that says the escrow cannot be 0. Let's change that up!

[https://pbs.twimg.com/media/GIrHso3asAAC1OH?format=png&name=medium](https://pbs.twimg.com/media/GIrHso3asAAC1OH?format=png&name=medium)

I remove the check that says escrow amounts must be greater than 0, just to see how the prover will catch it.

[https://pbs.twimg.com/media/GIrILRLakAEymzb?format=jpg&name=medium](https://pbs.twimg.com/media/GIrILRLakAEymzb?format=jpg&name=medium)

The prover then tells me which invariants are not being held, along with a trace of proof.

By changing this one line, I now made it possible to have the escrow be 0, and the prover caught that.

[https://pbs.twimg.com/media/GIrIfnRaIAA54L2?format=jpg&name=medium](https://pbs.twimg.com/media/GIrIfnRaIAA54L2?format=jpg&name=medium)

But, how does this differ from code coverage?

Code coverage tells you whether a line in code was covered, but not if every possible input.

Formal verification gets more technical, ensuring that for every input a property will hold, by usually proving there is no possible input to break the property.

You can learn more about the Prover here: [](https://t.co/9aCln3CZ8t)[https://aptos.dev/move/prover/move-prover](https://aptos.dev/move/prover/move-prover)

And the source code for the example is here: [](https://t.co/fQdZ2VqlTI)[https://github.com/aptos-labs/daily-move/blob/main/snippets/prover/sources/payment_escrow.move](https://github.com/aptos-labs/daily-move/blob/main/snippets/prover/sources/payment_escrow.move)

[https://pbs.twimg.com/card_img/1776982127621419008/GMSw8irv?format=jpg&name=medium](https://pbs.twimg.com/card_img/1776982127621419008/GMSw8irv?format=jpg&name=medium)

[From aptos.dev](https://t.co/9aCln3CZ8t)

Thanks for reading my post on the Move prover.

Keep on building and check in frequently for the latest

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

# 中文

人们之前问过我关于Aptos的Move Prover以及它的特殊之处。

我将简要介绍一下带有Venmo般托管合约的Prover在#DailyMove上的使用。

在@Aptos上，Move prover允许您正式验证您的代码，以确保在所有情况下都保持某些属性。

让我们谈谈我们的项目需求：

1. 用户应能够向另一个用户发送资金
2. 发送方可以在接受之前拒绝支付
3. 接收方可以接受或拒绝支付

深入了解一些代码，我们希望有一个Escrow对象，用于跟踪硬币和原始发送方。

您可以看到下面有**struct不变式**，这些不变式适用于所有情况下的结构。在这种情况下，我们确保托管不应为空。

![https://pbs.twimg.com/media/GIrGVDSaMAAG1Qg?format=jpg&name=medium](https://pbs.twimg.com/media/GIrGVDSaMAAG1Qg?format=jpg&name=medium)

我们可以添加形式验证规范来确保代码是有效的。

1. 转移的硬币数量正确
2. 发送方始终被跟踪
3. 我们有该实际对象的删除引用以便以后删除它

![https://pbs.twimg.com/media/GIrHHS0bsAE_WBU?format=jpg&name=medium](https://pbs.twimg.com/media/GIrHHS0bsAE_WBU?format=jpg&name=medium)

我们可以看到当我们运行prover时，它验证了这些属性。

特别是，其中一个说托管不能为0。让我们改变一下！

![https://pbs.twimg.com/media/GIrHso3asAAC1OH?format=png&name=medium](https://pbs.twimg.com/media/GIrHso3asAAC1OH?format=png&name=medium)

我移除了一个检查，即托管金额必须大于0，只是为了看看prover会如何捕捉到它。

![https://pbs.twimg.com/media/GIrILRLakAEymzb?format=jpg&name=medium](https://pbs.twimg.com/media/GIrILRLakAEymzb?format=jpg&name=medium)

然后prover告诉我哪些不变式没有被保持，并附有一个证明的跟踪。

通过更改这一行，我现在使得托管可以为0，而prover也捕捉到了这一点。

![https://pbs.twimg.com/media/GIrIfnRaIAA54L2?format=jpg&name=medium](https://pbs.twimg.com/media/GIrIfnRaIAA54L2?format=jpg&name=medium)

但是，这与代码覆盖有何不同呢？

代码覆盖告诉您代码中的某一行是否被覆盖，但不会告诉您每个可能的输入。

形式验证更加技术化，通常通过证明没有可能破坏属性的输入来确保每个输入都会保持属性。

您可以在这里了解更多有关Prover的信息：[https://aptos.dev/move/prover/move-prover](https://aptos.dev/move/prover/move-prover)

以及示例的源代码在这里：[https://github.com/aptos-labs/daily-move/blob/main/snippets/prover/sources/payment_escrow.move](https://github.com/aptos-labs/daily-move/blob/main/snippets/prover/sources/payment_escrow.move)

[https://pbs.twimg.com/card_img/1776982127621419008/GMSw8irv?format=jpg&name=medium](https://pbs.twimg.com/card_img/1776982127621419008/GMSw8irv?format=jpg&name=medium)

[来自 aptos.dev](https://t.co/9aCln3CZ8t)

感谢阅读我的Move prover帖子。

继续构建，并经常查看最新动态

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)