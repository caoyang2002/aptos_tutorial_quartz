---
title: 附录：集成 Aptos 钱包适配器
---
# 1. 为什么选择 Aptos 钱包适配器

## Aptos 钱包适配器的目的：

- 简化钱包与 dapp 的集成。
- 为开发者提供一个单体仓库，以简化在 Aptos 网络上的开发。
- 作为 dapp 与钱包之间的桥梁，通过标准化的 API 促进交互。
- 通过利用 Aptos 钱包适配器，dapp 可以轻松支持多个钱包，同时遵循公认的标准，提高钱包的可见性，并确保无缝的用户体验。

## Aptos 钱包适配器的特点：

- 易于实现：无需为多个钱包编写代码。
- 支持各种钱包 API。
- 包含钱包原生不具备的附加功能。
- 检测未安装的钱包。
- 自动连接功能和状态保留。
- 具备监听钱包事件（如账户和网络更改）的能力。
- 由 Aptos 生态系统团队维护的参考实现。


# AIP-62 钱包标准

AIP-62 钱包标准是一套链无关的接口和约定，旨在改善应用程序与注入钱包的交互方式。在此处了解更多。

## 为什么要与 AIP-62 钱包标准集成？

在不久的将来，随着钱包采用新标准，钱包适配器将弃用旧标准，仅保留对 AIP-62 钱包标准的支持。

