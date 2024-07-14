路由守卫

react


# 快速创建一个 Dapp
```tsx
pnpx create-aptos-dapp
cd my-aptos-dapp
npm run dev
```


# 安装 aptos SDK
```bash
pnpm add @aptos-labs/ts-sdk
```

# 使用 aptos connect

```tsx
pnpm add @aptos-labs/wallet-adapter-react
```

```tsx
import { AptosWalletAdapterProvider } from "@aptos-labs/wallet-adapter-react";

const wallets = [new AnyOtherWalletYouWantToInclude()];
<AptosWalletAdapterProvider
plugins={wallets}
autoConnect={true}
optInWallets={["Petra"]}
dappConfig={{ network: network.MAINNET, aptosConnectDappId: "dapp-id" }}>
  <App >
</AptosWalletAdapterProvider>
```



----
# 创建 Next.js 项目

```tsx
npx create-next-app@latest
cd project-name
npx run dev
```


---
# 创建 React 项目

```bahs
npx create-react-app my-app
cd my-app
npm start
```




# 网络
```tsx
import { Network } from "@aptos-labs/ts-sdk";
```

# 账户相关的组件

## Adapter

```bash
npm i @aptos-labs/wallet-adapter-react
```

```tsx
import { AptosWalletAdapterProvider } from "@aptos-labs/wallet-adapter-react";  // aptos 的钱包适配器 react 组件
```

```tsx
root.render(
  <React.StrictMode>
    <AptosWalletAdapterProvider plugins={wallets} autoConnect={true}>
  		<App />
	</AptosWalletAdapterProvider>
  </React.StrictMode>
);
```

## Selector
https://github.com/aptos-labs/aptos-wallet-adapter/tree/main/packages/wallet-adapter-ant-design
```bash
npm install @aptos-labs/wallet-adapter-ant-design
```

引入
```tsx
import { WalletSelector } from "@aptos-labs/wallet-adapter-ant-design";
```

```tsx
return(
	<Col span={12} style={{ textAlign: "right", paddingRight: "200px" }}>
	  <WalletSelector />
	</Col>
)
```
# petra

```bash
npm i petra-plugin-wallet-adapter
```

引入

```tsx
import { PetraWallet } from "petra-plugin-wallet-adapter";  // petra 钱包适配器插件
```

添加钱包数组
```tsx
const wallets = [new PetraWallet()];
```

```tsx
const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);
root.render(
  <React.StrictMode>
    <AptosWalletAdapterProvider plugins={wallets} autoConnect={true}>
  		<App />
	</AptosWalletAdapterProvider>
  </React.StrictMode>
);
```