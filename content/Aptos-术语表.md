---
title: Aptos-术语表
---
> 纯机翻，未核对

```yaml
original: "https://aptos.dev/reference/glossary"
status: 待编辑
note: 纯机翻、未核对
```

[toc]
# Aptos术语表

## A

### Accumulator Root Hash（累加器根哈希）

- **累加器根哈希**是[默克尔累加](https://eprint.iacr.org/2009/625.pdf)器的根哈希。

### Account（账户）

- Aptos区块链中的**帐户**是任意数量的[Move模块](https://aptos.dev/reference/glossary#move-module)和[Move资源](https://aptos.dev/reference/glossary#move-resources)的容器。
- 每个帐户的状态由代码和数据组成。
- 该帐户由[帐户地址](https://aptos.dev/reference/glossary#account-address)标识。

有关更多信息[，](https://aptos.dev/concepts/accounts)请参阅[帐户](https://aptos.dev/concepts/accounts)。

### Account Address（帐户地址）

- **帐户地址**是 Aptos 帐户的地址。
- 帐户地址是指 Aptos 网络上的特定目的地。该地址决定了双方在区块链上交换的特定数量资产的目的地和来源。
- Aptos 地址是 64 个字符的十六边形字符串（32字节）。通常，这些字符串的前缀为`0x`，对于前 16 个地址，前导的0被排除在外（例如`0x1`

有关更多信息，请参阅[帐户](https://aptos.dev/concepts/accounts)。

### API

- **应用程序编程接口（API）**是一组协议和工具，允许用户通过外部应用程序与Aptos区块链节点和客户端网络进行交互。Aptos提供了一个REST API来与我们的节点通信。
- 有关更多详细信息，请参阅[文档](https://aptos.dev/apis/fullnode-rest-api)。

### APT

**Aptos令牌（APT）**是用于支付网络和交易费用的Aptos区块链原生令牌。

### Aptos

**Aptos**是适合每个人的第1层区块链。它使用Move编程语言，并于2022年10月17日推出了主网，以重新定义web3用户体验。Aptos区块链致力于通过提高速度、安全性、可扩展性、可靠性和可用性，以较低的交易成本来创造更好的用户体验。“Aptos”一词在Ohlone语言中的意思是“人民”。[在Aptos官方网站](https://aptosfoundation.org/)上了解有关Aptos区块链的更多信息。

### AptosBFT

- **AptosBFT**是Aptos协议的BFT共识算法。
- AptosBFT基于Jolteon。

### Aptos区块链

- **Aptos区块链**是Aptos网络（验证器网络）上验证器商定的不可变交易分类账。

### Aptos 域名服务（ANS）

- **Aptos 域名服务（ANS）**是Aptos区块链的分散式命名地址服务。Aptos名称是人类可读的*.apt*域名，用于代替公钥，例如*love.apt*。
- 这项服务还允许用户在注册域名之外注册子域名。更多信息请访问：[Aptosnames.com](https://www.aptosnames.com/)

### Aptos-core

**Aptos-core**是包含Aptos网络软件代码的[开源存储库](https://github.com/aptos-labs/aptos-core/)。Aptos-core包含软件

- Aptos区块链本身，它生成并存储已确认交易的不可变分类账和
- 验证过程，它实现了共识算法来验证交易，并将其添加到Aptos区块链不可变分类账中。

### Aptos生态系统

- **Aptos生态系统**是指Aptos区块链网络的各个组成部分及其相互作用。Aptos生态系统包括社区、[社区驱动的项目](https://aptosfoundation.org/ecosystem/projects/all)和[活动](https://aptosfoundation.org/events)。有关加入Aptos的所有可能方式，请参阅[为Aptos生态系统做出贡献](https://aptos.dev/community/)。

### Aptos 探索者

- **[Aptos Explorer](https://explorer.aptoslabs.com/)**是一个界面，帮助用户检查Aptos区块链的详细信息，包括帐户信息、验证器和交易。
- Aptos Explorer帮助用户在区块链中的Aptos钱包和其他工具中验证他们的工作。在[使用Aptos Explorer上](https://aptos.dev/guides/explore-aptos)查找更多详细信息。

### Aptos 框架

**Aptos 框架**定义了区块链更新的公共 API 和链上数据的结构。它定义了 Aptos 功能三个关键支柱的业务逻辑和访问控制：支付、财务和链上治理。它作为一组用 Move 编程语言编写的模块实现，并作为 Move 字节码存储在链上。

### Aptos节点

**Aptos 节点**是 Aptos 网络的对等实体，用于跟踪 Aptos 区块链的状态。有两种类型的 Aptos 节点，[验证器和](https://aptos.dev/reference/glossary#validator)[全节点](https://aptos.dev/reference/glossary#fullnodes)。

### Aptos 协议

- **Aptos协议**是如何在Aptos网络中提交、订购、执行和记录交易的规范。

### Aptos帐户

- **`AptosAccount`**是一个移动资源，保存与帐户相关的所有管理数据，如序列号、余额和身份验证密钥。
- **`AptosAccount`**是每个帐户都保证包含的唯一资源。

### AptosAccount模块

- **AptosAccount模块**是一个移动模块，包含用于操作特定`AptosAccount.T`资源中保存的管理数据的代码。
- 检查或增加序列号、提取或存入货币以及提取 Gas 存款的代码包含在AptosAccount模块中。

### Aptos devnet

- 见[devnet](https://aptos.dev/reference/glossary#devnet)。

## B

### Block（块）

- 在Aptos上，块是同时提交的一批[交易](https://aptos.dev/reference/glossary#transaction)。
- 块数类似于区块链文献中的“块高度”。
- 交易由分类账版本而不是块引用。

### 拜占庭（验证器）

- 不遵循共识协议规范并希望损害协议正确执行的**验证器**。
- BFT算法传统上支持高达三分之一的算法投票权，由拜占庭验证器持有。

### 拜占庭容错（BFT）

- **拜占庭容错**（BFT）是分布式系统在存在低于一定阈值的故障或“[拜占庭](https://aptos.dev/reference/glossary#byzantine-validator)”验证器时提供安全和活力保证的能力。
- Aptos区块链使用AptosBFT，这是一个基于[Jolteon](https://aptos.dev/reference/glossary#jolteon)的共识协议。
- BFT算法通常与多个实体一起运行，共同持有N票（在Aptos网络对系统的应用中称为“验证器”）。
- 选择N是为了抵御一些持有f票的验证者，这可能是恶意的。
- 在这种配置中，N通常设置为3f+1。持有f票的验证器将被允许出现故障——离线、恶意、慢速等。只要[诚实](https://aptos.dev/reference/glossary#honest-validator)的验证者持有2f+1票，他们就能够就一致的决定达成共识。
- 这意味着BFT共识协议可以正常运行，即使多达三分之一的投票权由受损或失败的验证者持有。

## C

### CLI

- **命令行界面**是指用于在Aptos区块链上开发、操作节点和调试问题的Aptos CLI。在[使用Aptos CLI上](https://aptos.dev/tools/aptos-cli/use-cli/)了解更多信息。

### 客户

- **客户端**是从区块链接收信息并管理交易的软件。客户端通过Aptos节点与区块链交互。

### 代码实验室

- **代码实验室和教程**描述了各种工作流程——例如在铸造不可替代令牌（NFT）时使用Aptos CLI——以便用户了解该过程的工作原理，并在其代码中使用相关功能。如果用户的帐户中有必要的资金，他们可以遵循devnet、testnet和mainnet网络中使用的相同代码实验室和教程步骤。

### 共识

- **共识**是验证器的组成部分。
- 共识部分负责所有验证者之间就要执行的交易块、其顺序和执行结果进行协调和达成一致。
- Aptos区块链是由这些商定的交易及其相应的执行结果组成的。
- 共识部分负责实现Aptos区块链上所有验证者之间的安全、信任和协议。

### 共识协议

- **共识协议**由n个验证者集体执行，以接受或拒绝交易，并就事务的顺序和执行结果达成一致。
- 见[BFT](https://aptos.dev/reference/glossary#byzantine-fault-tolerance-bft)。

## D

### 达普斯

- **分散式应用程序（dapps）**是在Aptos区块链上自主运行的程序或数字应用程序。智能合约通常用于实现此功能。

### 德夫内特

- **Aptos devnet**是Aptos网络的公开部署实例，使用一组验证器测试节点运行。
- devnet是Aptos网络的演示，该网络是为尝试新想法而构建的
- devnet模拟数字支付系统，devnet上的硬币*没有现实世界价值*。
- devnet是开发人员有机会测试给定协议的网络。它类似于测试网，因为它独立于主网运行，但每周重置一次。

## E

### Ed25519

- **Ed25519**是我们支持的数字签名方案。
- 更具体地说，Aptos网络在RFC 8032中定义的Ed25519曲线上使用PureEdDSA方案。

### 时代

- 一个**纪元**是验证器集重新配置与区块链其他管理操作之间的时间段。目前在Aptos主网上，每2小时一次。

### 事件

- **事件**是面向用户的执行事务效果的表示。
- 事务可以设计为以列表发送任意数量的事件。例如，`Coin<AptosCoin>`转账为发件人帐户发出`WithdrawEvent`，为收件人帐户发出`DepositEvent`。
- 在Aptos协议中，事件提供了证据，证明交易的成功执行产生了特定的效果。`DepositEvent`（在上述示例中）允许收件人确认已收到付款进入其帐户。
- 事件在区块链上持续存在，并用于回答[客户端](https://aptos.dev/reference/glossary#client)的查询。

### 执行

- Aptos区块链中的**执行**是管理事务块的Aptos节点组件。执行组件存储成功的交易。

### 到期时间

交易在**到期**后不再有效。如果假设：

- Time_C是验证器之间商定的当前时间（Time_C不是客户端的本地时间）；
- Time_E是事务T_N的到期时间；以及
- Time_C > Time_E和交易T_N尚未包含在区块链中，

那么可以保证T_N永远不会被包含在区块链中。

## F

### 水龙头

- **Faucet**是一种在devnet和testnet上铸造APT的服务。这些网络上的APT没有现实世界价值，它仅用于开发目的。
- 您可以通过几种不同的方式使用水龙头：
    - 使用[Aptos CLI](https://aptos.dev/tools/aptos-cli/use-cli/)。
    - 通过钱包，如[Petra](https://aptosfoundation.org/ecosystem/project/petra)或[Pontem](https://aptosfoundation.org/ecosystem/project/pontem-wallet)。查看[Aptos钱包](https://aptosfoundation.org/ecosystem/projects/wallets)的完整列表。
    - 使用SDK，例如使用TypeScript SDK中的`FaucetClient`。
    - 通过直接的HTTP请求。[在这里](https://aptos.dev/guides/system-integrators-guide#calling-the-faucet-other-languages)学习如何做到这一点。

### 全节点

- **Fullnodes**是确保数据在网络上存储最新的客户端。他们从其他全节点和验证器节点复制区块链状态和事务。

### 可理解的资产

- **可替代资产**是一种资产，如货币、股票、游戏内资源等，可与另一种相同的资产互换，其价值没有任何损失。例如，APT是一种可替代的资产，因为您可以将一个APT换成另一个。
- 遵循[资产标准](https://aptos.dev/standards/#asset-standards)，在Aptos区块链上创建可替代资产。
- 下一代Coin标准解决了`aptos_framework::coin`的缺点，如缺乏保证的冻结和燃烧执行，以及可编程传输等高级功能，例如在ERC-20中批准。

### 可替换的令牌

- 对于遗留的Aptos令牌标准（aptos_token::token），**可替代令牌**是与其他相同令牌（即共享相同`TokenId`的令牌）可互换的令牌。这意味着令牌具有相同的`creator address`、`collection name`、`token name`和`property version`。
- 对于Aptos数字资产标准（aptos_token_objects::token），**可替换令牌**是具有包含数字资产资源的元数据对象的可替换资产。

### 可折叠单元

- **可替换单位**是可替换资产的单个单位。这些单位是相同的，可以互换的，没有任何价值损失。例如，每个Octa（APT的最小单位）都是一个可替换单位。

## G

###  Gas 

- ** Gas **是在区块链网络上支付计算和存储费用的一种方式。Aptos网络上的所有交易都需要一定数量的 Gas 。
- 交易所需的 Gas 取决于交易的大小、执行交易的计算成本以及交易创建的额外全局状态的数量（例如，如果创建了新帐户）。
-  Gas 的目的是调节对验证器有限计算和存储资源的需求，包括防止拒绝服务（DoS）攻击。

有关更多信息，请参阅[ Gas 和存储费用](https://aptos.dev/concepts/gas-txn-fee)。

###  Gas 单价

- 每笔交易都规定了发件人愿意每单位 Gas 支付的** Gas 单价**。
- 交易所需的 Gas 价格取决于当前对网络使用的需求。
-  Gas 价格以Octa表示。1 APT = 10^8 Octa

有关更多信息，请参阅[ Gas 和存储费用](https://aptos.dev/concepts/gas-txn-fee)。

## H

### 诚实（验证者）

- **诚实**是指忠实执行共识协议而不是拜占庭的验证器。

### 乔尔顿

- **Jolteon**是最近提出的[BFT](https://aptos.dev/reference/glossary#byzantine-fault-tolerance-bft)共识协议提案。
- AptosBFT是Aptos网络的共识算法，基于Jolteon。
- 它简化了关于安全的推理，并解决了之前共识协议的一些性能限制。特别是，与HotStuff相比，它减少了33%的延迟。

## 我

### 索引器

- **[索引器](https://aptos.dev/indexer/indexer-landing)**是Aptos的组件，用于检索、处理和高效存储数据库中的原始数据，以提供对Aptos区块链状态的快速访问。
- 在高水平上，索引器从gRPC流中获取数据，并运行处理器来转换原始区块链数据，并通过GraphQL端点提供转换后的数据。

## L

### 领导者

- **领导者**是为共识协议提出交易块的验证器。
- 在基于领导者的协议中，节点必须就领导者达成一致才能取得进展。
- 领导者由一个函数选择，该函数将当前轮[数](https://fb.quip.com/LkbMAEBIVNbh#ffYACAO6CzD)作为输入。

## M

### 主网

- **Mainnet**是指一个有效的、完全运行的区块链。主网网络已经完全部署，并执行从发件人向收件人传输数字货币的功能。

### 最大 Gas 量

- 交易**的最大 Gas 金额**是发件人准备为交易支付的 Gas 单位的最大 Gas 金额。
- 只有当使用的 Gas 不超过最大 Gas 量时，交易才能成功执行。
- 收取的 Gas 等于 Gas 价格乘以处理此交易所需的 Gas 单位。
- 如果交易在执行期间耗尽 Gas ，或帐户在执行期间耗尽余额，则将向发件人收取使用 Gas 的费用，交易将失败。

有关更多信息，请参阅[ Gas 和存储费用](https://aptos.dev/concepts/gas-txn-fee)。

### 门普尔

- **Mempool**是验证器的组件之一。它持有已提交但尚未商定和执行的交易的内存缓冲区。Mempool接收来自其他[完整节点](https://aptos.dev/reference/glossary#fullnodes)的交易。
- 验证器的mempool中的事务从当前节点的JSON-RPC服务和其他Aptos节点的mempool添加。
- 当当前验证者是领导者时，其共识组件从其mempool中提取事务，并提出形成块的事务的顺序。然后，验证者法定人数对该提案进行投票。

### 默克尔树

- **Merkle树**是一种经过身份验证的数据结构，可以高效验证数据完整性和更新。

- Aptos网络将整个区块链视为一个单一的数据结构，记录交易历史和状态的历史。

- Merkle树

    实现简化了访问区块链的应用程序的工作。它允许应用程序：

    - 读取任何时间点的任何数据。
    - 使用统一的框架验证数据的完整性。

### Merkle累加器

- **[Merkle Accumulator](https://www.usenix.org/legacy/event/sec09/tech/full_papers/crosby.pdf)**是一个*仅附加的*Merkle树，Aptos区块链用于存储分类账。
- Merkle累加器可以提供交易包含在链中的证明（“包含证明”）。
- 它们在文学中也被称为“历史树”。

### 模块

- Move编程语言中的**模块**可以是可以创建、传输或存储资产的程序或库。

### 移动

- **Move**是一种新的编程语言，可以实现Aptos区块链上的所有交易。
- 它有两种不同的代码——[移动脚本](https://aptos.dev/reference/glossary#transaction-or-move-script)和[移动模块](https://aptos.dev/reference/glossary#move-module)。
- Move是web3的一种安全可靠的编程语言，强调访问控制和稀缺性。它是用于构建Aptos区块链的编程语言。您可以在[Move on Aptos](https://aptos.dev/move/move-on-aptos)中阅读更多有关它的信息。

### 移动字节码

- 移动程序被编译成**移动字节码**。
- 移动字节码用于表达移动脚本和移动模块。

### 移动模块

- **Move模块**定义了更新Aptos区块链全局状态的规则。
- 在Aptos协议中，Move模块是一个**智能合约**。
- 每个用户提交的事务都包含一个移动脚本。移动脚本调用一个或多个移动模块的过程，根据规则更新区块链的全局状态。

### 移动资源

- **移动资源**包含可以根据移动**模块**中声明**的程序**访问的数据**。**
- 移动资源永远不能被复制、重用或丢失。这可以防止移动程序员意外或故意丢失资源。

### 移动虚拟机（MVM）

- **Move虚拟机**执行用[Move字节码](https://aptos.dev/reference/glossary#move-bytecode)编写的Move脚本，以产生执行结果。此结果用于更新区块链**状态**。
- 虚拟机是[验证器](https://aptos.dev/reference/glossary#validator)的一部分。
- Move虚拟机（MoveVM）处理每个验证器节点，该节点将事务与当前区块链分类账状态一起转换，以生成更改集作为输入或存储增量作为输出。

## N

### 节点

- **节点**是Aptos网络的对等实体，用于跟踪Aptos区块链的状态。
- Aptos节点由逻辑组件组成。[Mempool](https://aptos.dev/reference/glossary#mempool)、[共识](https://aptos.dev/reference/glossary#consensus)和[Move虚拟机](https://aptos.dev/reference/glossary#move-virtual-machine-mvm)是节点组件的示例。

### 诺斯

- **Nonce**是一个只使用一次的数字，一个随机或半随机数，为身份验证协议和加密散列函数的特定用途而生成。

## 哦

### 开源社区

- **开源社区**是一群从事开源软件工作的开发人员的术语。如果您正在阅读本术语表，那么您就是Aptos项目开发人员社区的一部分。

## P

### 证明

- **证明**是验证区块链中数据准确性的一种方式。
- Aptos区块链中的每个操作都可以加密验证它确实正确，并且数据没有被省略。
- 例如，如果用户查询特定已执行交易中的信息，他们将获得返回给他们的数据正确的加密证明。

### PoS

**股权证明（PoS）**是一种安全机制，用于确认区块链交易的唯一性和合法性。PoS共识机制由由验证器网络驱动的Aptos区块链利用，该网络反过来更新系统并处理交易。

## R

### 资源帐户

- **资源帐户**用于独立于用户管理的帐户来管理资源。例如，开发人员可以使用资源帐户来管理模块发布帐户，例如管理合同。
- 合同本身不需要签名人后初始化。资源帐户为您提供了模块为其他模块提供签名者并代表模块签署事务的手段。

有关使用说明，请参阅[资源帐户](https://aptos.dev/move/move-on-aptos/resource-accounts)。

### REST服务

- **REST服务**组件是Aptos节点的外部接口。任何传入的客户端请求，如已提交的交易或查询，必须首先通过REST服务。客户端需要通过REST服务组件来访问存储或系统中的任何其他组件。这过滤了请求并保护了系统。
- 每当客户端提交新交易时，REST服务都会将其传递给[mempool](https://aptos.dev/reference/glossary#mempool)。

### 圆形

- 一**轮**包括就交易块及其执行结果达成共识。

### 圆形号码

- **圆形数字**是一个共享计数器，用于在共识协议的一个[时代](https://aptos.dev/reference/glossary#epoch)选择领导者。

## S

### SDK

- Aptos**软件开发工具包（SDK）**是一套工具，使开发人员能够在Aptos平台上快速创建自定义应用程序。在[使用Aptos SDKs上](https://aptos.dev/sdks/index)了解更多信息。

### 序号

- 帐户的**序列号**表示从该帐户在链上提交和提交的交易数量。每当从该帐户发送的交易被执行或中止并存储在区块链中时，它都会增加。
- 仅当交易与发件人帐户的当前序列号匹配时才会执行。这有助于对来自同一发件人的多个事务进行排序，并防止重播攻击。
- 如果帐户A的当前序列号是X，那么只有当T的序列号是X时，才会执行帐户A上的交易T。
- 这些交易将保留在mempool中，直到它们成为该帐户的下一个序列号（或直到它们到期）。
- 当交易被应用时，帐户的序列号将变为X+1。该帐户的序列号严格增加。

### 发件人

- *备用名称*：发件人地址。
- **发件人**是发起交易的地址。交易必须由发件人签名，但可以有多个签名人。

### 浅滩

- 减少BFT协议延迟的方法。见[纸](https://arxiv.org/pdf/2306.03058.pdf)

### 智能合约

- **智能合同**是指自动直接执行合同条款的计算机程序。
- 有关相关详细信息，请参阅[移动模块](https://aptos.dev/reference/glossary#move-module)。

### 状态

- Aptos协议中**的状态**是分布式数据库的快照。
- 事务修改数据库并生成新的和更新的状态。

### 状态根哈希

- **状态根散列**是所有密钥上的[Merkle散列](https://en.wikipedia.org/wiki/Merkle_tree)，并在给定版本中值Aptos区块链的状态。

## T

### 桌子

- [**表**](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/doc/table.md)实现了表类型，在Aptos中用于将信息作为密钥值数据大规模存储在帐户中。

有关关联的Aptos源文件，请参阅[`table.move`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/table.move)。

### 测试网

- **Testnet**描述了Aptos网络功能不完整，但比devnet更稳定；它是主网的替代网络，用于测试。

### 代币

- **代币**是在区块链上发行的数字价值单位。它们可以赎回资产或持有的价值。令牌可以有以下类型：可替换令牌（FT）、非可替换令牌（NFT）和半可替换令牌（SFT）。

### 交易

- 原始

    事务

    包含以下字段：

    - [发送者（帐户地址）](https://aptos.dev/reference/glossary#account-address)
    - [Move 脚本](https://aptos.dev/reference/glossary#transaction-or-move-script)
    - [Gas 价格](https://aptos.dev/reference/glossary#gas-unit-price)
    - [最大 Gas 量](https://aptos.dev/reference/glossary#maximum-gas-amount)
    - [序号](https://aptos.dev/reference/glossary#sequence-number)
    - [到期时间](https://aptos.dev/reference/glossary#expiration-time)

- 签名交易是带有数字签名的原始交易。

- 执行的交易会改变Aptos区块链的状态。

### 交易或移动脚本

- 用户提交的每个事务都包含一个**移动脚本**。
- 这些事务，也称为移动脚本，代表客户端提交给验证器的操作。
- 该操作可能是将硬币从用户A移动到用户B的请求，也可能涉及与已发布的[Move模块](https://aptos.dev/reference/glossary#move-module)（智能合约）的交互。
- Move脚本是一个任意程序，通过调用模块的过程与Aptos区块链全局存储中发布的资源进行交互。它编码交易的逻辑。
- 单个移动脚本可以向多个收件人发送资金，并从几个不同的模块调用过程。
- 移动脚本**不**存储在全局状态，也不能被其他移动脚本调用。这是一个一次性程序。

要查看移动脚本的示例，请遵循[Move 脚本](https://aptos.dev/move/move-on-aptos/scripts/script-tutorial)和[您的第一个Multisig](https://aptos.dev/tutorials/your-first-multisig)教程。

## V

### 验证器

- *备用名称*：验证器。
- **验证器**是Aptos生态系统的一个实体，在Aptos区块链上进行验证。它接收客户端的请求，并运行共识、执行和存储。
- 验证器维护区块链上所有交易的历史记录。
- 在内部，验证器需要保持当前状态，执行事务，并计算下一个状态。
- Aptos验证器负责验证交易。

### 验证器节点

- **验证器节点**是参与共识的唯一全节点类别，特别是Aptos中的拜占庭容错（BFT）共识协议。验证者同意将交易添加到Aptos区块链以及添加它们的顺序。

### 版本

- **版本**是一个顺序递增的数字，每[笔交易](https://aptos.dev/reference/glossary#transaction)都会递增。
- 在aptos上，交易是全局排序的，每个交易都有一个版本（在区块链文献中通常称为“高度”）。
- 交易版本0是第一个交易（起源交易），交易版本100是区块链中的第101个交易。

## W

### 格式良好的交易

如果交易满足以下每个条件，则 Aptos 交易是**格式良好的**：

- 交易有有效的签名。
- 发件人地址存在一个帐户。
- 它包括一个公钥，公钥的哈希与发件人帐户的身份验证密钥相匹配。
- 交易的序列号与发件人帐户的序列号匹配。
- 发件人帐户的余额大于[最大 Gas 量](https://aptos.dev/reference/glossary#maximum-gas-amount)。
- 交易的到期时间尚未过。