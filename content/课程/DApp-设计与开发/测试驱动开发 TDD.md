---
title: 测试驱动开发 TDD
---
> 传统的软件开发模式： 小步快跑、快速迭代
> - 需求分析：在没想清楚需求细节的情况下直接上手代码
> - 开发过程中不断和产品经理确认细节，终于写完所有逻辑
> - 运行起来测试一下，发现好多问题
> - 产品交给测试 / QA，并被测出 Bug，继续修改
> - 初步达到上线发布标准
> - 有新需求：不敢动、继续手工测试、该 Bug
>
> 问题：（屎山代码）
>
> - 前人留下的一堆特别乱的代码
> - 



> 区块链软件开发模式：测试驱动开发
>
> - 测试驱动开发（Test Driven Development）是一种不同于传统软件开发流程的心方法。它要求在编写某个功能的代码之前线编写测试代码，然后只编写能使测试通过的功能代码，通过测试来推动整个开发的进行。这有助于编写简洁可用和高质量的代码，并加速开发过程。
>
> 流程：
>
> 1. 写一个一定会失败的测试代码
> 2. 针对测试写代码，使测试代码能够成功运行
> 3. 重构代码，使其干净整洁。
>
> ```mermaid
> graph LR
>     A[开始] --> B[编写测试用例]
>     B --> C{如期失败?}
>     C -->|是| D[编写功能代码]
>     C -->|否| B
>     D --> E{测试通过？}
>     E -->|是| F[重构代码]
>     E -->|否| B
>     F --> G{代码整洁?}
>     G -->|是| H[结束]
>     G -->|否| F
> ```
>
> 好处：
>
> - 降低开发者负担
> - 保护网
> - 提前澄清需求
> - 快速反馈
> - 容易更改，容易添加新需求
> 
> 实施测试驱动开发的要点
>
> 1. 分析问题并拆分问题：把问题分解成一个个可以操作的任务
> 
> 2. 代码设计：规划、设计功能、实现



> 测试查看是否如期失败（❌ 红）
>
> 写代码让它通过这个测试（✅ 绿）
>
> 重构代码（Ⓜ️ 蓝）



# 案例演示

信箱软件



## 功能设计

1. 可以查看总共有多少邮件
2. 当新的邮件到来时，总邮件数 + 1
3. 存储信件内容，并可查看
4. 存储信件发送人，并可查看

## 编写项目

创建并初始化 `hardhat`

### 测试邮箱合约

1. 编写代码测试合约是否存在

```js title="test/Mailbox.test.js"
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Mailbox", async () => {
  it("should get mailbox contract", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
  });
});
```

2. 测试查看是否如期失败（❌ 红）

```bash
npx hardhat test
```

> 如期失败
>
> ```bash
> caoyang@cccy hardhat_project % npx hardhat test
> 
> 
>   Mailbox
>     1) should get mailbox contract
> 
> 
>   0 passing (25ms)
>   1 failing
> 
>   1) Mailbox
>        should get mailbox contract:
>      HardhatError: HH700: Artifact for contract "Mailbox" not found. 
>       at Artifacts._handleWrongArtifactForContractName (/Users/caoyang/Desktop/GitHub/liangpeili-dapp-develop-course/hardhat_project/node_modules/hardhat/src/internal/artifacts.ts:721:11)
>       at Artifacts._getArtifactPathFromFiles (/Users/caoyang/Desktop/GitHub/liangpeili-dapp-develop-course/hardhat_project/node_modules/hardhat/src/internal/artifacts.ts:852:19)
>       at Artifacts._getArtifactPath (/Users/caoyang/Desktop/GitHub/liangpeili-dapp-develop-course/hardhat_project/node_modules/hardhat/src/internal/artifacts.ts:516:21)
>       at Artifacts.readArtifact (/Users/caoyang/Desktop/GitHub/liangpeili-dapp-develop-course/hardhat_project/node_modules/hardhat/src/internal/artifacts.ts:71:26)
>       at getContractFactory (/Users/caoyang/Desktop/GitHub/liangpeili-dapp-develop-course/hardhat_project/node_modules/@nomicfoundation/hardhat-ethers/src/internal/helpers.ts:107:22)
>       at Context.<anonymous> (/Users/caoyang/Desktop/GitHub/liangpeili-dapp-develop-course/hardhat_project/test/Mailbox.test.js:6:29)
> ```
>
> 



3. 写代码让它通过这个测试（✅ 绿）

```solidity title="contracts/Mailbox.sol"
pragma solidity ^0.8.0;

contract Mailbox {}

```

