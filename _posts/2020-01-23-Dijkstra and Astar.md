---
layout: post
title: 基于图搜索的路径规划算法(一)：Dijkstra 和 A*
subtitle:  " "
date:   2020-01-23
author: WSY
header-img: img/IU/iu2.jpeg
catalog: true
tags:
  - Path Planning
---

## 引言
　　本文会先介绍图搜索的一些基本知识，然后对比深度优先搜索(DFS)和广度优先搜索(BFS)，接下来介绍贪心最佳优先搜索，也就是最基本的贪心算法，最后引出 Dijkstra 和 A* 算法。本文为个人学习的总结，仅供参考，若有错漏之处，敬请指正。


## 图搜索算法概述

### 基本概念
　　首先介绍一下，图搜索算法中节点和边的概念，如下图所示，图由节点和边组成，上图中的A、B、C、D等称为节点，每两个节点之间的连接关系为边，边可以是无向的，也可以是单向的，也可以是双向的。此外每条边可以有权重，可以理解为走这条路所花费的代价。

<img src="/img/Dijkstra&Astar/graph.png" >

### 搜索树
　　所谓的图搜索问题实际就是从开始节点S开始，寻找一条到G节点之间可能存在的一条路径，如下图所示，我们可以将图转化成一个树形结构，若在搜索树中找到一条路径，回溯每一个节点，就可以找到一条完整的从起点到终点的路径。然而在机器人的实际问题中，我们永远无法构建整个树，效率太低下，我们只想尽快到达目标节点，这也是此文后面介绍的主要内容。
　　
<img src="/img/Dijkstra&Astar/searchTree.png" >

### 图搜索基本框架

+ 维护一个**容器**来存储所有要访问的节点
+ 以起始状态 Xs 来初始容器
+ Loop：
	+ 移除：根据预定义的函数计算容器中节点的分数，弹出分数最低的节点（访问该节点）
	+ 扩展：获取该节点的所有邻居节点
	+ 存储：将所有邻居节点存入容器中
+ EndLoop

　　以上是图搜索算法的基本框架，后面介绍的算法都是基于此框架，此外还需注意：以何种方式访问容器中的节点，才能尽快到达目标节点，从而减少图节点的扩展。这是我们需要重点关注的地方，也是下面我们要讨论的几个算法的不同之处。


## 广度优先搜索(Breadth First Search) VS 深度优先搜索(Depth First Search) 

　　接下来介绍两种最基本的图的遍历算法：广度优先搜索(BFS)和深度优先搜索(DFS)，这两种算法都是基于刚刚提到的基本图搜索框架，他们主要区别在于维护的容器不同。
　　广度优先搜索维护的是一个队列(queue)，它遵循 “first in first out” 原则，总是访问容器中最先进入的元素；而深度优先搜索维护的是一个堆栈(stack) ，它遵循 “last in first out” 原则，总是访问容器中最后一个进入的元素。
　　
<img src="/img/Dijkstra&Astar/DFSvsBFS.png" >

+ 广度优先搜索(BFS)实例

<img src="/img/Dijkstra&Astar/BFSDir.png" >

遍历结果为：A→B→C→E→F→D→G
+  深度优先搜索(DFS)实例

<img src="/img/Dijkstra&Astar/DFSDir.png" >

遍历结果为：A→B→C→E→D→F→G

+ BFS和DFS对比

　　下面通过一组动图来对比一下BFS和DFS的遍历效果，从动图中可以看出两种算法都可以找到一条路径通往目标节点，而显然DFS搜索的路径并不是最短路径，BFS扩展节点后回溯出来的路径是最短路径，所以后面要介绍的最短路径算法**Dijkstra 和 A*都是基于广度优先算法**。

<img src="/img/Dijkstra&Astar/BFS&DFS.gif" >


## 贪心最佳优先搜索(Greedy Best First Search)

　　贪心最佳优先搜索(Greedy Best First Search)正如其名，是一种贪心算法，前面提到的BFS和DFS只是根据“First in”或者“Last in”来选择下一个节点，而Greedy Best First Search则是根据某些规则来选择“最佳节点”，称之为启发式(heuristic)。
对于一个启发式函数，至少要满足以下两点要求：
+ 能够指引向着离目标更近的方向前进。
+ 容易计算，即能满足实时性要求。

<img src="/img/Dijkstra&Astar/GBFS.png" >

一般地，选择欧氏距离(Euclidean Distance)或者曼哈顿距离(Manhattan Distance)来作heuristic。

<img src="/img/Dijkstra&Astar/BFS&GBFS.gif" >

