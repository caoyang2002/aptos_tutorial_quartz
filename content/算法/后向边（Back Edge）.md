---
title: 后向边
---

"后向边"是[[图论]]中的概念，指的是从一个节点到自身或其祖先节点的有向边。在有向图中，如果存在一条从节点A到节点B的有向路径，且节点B是节点A的祖先，则这条边就被称为后向边。

在调用依赖图中，后向边表示一个函数在其调用链中重新调用了自身或其祖先函数，从而形成了一个循环调用。这种循环调用可能导致无限递归，进而引发栈溢出等问题。因此，通常情况下，编程中会尽量避免形成后向边。



树边，前向边，后向边，横叉边，应该说，不是一个图本身有的概念，应该是图进行DFS时才有的概念。图进行DFS会得到一棵DFS树（森林），在这个树上 才有了这些概念。对图进行DFS，可以从任意的顶点开始，遍历的方式也是多样的，所以不同的遍历会得到不同的DFS树，进而产生不同的树边，前向边，后向 边，横叉边。所以这4种边，是一个相对的概念。
在图的遍历中，往往设置了一个标记数组vis的bool值来记录顶点是否被访问过。但有些时候需要改变vis值的意义。令vis具有3种值并表示3种不同含义
`vis = 0`,表示该顶点没没有被访问
`vis = 1`,表示该顶点已经被访问，但其子孙后代还没被访问完，也就没从该点返回
`vis = 2`,，表示该顶点已经被访问，其子孙后代也已经访问完，也已经从该顶点返回
可以vis的3种值表示的是一种顺序关系和时间关系

《算法导论》334页有这4种边的准确定义，在此不累述
DFS过程中，对于一条边u->v
vis[v] = 0,说明v还没被访问，v是首次被发现，u->v是一条树边
vis[v] = 1,说明v已经被访问，但其子孙后代还没有被访问完（正在访问中），而u又指向v？说明u就是v的子孙后代，u->v是一条后向边，因此后向边又称返祖边
vis[v] = 3,z说明v已经被访问，其子孙后代也已经全部访问完，u->v这条边可能是一条横叉边，或者前向边

注意：树边，后向边，前向边，都有祖先，后裔的关系，但横叉边没有，u->v为横叉边，说明在这棵DFS树中，它们不是祖先后裔的关系它们可能是兄弟关系，堂兄弟关系，甚至更远的关系，如果是dfs森林的话，u和v甚至可以在不同的树上

在很多算法中，后向边都是有作用的，但是前向边和横叉边的作用往往被淡化，其实它们没有太大作用。

