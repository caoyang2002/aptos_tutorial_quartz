---
title: 可分割 token 和 ERC-404
---
```yaml
original: 
  author: Greg
  url: 
note: 纯机翻、未核对
```
# English

It was a leap day yesterday, so an extra day to learn, and an extra episode of

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

People asked me a bunch about fractionalized tokens and ERC-404, so I figured I'd do my take on it on Aptos.

ERC-404 is a semi-standard for defining a mixture of a ERC-20 fungible token and a ERC-721 non-fungible token. The purpose here being to add more liquidity to NFTs

The main takeaways of ERC-404 from my research was the ability to convert between a fungible and non-fungible token seamlessly, and that the two supplies are tied to each other.

My take here is that it needs this functionality:

- A 1:1 NFT to Fungible token (with decimals) supply
- Ability to exchange between either seamlessly
- Randomization between NFTs (for rarity)

Let's dive into some code! Fungible Assets on Aptos provides a next-gen way for fungible tokens. I have an additional example for Coin, but we'll skip it.

Below we see that we ensure only the owner can fractionalize the token, and the supply must be fixed.

[https://pbs.twimg.com/media/GHmq6rDboAESgc-?format=png&name=900x900](https://pbs.twimg.com/media/GHmq6rDboAESgc-?format=png&name=900x900)

We then take that information to create a pool of fungible assets, and provide some metadata for the pool. It's tied to the collection.

[https://pbs.twimg.com/media/GHmrOp4asAAp_ti?format=jpg&name=medium](https://pbs.twimg.com/media/GHmrOp4asAAp_ti?format=jpg&name=medium)

Creating this fungible asset uses a primary fungible store. You can think of this as a primary store, that you can easily access based on your account. Like a primary bank account.

Fungible assets gives the ability to have secondary stores as well, but we'll ignore it here.

[https://pbs.twimg.com/media/GHmrcgrbcAANacm?format=png&name=900x900](https://pbs.twimg.com/media/GHmrcgrbcAANacm?format=png&name=900x900)

At this point we have an object that holds all of the fungible assets, but, how do we exchange them?

Here we lock up NFTs into the fungible asset's metadata object, and issue fungible assets from the pool for each.

This gives liquid tokens to the user for their NFTs.

[https://pbs.twimg.com/media/GHmsIQ3aQAAyPGD?format=png&name=900x900](https://pbs.twimg.com/media/GHmsIQ3aQAAyPGD?format=png&name=900x900)

At this point a user can go and do anything they want with these liquid tokens, and as well swap them in for the NFTs directly.

The contract allows a user to claim the tokens, which would swap a whole liquid tokens (not fractional) for NFTs, but randomly choose them.

[https://pbs.twimg.com/media/GHmse1da0AEMJRe?format=jpg&name=medium](https://pbs.twimg.com/media/GHmse1da0AEMJRe?format=jpg&name=medium)

That means you can liquify, and claim, and liquify, and claim to get randomly other NFTs in the pool.

Keeping in mind that the functions for claim and liquify **must be** non-public entry, to prevent cheating on the randomization.

[https://pbs.twimg.com/media/GHmtEDMaYAALIuN?format=png&name=small](https://pbs.twimg.com/media/GHmtEDMaYAALIuN?format=png&name=small)

And that's it, you've got liquid NFTs for a collection that can be swapped in and out, there are other extension you can do like:

- Use upcoming randomness rather than the pseudorandom generator I made here
- Randomness by rarity or types rather than treating all NFTs the same

Thanks for reading, and comment below of what collections you might want to use this on.

Source:

[](https://t.co/W68qIDadvB)[https://github.com/aptos-labs/daily-move/blob/main/snippets/liquid-nfts/sources/liquid_fungible_asset.move](https://github.com/aptos-labs/daily-move/blob/main/snippets/liquid-nfts/sources/liquid_fungible_asset.move)

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

# 中文

昨天是一个闰日，所以有一个额外的学习日，也有一个额外的

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

人们问了我很多关于分数化代币和 ERC-404 的问题，所以我觉得我应该在 Aptos 上谈谈我的看法。

ERC-404 是一个半标准，用于定义 ERC-20 可互换代币和ERC-721不可互换代币的混合体。这里的目的是为NFT增加更多的流动性。

从我的研究中得出的 ERC-404 的主要结论是能够在可互换和不可互换代币之间无缝转换，并且两者的供应量是相互关联的。

我的看法是它需要以下功能：

- 1:1 的 NFT 到可互换代币（带小数位）供应
- 能够在两者之间无缝交换
- 对 NFT 进行随机化（用于稀有度）

让我们深入一些代码吧！在 Aptos 上的可互换资产为可互换代币提供了下一代的方式。我还有一个关于 Coin 的额外示例，但我们将跳过它。

下面我们看到我们确保只有所有者可以将代币分数化，而且供应量必须固定。

![https://pbs.twimg.com/media/GHmq6rDboAESgc-?format=png&name=900x900](https://pbs.twimg.com/media/GHmq6rDboAESgc-?format=png&name=900x900)

然后我们利用这些信息创建一个可互换资产池，并为该池提供一些元数据。它与集合相关联。

![https://pbs.twimg.com/media/GHmrOp4asAAp_ti?format=jpg&name=medium](https://pbs.twimg.com/media/GHmrOp4asAAp_ti?format=jpg&name=medium)

创建这个可互换资产使用了一个主要的可互换存储。您可以将其视为一个主要的存储，根据您的帐户轻松访问。就像主要的银行账户一样。

可互换资产还可以拥有次要存储的能力，但我们在这里将其忽略。

![https://pbs.twimg.com/media/GHmrcgrbcAANacm?format=png&name=900x900](https://pbs.twimg.com/media/GHmrcgrbcAANacm?format=png&name=900x900)

到目前为止，我们有一个包含所有可互换资产的对象，但是，我们如何交换它们呢？

在这里，我们将NFT锁定到可互换资产的元数据对象中，并为每个NFT从池中发行可互换资产。

这为用户的NFT提供了流动的代币。

![https://pbs.twimg.com/media/GHmsIQ3aQAAyPGD?format=png&name=900x900](https://pbs.twimg.com/media/GHmsIQ3aQAAyPGD?format=png&name=900x900)

此时，用户可以对这些流动代币做任何他们想做的事情，同时也可以直接将其兑换成NFT。

合同允许用户领取代币，这将交换整个流动代币（而不是部分），但是会随机选择它们。

![https://pbs.twimg.com/media/GHmse1da0AEMJRe?format=jpg&name=medium](https://pbs.twimg.com/media/GHmse1da0AEMJRe?format=jpg&name=medium)

这意味着您可以将其转化为流动代币，然后兑换，再转化，再兑换，以随机获取池中的其他NFT。

请记住，领取和转化的函数**必须**是非公开的入口，以防止随机化时的作弊。

![https://pbs.twimg.com/media/GHmtEDMaYAALIuN?format=png&name=small](https://pbs.twimg.com/media/GHmtEDMaYAALIuN?format=png&name=small)

就是这样，您已经拥有了可以无缝交换的集合的流动NFT，您可以进行其他扩展，比如：

- 使用即将推出的随机性而不是我在这里制作的伪随机生成器
- 根据稀有度或类型而不是将所有NFT视为相同来进行随机化

感谢阅读，请在下面评论您可能想要在哪些集合上使用这个功能。

来源：

[https://github.com/aptos-labs/daily-move/blob/main/snippets/liquid-nfts/sources/liquid_fungible_asset.move](https://github.com/aptos-labs/daily-move/blob/main/snippets/liquid-nfts/sources/liquid_fungible_asset.move)

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)