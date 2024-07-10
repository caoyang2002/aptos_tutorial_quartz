---
title: Move 0x1 中断是什么意思？
---
```yaml
original: 
  author: Greg
  url: https://x.com/Greg_Nazario/status/1748257251343864219
created: 2024年1月19日
note: 纯机翻、未核对
```

[查看原文](https://x.com/Greg_Nazario/status/1748257251343864219)

>[!NOTE] 问题
>原帖子的问题来自于 Discord 上的提问：
>“Move中止0x1是什么意思？”
>[https://pbs.twimg.com/media/GGQJghPbIAEY2bl?format=png&name=900x900](https://pbs.twimg.com/media/GGQJghPbIAEY2bl?format=png&name=900x900)

你是否曾经在钱包中看到过一个不太有帮助的错误消息？让我们深入了解开发者如何修复这个问题：

![https://pbs.twimg.com/media/GEMKNHBbkAAhLFx?format=png&name=900x900](https://pbs.twimg.com/media/GEMKNHBbkAAhLFx?format=png&name=900x900)

Move 语言中的错误代码用于区分合约中的错误。它让你能够确定是你没有支付足够的费用，还是你提供了无效的输入。

让我们看看下面的这个代码片段。在错误代码上面没有文档注释`///`。这意味着错误没有附加的消息。

![https://pbs.twimg.com/media/GEMLDTTb0AE-FjI?format=jpg&name=large](https://pbs.twimg.com/media/GEMLDTTb0AE-FjI?format=jpg&name=large)

上面的函数最终产生了一个错误消息，给出了代码 `0x1`，这与预期的代码相同。但是，给出了一个非常无用的帮助消息。

让我们修复它。

![https://pbs.twimg.com/media/GEMLbYxbwAAmRdK?format=png&name=small](https://pbs.twimg.com/media/GEMLbYxbwAAmRdK?format=png&name=small)

我们现在将在错误消息上方添加一个文档注释`///`。这将把注释消息作为交易的错误消息附加上。这样你的用户就可以直接理解错误是什么，而不需要额外的说明信息。

![https://pbs.twimg.com/media/GEMMMBTawAAnMD4?format=jpg&name=medium](https://pbs.twimg.com/media/GEMMMBTawAAnMD4?format=jpg&name=medium)

我们现在得到了一个有用的错误消息，正是文档注释中所说的！

![https://pbs.twimg.com/media/GEMMusgaIAARcXl?format=png&name=small](https://pbs.twimg.com/media/GEMMusgaIAARcXl?format=png&name=small)

>[!NOTE] 如何用？
>
>但是，Greg，我们应该使用什么样的惯例 / 模式呢？

按照惯例，错误消息的名称以`E`开头，并且全部是大写字母。它们是常量，并且始终是 `u64` 类型。

还可以将错误分类为不同的类型。

![https://pbs.twimg.com/media/GEMNH_4bEAADJwW?format=jpg&name=medium](https://pbs.twimg.com/media/GEMNH_4bEAADJwW?format=jpg&name=medium)

通过使用`std::error::<type>`的分类，它为错误代码添加了一个前缀。这允许更容易地分割共享但不同类型的错误。

如果有一个错误消息，它不会直接显示给用户的消息，所以我在这里跳过它，以展示它看起来像什么。

![https://pbs.twimg.com/media/GEMNLUybIAAFxG_?format=jpg&name=medium](https://pbs.twimg.com/media/GEMNLUybIAAFxG_?format=jpg&name=medium)

正如你所看到的，它为错误代码添加了`0xc`前缀。

![https://pbs.twimg.com/media/GEMNoKxa4AAdNgE?format=png&name=small](https://pbs.twimg.com/media/GEMNoKxa4AAdNgE?format=png&name=small)

你可以查看下面用于这个代码片段的所有[源代码](https://github.com/aptos-labs/daily-move/blob/main/snippets/19-01-2024/sources/error_codes.move)，并请在下面留下任何问题和想法。在[@Aptos_Network](https://twitter.com/Aptos_Network)上愉快地构建！



# 源代码（中文）

此代码片段教导我们关于错误代码的知识

- 双斜杠 `//` 仅代表注释，而三斜杠 `///` 代表文档注释

- 当文档注释放在错误代码上方时，可用 DApp 中提供有用的错误消息

请根据以下说明使用 aptos CLI 自行部署

```
MY_ADDR=0x12345
aptos move publish --named-addresses deploy_addr=$MY_ADDR
```

或者，如果您已在 Aptos CLI 中设置配置文件，也可以直接使用该配置文件

```
aptos init --profile my-profile
aptos move publish --profile my-profile --named-addresses deploy_addr=my-profile
```

类似地，如果设置了默认配置文件，那么它也会起作用。

```
aptos init
aptos move publish --named-addresses deploy_addr=default
```

然后，您可以直接在 `https://explorer.aptoslabs.com/account/<ADDRESS>/modules/run/error_codes?network=devnet` 上使用钱包进行测试

```rust
module deploy_addr::error_codes {
    // 按照最佳实践，应将常量放置在函数顶部附近，但为了本教程的目的，我们将它们放在它们的使用位置旁边。
    //
    // 按照惯例，错误代码常量应以 E 开头。
    // 如果以 E 开头，那么它非常清楚地是一个错误，并且将显示在错误中。
    //
    // 错误代码始终是常量。错误消息始终是 u64 类型，并且按照惯例跳过 0，从 1 开始。请记住，所有错误应该有不同编号。如果它们相同，则错误消息可能会混在一起。

    // 双斜杠注释，不计入错误消息。确保它们是三个斜杠（文档注释）
    const E_ERROR_WITHOUT_MESSAGE: u64 = 1;

    /// 此函数将在没有有用的错误消息的情况下出错
    entry fun throw_error_code_only() {
        abort E_ERROR_WITHOUT_MESSAGE
    }

    /// 此错误消息将出现在错误消息中
    const E_USEFUL_ERROR: u64 = 2;

    /// 此函数将在定义上述有用的错误消息时出错
    entry fun throw_useful_error() {
        abort E_USEFUL_ERROR
    }

    // 此错误使用错误类型提供错误分组，注意错误代码将是 0xc0003
    const E_ERROR_WITH_CLASSIFICATION: u64 = 3;

    /// 此错误将抛出错误，但具有更高的错误代码，用于分类
    entry fun throw_classified_error() {
        abort std::error::not_implemented(E_ERROR_WITH_CLASSIFICATION)
    }

    /// 值不是 true，所以我们正在使函数失败
    const E_VALUE_NOT_TRUE: u64 = 4;

    /// 如果输入为 false，则此函数将失败，并带有有用的错误消息。这是大多数错误的方式
    entry fun throw_if_false(input: bool) {
        assert!(input == true, E_VALUE_NOT_TRUE)
    }
}
```
