---
title: 出售可组合的 NFT
---
# Question

Some gaming builders were really excited about composable NFTs.

"How do I combine two NFTs together and sell them as one?"

This was inspired by [@firstdrop_xyz](https://twitter.com/firstdrop_xyz)'s Sw33t friends a while back, and has inspired [@AptosCreature](https://twitter.com/AptosCreature) as well.

# English

Have you ever wondered, how do people make dynamic, composable NFTs? Let's dive right in and make your move into [#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

Composability with the Aptos Digital Standard is fairly easy. Objects can own other objects. But, the amazing feature is the extensibility.

In this particular example, I have a Face token, and a Hat token. You can see here, that both are structs that describe the features of these individual tokens. In this case that the Face, has an equippable hat.

[https://pbs.twimg.com/media/GEo7sJeakAAVQnZ?format=jpg&name=medium](https://pbs.twimg.com/media/GEo7sJeakAAVQnZ?format=jpg&name=medium)

We first have to create both collections for the Faces, and the Hats. In this example, I'll use an Object specifically to own the collection rather than an account or resource account.

This is simply done by creating an object, and then minting the collection inside it.

[https://pbs.twimg.com/media/GEo8MJgaAAAXy_u?format=jpg&name=medium](https://pbs.twimg.com/media/GEo8MJgaAAAXy_u?format=jpg&name=medium)

You can see here, I create a collection, with the ExtendRef attached. This is specifically so I can mint the NFTs, without needing the creator to specifically sign.

For these collections, they're unlimited, free, and totally permissionless.

[https://pbs.twimg.com/media/GEpBDQRaUAA4IKP?format=jpg&name=medium](https://pbs.twimg.com/media/GEpBDQRaUAA4IKP?format=jpg&name=medium)

Simply enough, tokens are minted with a single transaction. We extend the Token object with the Face or Hat above, along with associated properties.

In this example, we mint a face, with no hat and transfer to the user.

[https://pbs.twimg.com/media/GEpBhHbbkAAxv4y?format=jpg&name=900x900](https://pbs.twimg.com/media/GEpBhHbbkAAxv4y?format=jpg&name=900x900)

[https://pbs.twimg.com/media/GEpBwaoboAAtHGS?format=jpg&name=small](https://pbs.twimg.com/media/GEpBwaoboAAtHGS?format=jpg&name=small)

Now, we can simply mint these NFTs directly with a wallet for both Face and Hat easily with even the explorer.

[](https://t.co/pgjonmvaJs)[https://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/run/composable_nfts/mint_face?network=testnet](https://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/run/composable_nfts/mint_face?network=testnet)[](https://t.co/tunUroyZCM)[https://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/run/composable_nfts/mint_sailor_hat?network=testnet](https://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/run/composable_nfts/mint_sailor_hat?network=testnet)

[https://pbs.twimg.com/media/GEpCiZcaIAANBYO?format=png&name=360x360](https://pbs.twimg.com/media/GEpCiZcaIAANBYO?format=png&name=360x360)

[https://pbs.twimg.com/media/GEpClMia8AAFDF1?format=png&name=360x360](https://pbs.twimg.com/media/GEpClMia8AAFDF1?format=png&name=360x360)

Let's say we wanted to combine them! In order to put the hat on the user, we'll use an add_hat function. It goes ahead and transfers ownership of the hat to the face, locks it from being transferred, and changes the NFT metadata.

[https://pbs.twimg.com/media/GEpC0mWb0AA-iex?format=jpg&name=small](https://pbs.twimg.com/media/GEpC0mWb0AA-iex?format=jpg&name=small)

[https://pbs.twimg.com/media/GEpC3SybMAAwYEF?format=jpg&name=large](https://pbs.twimg.com/media/GEpC3SybMAAwYEF?format=jpg&name=large)

It get's nicely applied as a face with a sailor hat, and the image is directly updated in my wallet. The hat is now a part of the face, and will go everywhere with the face. It can't be transferred on it's own unless we remove it.

[https://pbs.twimg.com/media/GEpC9whbQAA1Sp8?format=png&name=360x360](https://pbs.twimg.com/media/GEpC9whbQAA1Sp8?format=png&name=360x360)

We can remove the hat afterwards with a similar function. Pulling the hat ownership back to the face's owner, and unlocking transfer.

[https://pbs.twimg.com/media/GEpDH8WbgAAwkk7?format=jpg&name=medium](https://pbs.twimg.com/media/GEpDH8WbgAAwkk7?format=jpg&name=medium)

Thanks for reading, and hopefully this helps you think of dynamic NFT and composable NFT use cases as a creator. As always, the code is open source here

[](https://t.co/IqTkpnovcy)[https://github.com/aptos-labs/daily-move/tree/main/snippets/composable-nfts](https://github.com/aptos-labs/daily-move/tree/main/snippets/composable-nfts)

And this time, I've deployed the code also here on testnet for anyone to try

[](https://t.co/DcBumB9uej)[https://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/code/composable_nfts/mint_sailor_hat?network=testnet](https://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/code/composable_nfts/mint_sailor_hat?network=testnet)

# 问题

一些游戏开发者对可组合的 NFT 非常兴奋。

“我如何将两个NFT组合在一起并作为一件出售？”

这受到了@firstdrop_xyz的Sw33t朋友一段时间前的启发，也启发了@AptosCreature。

# 中文

你是否曾经想过，人们是如何制作动态的、可组合的NFT的？让我们直接进入并开始你的行动到[#DailyMove](https://xn--y9gaa/hashtag/DailyMove?src=hashtag_click)

在Aptos数字标准中，可组合性相当容易。对象可以拥有其他对象。但，令人惊叹的特性是可扩展性。

在这个特别的例子中，我有一个脸的代币，和一个帽子的代币。你可以看到，这两个都是描述这些个别代币特征的结构体。在这个例子中，脸有一个可装备的帽子。

![https://pbs.twimg.com/media/GEo7sJeakAAVQnZ?format=jpg&name=medium](https://pbs.twimg.com/media/GEo7sJeakAAVQnZ?format=jpg&name=medium)

我们首先必须为脸和帽子创建两个集合。在这个例子中，我将使用一个对象专门拥有集合，而不是账户或资源账户。

这只需通过创建一个对象，然后在其中铸造集合即可完成。

![https://pbs.twimg.com/media/GEo8MJgaAAAXy_u?format=jpg&name=medium](https://pbs.twimg.com/media/GEo8MJgaAAAXy_u?format=jpg&name=medium)

你可以看到，我创建了一个集合，附带了ExtendRef。这是为了我可以铸造NFT，而不需要创作者特别签名。

对于这些集合，它们是无限的、免费的，并且完全无需许可。

![https://pbs.twimg.com/media/GEpBDQRaUAA4IKP?format=jpg&name=medium](https://pbs.twimg.com/media/GEpBDQRaUAA4IKP?format=jpg&name=medium)

简单来说，代币通过单笔交易铸造。我们扩展了Token对象，上面有脸或帽子以及相关属性。

在这个例子中，我们铸造了一个没有帽子的脸，并将其转移给用户。

![https://pbs.twimg.com/media/GEpBhHbbkAAxv4y?format=jpg&name=900x900](https://pbs.twimg.com/media/GEpBhHbbkAAxv4y?format=jpg&name=900x900)

![https://pbs.twimg.com/media/GEpBwaoboAAtHGS?format=jpg&name=small](https://pbs.twimg.com/media/GEpBwaoboAAtHGS?format=jpg&name=small)

现在，我们可以直接使用钱包为脸和帽子铸造这些NFT，甚至使用浏览器。

[https://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/run/composable_nfts/mint_face?network=testnethttps://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/run/composable_nfts/mint_sailor_hat?network=testnet](https://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/run/composable_nfts/mint_face?network=testnethttps://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/run/composable_nfts/mint_sailor_hat?network=testnet)

![https://pbs.twimg.com/media/GEpCiZcaIAANBYO?format=png&name=360x360](https://pbs.twimg.com/media/GEpCiZcaIAANBYO?format=png&name=360x360)

![https://pbs.twimg.com/media/GEpClMia8AAFDF1?format=png&name=360x360](https://pbs.twimg.com/media/GEpClMia8AAFDF1?format=png&name=360x360)

假设我们想要将它们组合在一起！为了将帽子放在用户身上，我们将使用一个add_hat函数。它会将帽子的所有权转移到脸上，将其锁定，防止转移，并更改NFT的元数据。

![https://pbs.twimg.com/media/GEpC0mWb0AA-iex?format=jpg&name=small](https://pbs.twimg.com/media/GEpC0mWb0AA-iex?format=jpg&name=small)

![https://pbs.twimg.com/media/GEpC3SybMAAwYEF?format=jpg&name=large](https://pbs.twimg.com/media/GEpC3SybMAAwYEF?format=jpg&name=large)

它被漂亮地应用为一个戴着水手帽的脸，图像直接在我的钱包中更新。帽子现在是脸的一部分，并将随脸一起移动。除非我们将其移除，否则它不能单独转移。

![https://pbs.twimg.com/media/GEpC9whbQAA1Sp8?format=png&name=360x360](https://pbs.twimg.com/media/GEpC9whbQAA1Sp8?format=png&name=360x360)

我们之后可以用一个类似的函数移除帽子。将帽子的所有权拉回脸的所有者，并解锁转移。

![https://pbs.twimg.com/media/GEpDH8WbgAAwkk7?format=jpg&name=medium](https://pbs.twimg.com/media/GEpDH8WbgAAwkk7?format=jpg&name=medium)

感谢阅读，希望这能帮助你思考作为创作者的动态NFT和可组合NFT的使用案例。如往常一样，代码在这里是开源的

[https://github.com/aptos-labs/daily-move/tree/main/snippets/composable-nfts](https://github.com/aptos-labs/daily-move/tree/main/snippets/composable-nfts)

这次，我已经将代码部署在测试网上，任何人都可以尝试

[https://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/code/composable_nfts/mint_sailor_hat?network=testnet](https://explorer.aptoslabs.com/account/0x21dbfcef4bafda0a410050852d03e1924edb785e4ab98b19429ae1875e97a591/modules/code/composable_nfts/mint_sailor_hat?network=testnet)