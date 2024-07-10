---
title: 重复
draft: true
---
```yaml
original: 
  author: Greg
  url: 
note: 纯机翻、未核对
```
# English

Have you been wondering, what's this extensibility that people are talking about on Aptos NFTs?

Let's do a simple example with points allocated to tokens by the creator.

Let's dive in to it on

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

Normally for an application, people might think they have to get the entire data right from the get go, and we understand sometimes as a creator you want to be able to modify things later.

The great thing about the Digital Asset standard and the Object standard on Aptos, is that objects can be extended.

Below you can see a collection, and this collection simply stores extend, and mutator refs to modify features later. These must be specified at create time.

[https://pbs.twimg.com/media/GGMd8CAbUAEijHQ?format=jpg&name=medium](https://pbs.twimg.com/media/GGMd8CAbUAEijHQ?format=jpg&name=medium)

The MutatorRef is special to tokens / collections. In this case, the collection mutator ref allows for things like setting the URI or the description of the collection.

In this case, we're a little sneaky, and we allow both the creator and the owner of the collection to change it.

[https://pbs.twimg.com/media/GGMeIa5aQAAgcFK?format=jpg&name=medium](https://pbs.twimg.com/media/GGMeIa5aQAAgcFK?format=jpg&name=medium)

The ExtendRef is more powerful, however. We can actually add on points after the fact to the collection.

It's like the points were already in the collection in the first place, with the extensibility!

[https://pbs.twimg.com/media/GGMeZolbgAAiNxW?format=jpg&name=900x900](https://pbs.twimg.com/media/GGMeZolbgAAiNxW?format=jpg&name=900x900)

[https://pbs.twimg.com/media/GGMehH8bQAA7m6F?format=png&name=900x900](https://pbs.twimg.com/media/GGMehH8bQAA7m6F?format=png&name=900x900)

But, what about tokens?

Tokens can also be extended and modified with, an extend ref, a mutator ref, and a burn ref. These must always be specified at create time.

[https://pbs.twimg.com/media/GGMe0fmaMAA6eME?format=jpg&name=medium](https://pbs.twimg.com/media/GGMe0fmaMAA6eME?format=jpg&name=medium)

The Extend ref lets us do something amazing! We can actually check if the collection has the points set, and distribute them and extend the tokens as well.

This means we can add lots more functionality later for games, and other fun exciting extensions to tokens.

[https://pbs.twimg.com/media/GGMfKe5aYAAJ8_K?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfKe5aYAAJ8_K?format=jpg&name=medium)

Mutator ref lets us change the URI, description, and name, while the burn ref let's us burn the token!

![https://abs-0.twimg.com/emoji/v2/svg/1f525.svg](https://abs-0.twimg.com/emoji/v2/svg/1f525.svg)

[https://pbs.twimg.com/media/GGMfbMlaEAAJ5VF?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfbMlaEAAJ5VF?format=jpg&name=medium)

[https://pbs.twimg.com/media/GGMfdQyasAA7-9i?format=jpg&name=small](https://pbs.twimg.com/media/GGMfdQyasAA7-9i?format=jpg&name=small)

And view functions can use these extensions as well, which makes it fully able to be extended to any application.

[https://pbs.twimg.com/media/GGMfnceaMAAWCM1?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfnceaMAAWCM1?format=jpg&name=medium)

Thanks for reading this episode of

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

As always check out the source code here!

[](https://t.co/2Mwh4y2BVm)[https://github.com/aptos-labs/daily-move/blob/main/snippets/modifying-nfts/sources/modify_nfts.move#L179-L195](https://github.com/aptos-labs/daily-move/blob/main/snippets/modifying-nfts/sources/modify_nfts.move#L179-L195)

# 中文

你是否曾好奇，人们在谈论 Aptos NFTs 时提到的可扩展性是什么？

让我们通过一个简单的示例来了解，即由创作者分配给代币的积分。

让我们在

[#每日动态](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

中深入探讨它

通常对于一个应用来说，人们可能认为他们必须从一开始就获取所有数据，我们理解有时候作为创作者你可能会想要稍后修改内容。

Aptos上的数字资产标准和对象标准的好处在于，对象是可以扩展的。

在下面你可以看到有一个收藏，这个收藏简单地存储了扩展和修改功能的mutator refs（修改引用）。这些必须在创建时指定。

![https://pbs.twimg.com/media/GGMd8CAbUAEijHQ?format=jpg&name=medium](https://pbs.twimg.com/media/GGMd8CAbUAEijHQ?format=jpg&name=medium)

MutatorRef对于代币/收藏来说是特别的。在这种情况下，收藏的mutator ref允许设置URI或收藏的描述等事情。

在这种情况下，我们有点狡猾，我们允许收藏的创作者和所有者都能改变它。

![https://pbs.twimg.com/media/GGMeIa5aQAAgcFK?format=jpg&name=medium](https://pbs.twimg.com/media/GGMeIa5aQAAgcFK?format=jpg&name=medium)

然而，ExtendRef更加强大。我们实际上可以在事后向收藏中添加积分。

这就像是积分一开始就在收藏中，通过可扩展性！

![https://pbs.twimg.com/media/GGMeZolbgAAiNxW?format=jpg&name=900x900](https://pbs.twimg.com/media/GGMeZolbgAAiNxW?format=jpg&name=900x900)

![https://pbs.twimg.com/media/GGMehH8bQAA7m6F?format=png&name=900x900](https://pbs.twimg.com/media/GGMehH8bQAA7m6F?format=png&name=900x900)

但是，代币呢？

代币也可以通过extend ref（扩展引用）、mutator ref和burn ref（销毁引用）来扩展和修改。这些必须在创建时始终指定。

![https://pbs.twimg.com/media/GGMe0fmaMAA6eME?format=jpg&name=medium](https://pbs.twimg.com/media/GGMe0fmaMAA6eME?format=jpg&name=medium)

Extend ref让我们可以做一些令人惊叹的事情！我们实际上可以检查收藏是否设置了积分，并分配它们，同时扩展代币。

这意味着我们以后可以为游戏和其他有趣的代币扩展添加更多功能。

![https://pbs.twimg.com/media/GGMfKe5aYAAJ8_K?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfKe5aYAAJ8_K?format=jpg&name=medium)

Mutator ref让我们可以改变URI、描述和名称，而burn ref让我们可以销毁代币！

![https://abs-0.twimg.com/emoji/v2/svg/1f525.svg](https://abs-0.twimg.com/emoji/v2/svg/1f525.svg)

![https://pbs.twimg.com/media/GGMfbMlaEAAJ5VF?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfbMlaEAAJ5VF?format=jpg&name=medium)

![https://pbs.twimg.com/media/GGMfdQyasAA7-9i?format=jpg&name=small](https://pbs.twimg.com/media/GGMfdQyasAA7-9i?format=jpg&name=small)

视图函数也可以使用这些扩展，这使得它完全能够扩展到任何应用。

![https://pbs.twimg.com/media/GGMfnceaMAAWCM1?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfnceaMAAWCM1?format=jpg&name=medium)

感谢阅读这一期的

[#每日动态](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

像往常一样，请查看这里的源代码！

[源代码链接](https://t.co/2Mwh4y2BVm)