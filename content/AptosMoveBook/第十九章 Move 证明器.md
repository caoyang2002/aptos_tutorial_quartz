---
title: 第十九章 Move 证明器
tags:
  - aptos-cli
---
# 1. 概述

Move 证明器支持对 Move 代码进行正式的[规范](https://aptos.dev/en/build/smart-contracts/prover/spec-lang)与[验证](https://aptos.dev/en/build/smart-contracts/prover/prover-guide)。Move 证明器可以自动验证 Move 智能合约的逻辑属性，同时提供类似于类型检查器或代码检查工具的用户体验。

Move 证明器的存在旨在使合约更具*可信度*；它：

- 保护由 Aptos 区块链管理的大量资产免受智能合约漏洞的影响
- 防范资源丰富的对手
- 预期合理的监管审查和合规要求
- 允许具有数学背景但不一定具有软件工程背景的领域专家理解智能合约的作用

更多信息，请参考以下文档：

- [安装](https://aptos.dev/en/build/cli/setup-cli/install-move-prover)
- [Move 证明器用户指南](https://aptos.dev/en/build/smart-contracts/prover/prover-guide)
- [Move 规范语言](https://aptos.dev/en/build/smart-contracts/prover/spec-lang)
- [Move 证明器支持资源](https://aptos.dev/en/build/smart-contracts/prover/supporting-resources)



# 2. 用户指南

这是 Move 证明器的用户指南。此文档与 Move 规范语言配套。详情请参阅以下各节。

## 2.1 运行 Move 证明器

Move 证明器通过 Aptos CLI 调用。为了调用 CLI，您必须有一个 Move 包就位。在最简单的情况下，Move 包由一个目录定义，其中包含一组 `.move` 文件和一个名为 `Move.toml` 的清单。您可以通过运行以下命令在给定位置创建一个新的 Move 包：`aptos move init --name <名称>`

一旦包存在，从要测试的目录调用 Move 证明器或通过将其路径提供给 --package-dir 参数：

证明当前目录中包的源文件：

```bash
aptos move prove
```

证明特定目录中包的源文件：

```bash
aptos move prove --package-dir <路径>
```

在“使用 Aptos CLI 进行 Move 证明”部分查看示例输出和其他可用选项。

## 2.2 目标筛选
默认情况下，`aptos move prove` 命令会验证包的所有文件。在较大包的迭代开发过程中，使用 `-f` (`--filter`) 选项将验证集中在特定文件上通常更有效，如下所示：

```bash
aptos move prove -f coin
```

通常，如果提供给 `-f` 选项的字符串包含在源文件的文件名中的某个位置，则该源文件将包含在验证中。

>[!NOTE] 注意
>Move 证明器确保逐个验证模块或一次验证所有模块之间没有语义差异。但是，如果您的目标是验证所有模块，在单个 `aptos move prove` 运行中验证它们将比顺序验证快得多。

## 2.3 证明器选项

Move 证明器有许多选项（如上述筛选选项），您可以通过调用：`aptos move prove <选项>` 来传递。最常用的选项是 `-t`（`--trace`）选项，当 Move 证明器遇到错误时，它会生成更丰富的诊断：

```bash
aptos move prove -f coin -t
```

要查看所有命令行选项的列表，请运行：

```bash
aptos move prove --help
```


## 2.4 证明器配置文件

您还可以创建一个名为 `Prover.toml` 的 Move 证明器配置文件，该文件与 `Move.toml` 清单文件一起位于包目录的**根目录**中。例如，要为包默认启用跟踪，添加一个具有以下配置的 `Prover.toml` 文件：

```toml
[prover]
auto_trace_level = "VerifiedFunction"
```

在下面的示例 `.toml` 中找到最常用的选项，您可以根据需要剪切、粘贴和采用（根据显示的值调整默认值）：
```toml
# 详细程度级别
# 可能的值："ERROR"、"WARN"、"INFO"、"DEBUG"。每个级别包含前一个级别的输出。
verbosity_level = "INFO"

[prover]
# 设置自动跟踪级别，增强 Move 证明器在验证错误时产生的诊断。
# 可能的值："Off"、"VerifiedFunction"、"AllFunctions"
auto_trace_level = "Off"

# 要报告的诊断的最小严重程度级别。
# 可能的值："Error"、"Warning"、"Note"
report_severity = "Warning"

[backend]
# 求解器后端的超时（秒）。请注意，这是一个软超时，可能并不总是被遵守。
vc_timeout = 40

# 求解器后端的随机种子。不同的种子可能导致不同的验证运行时间，因为求解器使用启发式方法。
random_seed = 1

# 假设用于并发检查验证条件的处理器核心数量。
proc_cores = 4
```

提示：对于本地验证，您可能希望将 `proc_cores` 设置为一个激进的数字（您的实际核心数）以加快周转周期。

## 2.5 证明器诊断

当 Move 证明器发现验证错误时，它会以类似于编译器或调试器的样式将诊断打印到标准输出。我们根据以下不断演变的示例解释不同类型的诊断：

```rust
module 0x42::m {
  struct Counter has key {
    value: u8,
  }

  public fun increment(a: address) acquires Counter {
    let r = borrow_global_mut<Counter>(a);
    r.value = r.value + 1;
  }

  spec increment {
    aborts_if!exists<Counter>(a);
    ensures global<Counter>(a).value == old(global<Counter>(a)).value + 1;
  }
}
```


我们将在演示不同类型的诊断时修改此示例。

## 2.6 意外中止
如果我们立即对上述示例运行 Move 证明器，我们会得到以下错误：

```bash
error: abort not covered by any of the `aborts_if` clauses
   ┌─ m.move:11:5
   │
 8 │           r.value = r.value + 1;
   │                             - abort happened here with execution failure
   ·
11 │ ╭     spec increment {
12 │ │         aborts_if!exists<Counter>(a);
13 │ │         ensures global<Counter>(a).value == old(global<Counter>(a)).value + 1;
14 │ │     }
   │ ╰─────^
   │
   =     at m.move:6: increment
   =         a = 0x29
   =     at m.move:7: increment
   =         r = &mmm.Counter{value = 255u8}
   =     at m.move:8: increment
   =         ABORTED

{
  "Error": "Move Prover failed: exiting with verification errors"
}
```

Move 证明器生成了一个示例计数器，当对 `u8` 的值 `255` 加 `1` 时会导致溢出。如果函数规范要求中止行为，但函数中止的条件未被规范涵盖，则会发生这种溢出。实际上，使用 `aborts_if!exists<Counter>(a)`，我们仅涵盖了由于资源不存在导致的中止，而不是由于算术溢出导致的中止。

让我们修复上述问题并添加以下条件：

```bash
module 0x42::m {
  spec increment {
    aborts_if global<Counter>(a).value == 255;
    //...
  }
}
```

这样，Move 证明器将成功运行，没有任何错误。

## 2.7 后置条件失败
让我们在上述示例的 ensures 条件中注入一个错误：

```rust
module 0x42::m {
  spec increment {
    ensures global<Counter>(a).value == /*old*/(global<Counter>(a).value) + 1;
  }
}
```

这样，Move 证明器将产生以下诊断：

```bash
error: post-condition does not hold
   ┌─ m.move:14:9
   │
14 │         ensures global<Counter>(a).value == /*old*/(global<Counter>(a).value) + 1;
   │         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   │
   =     at m.move:6: increment
   =         a = 0x29
   =     at m.move:7: increment
   =         r = &mmm.Counter{value = 0u8}
   =     at m.move:8: increment
   =     at m.move:9: increment
   =     at m.move:12: increment (spec)
   =     at m.move:15: increment (spec)
   =     at m.move:13: increment (spec)
   =     at m.move:14: increment (spec)

{
  "Error": "Move Prover failed: exiting with verification errors"
}
```

虽然我们知道错误是什么（因为我们刚刚注入了它），但在输出中这并不是特别明显。这是因为我们没有直接看到 `ensures` 条件实际上是在哪些值上进行评估的。要查看此内容，请使用 `-t` (`--trace`) 选项；此选项默认未启用，因为它会使求解器的验证问题稍微困难一些。

除了 `--trace` 选项之外，您还可以在条件中使用内置函数 `TRACE(exp)` 来明确标记在验证失败时应打印其值的表达式。

>[!NOTE] 注意
>依赖于量化符号的表达式无法跟踪。此外，当前规范函数中出现的表达式无法跟踪。

## 2.8 调试 Move 证明器

Move 证明器是一个不断发展的工具，存在错误和不足。有时可能需要根据 Move 证明器传递给底层后端的输出来调试问题。如果您传递 `--dump` 选项，Move 证明器将输出原始的 Move 字节码以及 Move 证明器字节码，因为前者在编译过程中会进行转换。


# 2. Move 证明器支持资源

## 2.1 标准库和框架规范

- [Move 标准库](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/framework/move-stdlib)
- [Aptos 标准库](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/framework/aptos-stdlib)
- [Aptos 框架](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/framework/aptos-framework)
- [Diem 框架](https://github.com/move-language/move/tree/main/language/documentation/examples/diem-framework/move-packages/DPN)

## 2.2 示例

- [`hello_prover` 示例](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/hello_prover)
- [`basic-coin` 示例](https://github.com/move-language/move/tree/main/language/documentation/examples/experimental/basic-coin)
- [`math-puzzle` 示例](https://github.com/move-language/move/tree/main/language/documentation/examples/experimental/math-puzzle)
- [`rounding-error` 示例](https://github.com/move-language/move/tree/main/language/documentation/examples/experimental/rounding-error)
- [`verify-sort` 示例](https://github.com/move-language/move/tree/main/language/documentation/examples/experimental/verify-sort)
- [Zellic 的 Move 证明器示例](https://github.com/zellic/move-prover-examples)

## 2.3 教程

- [Move 教程，步骤 7 和 8](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/move-tutorial#step-7--use-the-move-prover)
- [使用 Move 证明器验证 Aptos 中的智能合约 - MoveBit](https://www.movebit.xyz/blog/post/move-prover-tutorial-part-1.html)
- [Move 证明器：实用指南 - OtterSec](https://osec.io/blog/2022-09-16-move-prover)
- [形式验证、Move 语言和 Move 证明器 - Certik](https://www.certik.com/resources/blog/2wSOZ3mC55AB6CYol6Q2rP-formal-verification-the-move-language-and-the-move-prover)
- [Move 证明器：形式验证的质量保证 - Certik](https://www.certik.com/resources/blog/1NygvVeqIwhbUk1U1q3vJF-the-move-prover-quality-assurance-of-formal-verification)

## 2.4 演示文稿

- [Wolfgang Grieskamp 的使用 Move 证明器验证智能合约（视频）](https://drive.google.com/file/d/1DpI-rQ25Kq1jqMGioLgVrG3YuCqJHVMm/view?usp=share_link)
- [David Dill 的 Libra 区块链的 Move 程序的形式验证（视频）](https://www.fields.utoronto.ca/talks/Formal-verification-Move-programs-Libra-blockchain)
- [Move 证明器 - 最佳实践与技巧 - 用户视角 - Xu-Dong@MoveBit（幻灯片）](https://docs.google.com/presentation/d/1SuV0m5gGxSN9SaLdj9lLmTjspJ2xN1TOWgnwvdWbKEY/edit?usp=sharing)

## 2.5 会议论文

- Zhong, Jingyi Emma, Kevin Cheang, Shaz Qadeer, Wolfgang Grieskamp, Sam Blackshear, Junkil Park, Yoni Zohar, Clark Barrett, and David L. Dill. “The move prover.” In International Conference on Computer Aided Verification, pp. 137-150. Springer, Cham, 2020.Harvard
    - https://research.facebook.com/publications/the-move-prover/
- Dill, David, Wolfgang Grieskamp, Junkil Park, Shaz Qadeer, Meng Xu, and Emma Zhong. “Fast and reliable formal verification of smart contracts with the Move prover.” In International Conference on Tools and Algorithms for the Construction and Analysis of Systems, pp. 183-200. Springer, Cham, 2022.Harvard
    - https://research.facebook.com/publications/fast-and-reliable-formal-verification-of-smart-contracts-with-the-move-prover/