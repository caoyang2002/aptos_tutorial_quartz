---
title: Harhat 的基本使用
---
[快速上手](https://hardhat.org/hardhat-runner/docs/getting-started#quick-start)

# 本地开发

安装 hardhat

```bash
yarn add --dev hardhat
```

初始化

```bash
npx hardhat init
```

> 会初始化一个锁仓合约，平台币会被锁定到合约里，只能到特定的时间后的才能被所有者取出。

运行任务

```bash
npx hardhat
```

编译

```bash
npx hardhat compile
```
会生成编译后的目录 `artifacts` 和 `cache`，其中， `abi` 在 `artifacts/contracts/合约名称.json` 里
```bash
"abi": [] # 提供了一个合约对外交互的接口
```

测试

```bash
npx hardhat test
```

> 智能合约
> hardhat 提供了一种 “打印” 内部状态的方法：`console.sol`
> `import "hardhat/console.sol"
> `console.log()`

部署到本地

`ignition/modules/合约名称.js`

```bash
npx hardhat run ignition/modules/合约名称.js
```

部署到了本地的虚拟机，可以通过 `npx hardhat node` 查看虚拟机状态，逐页查看 `npx hardhat node | more`

>[!NOTE]
> remix 也可以使用这个虚拟机
> 在 `ENVIRONMENT` 里面选择 `Dev - Hardhat Provider`

部署到测试网

更改 `hardhat.config.js`
```js title="hardhat.config.js"
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
};
```

改为

```js
module.exports = {
  solidity: "0.8.24",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    testnet: {
      url: "https://exchaintestrpc.okex.org",
      chainId: 65,
      gasPrice: 3000000000,
      accounts: [process.env.PRIVATE_KET],
    },
  },
};
```

部署 

```bash
npx hardhat run ignition/modules/合约名称.js --network testnet
```

