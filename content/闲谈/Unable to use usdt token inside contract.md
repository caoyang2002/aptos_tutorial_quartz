---
title: Unable to use usdt token inside contract
---
```yaml
original: https://ethereum.stackexchange.com/questions/144368/unable-to-use-usdt-token-inside-contract

update: "2023-03-21"
```

I have a contract that works with usdt. It creates an IERC20 object of the contract address that we pass to it in constructor, but the contract is working abnormally when I try to call usdt.transferFrom function. Here's the whole error trace (hardhat testing).

Here's the function that is causing this error



```solidity
function deposit(uint256 depositAmount) external {
    if (isDiscounted) {
        usdt.transferFrom(msg.sender, address(this), depositAmount.mul(9).div(10));        
    }
    else {
        usdt.transferFrom(msg.sender, address(this), depositAmount);
    }
    _deposit(msg.sender, depositAmount);
    uint256 contractBalance = usdt.balanceOf(address(this));
    if (contractBalance >= maxContractBalance) {
        maxContractBalance = contractBalance;
        
        if (isFrozen) {
            isFrozen = false;
        }
    }
    emit Deposit(msg.sender, depositAmount);
}
```

```bash
    EVENT TetherToken.Approval(owner=0xd5b7517b5aDE4CD7d90DBdb612379C771e0592FF, spender=0x59b670e9fA9D0A427751Af201D676719a970857b, value=2000000000)
CALL TetherToken.approve(_spender=0x59b670e9fA9D0A427751Af201D676719a970857b, _value=2000000000)
   EVENT TetherToken.Approval(owner=0x8eE57D6Aa734663b91f06246a478F41beC8E78Ee, spender=0x59b670e9fA9D0A427751Af201D676719a970857b, value=2000000000)
CALL TetherToken.approve(_spender=0x59b670e9fA9D0A427751Af201D676719a970857b, _value=2000000000)
   EVENT TetherToken.Approval(owner=0x2315843F9fC72ce897D83984274676304FCfdc11, spender=0x59b670e9fA9D0A427751Af201D676719a970857b, value=2000000000)
CALL TetherToken.approve(_spender=0x59b670e9fA9D0A427751Af201D676719a970857b, _value=2000000000)
   EVENT TetherToken.Approval(owner=0xf5506aBcE02b5BcFF90f007E1c4E3D5b2512FB55, spender=0x59b670e9fA9D0A427751Af201D676719a970857b, value=2000000000)
CALL TetherToken.approve(_spender=0x59b670e9fA9D0A427751Af201D676719a970857b, _value=2000000000)
   EVENT TetherToken.Approval(owner=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, spender=0x59b670e9fA9D0A427751Af201D676719a970857b, value=2000000000)
CALL TwoXWorld.register(referral=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
   EVENT TwoXWorld.Register(user=0x30178B75fBa2267De822b61d9026b6e9EafCC181, referral=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
CALL TwoXWorld.deposit(depositAmount=100000000)
   CALL TetherToken.transferFrom(_from=0x30178B75fBa2267De822b61d9026b6e9EafCC181, _to=0x59b670e9fA9D0A427751Af201D676719a970857b, _value=90000000)
      EVENT TetherToken.Transfer(from=0x30178B75fBa2267De822b61d9026b6e9EafCC181, to=0x59b670e9fA9D0A427751Af201D676719a970857b, value=90000000)
   REVERT UnknownError(0x)

      1) Should allow users to make deposits


  0 passing (6s)
  1 failing

  1) 2xWorld
       Deposit
         Should allow users to make deposits:
     Error: Transaction reverted without a reason string
      at <UnrecognizedContract>.<unknown> (0x59b670e9fa9d0a427751af201d676719a970857b)
      at processTicksAndRejections (node:internal/process/task_queues:95:5)
      at runNextTicks (node:internal/process/task_queues:64:3)
      at listOnTimeout (node:internal/timers:533:9)
      at processTimers (node:internal/timers:507:7)
      at async HardhatNode._mineBlockWithPendingTxs (node_modules\hardhat\src\internal\hardhat-network\provider\node.ts:1815:23)
      at async HardhatNode.mineBlock (node_modules\hardhat\src\internal\hardhat-network\provider\node.ts:504:16)
      at async EthModule._sendTransactionAndReturnHash (node_modules\hardhat\src\internal\hardhat-network\provider\modules\eth.ts:1522:18)
```
