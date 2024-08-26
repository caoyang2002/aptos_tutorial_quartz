---
title: 第二十六章-资源账户
aliases:
  - 第二十六章-资源账户
tags:
  - Move
---

# 资源账户

[对象代码部署](https://aptos.dev/en/build/smart-contracts/object-code-deployment)是在 Aptos 中部署和升级智能合约的首选方法。资源账户要求开发人员每次创建资源账户时都生成种子，并且升级合约需要特定步骤，容易出现错误。

[资源账户](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/resource_account.move)是开发人员用于独立于用户管理的账户来管理资源的一项功能，特别是发布模块和提供仅链上的访问控制，例如签名者。

通常，资源账户主要用于两个目的：

- 存储和隔离资源；一个模块创建一个资源账户只是为了托管特定资源。
- 作为独立（资源）账户发布模块，这是去中心化设计中的一个构建块，其中没有私钥可以控制资源账户。所有权（SignerCap）可以保存在另一个模块中，例如治理模块。

## 限制

在 Aptos 中，资源账户是根据源地址的 SHA3-256 哈希和附加的种子数据创建的。资源账户只能创建一次；对于给定的源地址和种子，只能有一个资源账户。这是因为资源账户地址的计算完全由前者确定。

一个实体可能会调用 `create_account` ，试图在创建资源账户之前声明一个账户。但是，如果找到了资源账户，Aptos 将把账户的所有权转移给资源账户。这是通过验证该账户尚未执行任何交易并且 `Account::signer_capbility_offer::for` 为空来完成的。有人合法生成映射到资源账户地址的私钥的冲突概率极低。

## 设置

设置资源账户的最简单方法是：

1. 使用 Aptos CLI：`aptos account create-resource-account` 创建资源账户，`aptos move create-resource-account-and-publish-package` 创建资源账户并在资源账户的地址下发布指定的包。
2. 编写自定义智能合约代码：在 `resource_account.move` 模块中，开发人员可以找到资源账户创建函数 `create_resource_account`、`create_resource_account_and_fund` 和 `create_resource_account_and_publish_package`。然后，开发人员可以在他们的智能合约中调用这些函数来创建资源账户。

这些选项中的每一个都提供了略有不同的功能：

- `create_resource_account` - 仅创建资源账户但不提供资金，在明确调用 `retrieve_resource_account_cap` 之前保留对资源账户签名者的访问权限。
- `create_resource_account_and_fund` - 创建资源账户并提供资金，在明确调用 `retrieve_resource_account_cap` 之前保留对资源账户签名者的访问权限。
- `create_resource_account_and_publish_package` - 创建资源账户，并根据设计导致失去对资源账户的访问权限，因为资源账户用于使合约自主和不可变。

在此示例中，您将[初始化](https://github.com/aptos-labs/aptos-core/blob/2e9d8ee759fcd3f6e831034f05c1656b1c48efc4/aptos-move/move-examples/mint_nft/sources/minting.move#L73) `mint_nft` 模块，并从资源账户和模块账户中检索签名者能力。为此，调用 `create_resource_account_and_publish_package` 在资源账户的地址下发布模块。

1. 如在 [`minting.move`](https://github.com/aptos-labs/aptos-core/blob/2e9d8ee759fcd3f6e831034f05c1656b1c48efc4/aptos-move/move-examples/mint_nft/sources/minting.move#L73) 示例中所示初始化模块。
2. 调用 `create_resource_account_and_publish_package` 在资源账户的地址下发布模块，如在 [`mint_nft.rs`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/e2e-move-tests/src/tests/mint_nft.rs#L62) 端到端示例中。
3. 如在 [`minting.move`](https://github.com/aptos-labs/aptos-core/blob/2e9d8ee759fcd3f6e831034f05c1656b1c48efc4/aptos-move/move-examples/mint_nft/sources/minting.move#L83) 示例中所示从资源账户 + 模块账户中检索签名者能力。

请注意，如果上述 `resource_account` 签名者尚未被设置为资源账户，检索签名者能力将会失败。`retrieve_resource_account_cap` 函数中的 `source_addr` 字段指的是源账户的地址，即创建资源账户的账户。

有关示例，请参阅 [`minting.move`](https://github.com/aptos-labs/aptos-core/blob/2e9d8ee759fcd3f6e831034f05c1656b1c48efc4/aptos-move/move-examples/mint_nft/sources/minting.move#L143-L181) 中 `mint_nft` 函数所使用的 `SignerCapability` 。

有关更多详细信息，请参阅 [`resource_account.move`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/resource_account.move) 和 [`account.move`](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/account.move) 中的“资源账户”参考。