　　对比BFS和GBFS算法，对于没有障碍物的情况，显然Greedy Best First Search搜索速度更快，且两种算法都能找到最短路径。然而如果有障碍，如下动图所示，Greedy Best First Search算法会过分贪心地想尽快接近目标节点，而有可能得到一个不是最优的解。
　　
<img src="/img/Dijkstra&Astar/BFS&GBFSwithOBS.gif" >

　　虽然Greedy Best First Search不是最优解，但它所用的启发式思想我们可以借鉴，后面要介绍的 A* 算法就是在 Dijkstra 算法上加入了 heuristic 的思想。


## Dijkstra 算法

### 简介
　　接下来介绍一种广泛熟知的最短路径算法——Dijkstra。Dijkstra 和 广度优先算法(BSF) 的本质区别在于 **BFS 是按照人为预先定义好的顺序访问容器中的节点，而 Dijkstra 是访问当前容器累计成本 g(n) 最低的节点**。
+ g(n)：从起始节点到节点“n”的累计成本的当前最佳估计。

<img src="/img/Dijkstra&Astar/DijkstraCost.png" > 

　　Dijkstra 算法可以保证它访问过的节点当前时刻容器中代价最小的节点，因此保证了整个算法的完备性。

### 算法流程

　　Dijkstra 算法伪代码如下图所示。

<img src="/img/Dijkstra&Astar/Dijkstraflow.png" >

　　以下是 Dijkstra 算法的一次迭代过程。

<img src="/img/Dijkstra&Astar/DijkstraComplete.png" >

　　**使用 Dijkstra 对该图进行搜索所扩展的节点为：S→p→d→b→e→a→r→f→G**
　　
+ **Dijkstra 优点**：
　　Dijkstra 可以保证它扩展过的节点一定是从起点开始到当前的最小代价的路径，因此按照这一原则进行搜索，当它发现目标节点后，回溯出的路径一定是最小代价的路径，即具有完备性。

+ **Dijkstra 缺点**：
　　Dijkstra 不知道目标节点的位置，只能保证下一步扩展过的节点累计代价g(n)最小，因此如下图所示，它必须向所有方向扩展，目的性不强，所以算法效率不高。

<img src="/img/Dijkstra&Astar/DijkstraAllDir.png" >


## A* 算法

### 简介
　　最后介绍一种在机器人、导航、游戏等领域广泛应用的一个搜路算法，也是本文的重头戏——A* 算法。A* 是 Dijkstra 的改进版，目的就在于解决 Dijkstra 效率低下的问题，刚刚提到 Dijkstra 算法不知道目标节点的位置，因此它只能向所有可能的方向扩展节点知道发现目标节点为止。而回忆一下我们之前介绍的 Greedy Best First Search 算法，它的缺点在于，它过分关注目标节点的位置，即 **Greedy Best First Search每次访问的节点具有到目标节点的最小代价**，从而导致在有障碍物的情况下搜出来的路径可能并不是最优的。
　　A* 算法同时借鉴了上面两种算法，在 Dijkstra 的基础上引入了启发式函数 h(n)，**h(n)表示了当前节点到目标节点的成本**。保证了最优性的同时，加入了目标节点的信息，提升了搜索效率。
+ 累积成本g(n)：对从初始节点到节点“n”的累计成本的当前最佳估计
+ 启发式h(n)：节点“n”到目标节点的代价估计(即目标代价)
+ f(n) = g(n) + h(n)：从初始节点，通过当前节点“n”，再到目标节点的代价估计
+ **策略：每次访问容器中 f(n) 值最小的节点**

### 算法流程

　　A* 算法伪代码如下图所示。

<img src="/img/Dijkstra&Astar/Astarflow.png" >

　　A* 算法完整的迭代过程如下图所示。

<img src="/img/Dijkstra&Astar/AstarComplete.png" >

　　与前文提到的 Dijkstra 算法相比，A* 算法由于引入了启发函数 h(n)，所以它拓展节点的时候具有一定目的性(即向目标节点的方向扩展)，所以它搜索目标节点时所需要扩展的中间节点更少，因此算法效率更高。

<img src="/img/Dijkstra&Astar/AstarGoalDir.png" >

　　但同时，由于采用了 Greedy Best First Search 算法的贪心思想，所以 A* 并不能保证具有完备性(即找到最优路径)。那么什么条件下，A* 具有完备性呢？下面直接给出算法完备性的条件，这里忽略证明，若感兴趣可自行查找相关论文。
+ 当**h(n) <= h*(n)**时  A* 具有完备性，这里 h*(n) 指节点 “n” 到目标节点的真实代价。

　　前文介绍了两种 h(n) 的取法：欧式距离、曼哈顿距离，那么它们是否满足A* 的最优性呢？

