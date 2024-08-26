---
title: 附录六：aptos sdk
aliases:
  - 附录六：aptos sdk
---

# Aptos Go SDK

## 安装 Go SDK

⚠️

Go SDK 目前处于测试阶段，其接口可能会发生变化

Aptos 在 [aptos-go-sdk GitHub](https://github.com/aptos-labs/aptos-go-sdk) 仓库中提供了一个官方的 Go SDK。要使用 Go SDK，请在此获取主包：

```
go get github.com/aptos-labs/aptos-go-sdk
```



## 使用 Go SDK

### 创建客户端

您可以通过导入 aptos-go-sdk 并创建一个 `Client` 来创建客户端

```
package main import (	"fmt"	"github.com/aptos-labs/aptos-go-sdk") func main() {	client, err := aptos.NewClient(aptos.DevnetConfig)	if err!= nil {		panic("Failed to create client:" + err.Error())	}	fmt.Println("client", client)}
```



您可以使用 `aptos.NetworkConfig` 配置网络，或者使用预先存在的 `aptos.DevnetConfig`、`aptos.TestnetConfig` 或 `aptos.MainnetConfig`

### 创建私钥

您可以通过调用 `NewEd25519Account()` 创建一个新的 `Ed25519` 账户的私钥。

```
account, err := aptos.NewEd25519Account()if err!= nil {  return err}
```



### 为账户提供资金

您可以在任何非主网的网络上通过水龙头创建并资助一个账户

```
account, err := aptos.NewEd25519Account()err = client.Fund(account.Address, 100_000_000)
```



### 发送交易

您可以通过一笔交易发送一个 AptosCoin

```
  account, err := aptos.NewEd25519account()   // 构建交易	signed_txn, err := aptos.APTTransferTransaction(client, account, AccountOne, 100) 	// 提交交易	result, err := client.SubmitTransaction(signed_txn)	hash := result["hash"].(string) 	// 等待交易	_, err = client.WaitForTransaction(hash)   // 按哈希读取交易	txn, err := client.TransactionByHash(hash)
```



### 更多示例

您可以在 Go SDK 仓库的 [`examples/` 文件夹](https://github.com/aptos-labs/aptos-go-sdk/tree/main/examples) 中查看更多示例



# Python SDK

Aptos 提供了一个维护程度较低的官方 Python SDK。它在 [PyPi](https://pypi.org/project/aptos-sdk/) 上可用，源代码在 [aptos-python-sdk GitHub 仓库](https://github.com/aptos-labs/aptos-python-sdk) 中。Python SDK 的许多功能与 [Typescript SDK](https://aptos.dev/en/build/sdks/ts-sdk) 类似。Python SDK 的主要目的是帮助 Python 开发者快速熟悉 Aptos，并作为 Aptos 教程的配套。

## 安装 Python SDK

Python SDK 可以通过 `pip`、源代码或嵌入的方式进行安装：

### 通过 `pip` 安装

要通过 `pip` 安装：

```
pip3 install aptos-sdk
```

`aptos-sdk` 将安装在本地的站点包目录中。例如，在 macOS 上，您将在 `~/Library/Python/3.8/lib/python/site-packages/aptos_sdk` 目录中找到 `aptos-sdk`。

### 从源代码安装

要从源代码安装：

```
git clone https://github.com/aptos-labs/aptos-python-sdkpip3 install. --user
```

### 通过嵌入安装

要将 Python SDK 嵌入到您现有的 Python 项目中：


```
cd /path/to/python/projectcp -r /path/to/aptos-python-sdk aptos-sdk
```

## 使用 Python SDK

有关如何使用 Python SDK 的代码示例，请参阅 [开发者教程](https://aptos.dev/en/build/guides) 。


# Rust SDK

## 安装

Aptos 在 [Aptos-core GitHub](https://github.com/aptos-labs/aptos-core/tree/main/sdk) 仓库中提供了一个官方的支持力度较小的 Rust SDK。要使用 Rust SDK，直接在您的 `Cargo.toml` 中对 git 仓库添加以下依赖项和补丁，如下所示：

Cargo.toml

```
[dependencies]aptos-sdk = { git = "https://github.com/aptos-labs/aptos-core", branch = "devnet" } [patch.crates-io]merlin = { git = "https://github.com/aptos-labs/merlin" }x25519-dalek = { git = "https://github.com/aptos-labs/x25519-dalek", branch = "zeroize_v1" }
```

您还必须创建一个具有以下内容的 `.cargo/config.toml` 文件：

.cargo/config.toml

```
[build]rustflags = ["--cfg", "tokio_unstable"]
```

官方 Rust SDK 的源代码可在 [aptos-core GitHub 仓库](https://github.com/aptos-labs/aptos-core/tree/main/sdk) 中获取。

## 使用 Rust SDK

有关如何使用 Rust SDK 的代码示例，请参阅 [开发者教程](https://aptos.dev/en/build/guides) 。