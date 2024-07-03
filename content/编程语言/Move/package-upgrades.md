---
title: 升级包
---
# 升级包

Aptos区块链上的移动代码（例如移动模块）可以升级。这允许代码所有者和模块开发人员在一个不变的单一、稳定、众所周知的帐户地址下更新和发展他们的合同。如果发生模块升级，该模块的所有消费者将自动收到最新版本的代码（例如，下次他们与它交互时）。

Aptos区块链原生支持不同的_升级策略_，允许移动开发人员明确定义有关如何升级其移动代码的约束。默认策略向_后兼容_。这意味着只有当代码升级保证升级（包括公共功能）不会破坏现有资源存储或公共API时，才接受代码升级。由于Move的强类型字节码语义，这种兼容性检查是可能的。

然而，我们注意到，即使是兼容的升级也会对应用程序和依赖的Move代码产生危险影响（例如，如果修改了基础模块的语义）。因此，开发人员在依赖可以在链上升级的第三方移动代码时应该小心。有关更多详细信息，请参阅[依赖项的安全注意事项](https://aptos.guide/en/build/smart-contracts/book/package-upgrades#security-considerations-for-dependencies)。

## 工作方式[](https://aptos.guide/en/build/smart-contracts/book/package-upgrades#how-it-works)

Aptos区块链上的移动代码升级发生在[移动包](https://aptos.guide/en/build/smart-contracts/book/packages)粒度上。软件包在`Move.toml`清单中指定升级策略：

```toml
[package]
name = "MyApp"
version = "0.0.1"
upgrade_policy = "compatible"
...
```

Aptos在通过Aptos事务发布Move软件包时检查兼容性。如果认为不兼容，这笔交易将中止。

## 如何升级[](https://aptos.guide/en/build/smart-contracts/book/package-upgrades#how-to-upgrade)

要升级已发布的移动代码，只需尝试在之前发布的同一地址重新发布代码。这可以通过遵循使用[Aptos CLI](https://aptos.guide/en/build/cli/working-with-move-contracts)进行代码编译和发布的说明来完成。例如，请参阅[您的第一次移动模块](https://aptos.guide/en/build/guides/first-move-module)教程。

## 升级政策[](https://aptos.guide/en/build/smart-contracts/book/package-upgrades#upgrade-policies)

Aptos目前支持两种不同的升级策略：

- `compatible`：这些升级必须向后兼容，特别是：
    - 对于存储，所有旧的结构声明在新代码中必须相同。这确保了现有的存储状态被新代码正确解释。然而，可以添加新的结构声明。
    - 对于API，所有现有的公共功能必须具有与以前相同的签名。可以添加新功能，包括公共和入口功能。
- `immutable`：代码不可升级，并保证永远保持不变。

这些政策是关于强度的命令，以便`compatible < immutable`，即兼容比不可变弱。链上软件包的政策只会变得更强，而不是更弱。此外，一揽子计划的所有依赖项的政策必须更强或等于给定一揽子计划的政策。例如，`immutable`包不能直接或间接引用`compatible`的包。这为用户提供了保证，引擎盖下不会发生意外更新。

请注意，上述规则有一个例外：在地址`0x1`至`0xa`安装的框架包免于依赖项检查。这是必要的，这样人们才能根据标准库定义一个`immutable`软件包，这些库具有允许关键升级和修复的`compatible`策略。

## 兼容性规则[](https://aptos.guide/en/build/smart-contracts/book/package-upgrades#compatibility-rules)

当使用`compatible`升级策略时，可以升级模块包。然而，之前已经发布的现有模块的更新需要兼容并遵循以下规则：

- 所有现有结构的字段都无法更新。这意味着无法添加新字段，也无法修改现有字段。结构能力也不能更改（没有添加新的或删除现有的）。
- 所有公共和条目函数都不能更改其签名（参数类型、类型参数、返回类型）。然而，参数名称可能会改变。
- `public(friend)`功能被视为私有，因此其签名可以任意更改。这是安全的，因为无论如何，只有同一软件包中的模块才能调用朋友函数，如果签名发生变化，则需要更新它们。

更新模块时，如果您看到不兼容的错误，请务必检查上述规则并修复任何违规行为。

## 依赖项的安全注意事项[](https://aptos.guide/en/build/smart-contracts/book/package-upgrades#security-considerations-for-dependencies)

如上所述，即使是兼容的升级也可能对依赖升级代码的应用程序产生灾难性影响。这些影响可能来自错误，但它们也可能是恶意升级的结果。例如，升级的依赖项可能会突然使所有函数中止，破坏您的移动代码的操作。或者，升级的依赖项可能会使所有功能突然在升级前执行成本更高。因此，需要谨慎处理对可升级软件包的依赖：

- 当然，最安全的依赖项是一个`immutable`软件包。这保证了依赖性永远不会改变，包括其传递依赖性。为了更新一个不可变的软件包，所有者必须引入一个新的主要版本，这实际上就像部署一个新的、单独的和独立的软件包。这是因为主要版本化只能用名称表示（例如`module feature_v1`和`module feature_v2`）。然而，并非所有软件包所有者都喜欢将他们的代码发布为`immutable`，因为这剥夺了修复错误和更新代码的能力。
- 如果您对`compatible`软件包有依赖，强烈建议您了解并理解发布软件包的实体。最高级别的保证是当软件包由分散式自治组织（DAO）管理时，单个用户都不能发起升级；必须进行投票或类似情况。Aptos框架就是这种情况。

## 程序升级[](https://aptos.guide/en/build/smart-contracts/book/package-upgrades#programmatic-upgrade)

一般来说，Aptos通过Move模块`aptos_framework::code`提供从智能合约中任何地方发布代码的方法。但是，请注意，当前交易中发布的代码只能在该交易结束后执行。

Aptos框架本身，包括所有链上管理逻辑，是编程升级的示例。该框架被标记为`compatible`。升级通过特定生成的治理脚本进行。有关更多详细信息，请参阅[Aptos治理](https://aptos.guide/en/network/blockchain/governance)。