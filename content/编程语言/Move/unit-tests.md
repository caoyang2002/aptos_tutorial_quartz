# 单元测试

Move的单元测试为Move源语言添加了三个新的注释：

- `#[test]`
- `#[test_only]`，和
- `#[expected_failure]`。

他们分别将函数标记为测试，将模块或模块成员（`use`、函数或结构）标记为仅用于测试的代码，并标记测试预计会失败。这些注释可以放置在具有任何可见性的函数上。每当模块或模块成员被注释为`#[test_only]`或`#[test]`时，除非为测试而编译，否则它不会包含在编译的字节码中。

## 测试注释：它们的含义和用法[](https://aptos.guide/en/build/smart-contracts/book/unit-testing#testing-annotations-their-meaning-and-usage)

`#[test]`和`#[expected_failure]`注释都可以带参数或不带参数使用。

如果没有参数，`#[test]`注释只能放置在没有参数的函数上。此注释只是将此功能标记为由单元测试线束运行的测试。

```rust
module 0x42::example {
  #[test] // OK
  fun this_is_a_test() { /* ... */ }
 
  #[test] // Will fail to compile since the test takes an argument
  fun this_is_not_correct(arg: signer) { /* ... */ }
}
```

### 预期失败[](https://aptos.guide/en/build/smart-contracts/book/unit-testing#expected-failure)

测试也可以注释为`#[expected_failure]`。此注释标记测试应该引起错误。

您可以通过用`#[expected_failure(abort_code = <code>)]`注释来确保测试使用特定的中止`<code>`中止，对应于`abort`语句的参数（或失败`assert!`宏）。

`expected_failure`可能会指定程序执行错误，例如asarithmetic`arithmetic_error`、`major_status`、`vector_error`和`out_of_gas`而不是`abort_code`。为了更具体，可以选择指定 `minor_status`。

如果预计错误来自特定位置，也可以指定：`#[expected_failure(abort_code = <code>, location = <loc>)]`。如果测试以正确的错误失败，但在另一个模块中，测试也会失败。请注意，`<loc>`可以是`Self`（在当前模块中）或合格的名称，例如`vector::std`。

只有具有`#[test]`注释的函数才能注释为#`[expected_failure]`。

```rust
module 0x42::example {
  #[test]
  #[expected_failure]
  public fun this_test_will_abort_and_pass() { abort 1 }
 
  #[test]
  #[expected_failure]
  public fun test_will_error_and_pass() { 1/0; }
 
  #[test]
  #[expected_failure(abort_code = 0, location = Self)]
  public fun test_will_error_and_fail() { 1/0; }
 
  #[test, expected_failure] // Can have multiple in one attribute. This test will pass.
  public fun this_other_test_will_abort_and_pass() { abort 1 }
 
  #[test]
  #[expected_failure(vector_error, minor_status = 1, location = Self)]
  fun borrow_out_of_range() { /* ... */ }
  #[test]
  #[expected_failure(abort_code = 26113, location = extensions::table)]
  fun test_destroy_fails() { /* ... */ }
}
```

### 测试参数[](https://aptos.guide/en/build/smart-contracts/book/unit-testing#test-parameters)

使用参数，测试注释的形式为`#[test(<param_name_1> = <address>, ..., <param_name_n> = <address>)]`。如果函数以这种方式注释，函数的参数必须是参数`<param_name_1>, ..., <param_name_n>`的排列，即这些参数在函数中出现的顺序和它们在测试注释中的顺序不必相同，但它们必须能够通过名称相互匹配。

仅支持具有`signer`类型的参数作为测试参数。如果提供了`signer`以外的参数，测试在运行时将导致错误。

```rust
module 0x42::example {
  #[test(arg = @0xC0FFEE)] // OK
  fun this_is_correct_now(arg: signer) { /* ... */ }
 
  #[test(wrong_arg_name = @0xC0FFEE)] // Not correct: arg name doesn't match
  fun this_is_incorrect(arg: signer) { /* ... */ }
 
  #[test(a = @0xC0FFEE, b = @0xCAFE)] // OK. We support multiple signer arguments, but you must always provide a value for that argument
  fun this_works(a: signer, b: signer) { /* ... */ }
 
  // somewhere a named address is declared
  #[test_only] // test-only named addresses are supported
  address TEST_NAMED_ADDR = @0x1;
  ...
  #[test(arg = @TEST_NAMED_ADDR)] // Named addresses are supported!
  fun this_is_correct_now(arg: signer) { /* ... */ }
}
```

### 支持测试的任意代码[](https://aptos.guide/en/build/smart-contracts/book/unit-testing#arbitrary-code-to-support-tests)

模块及其任何成员只能声明为测试。在这种情况下，只有在测试模式下编译时，该项目才会包含在编译的移动字节码中。此外，当在测试模式之外编译时，`#[test_only]`模块的任何非测试使用都会在编译过程中引发错误。

```rust
#[test_only] // test only attributes can be attached to modules
module 0x42::abc { /*... */ }
 
module 0x42::other {
  #[test_only] // test only attributes can be attached to named addresses
  address ADDR = @0x1;
 
  #[test_only] // .. to uses
  use 0x1::some_other_module;
 
  #[test_only] // .. to structs
  struct SomeStruct { /* ... */ }
 
  #[test_only] // .. and functions. Can only be called from test code, but not a test
  fun test_only_function(/* ... */) { /* ... */ }
}
```

## 运行单元测试[](https://aptos.guide/en/build/smart-contracts/book/unit-testing#running-unit-tests)

