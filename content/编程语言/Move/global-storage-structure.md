---
title: 全局存储-结构体
---
# 全球存储-结构

移动程序的目的是[从](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators)树形持久全局存储中[读取和写入](https://aptos.guide/en/build/smart-contracts/book/global-storage-operators)。程序无法访问文件系统、网络或此树之外的任何其他数据。

在伪代码中，全局存储看起来像：

```rust
module 0x42::example {
  struct GlobalStorage {
    resources: Map<(address, ResourceType), ResourceValue>,
    modules: Map<(address, ModuleName), ModuleBytecode>
  }
}
```

从结构上讲，全球存储是由植根于帐户[`address`](https://aptos.guide/en/build/smart-contracts/book/address)的树木组成的[森林](https://en.wikipedia.org/wiki/Tree_(graph_theory))。每个地址都可以存储[资源](https://aptos.guide/en/build/smart-contracts/book/structs-and-resources)数据值和[模块](https://aptos.guide/en/build/smart-contracts/book/modules-and-scripts)代码值。正如上面的伪代码所示，每个`address`最多可以存储一个给定类型的资源值，最多存储一个具有给定名称的模块。