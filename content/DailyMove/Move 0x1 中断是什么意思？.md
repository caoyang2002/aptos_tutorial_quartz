---
title: Move 0x1 中断是什么意思？
---
```yaml
original: 
  author: Greg
  url: 
note: 纯机翻、未核对
```
# Question

And the OG post, was inspired by discord questions of:

"What does Move abort 0x1 mean?"

[https://pbs.twimg.com/media/GGQJghPbIAEY2bl?format=png&name=900x900](https://pbs.twimg.com/media/GGQJghPbIAEY2bl?format=png&name=900x900)

# English

Happy Friday! I wanted to kick off a new series for Move on

[@Aptos_Network](https://twitter.com/Aptos_Network)

:

Ever wondered why you've seen an unhelpful error message in a wallet? Let's dive in how a dev can fix this:

[](https://t.co/3IH5Kopmw0)[https://github.com/aptos-labs/daily-move/blob/main/snippets/19-01-2024/sources/error_codes.move](https://github.com/aptos-labs/daily-move/blob/main/snippets/19-01-2024/sources/error_codes.move)

[https://pbs.twimg.com/media/GEMKNHBbkAAhLFx?format=png&name=900x900](https://pbs.twimg.com/media/GEMKNHBbkAAhLFx?format=png&name=900x900)

Error codes in Move differentiate between errors in a contract. It let's you determine whether you didn't pay enough, or you gave invalid inputs.

Let's look at this snippet below. There's no doc comment `///` above the error. This means that the error has no messaged attached.

[https://pbs.twimg.com/media/GEMLDTTb0AE-FjI?format=jpg&name=large](https://pbs.twimg.com/media/GEMLDTTb0AE-FjI?format=jpg&name=large)

The function above ends up with this error message that gives the code `0x1`, which is the same as the expected code. But, gives a very unhelpful message.

Let's fix that

[https://pbs.twimg.com/media/GEMLbYxbwAAmRdK?format=png&name=small](https://pbs.twimg.com/media/GEMLbYxbwAAmRdK?format=png&name=small)

We will now add a doc comment `///` above the error message. This will attach the comment message as the error message for the transaction.

This way your users can understand what the error is directly, without extra information.

[https://pbs.twimg.com/media/GEMMMBTawAAnMD4?format=jpg&name=medium](https://pbs.twimg.com/media/GEMMMBTawAAnMD4?format=jpg&name=medium)

We now get a useful error message, that is exactly what the doc comment said above!

[https://pbs.twimg.com/media/GEMMusgaIAARcXl?format=png&name=small](https://pbs.twimg.com/media/GEMMusgaIAARcXl?format=png&name=small)

But, Greg what kind of conventions / patterns should we use?

Error messages by convention start with an `E` in the name, and are all caps. They're constants, and always u64 type.

There is also the ability for error classification into different types.

[https://pbs.twimg.com/media/GEMNH_4bEAADJwW?format=jpg&name=medium](https://pbs.twimg.com/media/GEMNH_4bEAADJwW?format=jpg&name=medium)

By using the classification of `std::error::<type>`, it adds a prefix to the error code. This allows for easier splitting of shared but different types of errors.

It won't show for a user's message directly, if there's an error message, so I skip it here to show what it looks like.

[https://pbs.twimg.com/media/GEMNLUybIAAFxG_?format=jpg&name=medium](https://pbs.twimg.com/media/GEMNLUybIAAFxG_?format=jpg&name=medium)

And as you can see, it adds the `0xc` prefix to the error code.

[https://pbs.twimg.com/media/GEMNoKxa4AAdNgE?format=png&name=small](https://pbs.twimg.com/media/GEMNoKxa4AAdNgE?format=png&name=small)

You can check out all the source used for this snippet below, and please leave any questions and thoughts below. Happy building on

[@Aptos_Network](https://twitter.com/Aptos_Network)

![https://abs-0.twimg.com/emoji/v2/svg/1f310.svg](https://abs-0.twimg.com/emoji/v2/svg/1f310.svg)

[](https://t.co/3IH5Kopmw0)[https://github.com/aptos-labs/daily-move/blob/main/snippets/19-01-2024/sources/error_codes.move](https://github.com/aptos-labs/daily-move/blob/main/snippets/19-01-2024/sources/error_codes.move)

# 问题

原始帖子的灵感来自于Discord上的提问：

“Move中止0x1是什么意思？”

[https://pbs.twimg.com/media/GGQJghPbIAEY2bl?format=png&name=900x900](https://pbs.twimg.com/media/GGQJghPbIAEY2bl?format=png&name=900x900)

# 中文

周五愉快！我想在[@Aptos_Network](https://twitter.com/Aptos_Network)上为Move语言启动一个新的系列：

你是否曾经在钱包中看到过一个不太有帮助的错误消息？让我们深入了解开发者如何修复这个问题：

[错误代码的Move语言源代码](https://t.co/3IH5Kopmw0)

![https://pbs.twimg.com/media/GEMKNHBbkAAhLFx?format=png&name=900x900](https://pbs.twimg.com/media/GEMKNHBbkAAhLFx?format=png&name=900x900)

Move语言中的错误代码用于区分合约中的错误。它让你能够确定是你没有支付足够的费用，还是你提供了无效的输入。

让我们看看下面的这个代码片段。在错误代码上面没有文档注释`///`。这意味着错误没有附加的消息。

![https://pbs.twimg.com/media/GEMLDTTb0AE-FjI?format=jpg&name=large](https://pbs.twimg.com/media/GEMLDTTb0AE-FjI?format=jpg&name=large)

上面的函数最终产生了一个错误消息，给出了代码`0x1`，这与预期的代码相同。但是，给出了一个非常不有帮助的消息。

让我们修复它。

![https://pbs.twimg.com/media/GEMLbYxbwAAmRdK?format=png&name=small](https://pbs.twimg.com/media/GEMLbYxbwAAmRdK?format=png&name=small)

我们现在将在错误消息上方添加一个文档注释`///`。这将把注释消息作为事务的错误消息附加上。

这样你的用户就可以直接理解错误是什么，而不需要额外的信息。

![https://pbs.twimg.com/media/GEMMMBTawAAnMD4?format=jpg&name=medium](https://pbs.twimg.com/media/GEMMMBTawAAnMD4?format=jpg&name=medium)

我们现在得到了一个有用的错误消息，正是文档注释中所说的！

![https://pbs.twimg.com/media/GEMMusgaIAARcXl?format=png&name=small](https://pbs.twimg.com/media/GEMMusgaIAARcXl?format=png&name=small)

但是，Greg，我们应该使用什么样的惯例/模式呢？

按照惯例，错误消息的名称以`E`开头，并且全部是大写字母。它们是常量，并且始终是u64类型。

还可以将错误分类为不同类型的能力。

![https://pbs.twimg.com/media/GEMNH_4bEAADJwW?format=jpg&name=medium](https://pbs.twimg.com/media/GEMNH_4bEAADJwW?format=jpg&name=medium)

通过使用`std::error::<type>`的分类，它为错误代码添加了一个前缀。这允许更容易地分割共享但不同类型的错误。

如果有一个错误消息，它不会直接显示给用户的消息，所以我在这里跳过它，以展示它看起来像什么。

![https://pbs.twimg.com/media/GEMNLUybIAAFxG_?format=jpg&name=medium](https://pbs.twimg.com/media/GEMNLUybIAAFxG_?format=jpg&name=medium)

正如你所看到的，它为错误代码添加了`0xc`前缀。

![https://pbs.twimg.com/media/GEMNoKxa4AAdNgE?format=png&name=small](https://pbs.twimg.com/media/GEMNoKxa4AAdNgE?format=png&name=small)

你可以查看下面用于这个代码片段的所有源代码，并请在下面留下任何问题和想法。在[@Aptos_Network](https://twitter.com/Aptos_Network)上愉快地构建！

![https://abs-0.twimg.com/emoji/v2/svg/1f310.svg](https://abs-0.twimg.com/emoji/v2/svg/1f310.svg)

[查看错误代码Move语言源代码](https://t.co/3IH5Kopmw0)