移动包的单元测试可以使用`aptos move test`命令运行。有关更多信息，请参阅[软件包](https://aptos.guide/en/build/smart-contracts/book/packages)。

运行测试时，每个测试都会`PASS`、`FAIL`或`TIMEOUT`。如果测试用例失败，如果可能的话，将报告故障位置以及导致故障的函数名。你可以在下面看到一个例子。

如果测试超过任何单个测试可以执行的最大指令数量，它将被标记为超时。此绑定可以使用以下选项进行更改，其默认值设置为100000指令。此外，虽然测试结果始终是确定性的，但测试默认情况下是并行运行的，因此除非仅使用一个线程运行，否则测试结果的顺序是非确定性的（请参阅下面的`OPTIONS`）。

还有一些选项可以传递给单元测试二进制文件，以微调测试并帮助调试失败的测试。这些可以使用帮助标志找到：

终端

```bash
aptos move test -h
```

## 示例：[](https://aptos.guide/en/build/smart-contracts/book/unit-testing#example)

以下示例显示了使用一些单元测试功能的简单模块：

首先在空目录中创建一个空包：

终端

```bash
aptos move init --name TestExample
```

接下来，将以下内容添加到`Move.toml`中：

```toml
[dependencies]
MoveStdlib = { git = "https://github.com/aptos-labs/aptos-core.git", subdir="aptos-move/framework/move-stdlib", rev = "main", addr_subst = { "std" = "0x1" } }
```

接下来在`sources`目录下添加以下模块：

```rust
// filename: sources/my_module.move
module 0x1::my_module {
 
  struct MyCoin has key { value: u64 }
 
  public fun make_sure_non_zero_coin(coin: MyCoin): MyCoin {
    assert!(coin.value > 0, 0);
    coin
  }
 
  public fun has_coin(addr: address): bool {
    exists<MyCoin>(addr)
  }
 
  #[test]
  fun make_sure_non_zero_coin_passes() {
    let coin = MyCoin { value: 1 };
    let MyCoin { value: _ } = make_sure_non_zero_coin(coin);
  }
 
  #[test]
  // Or #[expected_failure] if we don't care about the abort code
  #[expected_failure(abort_code = 0, location = Self)]
  fun make_sure_zero_coin_fails() {
    let coin = MyCoin { value: 0 };
    let MyCoin { value: _ } = make_sure_non_zero_coin(coin);
  }
 
  #[test_only] // test only helper function
  fun publish_coin(account: &signer) {
    move_to(account, MyCoin { value: 1 })
  }
 
  #[test(a = @0x1, b = @0x2)]
  fun test_has_coin(a: signer, b: signer) {
    publish_coin(&a);
    publish_coin(&b);
    assert!(has_coin(@0x1), 0);
    assert!(has_coin(@0x2), 1);
    assert!(!has_coin(@0x3), 1);
  }
}
```

### 运行测试[](https://aptos.guide/en/build/smart-contracts/book/unit-testing#running-tests)

然后，您可以使用`aptos move test`命令运行这些测试：

终端

```bash
$ aptos move test
BUILDING MoveStdlib
BUILDING TestExample
Running Move unit tests
[ PASS    ] 0x1::my_module::make_sure_non_zero_coin_passes
[ PASS    ] 0x1::my_module::make_sure_zero_coin_fails
[ PASS    ] 0x1::my_module::test_has_coin
Test result: OK. Total tests: 3; passed: 3; failed: 0
```

### 使用测试标志[](https://aptos.guide/en/build/smart-contracts/book/unit-testing#using-test-flags)

#### `-f <str>`或`--filter <str>`[](https://aptos.guide/en/build/smart-contracts/book/unit-testing#-f-str-or---filter-str)

这只会运行完全限定名称包含`<str>`的测试。例如，如果我们只想用他们的名字中的`"zero_coin"`运行测试：

终端

```bash
$ aptos move test -f zero_coin
CACHED MoveStdlib
BUILDING TestExample
Running Move unit tests
[ PASS    ] 0x1::my_module::make_sure_non_zero_coin_passes
[ PASS    ] 0x1::my_module::make_sure_zero_coin_fails
Test result: OK. Total tests: 2; passed: 2; failed: 0
```

#### `--coverage`[](https://aptos.guide/en/build/smart-contracts/book/unit-testing#--coverage)

这将计算测试用例所涵盖的代码，并生成覆盖范围摘要。

终端

```bash
$ aptos move test --coverage
INCLUDING DEPENDENCY AptosFramework
INCLUDING DEPENDENCY AptosStdlib
INCLUDING DEPENDENCY MoveStdlib
BUILDING TestExample
Running Move unit tests
[ PASS    ] 0x1::my_module::make_sure_non_zero_coin_passes
[ PASS    ] 0x1::my_module::make_sure_zero_coin_fails
[ PASS    ] 0x1::my_module::test_has_coin
Test result: OK. Total tests: 3; passed: 3; failed: 0
+-------------------------+
| Move Coverage Summary   |
+-------------------------+
Module 0000000000000000000000000000000000000000000000000000000000000001::my_module
>>> % Module coverage: 100.00
+-------------------------+
| % Move Coverage: 100.00  |
+-------------------------+
Please use `aptos move coverage -h` for more detailed source or bytecode test coverage of this package
```

然后，通过运行`aptos move coverage`，我们可以获得更详细的覆盖信息。这些可以使用帮助标志找到：

终端

```bash
$ aptos move coverage -h
```