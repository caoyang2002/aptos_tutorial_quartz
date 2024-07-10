---
title: 在 Move 中构建一个堆数据结构
---
```yaml
original: 
  author: Greg
  x-post: "https://x.com/Greg_Nazario/status/1762620052275388420"
  GitHub-url: "https://github.com/aptos-labs/daily-move/tree/main/snippets/data-structures/heap"
  DailyMove: "https://x.com/hashtag/DailyMove?src=hashtag_click"
note: 纯机翻、未校对
```

![image](https://pbs.twimg.com/media/GHXNLJwasAAsOTp?format=jpg&name=medium)


Move Institute Technology 的 [DailyMove](https://x.com/hashtag/DailyMove?src=hashtag_click) 课程正在进行中。还记得您衣柜里的那堆破烂吗？最大的东西必须在底部，最小的东西必须在顶部。今天我们将展示如何在 Move 中构建堆（heap）数据结构，以及如何对其进行测试。

堆是一种半有序的数据结构。就像您的那堆衣服，您能够看到并获取顶部的物品，但您得把衣服挪开才能拿到堆中更低位置的物品。

它可以表示为树或数组。在 Move 中，我们将表示为向量中的数组。

![image](https://pbs.twimg.com/media/GHXN3NgaEAEJu63?format=jpg&name=medium)

在这种情况下，我们正在创建一个最小堆。顶部的值始终是最小的。这提供了两个主要用例，一个是排序，另一个通常被称为优先队列，其中最高优先级首先被移除。
[https://en.wikipedia.org/wiki/Heap_(data_structure)](https://t.co/7K7cdcS3GB) 
[https://en.wikipedia.org/wiki/Priority_queue](https://t.co/bcOEdeqcPL)

![images](https://t.co/OzYnHLgUDD)

在这种情况下，我们正在创建一个最小堆。顶部的值始终是最小的。这提供了两个主要用例，一个是排序，第二个通常被称为优先队列，其中最高优先级首先被移除。 [https://en.wikipedia.org/wiki/Heap_(data_structure)…](https://t.co/7K7cdcS3GB) 
[https://en.wikipedia.org/wiki/Priority_queue…](https://t.co/bcOEdeqcPL) 
![](https://pbs.twimg.com/card_img/1807813443464110080/FvPRUEzM?format=png&name=360x360)



[堆（数据结构） - 维基百科](https://t.co/OzYnHLgUDD)

让我们深入到 Move 代码中：我们从堆的基本功能开始。堆化函数。这个实现找到了一个3节点树中的最小值，并将其移动到顶部。然后它返回该节点的位置。我们使用一个选项来告知是否还有更多工作。

![Image](https://pbs.twimg.com/media/GHYPIn-acAEKD3N?format=png&name=900x900)

然后，我们简单地遍历每个子树，直到我们有序地排列了所有子树。我们通过迭代（循环）而不是递归（调用自身）来做到这一点，以允许测试以及内联内函数。内联函数不能是递归的，否则你不能内联一个内联

![image](https://pbs.twimg.com/media/GHYPjLjbcAA8574?format=png&name=900x900)

此时，我们拥有了对堆进行排序的所有组件，但我们希望添加更多功能。所以，我们创建了一个新的结构来处理这个堆周围的功能。它是存储的，所以它可以被放入其他项目中，并且可以丢弃，以便它可以轻松地从内存中丢弃。

![iamge](https://pbs.twimg.com/media/GHYQPz2akAAOe_r?format=png&name=small)

然后，我们可以将任意向量转换为堆，通过堆化数组中的所有项。这将无序数字列表转换为早期的树结构。

![image](https://pbs.twimg.com/media/GHYQgt6aoAAYCrE?format=png&name=small)

从堆中插入和移除是简单的。只需在列表的开头移除或添加，然后运行堆化函数。这将过滤掉与堆中的所有更改相关的信息。

![iamge](https://pbs.twimg.com/media/GHYRDTZaIAAlJLT?format=png&name=small)

当然，也可以直接使用堆提供相对高效的排序。

![image](https://pbs.twimg.com/media/GHYRRc-aIAAdcG4?format=png&name=small)

测试！以前的例子中缺少的一件事是测试。让我们写一个测试 在这种情况下，你可以看到我们经历了一系列可能的堆排序，以确保堆排序可以正确地与不同顺序的数字一起工作。

![image](https://pbs.twimg.com/media/GHYRd6bbAAA68P5?format=small)

并且可以直接使用相关的中止代码测试错误。位置说它将要失败的地方。在这种情况下，两者都证明了 is_heap_ordered 函数正确地检查了排序。

![iamge](https://pbs.twimg.com/media/GHYRwosbAAA36k4?format=png&name=small)

现在有趣的部分，你可以简单地使用 aptos move test 运行测试。在这种情况下，我添加了覆盖率和 --dev 以使用开发地址。它将运行所有的测试并给我一个概述，甚至给出一个覆盖率摘要。

```bash
aptos move test --dev --coverage 
```

![image](Now the fun part, you can actually run the tests simply with aptos move test In this case, I add coverage and --dev to use dev addresses. It will run all of the tests and give me an overview, and even give a coverage summary.)

你也可以在测试后使用 --coverage 运行更详细的覆盖率

```bash
aptos move coverage --summary --summarize-functions --dev
```

![iamge](You can also run more detailed coverage after using --coverage in the test)

感谢收听这一集的 [#DailyMove](https://x.com/hashtag/DailyMove?src=hashtag_click)。你可以通过将其更改为 MaxHeap 甚至使用 Lambdas 使其通用来扩展。你可以在这里查看源代码和测试：[https://github.com/aptos-labs/daily-move/tree/main/snippets/data-structures/heap](https://t.co/5fWi3W5vhw)


---
# English

 Move Institute Technology's class is in session for [#DailyMove](https://x.com/hashtag/DailyMove?src=hashtag_click) Remember that heap of junk you had in your closet? The largest stuff had to be on the bottom, and the smallest had to be on the top. Today we'll show how to build a heap data structure in Move, and how to test it


![image](https://pbs.twimg.com/media/GHXNLJwasAAsOTp?format=jpg&name=medium)

A heap is a semi-ordered data structure. Like your pile of clothes, you can see and get the item on top, but you have to pull clothes off to get lower in the heap. It can be represented as either a tree or an array. On Move, we'll use the array representation in a vector.

![image](https://pbs.twimg.com/media/GHXN3NgaEAEJu63?format=jpg&name=medium)

In this case, we're making a MinHeap. The top value will always be the smallest. This provides two main use cases, one is sorting, and two what is usually referred to as a Priority Queue, where the highest priority is removed first. [https://en.wikipedia.org/wiki/Heap_(data_structure)](https://t.co/7K7cdcS3GB) [https://en.wikipedia.org/wiki/Priority_queue](https://t.co/bcOEdeqcPL)

![images](https://t.co/OzYnHLgUDD)

[Heap (data structure) - Wikipedia](https://t.co/OzYnHLgUDD)


Let's dive into the Move code: We start with the basic functionality of a heap. The heapify function. This implementation finds the smallest of a 3 node tree, and moves it to the top. It then returns the location of that node. We use an option to tell if there is more work.

![Image](https://pbs.twimg.com/media/GHYPIn-acAEKD3N?format=png&name=900x900)

Then, we simply go through each subtree until we've ordered all subtrees. We do this iteratively (a loop) instead of recursively (calling itself), to allow for testing and also inlining of the inner function. An inlined function can't be recursive, otherwise you can't inline an inline

![image](https://pbs.twimg.com/media/GHYPjLjbcAA8574?format=png&name=900x900)

At this point, we have all the pieces for sorting a heap, but we want more functionality added. So, we create a new struct to handle the functionality around this heap. It's store so it can be put into other items, and drop so that it can be easily dropped from memory.

![iamge](https://pbs.twimg.com/media/GHYQPz2akAAOe_r?format=png&name=small)

We can then convert an arbitrary vector into a Heap, by heapifying all the items in the array. This converts an unordered list of numbers into the tree structure from earlier.

![image](https://pbs.twimg.com/media/GHYQgt6aoAAYCrE?format=png&name=small)


Insertions and removals from the heap are simple. Just, remove or add at the beginning of the list, and then run the heapify function. This will filter down all the changes associated in the heap.

![iamge](https://pbs.twimg.com/media/GHYRDTZaIAAlJLT?format=png&name=small)


And of course provide relatively performant sorting using a heap directly.

![iamge](https://pbs.twimg.com/media/GHYRRc-aIAAdcG4?format=png&name=small)

Testing! One thing missing from previous examples was testing. let's write a test In this case, you can see we go through a suite of possible heap sorts to ensure that heap sort works properly with differently ordered numbers.

![image](https://pbs.twimg.com/media/GHYRd6bbAAA68P5?format=png&name=small)

And one can simply test errors directly with associated abort codes. The location says where it is going to fail. In this case, both are proving that the is_heap_ordered function properly checks ordering.

![iamge](https://pbs.twimg.com/media/GHYRwosbAAA36k4?format=png&name=small)


Now the fun part, you can actually run the tests simply with aptos move test In this case, I add coverage and --dev to use dev addresses. It will run all of the tests and give me an overview, and even give a coverage summary.

![image](Now the fun part, you can actually run the tests simply with aptos move test In this case, I add coverage and --dev to use dev addresses. It will run all of the tests and give me an overview, and even give a coverage summary.)


You can also run more detailed coverage after using --coverage in the test

![iamge](You can also run more detailed coverage after using --coverage in the test)

hanks for listening to this episode of [#DailyMove](https://x.com/hashtag/DailyMove?src=hashtag_click) You can expand upon this by changing it to a MaxHeap or even making it generic with Lambdas. You can check out the source and tests here: [https://github.com/aptos-labs/daily-move/tree/main/snippets/data-structures/heap](https://t.co/5fWi3W5vhw)


