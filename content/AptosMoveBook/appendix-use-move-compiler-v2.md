---
title: Move 编译器 v2
---

# Aptos 上的 Move 编译器（测试版）

Aptos 上的 Move 编译器（代号“compiler v2”）是一种将 Move 源代码转换为 Move 字节码的新工具。它统一了 Move 编译器和 Move 证明器的架构，能够在 Move 语言中实现更快的创新。它还提供了用于定义代码优化的新工具，可用于为 Move 程序生成更节省燃气的代码。

## 测试版测试

编译器 v2（版本“2.0 - 不稳定”）目前处于测试阶段，鼓励开发社区进行试用。然而，此版本编译器生成的代码**不能**部署在“mainnet”上。用于单元测试或本地节点、“devnet”和“testnet”是可以的。一旦情况发生变化，此页面将进行更新。

请注意，编译器 v2 尚未应用许多代码优化。因此，生成的代码在燃气效率上略低于编译器 v1。我们预计一旦新的编译器达到生产就绪状态，这种情况将会改变。

## 漏洞赏金

我们为在编译器中发现的每个独特的语义错误提供赏金。错误需要表现为 v1 和 v2 编译器执行结果的差异，正如 Move 单元测试所展示的那样。使用新编译器尝试您现有的 Move 测试，就像调用`aptos move test --compiler-version=2`一样简单！并非编译器行为的所有差异都计入程序，[点击此处](https://hackenproof.com/audit-programs/aptos-labs/move-on-aptos-beta-compiler)了解赏金计划的详细信息。即使行为差异不符合赏金条件，我们也鼓励您使用下面的链接提出问题。

## 报告问题

如果您遇到问题，请使用[此链接创建一个 github 问题](https://github.com/aptos-labs/aptos-core/issues/new?title=[compiler-v2] &body=&labels=compiler-v2&projects=aptos-labs/16)。如果您能够提供一小段重现问题的 Move 代码，对我们来说调试和修复会更容易。

## 使用编译器 v2

确保已安装最新版本的 Aptos CLI：

终端

```bash
aptos update aptos # 在支持的操作系统上
brew upgrade aptos # 在 MacOS 上
```

要运行编译器 v2，请将标志`--compiler-version=2`传递给 Aptos CLI。示例：

终端

```bash
aptos move compile --compiler-version=2
aptos move test --compiler-version=2
aptos move prove --compiler-version=2
```

## 使用 Move 2

编译器 v2 实现了“Aptos 上的 Move 新版本 Move 2”的一些初始功能。Move 2 的范围在博客[The Future of Move at Aptos](https://medium.com/aptoslabs/the-future-of-move-at-aptos-17d0656dcc31) （中文：[[附录：Move 编译器 v2 介绍]]）中有描述。不断增加的新功能列表记录如下，并将随着新功能的添加而扩展：

- 接收者风格的函数调用（有关更多详细信息，请参阅 [Move 手册](https://aptos.dev/en/build/smart-contracts/book/functions)）

目前必须使用标志 `--language-version=2` 明确选择使用 Move 2：

```bash
aptos move compile --compiler-version=2 --language-version=2
```
