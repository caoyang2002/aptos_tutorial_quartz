---
title: 第二十一章 Aptos 随机数
aliases:
  - 第二十一章 Aptos 随机数
tags:
  - MoveOnAptos
---
# Aptos Roll：一个随机性 API

## 它的作用：一个快速示例

### 如何不安全/笨拙地获取随机数

构建一个彩票系统并从 `n` 个参与者中随机选择一个获胜者在中心化世界中，有一个可信的服务器时是很简单的：后端只需调用 `random.randint(0, n-1)`（这是一个 Python 示例）。

不幸的是，在 Aptos Move 中没有相当于 `random.randomint()` 的函数，构建其 dApp 版本实际上要困难得多。

可能有人编写了一个合约，其中随机数是以不安全的方式采样的（例如，从区块链时间戳）：
```rust
module module_owner::lottery {
    // ...
 
    struct LotteryState {
        players: vector<address>,
        winner_idx: std::option::Option<u64>,
    }
 
    fun load_lottery_state_mut(): &mut LotteryState {
        // ...
    }
 
    entry fun decide_winner() {
        let lottery_state = load_lottery_state_mut();
        let n = std::vector::length(&lottery_state.players);
        let winner_idx = aptos_framework::timestamp::now_microseconds() % n;
        lottery_state.winner_idx = std::option::some(winner_idx);
    }
}
```

上述实现存在多种不安全的方式：

- 恶意用户可能通过选择交易提交时间来影响结果；
- 恶意验证者可以通过选择将 `decide_winner` 交易放入哪个块轻松影响结果。

