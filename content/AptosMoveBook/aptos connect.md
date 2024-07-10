---
title: aptos connect
---
[文档链接](https://aptosconnect.app/docs/)

# Aptos 无密钥钱包 Aptos Connect 的特点与集成实操

# 为什么我要向我的用户提供 Aptos Connect？

Aptos Connect 是一个网络托管的区块链钱包，提供 Aptos 无密钥账户。

Aptos Connect 可以通过以下方式实现更快的用户增长、提高产品粘性/使用率和增强用户保护...... 

1. 简化的注册过程 - 用户只需通过其社交账户登录即可获得一个自我托管的区块链账户。 

2. 无需下载 - 用户无需离开您的 dApp 即可获得钱包。创建账户和签署交易都通过应用网站上的弹出提示完成。 

3. 可互操作的账户 - 用户可以在 Aptos 生态系统中任何支持 Aptos Connect 的地方使用其账户桌面和移动设备上无缝的跨设备体验 - 桌面和移动设备的用户体验相同。 

4. 无需密钥管理 - Connect 不会要求用户管理任何私钥，保护用户免受自身失误影响。若用户被锁定，还为其提供熟悉的 Web2 社交恢复功能。

Aptos Connect 还为用户提供了一个链接其他类型账户的家园。用户可以注册他们在 Aptos 生态系统中拥有的其他私钥账户，以将账户访问权限整合在一个社交登录下。


## Aptos Connect 可以免费使用吗？

是的！Aptos Connect 对开发者和用户都是免费使用的。

## Aptos Connect 是否适用于多签交易？

是的。有关如何构多签助交易的示例，请参阅[Aptos 开发者文档（在新标签页中打开）](https://aptos.dev/guides/sponsored-transactions)。

## 从 Aptos Connect 通过无密钥账户发送的交易与通过私钥账户发送的交易有什么区别？

无密钥账户使用不同的签名方案，并且在链上需要不同的验证过程。因此，无密钥交易比源自私钥账户的交易成本更高。然而，由于 Aptos 的可扩展性，即使是无密钥交易，gas 费用仍然非常低。

## 用户在 Aptos Connect 和支持无密钥账户的另一个生态系统钱包中可以拥有相同的地址吗？

不可以，Aptos 无密钥的地址推导是特定于域的。因此，每个应用程序中用户的地址都是唯一的。

## Aptos Connect 有移动应用程序版本吗？

不，目前只有基于浏览器的版本。然而，Aptos Connect 是移动兼容的，因为应用程序和 Connect 之间的所有交互都是通过浏览器弹出窗口处理的。

## Aptos Connect 安全吗？

您的 Aptos Connect 账户仅通过 Aptos Connect 处理交易，其他应用程序无法直接访问。使用无密钥，Aptos Connect 服务器无法访问您的账户，您完全拥有您的账户，所有私人信息都存储在本地。Aptos Connect 已经过内部和外部安全审计。

## 在使用 Aptos Connect 时，我应该确保向我的用户说明什么？

在 Aptos Connect 中创建的无密钥账户由用于登录的账户控制（例如，如果选择“使用 Google 登录”，则是 Google 账户）。如果您的用户失去对该账户的访问权限，他们将无法再访问与 Aptos Connect 相关的区块链账户。为了保持安全性，我们建议您建议他们为其社交登录账户添加备份选项并启用 2FA。

## 我的用户将使用他们的社交登录账户登录。Aptos Connect 如何保护他们的数据？

Aptos Connect 遵守 PII 的所有数据保护要求。此外，Aptos Connect 使用的 Aptos 无密钥零知识技术确保用户的用户名不会泄露所有链上活动，保持链上隐私。


  


# 错误

当向 Aptos Connect 发出请求时，您可能会收到错误。以下是部分可能的错误及其相应代码的列表：

## 代码：4100

- **名称**：未经授权
- **消息**：请求方法和/或账户未被用户授权。

## 代码：4001

- **名称**：用户拒绝
- **消息**：用户拒绝了该请求。


注意：一旦发送交易，Aptos Connect 将返回交易详情。dApp 需要解析交易是成功还是失败。


# 前置准备


# 快速入门

在您的 dApp 中使用 Aptos Connect

与 Aptos Connect 进行交互的最简单方式是通过[Aptos Wallet Adapter（在新标签页中打开）](https://github.com/aptos-labs/aptos-wallet-adapter/tree/main/packages/wallet-adapter-react)。我们的 Aptos Wallet Adapter 提供了将钱包集成到您的 dApp 的标准化方法。如果您的 dApp 已经支持 Aptos Wallet Adapter，请跳转到在 Aptos Wallet Adapter 中添加对 Aptos Connect 的支持。

**安装 Aptos Wallet Adapter**

```bash
pnpm add @aptos-labs/wallet-adapter-react
```

AptosConnect 会自动添加到包中，所以无需将其作为插件添加。如果您想显示其他钱包，可以将它们包含在插件中。

```tsx
import { AptosWalletAdapterProvider } from "@aptos-labs/wallet-adapter-react";   
const wallets = [new AnyOtherWalletYouWantToInclude()];  
<AptosWalletAdapterProvider    
	plugins={wallets}    
	autoConnect={true}    
	optInWallets={["Petra"]}    
	dappConfig={
		{ 
			network: network.MAINNET, aptosConnectDappId: "dapp-id" 
		}
	}>      
	<App >  
</AptosWalletAdapterProvider>
```

**发送交易**

```ts
const { signAndSubmitTransaction } = useWallet(); 
const transaction: InputTransactionData = {  
	data: {    
		function: '0x1::coin::transfer',    
		typeArguments: [APTOS_COIN],    
		functionArguments: [account.address, 1],  
	},
}; 
const txn = await signAndSubmitTransaction(transaction);
```

一旦您的 dApp 支持钱包适配器，向您的 dApp 和用户公开 Aptos Connect 就像添加 Aptos Connect 包一样简单。要将 Aptos Connect 添加到您的应用程序，请遵循以下步骤。

在 Aptos Wallet Adapter 中添加对 Aptos Connect 的支持 将 Aptos Connect 插件添加到您的 Aptos Wallet Adapter

```bash
pnpm add @aptos-connect/wallet-adapter-plugin
```

然后，实例化并将 AptosConnect 钱包适配器插件添加到您的插件列表中，如钱包适配器文档中所示

```ts
const aptosConnectPlugin = new AptosConnectWalletAdapterPlugin();
const wallets = [  
	aptosConnectPlugin,  //...
];
```

注意：如果您之前实现了 Identity Connect，请使用此命令删除 identity connect 包。

```bash
pnpm remove @identity-connect/wallet-adapter-plugin
```

## 为 Aptos Connect 添加 UI 支持

如果您使用 Aptos 的钱包适配器 UI 包，则运行此命令更新钱包适配器 UI：

```bash
pnpm update @aptos-labs/wallet-adapter-react
```

如果您想开始使用 Aptos 钱包适配器 UI 包，请运行此命令

```bash
pnpm install @aptos-labs/wallet-adapter-react
```

如果您想继续使用您自己的自定义 UI，那么您只需像我们在钱包适配器 UI 中所做的那样添加一个“Continue with Google”按钮。我们还建议在您的已连接钱包 UI 中添加一个指向 aptosconnect.app 的链接，以便用户可以轻松打开一个新标签页到他们的钱包。这是必要的，因为用户没有扩展或应用程序来打开查看他们的账户
















----
```bash
npm init && npm add -D typescript @types/node ts-node && npx tsc --init && mkdir src && echo 'async function example() { console.log("Running example!")}; example()' > src/quickstart.ts
```


```bash
npx ts-node src/quickstart.ts
```



```bash
pnpm add @aptos-labs/ts-sdk
```