[AIP-62 钱包标准](https://github.com/aptos-foundation/AIPs/blob/main/aips/aip-62.md)消除了当前 dapp 存在的问题：

- 在 dapp 在钱包之前加载且 dapp 不知道新钱包的情况下，dapp 的检测过程逻辑可能会造成竞争条件风险
- 旧标准深度集成在 Aptos 钱包适配器中，任何更改都可能导致 dApp 和钱包的破坏性更改，要求 dApp 或钱包实施这些更改会产生无休止的维护工作。
- 旧标准仅支持旧的 TS SDK 输入、类型和逻辑。这意味着它无法享受新 TS SDK 的功能和增强。此外，旧的 TS SDK 不再获得任何支持或新功能。

此外，AIP-62 中描述的新钱包标准为 dApp 带来了许多好处：

- 钱包适配器处理钱包包的维护和安装，而不是 dApp，这可以防止潜在的供应链攻击
- 新的适配器版本提供了更好的验证和错误处理支持
- 新的适配器版本使用新的 TS SDK，它更可靠、快速，并且正在积极维护和更新新功能（旧的 sdk，即 npm i aptos，不再积极维护和开发）



# 如何集成

### 安装

目前，适配器为您支持一个用于包含在您的应用中的 React 提供者。

安装 React 提供者：

```bash
npm install @aptos-labs/wallet-adapter-react
```

最新版本的钱包适配器通过解析支持两种标准的钱包来支持 AIP-62 钱包标准集成。

由于 AIP-62 钱包标准在 dapp 和钱包之间使用事件通信，dapp 不需要安装、维护和传递给钱包适配器多个钱包插件（包）。此外，对于任何与 AIP-62 钱包标准兼容的钱包，钱包适配器将默认检测到该钱包。

### 导入依赖项

在 `App.jsx` 文件中：

导入 AptosWalletAdapterProvider：

```ts
import { AptosWalletAdapterProvider } from "@aptos-labs/wallet-adapter-react";
```

用提供者包裹您的应用，将您希望在应用中拥有的插件（钱包）作为数组传递给它，并包含一个 autoConnect 选项（默认设置为 false）：

```ts
<AptosWalletAdapterProvider autoConnect={true}>
  <App />
</AptosWalletAdapterProvider>
```

为了也支持以前的标准，dapp 应该向 React 提供者提供一个钱包数组。这样，适配器将解析两种钱包标准，并为最终用户提供 dapp 已安装的钱包和与 AIP-62 钱包标准兼容的钱包。

```ts
const wallets = [new SomeAptosWallet()];
<AptosWalletAdapterProvider plugins={wallets} autoConnect={true}>
  <App />
</AptosWalletAdapterProvider>;
```



# 如何使用

在您想要使用钱包属性的任何页面，从 `@aptos-labs/wallet-adapter-react` 导入 `useWallet`：

在演示中，我们展示了如何通过导入钱包连接的状态来实现钱包按钮

```ts
import { useWallet } from "@aptos-labs/wallet-adapter-react";
export const WalletButtons = () => {
  const { wallets, connected, disconnect, isLoading } = useWallet();
  if (connected) {
    return (
      <div className="flex flex-row">
        <div className={cn(buttonStyles, "hover:bg-blue-700 btn-small")} onClick={disconnect}>
          Disconnect
        </div>
      </div>
    );
  }
  if (isLoading ||!wallets[0]) {
    return <div className={cn(buttonStyles, "opacity-50 cursor-not-allowed")}>Loading...</div>;
  }
  return <WalletView wallet={wallets[0]} />;
};
```

还进行交易。在 Aptogotchi 演示中，我们与钱包交互以增加动物的健康点数。

```ts
const { account, network, signAndSubmitTransaction } = useWallet();
const response = await signAndSubmitTransaction({
  sender: account.address,
  data: {
    function: `${NEXT_PUBLIC_CONTRACT_ADDRESS}::main::feed`,
    typeArguments: [],
    functionArguments: [NEXT_PUBLIC_ENERGY_INCREASE],
  },
});
await aptosClient.waitForTransaction({ transactionHash: response.hash });
setPet((pet) => {
  if (!pet) return pet;
  if (pet.energy_points + Number(NEXT_PUBLIC_ENERGY_INCREASE) > Number(NEXT_PUBLIC_ENERGY_CAP))
    return pet;
  return {
   ...pet,
    energy_points: pet.energy_points + Number(NEXT_PUBLIC_ENERGY_INCREASE),
  };
});
```

然后您可以使用导出的属性：

```ts
const {
  connect,
  account,
  network,
  connected,
  disconnect,
  wallet,
  wallets,
  signAndSubmitTransaction,
  signTransaction,
  signMessage,
} = useWallet();
```

最后，使用包的 README 文件中的 [示例](https://github.com/aptos-labs/aptos-wallet-adapter/tree/main/packages/wallet-adapter-react#examples) 在您的 dapp 中构建更多功能。


# 为何采用 AIP-62 钱包标准

AIP-62 中描述的新钱包标准为钱包带来了许多好处：

- 钱包拥有并控制自己的接口，可以轻松更新并提供新功能，而不会给 dapp 造成任何破坏性更改
- 钱包集成代码位于钱包代码库中，不需要钱包创建和维护另一个钱包包
- 钱包不需要依赖 dapp 来安装和维护其钱包包
- AIP-62 钱包标准提供了更好的验证和错误处理支持，并使用新的 TS SDK，它更可靠、快速，并积极维护和开发新功能（旧的 sdk，即 aptos，不再积极维护和开发）。

>[!NOTE] 注意
>在不久的将来，随着钱包采用新标准，钱包适配器将弃用旧标准，仅保留对 AIP-62 钱包标准的支持。




# 如何集成

Aptos 提供了 `@aptos-labs/wallet-standard` 包，其中包括钱包的标准接口和类实现。此外，它还提供了用于识别与 Aptos 兼容的钱包的实用函数。

在您的钱包中实现 AIP-62 钱包标准主要有三个步骤。

### AptosWallet 接口实现

钱包必须使用钱包提供者信息和功能实现 AptosWallet 接口：

```ts
export default class MyWallet implements AptosWallet {
  // 区域：AptosWallet
  readonly name = 'MyWallet';
  readonly version = '1.0.0';
  readonly icon = 'y_icon';
  readonly url = 'y_url';
  readonly chains = APTOS_CHAINS;
  get accounts() {
    return this.activeAccount? [new MyAccount(this.activeAccount)] : [];
  }
  get features(): AptosFeatures {
    return {
      [AptosConnectNamespace]: {
        connect: this.connect.bind(this),
        version: '1.0.0',
      },
      [AptosDisconnectNamespace]: {
        disconnect: this.disconnect.bind(this),
        version: '1.0.0',
      },
      [AptosGetAccountNamespace]: {
        account: this.getAccount.bind(this),
        version: '1.0.0',
      },
      [AptosGetNetworkNamespace]: {
        network: this.getNetwork.bind(this),
        version: '1.0.0',
      },
      [AptosOnAccountChangeNamespace]: {
        onAccountChange: this.onAccountChange.bind(this),
        version: '1.0.0',
      },
      [AptosOnNetworkChangeNamespace]: {
        onNetworkChange: this.onNetworkChange.bind(this),
        version: '1.0.0',
      },
      [AptosSignMessageNamespace]: {
        signMessage: this.signMessage.bind(this),
        version: '1.0.0',
      },
      [AptosSignTransactionNamespace]: {
        signTransaction: this.signTransaction.bind(this),
        version: '1.0.0',
      },
    };
  }
  // 结束区域
  // MyWallet
  private activeAccount: AccountInfo | undefined = undefined;
  private readonly client: MyClient;
  constructor() {
    const transport = new MyApiWindowTransport(window);
    this.client = new MyApiClient(transport);
    // 初始化账户
    void this.client.isConnected().then(async (isConnected) => {
      if (isConnected) {
        const account = await this.client.getAccount();
        this.activeAccount = myAccountToAccountInfo(account);
      }
    });
  }
```

### AptosWalletAccount 接口实现

钱包必须实现一个 AptosWalletAccount 接口，该接口表示已被 dapp 授权的账户。

```ts
export default class MyAccount implements AptosWalletAccount {
  // 区域：AptosWalletAccount
  readonly chains = APTOS_CHAINS;
  get address() {
    return this.#address.toString();
  }
  get publicKey() {
    return this.#publicKey.toUint8Array();
  }
  get signingScheme() {
    if (this.#publicKey instanceof Ed25519PublicKey) {
      return SigningScheme.Ed25519;
    }
    if (this.#publicKey instanceof MultiEd25519PublicKey) {
      return SigningScheme.MultiEd25519;
    }
    if (this.#publicKey instanceof AnyPublicKey) {
      return SigningScheme.SingleKey;
    }
    if (this.#publicKey instanceof MultiKey) {
      return SigningScheme.MultiKey;
    }
    throw new Error("Unsupported public key type");
  }
  readonly label?: string;
  readonly features = [];
  // 结束区域
  // 区域：MyAccount
  readonly #address: AccountAddress;
  readonly #publicKey: PublicKey;
  constructor({ address, ansName, publicKey }: AccountInfo) {
    this.#publicKey = publicKey;
    this.#address = address;
    this.label = ansName;
  }
  // 结束区域
}
```

这些是钱包应支持并在此处实现的必需功能。

```ts
const REQUIRED_FEATURES: (keyof MinimallyRequiredFeatures)[] = [
  "aptos:account",
  "aptos:connect",
  "aptos:disconnect",
  "aptos:network",
  "aptos:onAccountChange",
  "aptos:onNetworkChange",
  "aptos:signMessage",
  "aptos:signTransaction",
];
```

### 注册钱包

**Web 扩展钱包** 钱包使用 registerWallet 方法注册自身，以通知 dapp 它已准备好被注册。

```ts
import { registerWallet } from "@aptos-labs/wallet-standard";
const myWallet = new MyWallet();
registerWallet(myWallet);
```

您可以查看钱包适配器存储库以获取完整的 [示例](https://github.com/aptos-labs/aptos-wallet-adapter/blob/main/apps/nextjs-example/utils/standardWallet.ts)