> 能够通过测试即可
>
> ```bash
> caoyang@cccy hardhat_project % npx hardhat test
> Warning: SPDX license identifier not provided in source file. Before publishing, consider adding a comment containing "SPDX-License-Identifier: <SPDX-License>" to each source file. Use "SPDX-License-Identifier: UNLICENSED" for non-open-source code. Please see https://spdx.org for more information.
> --> contracts/Mailbox.sol
> 
> 
> Compiled 1 Solidity file successfully (evm target: paris).
> 
> 
>   Mailbox
>     ✔ should get mailbox contract (1461ms)
> 
> 
>   1 passing (1s)
> ```





### 查看邮箱中的信件数量

> [!TIP]
>
> 可以查看信箱的信件数，也就是需要一个属性

1. 编写代码查看信箱信件数量

```js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Mailbox", async () => {
  it("should get mailbox contract", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
  });
  it("should get total letters in the box", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
    const mailbox = await mailboxContract.deploy(); // 部署合约
    expect(await mailbox.totalLetters()).to.equal(0); // 查看信件数量
  });
});

```



2. 测试查看是否如期失败（❌ 红）

```bash
npx hardhat test
```

> 如期失败
>
> ```bash
> caoyang@cccy hardhat_project % npx hardhat test
> 
> 
>   Mailbox
>     ✔ should get mailbox contract (1407ms)
>     1) should get total letters in the box
> 
> 
>   1 passing (2s)
>   1 failing
> 
>   1) Mailbox
>        should get total letters in the box:
>      TypeError: mailbox.totalLetters is not a function
>       at Context.<anonymous> (test/Mailbox.test.js:11:26)
> ```
>
> 

3. 写代码让它通过这个测试（✅ 绿）

```solidity
pragma solidity ^0.8.0;

contract Mailbox {
    uint public totalLetters;
}
```

> ```bash
> npx hardhat test
> ```
>
> 测试通过
>
> ```bash
> caoyang@cccy hardhat_project % npx hardhat test
> Warning: SPDX license identifier not provided in source file. Before publishing, consider adding a comment containing "SPDX-License-Identifier: <SPDX-License>" to each source file. Use "SPDX-License-Identifier: UNLICENSED" for non-open-source code. Please see https://spdx.org for more information.
> --> contracts/Mailbox.sol
> 
> 
> Compiled 1 Solidity file successfully (evm target: paris).
> 
> 
>   Mailbox
>     ✔ should get mailbox contract (919ms)
>     ✔ should get total letters in the box (47ms)
> 
> 
>   2 passing (970ms)
> ```
>
> 



### 当收到新的信件的时候，邮箱里的信件数量 + 1

1. 编写代码查看信箱信件数量

```js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Mailbox", async () => {
  it("should get mailbox contract", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
  });
  it("should get total letters in the box", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
    const mailbox = await mailboxContract.deploy(); // 部署合约
    expect(await mailbox.totalLetters()).to.equal(0); // 查看信件数量
  });
  it("should increase by one when  get new letter", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
    const mailbox = await mailboxContract.deploy(); // 部署合约
    await mailbox.write("Hello"); // 别人写了一封邮件给自己
    expect(await mailbox.totalLetters()).to.equal(1); // 查看信件数量是否增加了
  });
});

```

2. 测试代码是否如期失败（❌ 红）

```bash
npx hardhat test
```

> 如期失败
>
> ```bash
> caoyang@cccy hardhat_project % npx hardhat test
> 
> 
>   Mailbox
>     ✔ should get mailbox contract (845ms)
>     ✔ should get total letters in the box (58ms)
>     1) should increase by one when  get new letter
> 
> 
>   2 passing (936ms)
>   1 failing
> 
>   1) Mailbox
>        should increase by one when  get new letter:
>      TypeError: mailbox.write is not a function
>       at Context.<anonymous> (test/Mailbox.test.js:16:19)
> ```
>
> 

3. 编写代码让他通过测试（✅ 绿）

```solidity
pragma solidity ^0.8.0;

contract Mailbox {
    uint public totalLetters;
    function write(string memory letter) public {
        totalLetters++;
    }
}
```


> ```bash
> npx hardhat test
> ```
>
> 测试通过
>
> ```bash
> caoyang@cccy hardhat_project % npx hardhat test
> Warning: SPDX license identifier not provided in source file. Before publishing, consider adding a comment containing "SPDX-License-Identifier: <SPDX-License>" to each source file. Use "SPDX-License-Identifier: UNLICENSED" for non-open-source code. Please see https://spdx.org for more information.
> --> contracts/Mailbox.sol
> 
> 
> Warning: Unused function parameter. Remove or comment out the variable name to silence this warning.
> --> contracts/Mailbox.sol:5:20:
> |
> 5 |     function write(string memory letter) public {
> |                    ^^^^^^^^^^^^^^^^^^^^
> 
> 
> Compiled 1 Solidity file successfully (evm target: paris).
> 
> 
> Mailbox
>  ✔ should get mailbox contract (775ms)
>  ✔ should get total letters in the box (60ms)
>  ✔ should increase by one when  get new letter
> 
> 
> 3 passing (862ms)
> ```
>
> 





