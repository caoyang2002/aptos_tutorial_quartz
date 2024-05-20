---
title: 分割 NFT
---
```yaml
original: 
  author: Greg
  url: 
note: 纯机翻、未核对
```
# Question

Another builder asked me:

"How do I fractionalize an NFT?"

The source code goes fully into how to fractionalize it, and using the extending example, you can actually add more on top!

# English

gm ! People have been asking me, how do you fractionalize an NFT? Let's dive into one possible way to fractionalize a Digital Asset on this episode of [#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

First, what is a fractionalized asset.

A fractionalized asset is when a single item is split into fractional ownership, a percentage of the full item.

Think of this as a puzzle, you own an individual piece of the whole puzzle, or multiple pieces, but not the whole puzzle.

Let's think about the requirements we want for our fungible asset:

- Interoperable with other systems
- Represents the actual asset (locked up)
- Allows for owning variable size parts

We'll use a Fungible Asset to fractionalize it. Let's take a look at the storage for the Digital Asset.

We want to allow locking up the digital asset, and the ability to unlock it if the owner holds 100% of the fractionalized parts.

We have stored here the DigitalAsset here to lockup.

The ExtendRef for allows someone to defractionalize the asset only if they have 100%, and the BurnRef will allow destroying the fractionalized pieces when the token is claimed.

Having the "ObjectGroup" allows us to extend this in the future, if we find that we're missing something.

[https://pbs.twimg.com/media/GF13P8mbEAAvE-u?format=png&name=small](https://pbs.twimg.com/media/GF13P8mbEAAvE-u?format=png&name=small)

Okay, let's now start fractionalizing!

We first need to retrieve the token information, with the AptosTokenObjects library and then we can build the object for the fractionalized asset.

We specifically make this a sticky object, because fungible assets require that the metadata is not deletable.

This is because we want to make sure the asset is usable by other systems, and not to disappear.

Then, we go ahead and build up some information about the Fungible Asset from the Digital Asset that was its source.

[https://pbs.twimg.com/media/GF15db1bAAEx4HX?format=jpg&name=medium](https://pbs.twimg.com/media/GF15db1bAAEx4HX?format=jpg&name=medium)

Here's the fun part!

We can simply attach fungible asset to the object to allow it to be used as the metadata for the fungible asset.

At this point, we save the burn ref for cleanup later, and actually lock the asset up, while minting the number of shares we wanted.

Note, the mint ref is thrown away at the end of this function. No additional shares can be minted.

At this point your favorite wallet or defi tools can be used with the fractional asset directly if the support fungible assets.

[https://pbs.twimg.com/media/GF16A8FagAABXeq?format=png&name=900x900](https://pbs.twimg.com/media/GF16A8FagAABXeq?format=png&name=900x900)

But, what if you just want the Digital Asset back?

You can simply recombine all the shares if you have them, and burn all of the fractionalized pieces, unlocking the Digital Asset back to your wallet.

[https://pbs.twimg.com/media/GF17gzFbIAAlXU-?format=jpg&name=medium](https://pbs.twimg.com/media/GF17gzFbIAAlXU-?format=jpg&name=medium)

What next?

There's tons of extensions that can be handled here:

- Make it into a DAO, so the NFT can be used in staking and other places
- Allow minting extra shares with the DAO
- Make the fungible asset also a Digital Asset, so that it shows up in your wallet like a NFT
- And many more!

Thanks everyone for reading this episode of

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

and special thanks to

[@AptosNoob](https://twitter.com/AptosNoob)

for suggesting it!

LFM

Also, source code for these snippets:

[](https://t.co/nXP3nt7tJs)

[https://github.com/aptos-labs/daily-move/blob/main/snippets/fractional-token/sources/fractional_token.move](https://github.com/aptos-labs/daily-move/blob/main/snippets/fractional-token/sources/fractional_token.move)

# 问题

另一位构建者问我：

“我如何将一个NFT进行分割？”

源代码完全涵盖了如何将其分割，并且使用扩展示例，你实际上可以在此基础上添加更多！

# 中文

早上好！人们一直在问我，你如何将一个NFT进行分割？让我们在这一集的[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)中深入探讨一种可能的数字资产分割方式。

首先，什么是分割的资产。

分割的资产是指将单个物品分割成部分所有权，即整体物品的一部分百分比。

把这看作是一个拼图，你拥有整个拼图的一个单独的部分，或者多个部分，但不拥有整个拼图。

让我们思考一下我们对可交换资产的要求：

- 可与其他系统互操作
- 表示实际资产（锁定）
- 允许拥有不同大小的部分

我们将使用可交换资产来进行分割。让我们来看一下数字资产的存储。

我们希望允许锁定数字资产，并且如果所有者持有100％的分割部分，则可以解锁它。

我们在这里存储了数字资产以进行锁定。

ExtendRef允许某人仅在拥有100％时对资产进行分割，而BurnRef将允许在索赔代币时销毁分割的部分。

拥有“ObjectGroup”可以使我们在未来扩展这一点，如果我们发现我们缺少某些功能。

![https://pbs.twimg.com/media/GF13P8mbEAAvE-u?format=png&name=small](https://pbs.twimg.com/media/GF13P8mbEAAvE-u?format=png&name=small)

好的，现在让我们开始进行分割！

我们首先需要使用AptosTokenObjects库检索代币信息，然后我们可以构建分割资产的对象。

我们明确将其设置为粘性对象，因为可交换资产要求元数据不可删除。

这是因为我们希望确保资产可供其他系统使用，并且不会消失。

然后，我们继续从源数字资产构建一些有关可交换资产的信息。

![https://pbs.twimg.com/media/GF15db1bAAEx4HX?format=jpg&name=medium](https://pbs.twimg.com/media/GF15db1bAAEx4HX?format=jpg&name=medium)

这里是有趣的部分！

我们可以简单地将可交换资产附加到对象上，以使其作为可交换资产的元数据使用。

在这一点上，我们保存燃烧引用以供以后清理，并实际锁定资产，同时铸造我们想要的股份数量。

请注意，铸造引用在此函数结束时被丢弃。无法再铸造额外的股份。

此时，如果支持可交换资产，你可以直接使用你喜爱的钱包或DeFi工具与分割资产一起使用。

![https://pbs.twimg.com/media/GF16A8FagAABXeq?format=png&name=900x900](https://pbs.twimg.com/media/GF16A8FagAABXeq?format=png&name=900x900)

但是，如果你只想要数字资产呢？

如果你有所有的股份，你可以简单地重新组合所有股份，并烧毁所有分割的部分，将数字资产解锁回到你的钱包。

![https://pbs.twimg.com/media/GF17gzFbIAAlXU-?format=jpg&name=medium](https://pbs.twimg.com/media/GF17gzFbIAAlXU-?format=jpg&name=medium)

接下来呢？

这里有大量的扩展可以处理：

- 将其制作成DAO，使NFT可以在抵押和其他地方使用
- 允许使用DAO铸造额外的股份
- 使可交换资产也成为数字资产，以便在钱包中显示为NFT
- 还有许多其他！

感谢大家阅读这一集的[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

特别感谢[@AptosNoob](https://twitter.com/AptosNoob)提出这个问题！

祝顺利！

另外，这些片段的源代码：

[https://github.com/aptos-labs/daily-move/blob/main/snippets/fractional-token/sources/fractional_token.move](https://github.com/aptos-labs/daily-move/blob/main/snippets/fractional-token/sources/fractional_token.move)