![img](https://mielgo-markdown.oss-cn-chengdu.aliyuncs.com/349fe4f80b34edde2eb223cd17eb21c1.png)



使用邻接表实现 DFS 采用大小为 n=10 的有向图，并在图中随机选择从 9 到 45 不等的边数。将每条边标识为前向边、树边、后边和交叉边。

```py
import random

class Graph:
    def __init__(self, v):
        self.time = 0
        self.traversal_array = []  # 用于存储DFS遍历的顶点序列
        self.v = v  # 图的顶点数
        self.e = random.randint(9, 45)  # 图的边数，随机生成
        self.graph_list = [[] for _ in range(v)]  # 图的邻接表表示
        self.graph_matrix = [[0 for _ in range(v)] for _ in range(v)]  # 图的邻接矩阵表示

    def create_random_graph(self):
        # 随机生成图的边
        for i in range(self.e):
            src = random.randrange(0, self.v)
            dest = random.randrange(0, self.v)
            # 确保边的源和目标不同，且边不重复
            while src == dest or self.graph_matrix[src][dest] == 1:
                src = random.randrange(0, self.v)
                dest = random.randrange(0, self.v)
            # 添加边到邻接表和邻接矩阵中
            self.graph_list[src].append(dest)
            self.graph_matrix[src][dest] = 1

    def print_graph_list(self):
        # 打印图的邻接表表示
        print("Adjacency List Representation:")
        for i in range(self.v):
            print(i, "-->", *self.graph_list[i])
        print()

    def print_graph_matrix(self):
        # 打印图的邻接矩阵表示
        print("Adjacency Matrix Representation:")
        for i in self.graph_matrix:
            print(i)
        print()

    def dfs(self):
        # 深度优先搜索
        self.visited = [False]*self.v  # 标记顶点是否被访问过
        self.start_time = [0]*self.v  # 记录顶点的开始访问时间
        self.end_time = [0]*self.v  # 记录顶点的结束访问时间
        for node in range(self.v):
            if not self.visited[node]:
                self.traverse_dfs(node)  # 对未访问的顶点进行深度优先搜索

        print()
        print("DFS Traversal: ", self.traversal_array)
        print()

    def traverse_dfs(self, node):
        # 深度优先搜索的递归函数
        self.visited[node] = True  # 标记当前顶点为已访问
        self.traversal_array.append(node)  # 将当前顶点添加到遍历序列中
        self.start_time[node] = self.time  # 记录当前顶点的开始访问时间
        self.time += 1

        for neighbour in self.graph_list[node]:
            if not self.visited[neighbour]:
                print('Tree Edge:', str(node)+'-->'+str(neighbour))
                self.traverse_dfs(neighbour)  # 递归访问邻居节点
            elif self.start_time[node] > self.start_time[neighbour] and self.end_time[neighbour] == 0:
                print('Back Edge:', str(node)+'-->'+str(neighbour))
            elif self.start_time[node] < self.start_time[neighbour] and self.end_time[neighbour] == 0:
                print('Forward Edge:', str(node)+'-->'+str(neighbour))
            elif self.start_time[node] > self.start_time[neighbour] and self.end_time[node] < self.end_time[neighbour]:
                print('Cross Edge:', str(node)+'-->'+str(neighbour))

        self.end_time[node] = self.time  # 记录当前顶点的结束访问时间
        self.time += 1

if __name__ == "__main__":
    n = 10  # 图的顶点数
    g = Graph(n)
    g.create_random_graph()  # 创建随机图
    g.print_graph_list()  # 打印邻接表
    g.print_graph_matrix()  # 打印邻接矩阵
    g.dfs()  # 进行深度优先搜索
```



```py
caoyang@cccy del % python3 back_edge.py
Adjacency List Representation:
0 --> 5 2 8
1 --> 0 6
2 --> 6
3 --> 0
4 --> 3 6 7
5 -->
6 --> 7
7 --> 1 2 8
8 --> 1 4 0 6
9 -->

Adjacency Matrix Representation:
[0, 0, 1, 0, 0, 1, 0, 0, 1, 0]
[1, 0, 0, 0, 0, 0, 1, 0, 0, 0]
[0, 0, 0, 0, 0, 0, 1, 0, 0, 0]
[1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
[0, 0, 0, 1, 0, 0, 1, 1, 0, 0]
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
[0, 0, 0, 0, 0, 0, 0, 1, 0, 0]
[0, 1, 1, 0, 0, 0, 0, 0, 1, 0]
[1, 1, 0, 0, 1, 0, 1, 0, 0, 0]
[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Tree Edge: 0-->5
Tree Edge: 0-->2
Tree Edge: 2-->6
Tree Edge: 6-->7
Tree Edge: 7-->1
Back Edge: 1-->0
Back Edge: 1-->6
Back Edge: 7-->2
Tree Edge: 7-->8
Cross Edge: 8-->1
Tree Edge: 8-->4
Tree Edge: 4-->3
Back Edge: 3-->0
Back Edge: 4-->6
Back Edge: 4-->7
Back Edge: 8-->0
Back Edge: 8-->6

DFS Traversal:  [0, 5, 2, 6, 7, 1, 8, 4, 3, 9]
```

