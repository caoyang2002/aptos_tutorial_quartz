> 实现的功能

- `google` 和 `apple` 登陆
- 获取链上数据
- 用户界面
# 安装包

```bash
pnpm add @aptos-labs/ts-sdk
```

# 导入包
```bash
import { Account, Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";
 ```


```
// Specify which network to connect to via AptosConfig
async function example() {
  console.log(
    "This example will create two accounts (Alice and Bob), fund them, and transfer between them.",
  );
 
  // Setup the client
  const config = new AptosConfig({ network: Network.TESTNET });
  const aptos = new Aptos(config);
}
 
example()
```


# 获取链上数据

```ts
const ledgerInfo = await aptos.getLedgerInfo();
const modules = await aptos.getAccountModules({ accountAddress: "0x123" });
const tokens = await aptos.getAccountOwnedTokens({ accountAddress: "0x123" });
```