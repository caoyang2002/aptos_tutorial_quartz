---
title: 如何改变 Token 的 URL
---
# Question

The latest episode comes from a builder asking me:

"How can I mutate the token URI after the token is created?"

The actual code example shows mutating URIs, but then extended to extending tokens / objects, and even burning them in the source.

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

In this case, we're a little sneaky, and we allow both the creator and the owner of the collection to change…

Show more

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

# 问题

最新的一集来自一位构建者向我提问：

“在代币创建后，我如何改变代币的URI？”

实际的代码示例展示了如何改变URI，然后扩展到了扩展代币/对象，甚至在源代码中烧毁它们。

# 中文

你是否一直在想，人们在Aptos NFTs上谈论的这种可扩展性是什么？

让我们通过一个简单的例子，由创建者分配点数给代币来解释。

让我们在

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

中深入了解它

通常对于一个应用程序，人们可能认为他们必须从一开始就把所有的数据搞定，我们明白有时作为创建者，你希望能够稍后修改事物。

Digital Asset标准和Aptos上的Object标准的伟大之处在于，对象可以被扩展。

在下面，你可以看到一个集合，这个集合简单地存储扩展和变异器引用以后来修改功能。这些必须在创建时指定。

![https://pbs.twimg.com/media/GGMd8CAbUAEijHQ?format=jpg&name=medium](https://pbs.twimg.com/media/GGMd8CAbUAEijHQ?format=jpg&name=medium)

MutatorRef对于代币/集合是特殊的。在这种情况下，集合变异器引用允许诸如设置集合的URI或描述之类的操作。

在这种情况下，我们有点狡猾，我们允许创建者和集合的所有者都能改变...

显示更多

![https://pbs.twimg.com/media/GGMeIa5aQAAgcFK?format=jpg&name=medium](https://pbs.twimg.com/media/GGMeIa5aQAAgcFK?format=jpg&name=medium)

然而，ExtendRef更加强大。我们实际上可以在事后向集合添加积分。

就像积分已经在集合中一样，具有可扩展性！

![https://pbs.twimg.com/media/GGMeZolbgAAiNxW?format=jpg&name=900x900](https://pbs.twimg.com/media/GGMeZolbgAAiNxW?format=jpg&name=900x900)

![https://pbs.twimg.com/media/GGMehH8bQAA7m6F?format=png&name=900x900](https://pbs.twimg.com/media/GGMehH8bQAA7m6F?format=png&name=900x900)

但是，代币呢？

代币也可以通过扩展引用、变异器引用和燃烧引用来扩展和修改。这些必须在创建时指定。

![https://pbs.twimg.com/media/GGMe0fmaMAA6eME?format=jpg&name=medium](https://pbs.twimg.com/media/GGMe0fmaMAA6eME?format=jpg&name=medium)

扩展引用让我们可以做一些令人惊奇的事情！我们实际上可以检查集合是否设置了积分，并分发它们并扩展代币。

这意味着我们可以为游戏和其他有趣的代币扩展后续添加许多功能。

![https://pbs.twimg.com/media/GGMfKe5aYAAJ8_K?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfKe5aYAAJ8_K?format=jpg&name=medium)

变异器引用让我们可以更改URI、描述和名称，而燃烧引用让我们可以烧毁代币！

![https://abs-0.twimg.com/emoji/v2/svg/1f525.svg](https://abs-0.twimg.com/emoji/v2/svg/1f525.svg)

![https://pbs.twimg.com/media/GGMfbMlaEAAJ5VF?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfbMlaEAAJ5VF?format=jpg&name=medium)

![https://pbs.twimg.com/media/GGMfdQyasAA7-9i?format=jpg&name=small](https://pbs.twimg.com/media/GGMfdQyasAA7-9i?format=jpg&name=small)

查看函数也可以使用这些扩展，这使得它完全可以扩展到任何应用程序。

[https://pbs.twimg.com/media/GGMfnceaMAAWCM1?format=jpg&name=medium](https://pbs.twimg.com/media/GGMfnceaMAAWCM1?format=jpg&name=medium)

感谢阅读这一集

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

如往常一样，查看这里的源代码！

[https://github.com/aptos-labs/daily-move/blob/main/snippets/modifying-nfts/sources/modify_nfts.move#L179-L195](https://github.com/aptos-labs/daily-move/blob/main/snippets/modifying-nfts/sources/modify_nfts.move#L179-L195)