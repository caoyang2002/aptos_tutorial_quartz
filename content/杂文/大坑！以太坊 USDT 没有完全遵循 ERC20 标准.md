---
title: 大坑！以太坊 USDT 没有完全遵循 ERC20 标准
---
```yaml
original: https://learnblockchain.cn/article/506
author: Ashton 
  home: https://learnblockchain.cn/people/29
update: 2018-11-23 15:30
copyright: Ashton 
```
## 0x00 起因

公司有个业务，需要用户将 ERC20 版的 USDT 转入一个合约，然后满足一定条件时通过该合约将转入的 USDT 转回给用户。

ropsten 测试网上测试，一切正常。合约审查，完全没问题。

顺利主网上线！

测试用户将 USDT 转入合约，满足条件后等待合约将 USDT 转回。问题出现了，转入的 USDT 竟然转不出来了，转不出来了！

## 0x01 初步分析

将 USDT 换为其它 ERC20 代币，转入，设置条件，转出，完全正常。

尝试通过合约转出一部分 USDT，失败。

尝试通过钱包从个人账户转入转出 USDT，成功。

新部署一个如下所示简单的合约，就做转出 USDT 一件事，失败。

```sol
pragma solidity ^0.4.25;

import "./ERC20.sol";

contract TransDemo {
    ERC20 public erc20;
    address public owner;

    constructor(address _addr) public {
        erc20 = ERC20(_addr);
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    function transferUSDT(uint _amount) public onlyOwner {
        erc20.transfer(owner, _amount);
    }
}
```

基本确定，问题和 Tether 的合约实现有关，并且问题只存在于通过合约转账。

## 0x03 深入分析

通过 [https://etherscan.io/address/0xdac17f958d2ee523a2206206994597c13d831ec7#code](https://etherscan.io/address/0xdac17f958d2ee523a2206206994597c13d831ec7#code) 将 USDT 的合约代码拔下来，放到 remix 里在内置虚拟机里部署一份。

将 TransDemo 也部署一份。

转账给 TransDemo。

调用 TransDemo 的 transferUSDT 方法，交易失败。

![](https://img.learnblockchain.cn/2020/02/05_/804290895.png)

Remix 失败交易

纳尼？！ 居然将对 ERC20 的 transfer 方法调用，当成了内置的 address.transfer 这个调用。

看了一下 USDT 合约对 transfer 方法的具体实现， **居然没有返回值，没有返回值啊尼玛** 。代码里还装模作样的整了两个 return 语句，实际上这两个 return 后面的方法调用都是没有定义返回结果的，否则编译器会报错，不可能部署成功。

```sol
   function transfer(address _to, uint _value) public whenNotPaused {
        require(!isBlackListed[msg.sender]);
        if (deprecated) {
            return UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
        } else {
            return super.transfer(_to, _value);
        }
    }


```

而 ERC20 的标准是怎样的呢，仔细看看下面 ERC20 标准接口的 transfer 方法，都是有返回值定义的， `returns (bool);`

```sol
interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}
```

尝试把 TransDemo 中引用的 ERC20 接口中 transfer 方法中的返回值定义去掉。

重新打币，测试，毫无阻碍，完美通过！

## 0x04 解决方案

1. 针对 USDT 单独处理，使用经调整过的和 USDT 具体实现相吻合的合约接口。
2. 针对非 USDT 的 ERC20 合约，仍然使用标准的 ERC20 接口。
3. 支持任何非自家 ERC20 代币，均需验证一下其具体实现，将主网上公开的代码实现部署到本地环境和测试网进行测试。

## 0x05 结论

测试用户转进合约里的 USDT 怎么办？取不回来了啊，所有转出操作都失效 :(  
如果你有什么独门秘籍取出锁定在合约里的 USDT，定重谢！