### 查看信件的内容

1. 编写测试代码，测试将如期失败（❌ 红）

```js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Mailbox", async () => {
  it("should get mailbox contract", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
  });
  it("should get total letters in the box", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
    const mailbox = await mailboxContract.deploy(); // 部署合约
    expect(await mailbox.totalLetters()).to.equal(0); // 查看信件数量
  });
  it("should increase by one when  get new letter", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
    const mailbox = await mailboxContract.deploy(); // 部署合约
    await mailbox.write("Hello"); // 别人写了一封邮件给自己
    expect(await mailbox.totalLetters()).to.equal(1); // 查看信件数量是否增加了
  });

  it("should get mail contents", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
    const mailbox = await mailboxContract.deploy(); // 部署合约

    await mailbox.write("Hello"); // 别人写了一封邮件给自己
    const letters = await mailbox.read(); // 获取所有信件
    expect(await letters[0][0]).to.equal("Hello"); // 查看信件内容
  });
});

```

> ```bash
> npx hardhat test
> ```
>
> 如期失败
>
> ```bash
> caoyang@cccy hardhat_project % npx hardhat test
> 
> 
>   Mailbox
>     ✔ should get mailbox contract (1392ms)
>     ✔ should get total letters in the box (87ms)
>     ✔ should increase by one when  get new letter
>     1) should get mail contents
> 
> 
>   3 passing (2s)
>   1 failing
> 
>   1) Mailbox
>        should get mail contents:
>      TypeError: mailbox.allLetters is not a function
>       at Context.<anonymous> (test/Mailbox.test.js:25:35)
> ```
>
> 



2. 编写合约代码，让测试能够通过（✅ 绿）

```solidity
pragma solidity ^0.8.0;

contract Mailbox {
    uint public totalLetters;

    function write(string memory letter) public {
        totalLetters++;
        
        
        letters.push(Letter(letter, msg.sender));
    }

    struct Letter {
        string letter;
        address sender;
    }
    Letter[] private letters;
    function read() public view returns (Letter[] memory) {
        return letters;
    }
}

```

> 测试合约
>
> ```bash
> npx hardhat test
> ```
>
> ```bash
> caoyang@cccy hardhat_project % npx hardhat test
> 
> 
>   Mailbox
>     ✔ should get mailbox contract (900ms)
>     ✔ should get total letters in the box (58ms)
>     ✔ should increase by one when  get new letter (47ms)
>     ✔ should get mail contents
> 
> 
>   4 passing (1s)
> ```
>
> 



### 获取合约地址的发送人

1. 编写测试代码，并如期失败

```js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Mailbox", async () => {
  it("should get mailbox contract", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
  });
  it("should get total letters in the box", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
    const mailbox = await mailboxContract.deploy(); // 部署合约
    expect(await mailbox.totalLetters()).to.equal(0); // 查看信件数量
  });
  it("should increase by one when  get new letter", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
    const mailbox = await mailboxContract.deploy(); // 部署合约
    await mailbox.write("Hello"); // 别人写了一封邮件给自己
    expect(await mailbox.totalLetters()).to.equal(1); // 查看信件数量是否增加了
  });

  it("should get mail contents", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
    const mailbox = await mailboxContract.deploy(); // 部署合约

    await mailbox.write("Hello"); // 别人写了一封邮件给自己
    const letters = await mailbox.read(); // 获取所有信件
    expect(await letters[0][0]).to.equal("Hello"); // 查看信件内容
  });

  // ===================================================================
  it("should get mail sender", async () => {
    const mailboxContract = await ethers.getContractFactory("Mailbox");
    const mailbox = await mailboxContract.deploy(); // 部署合约

    await mailbox.write("Hello"); // 别人写了一封邮件给自己
    const letters = await mailbox.read(); // 获取所有信件
    expect(await letters[0][0]).to.equal("Hello"); // 查看信件内容
  });
});

```

因为之前已经写了地址的配置，所以没有报错

```solidity
  function write(string memory letter) public {
        totalLetters++;
        
   
        letters.push(Letter(letter, msg.sender)); // 将地址放入信件中
    }

    struct Letter {
        string letter;
        address sender;  // 发送者地址
    }
```



```bash
caoyang@cccy hardhat_project % npx hardhat test


  Mailbox
    ✔ should get mailbox contract (838ms)
    ✔ should get total letters in the box (90ms)
    ✔ should increase by one when  get new letter (45ms)
    ✔ should get mail contents
    ✔ should get mail sender
```





> [!NOTE]
>
> 由于这个合约很简单，所以没有重构，但是如果合约复杂，功能多的话，就必须要重构，并再次测试所有案例





测试查看是否如期失败（❌ 红）

写代码让它通过这个测试（✅ 绿）

重构代码（Ⓜ️ 蓝）
