---
title: " VRF（可验证的随机函数）的使用"
---
```yaml
original: 
  author: Greg
  url: 
note: 纯机翻、未核对
```
# Question

"Is there a VRF on-chain and how do I use this?"

This question along with a real on-chain exploit

![https://abs-0.twimg.com/emoji/v2/svg/1f92b.svg](https://abs-0.twimg.com/emoji/v2/svg/1f92b.svg)

led to the idea that there should be an episode on security around randomness, and entry functions. This real exploit was solved by this change.

# English

Today's lesson on Move:

Ever wonder why functions are private or public? Let's go over the reasons you'll want to make them one way or another with a little chance game I like to call:

Dice roll

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

Dice rolls in real life are mostly fair, casinos protect against weighted dice, so that the odds are even.

In this game, when you roll a 1, you win and you pay a fee in this of 1 test APT to play the game.

The function here is a public entry function, let's dive in.

[https://pbs.twimg.com/media/GEd-2a6a4AIGEyx?format=png&name=900x900](https://pbs.twimg.com/media/GEd-2a6a4AIGEyx?format=png&name=900x900)

The public entry function allows it to be called as a transaction on its own as well as by other functions in Move.

[](https://t.co/owaKJYBxbx)[https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/dice_roll/sources/dice_roll.move#L48-L57](https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/dice_roll/sources/dice_roll.move#L48-L57)

It can be called directly with wallets as well through the Aptos explorer [](https://t.co/dmoq5t4Oeg)[https://explorer.aptoslabs.com](https://explorer.aptoslabs.com/)

[https://pbs.twimg.com/media/GEeAEIBa4AE4s3L?format=png&name=small](https://pbs.twimg.com/media/GEeAEIBa4AE4s3L?format=png&name=small)

It has a problem though, a smart cheater can actually cheat the system, and not pay the fee if they fail. Instead they only pay gas.

[](https://t.co/1jswVbys8f)[https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/cheater/sources/cheater.move#L11-L28](https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/cheater/sources/cheater.move#L11-L28)

[https://pbs.twimg.com/media/GEeAY_La4AEkQXP?format=jpg&name=medium](https://pbs.twimg.com/media/GEeAY_La4AEkQXP?format=jpg&name=medium)

The protection against this is to use a private entry function. This entry function **can only** be called as a transaction. It cannot be wrapped in other functions, and it prevents the cheater from not paying the fee.

[](https://t.co/8XdtJbOzqr)[https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/dice_roll/sources/dice_roll.move#L69-L77](https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/dice_roll/sources/dice_roll.move#L69-L77)

[https://pbs.twimg.com/media/GEeAhF2a4AIenS4?format=jpg&name=medium](https://pbs.twimg.com/media/GEeAhF2a4AIenS4?format=jpg&name=medium)

Additionally, public functions can be exploited in the same way. Private functions cannot.

[](https://t.co/pQWAhickFm)[https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/cheater/sources/cheater.move#L30-L35](https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/cheater/sources/cheater.move#L30-L35)

[https://pbs.twimg.com/media/GEeBcaDacAAP9_H?format=png&name=900x900](https://pbs.twimg.com/media/GEeBcaDacAAP9_H?format=png&name=900x900)

Public functions are great, as they can be called by any other program, but keeping in mind that sometimes that may not be the choice you want.

Thanks for reading, source here:

[](https://t.co/xEhxXrEO7J)[https://github.com/aptos-labs/daily-move/tree/main/snippets/private-vs-public](https://github.com/aptos-labs/daily-move/tree/main/snippets/private-vs-public)

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

# 问题

"链上有 VRF（可验证的随机函数）吗？我该如何使用它？"

这个问题连同一个真实的链上漏洞

![https://abs-0.twimg.com/emoji/v2/svg/1f92b.svg](https://abs-0.twimg.com/emoji/v2/svg/1f92b.svg)

引发了关于随机性安全和入口函数的想法。这个真实的漏洞正是通过这个改变解决的。

# 中文

今天在 Move 上的课程：

你是否想知道为什么函数是私有的或公共的？让我们通过一个我喜欢称为：

掷骰子

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)

在现实生活中，掷骰子通常是公平的，赌场会防止使用有偏重的骰子，以保证赔率是均等的。

在这个游戏中，当你掷出1时，你赢了，并支付1个测试APT的费用来玩这个游戏。

这里的函数是一个公共入口函数，让我们深入了解一下。

![https://pbs.twimg.com/media/GEd-2a6a4AIGEyx?format=png&name=900x900](https://pbs.twimg.com/media/GEd-2a6a4AIGEyx?format=png&name=900x900)

公共入口函数允许它作为独立的事务调用，也可以通过 Move 中的其他函数调用。

[https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/dice_roll/sources/dice_roll.move#L48-L57](https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/dice_roll/sources/dice_roll.move#L48-L57)

它也可以直接通过 Aptos explorer [](https://explorer.aptoslabs.com/)[https://explorer.aptoslabs.com](https://explorer.aptoslabs.com/) 与钱包一起调用。

![https://pbs.twimg.com/media/GEeAEIBa4AE4s3L?format=png&name=small](https://pbs.twimg.com/media/GEeAEIBa4AE4s3L?format=png&name=small)

然而，它存在一个问题，一个聪明的作弊者实际上可以欺骗系统，如果他们失败了就不支付费用。相反，他们只支付gas。

[https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/cheater/sources/cheater.move#L11-L28](https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/cheater/sources/cheater.move#L11-L28)

![https://pbs.twimg.com/media/GEeAY_La4AEkQXP?format=jpg&name=medium](https://pbs.twimg.com/media/GEeAY_La4AEkQXP?format=jpg&name=medium)

对抗这种情况的方法是使用私有入口函数。这个入口函数**只能**作为一个事务调用。它不能被包装在其他函数中，并且防止作弊者不支付费用。

[https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/dice_roll/sources/dice_roll.move#L69-L77](https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/dice_roll/sources/dice_roll.move#L69-L77)

![https://pbs.twimg.com/media/GEeAhF2a4AIenS4?format=jpg&name=medium](https://pbs.twimg.com/media/GEeAhF2a4AIenS4?format=jpg&name=medium)

此外，公共函数也可以以同样的方式被利用。私有函数则不会。

[https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/cheater/sources/cheater.move#L30-L35](https://github.com/aptos-labs/daily-move/blob/main/snippets/private-vs-public/cheater/sources/cheater.move#L30-L35)

![https://pbs.twimg.com/media/GEeBcaDacAAP9_H?format=png&name=900x900](https://pbs.twimg.com/media/GEeBcaDacAAP9_H?format=png&name=900x900)

公共函数很棒，因为它们可以被任何其他程序调用，但要记住，有时这可能不是你想要的选择。

谢谢阅读，源代码在这里：

[https://github.com/aptos-labs/daily-move/tree/main/snippets/private-vs-public](https://github.com/aptos-labs/daily-move/tree/main/snippets/private-vs-public)

[#DailyMove](https://twitter.com/hashtag/DailyMove?src=hashtag_click)