<img src="/img/Dijkstra&Astar/GBFS.png" >

　　由上图，紫色为真实代价 h*(n) ，黄色为采用欧式距离作为 h(n) 的估计代价，绿色为采用曼哈顿距离作为 h(n) 的估计代价。显然：　
+ 采用欧式距离作为 h(n)，一定满足 h(n) <= h*(n)
+ 当机器人只允许前后左右方向移动时，曼哈顿距离满足 h(n) <= h*(n)，若机器人可沿对角线移动，曼哈顿距离不一定保证 h(n) <= h*(n)

### Dijkstra VS A*

<img src="/img/Dijkstra&Astar/DijkstraVSAstar.png" >

　　介绍到这里，应该可以发现，实际上A* 就是一个带有启发性的 Dijkstra 算法，这一小节，主要总结梳理一下前面提到的一些算法之间联系，要**重点理解！！！**
+ 当 h(n) = 0 时，那么意味着  f(n) = g(n) , A*算法退化了Dijkstra算法。
+ 当 h(n) < h*(n) 时，A*算法可以找到最短路径，但是搜索效率略低，h(n)越小，意味着需要扩展的节点就越多，效率上越低，但是精度上越准确，因为它更趋近于Dijkstra算法。( h*(n) 表示从节点n到目标节点的真实代价 )
+ 当 h(n) = h*(n) 时，它可以兼顾精度和速度，是A*最优状态。
+ 当 h(n) >> g(n) 时，那么 f(n)的值就主要取决于 h(n)，A*就退化成了Greedy Best First Search。

### A* 算法的优化思路

<img src="/img/Dijkstra&Astar/AstarExam.png" >

　　上图为采用欧氏距离作为 h(n) 的 A* 算法搜索结果，可以看到，过程中扩展了很多没有必要的节点，为什么会引起这种现象呢？
+ 因为欧氏距离计算的 h(n) 远远小于真实目标代价 h*(n) ，此时h(n)会引导扩展很多不必要的栅格。

　　实际上，对于无障碍物情况下真实目标代价 h*(n) 是闭氏解的( closed-form solution)。如下图：

<img src="/img/Dijkstra&Astar/AstarTrulyH.png" >

　　其闭氏解如下，感兴趣的可以自己推导一下，非常简单。

<img src="/img/Dijkstra&Astar/closed-form solution.png" >

　　如下图，左面的是采用闭氏解的 h(n)，右面的是采用欧氏距离作为h(n)。

<img src="/img/Dijkstra&Astar/DiagonalCompare.png" >

　　我们再看一下另外一种情况。

<img src="/img/Dijkstra&Astar/TieBreaker.png" >

　　对于这种情形，我们可以考虑打破对称性，让 A* 具有某种倾向性，可以减少扩展没必要的节点。最简单地做法就是将 h(n) 值略微放大，但此时可能有人怀疑，扩大 h(n) 值会不会导致h(n) > h*(n)，从而破坏算法的完备性？一般不会，因为真实环境中会有很多障碍物，h 一般远远小于 h*，所以略微放大一点不会很大地影响完备性。

<img src="/img/Dijkstra&Astar/TieBreakerForm.png" >

　　为了打破平衡性，其实还有很多办法，例如倾向于选择离起点 --- 终点连线距离更近的节点。

<img src="/img/Dijkstra&Astar/nearPath.png" >

　　类似方法还有很多，总之，核心的思想就是**打破平衡性**，让 A* 有更大的目的性。


## 源码分享
　　最后，在这里提供两版 A* 算法程序，第一版是 MATLAB 版本的2D空间下的 A* 算法，第二版是 ROS(C++) 版本3D空间下的A* 算法，代码都托管在Github上**（~~求star~~）**，供大家下载学习。

###  MATLAB版本
+ [程序源码链接](https://github.com/Mesywang/Astar-Algorithm-MATLAB)
<img src="/img/Dijkstra&Astar/AstarMatLab.png" >

###  ROS(C++)版本
+ [程序源码链接](https://github.com/Mesywang/Astar-JPS-Algorithm-ROS)

　　这个工程除了包含 A* 算法外，还包括另一个优化版 A* —— Jump Point Search(JPS)，关于JPS算法的细节，我会在下一篇文章中详细介绍，关于这个ROS包如何运行，请仔细阅读上述链接里的介绍。
<img src="/img/Dijkstra&Astar/AstarDemo.png" >

## Reference　
1. 深蓝学院 —— Motion Planning for Mobile Robots 课程
2. http://theory.stanford.edu/~amitp/GameProgramming/