其他 dApp 可能选择使用外部安全的随机性源（例如，[drand](https://drand.love/)），这通常是一个复杂的流程：

1. 参与者同意使用随机性源承诺的未来随机性种子来确定获胜者。
2. 一旦随机性种子被揭示，客户端获取它并在本地推导出获胜者。
3. 其中一个参与者在链上提交种子和获胜者。
```
module module_owner::lottery {    //...     struct LotteryState {        players: vector<address>,        /// 关于“未来随机性”的公共信息，通常是 VRF 公钥和输入。        seed_verifier: vector<u8>,        winner_idx: std::option::Option<u64>,    }     fun load_lottery_state_mut(): &mut LotteryState {        //...    }     fun is_valid_seed(seed_verifier: vector<u8>, seed: vector<u8>): bool {        //...    }     fun derive_winner(n: u64, seed: vector<u8>): u64 {        //...    }     entry fun update_winner(winner_idx: u64, seed: vector<u8>) {        let lottery_state = load_lottery_state_mut();        assert!(is_valid_seed(lottery_state.seed_verifier, seed), ERR_INVALID_SEED);        let n = std::vector::length(players);        let expected_winner_idx = derive_winner(n, seed);        assert!(expected_winner_idx == winner_idx, ERR_INCORRECT_DERIVATION);        lottery_state.winner_idx = std::option::some(winner_idx);    }}
```

### 使用 Aptos 随机性 API 实现简单性和安全性

使用 Aptos 随机性 API，实现将如下所示：
```
module module_owner::lottery {    //...     struct LotteryState {        players: vector<address>,        winner_idx: std::option::Option<u64>,    }     fun load_lottery_state_mut(): &mut Lottery {        //...    }     #[randomness]    entry fun decide_winner() {        let lottery_state = load_lottery_state_mut();        let n = vector::length(&lottery_state.players);        let winner_idx = aptos_framework::randomness::u64_range(0, n);        lottery_state.winner_idx = std::option::some(winner_idx);    }}
```

其中：

- `let winner_idx = aptos_framework::randomness::u64_range(0, n);` 是随机性 API 调用，它均匀随机地返回范围 `[0, n)` 内的一个 u64 整数。
- `#[randomness]` 是一个必需的属性，用于在运行时启用 API 调用。

### 安全考虑

编译器有助于防止测试和中止攻击，要求使用随机性的函数为私有。然而，随机性 API 目前无法防止欠 gas 攻击。智能合约需要以某种方式编写以避免这种情况。

## 如何使用 Aptos 随机性 API

### 当前支持的网络

随机性 API 在 devnet 和 testnet 上启用，很快将在 mainnet 上启用。

### 从最新源代码构建 Aptos CLI

对 [Aptos CLI](https://aptos.dev/en/build/cli) 进行了一些更改，以支持编译使用随机性的合同。虽然这些更改尚未包含在官方的 Aptos CLI 版本中（但即将推出），您可以从源代码构建它以支持您的依赖随机性的合同开发。

终端

```
git clone https://github.com/aptos-labs/aptos-corecd aptos-core./scripts/dev_setup.sh -bsudo apt-get install libudev-dev. ~/.profilecargo build -p aptosalias aptos=target/debug/aptos
```

### 记住欠 gas 攻击

⚠️

**随机性 API 目前无法防止欠 gas 攻击。** 仔细阅读欠 gas 部分，了解欠 gas 攻击以及如何防止它们。作为 dApp 开发人员，您需要在设计使用随机性的应用程序时牢记安全性。

### 识别依赖随机性的入口函数并使其合规

为了安全（稍后将详细讨论），随机性 API 调用仅允许来自以下入口函数：

- 私有，并且
- 带有 `#[randomness]` 注释。

现在是时候考虑哪些用户操作需要随机性 API，将它们写下来，并确保它们是私有的并且具有正确的属性，如下例所示。

```
module module_owner::lottery {    //...     #[randomness]    entry fun decide_winner() {        //...    }}
```

在运行时，当调用随机性 API 时，VM 检查调用栈的最外层是否为带有 `#[randomness]` 属性的私有入口函数。**如果不是，整个交易将被中止。**

注意：这也意味着随机性 API 调用仅在基于入口函数的交易中支持。（例如，在 Move 脚本中使用随机性 API 是不可能的。）

### 调用 API

这些 API 是 `0x1::randomness` 下的公共函数，可以直接引用，如上面的彩票示例所示。

```
module module_owner::lottery {    //...     #[randomness]    entry fun decide_winner() {        //...        let winner_idx = aptos_framework::randomness::u64_range(0, n);        lottery_state.winner_idx = std::option::some(winner_idx);    }}
```

上述示例使用了函数 `u64_range()` ，但也支持许多其他基本类型。以下是所有 API 的快速概述，其中 `T` 可以是 `u8, u16, u32, u64, u128, u256` 之一。

```
module aptos_framework::randomness {    /// 均匀随机生成一个数字。    fun u8_integer(): u8 {}     /// 均匀随机生成一个数字。    fun u16_integer(): u16 {}     // fun u32_integer(), fun u64_integer()...     /// 均匀随机生成一个范围在 `[min_incl, max_excl)` 内的数字。    fun u8_range(min_incl: u8, max_excl: u8): u8 {}     /// 均匀随机生成一个范围在 `[min_incl, max_excl)` 内的数字。    fun u16_range(min_incl: u16, max_excl: u16): u16 {}     // fun u32_range(), fun u64_range()...     /// 均匀随机生成一个字节序列    /// n 是字节数    /// 如果 n 为 0，则返回空向量。    fun bytes(n: u64): vector<u8> {}     /// 均匀随机生成 `[0, 1,..., n-1]` 的一个排列。    /// n 是数字    /// 如果 n 为 0，则返回空向量。    fun permutation(n: u64): vector<u64> {}}
```

完整的 API 函数列表和文档可以在 [这里](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/doc/randomness.md) 找到。

## 安全考虑

随机性 API 在许多方面都很强大：它解锁了新的 dApp 设计；但如果使用不当，可能会使您的 dApp 容易受到攻击！以下是您应该避免的一些常见错误。

### 公共函数中的随机性 API 调用

随着您的 dApp 变得更加复杂，您可能有多个入口函数需要共享相同的依赖随机性的逻辑，并希望将逻辑提取为一个单独的辅助函数。

虽然如下所示是支持的，但必须格外小心。

```
module module_owner::lottery {    //...     #[randomness]    entry fun decide_winner_v0() {        //...        decide_winner_internal(lottery_state);    }     #[randomness]    entry fun decide_winner_v1() {        //...        decide_winner_internal(lottery_state);    }     // 一个私有辅助函数    fun decide_winner_internal(lottery_state: &mut lottery_state) {        let n = std::vector::length(&lottery_state.players);        let winner_idx = aptos_framework::randomness::u64_range(0, n);        lottery_state.winner_idx = std::option::some(winner_idx);    }}
```

如果 `decide_winner_internal()` 不小心被标记为公共，恶意玩家可以部署他们自己的合同来：

1. 调用 `decide_winner_internal()`；
2. 读取彩票结果（假设 `lottery` 模块有一些用于获取结果的获取函数）；
3. 如果结果对他们不利则中止。通过反复调用他们自己的合同，直到交易成功，恶意用户可以影响获胜者的均匀分布（dApp 开发者的初始设计）。这被称为 [测试和中止攻击](https://github.com/aptos-foundation/AIPs/blob/main/aips/aip-41.md#test-and-abort-attacks)。

Aptos Move 编译器已更新以防止这种对您合同的攻击以确保您的安全：依赖随机性的公共函数被视为编译错误。如果您已经完成了[“构建 Aptos CLI”](https://aptos.dev/en/build/smart-contracts/randomness#build-aptos-cli-from-latest-source)) 部分中的步骤，那么您的 Aptos CLI 配备了更新的编译器。

```
module module_owner::lottery {    // 编译错误！    public fun decide_winner_internal(lottery_state: &mut lottery_state) {        let n = std::vector::length(&lottery_state.players);        let winner_idx = aptos_framework::randomness::u64_range(0, n);        lottery_state.winner_idx = std::option::some(winner_idx);    }}
```

不推荐，但如果您有意将这样一个依赖随机性的函数公开，可以通过用 `#[lint::allow_unsafe_randomness]` 注释您的函数来绕过编译器检查。

```
module module_owner::lottery {    // 可以编译，但使用需自担风险！    #[lint::allow_unsafe_randomness]    public fun decide_winner_internal(lottery_state: &mut lottery_state) {        let n = std::vector::length(&lottery_state.players);        let winner_idx = aptos_framework::randomness::u64_range(0, n);        lottery_state.winner_idx = std::option::some(winner_idx);    }}
```

### 欠 gas 攻击以及如何防止

想象这样一个 dApp。它为用户定义了一个私有入口函数来：

1. 抛硬币（gas 成本：9），然后
2. 如果硬币 = 1 则获得奖励（gas 成本：10），否则进行一些清理（gas 成本：100）。

恶意用户可以控制其账户余额，因此它最多覆盖 108 个 gas 单位（或设置交易参数 `max_gas=108`），并且清理分支（总 gas 成本：110）将始终因 gas 不足错误而中止。然后用户反复调用入口函数，直到获得奖励。

正式地，这被称为 [欠 gas 攻击](https://github.com/aptos-foundation/AIPs/blob/main/aips/aip-41.md#undergasing-attacks)，攻击者可以控制入口函数执行剩余的 gas 量，因此可以任意决定中止消耗更多 gas 的路径，影响结果（即有效地改变随机数的分布）。

**警告：随机性 API 目前无法防止欠 gas 攻击。** 作为 dApp 开发人员，您在设计时需要非常小心以避免这种类型的攻击。以下是一些如何一般地防止欠 gas 攻击的想法。

- 使您的入口函数的 gas 消耗与随机性结果无关。最简单的例子是不对随机性结果“采取行动”，即读取并存储以供以后使用。请注意，调用任何其他函数可能具有可变的 gas 成本。例如，当调用随机性来决定哪个玩家应该获胜，然后将奖金存入获胜者可能看起来像是固定的 gas 成本。但是，`0x1::coin::transfer` / `0x1::fungible_asset::transfer` 可能根据用户的链上状态具有可变成本。
- 如果您的 dApp 涉及一个受信任的管理员/管理员组，仅允许受信任的人员执行随机性交易（即需要管理员签名）。
- 使最有益的路径具有最高的 gas 消耗（因为攻击者只能中止 gas 消耗高于他选择的阈值的路径。注意：这可能很难正确实现，并且 gas 调度可能会改变，并且当有两个以上的可能结果时更难正确实现。

请注意，不属于上述类别的所有内容都可能以微妙的方式容易受到欠 gas 攻击。如果您需要帮助，请联系我们。

我们将来会提供更多功能，以使更复杂的代码能够安全地防止欠 gas 攻击。

### 它是随机的，但不是秘密

虽然随机性 API 模仿您用于实现私有中心化服务器的标准库，但请记住，**种子是公开的，您的交易执行也是公开的**，并且您的私有中心化服务器中的并非每个依赖随机性的逻辑都可以安全地转移到链上，**尤其是当它涉及只有服务器应该看到的秘密时**。

例如，在您的合同中，请勿尝试执行以下操作。

- 使用随机性 API 生成非对称密钥对，丢弃私钥，然后认为公钥是安全的。
- 使用随机性 API 洗牌一些打开的卡片，遮盖它们，并认为没有人知道排列。

## 阅读更多

[Aptogotchi Random Mint](https://github.com/aptos-labs/aptogotchi-random-mint/tree/main) 是一个官方演示 dApp，用于展示随机性 API 的使用。

完整的 API 函数列表和文档可以在 [这里](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/doc/randomness.md) 找到。

您还可以在 [这里](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/randomness.move) 找到 API 函数的部分实现和示例单元测试。

有关 API 设计，请参阅 [AIP-41](https://github.com/aptos-foundation/AIPs/blob/main/aips/aip-41.md) ，如果您对系统级/密码学细节感兴趣，请参阅 [AIP-79](https://github.com/aptos-foundation/AIPs/blob/main/aips/aip-79.md) 。