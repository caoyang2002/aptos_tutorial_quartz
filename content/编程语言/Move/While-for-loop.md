# While、For和Loop

Move提供了三种循环结构：`while`、`for`和`loop`。

## `while`循环[](https://aptos.guide/en/build/smart-contracts/book/loops#while-loops)

`while`构造重复主体（类型单位的表达式），直到条件（typebool的表达式）求值为`false`。

以下是计算从`1`到`n`的数字之和的简单`while`循环示例：

```rust
script {
  fun sum(n: u64): u64 {
    let sum = 0;
    let i = 1;
    while (i <= n) {
      sum = sum + i;
      i = i + 1
    };
 
    sum
  }
}
```

允许无限循环：

```rust
script {
  fun foo() {
    while (true) { }
  }
}
```

### `break`[](https://aptos.guide/en/build/smart-contracts/book/loops#break)

在条件评估为`false`之前，可以使用`break`表达式退出循环。例如，这个循环使用`break`来找到`n`大于1的最小因子：

```
script {
  fun smallest_factor(n: u64): u64 {
    // assuming the input is not 0 or 1
    let i = 2;
    while (i <= n) {
      if (n % i == 0) break;
      i = i + 1
    };
 
    i
  }
}
```

`break`表达式不能在循环之外使用。

### `continue`[](https://aptos.guide/en/build/smart-contracts/book/loops#continue)

`continue`表达式跳过循环的其余部分，并继续进行下一次迭代。这个循环使用`continue`计算`1, 2, ..., n`的总和，除非数字能被10整除：

```rust
script {
  fun sum_intermediate(n: u64): u64 {
    let sum = 0;
    let i = 0;
    while (i < n) {
      i = i + 1;
      if (i % 10 == 0) continue;
      sum = sum + i;
    };
 
    sum
  }
}
```

`continue`表达式不能在循环之外使用。

### `break`的类型和`continue`[](https://aptos.guide/en/build/smart-contracts/book/loops#the-type-of-break-and-continue)

`break`并`continue`，就像`return`和`abort`一样，可以有任何类型。以下示例说明了这种灵活的打字在哪些地方会有帮助：

```rust
script {
  fun pop_smallest_while_not_equal(
    v1: vector<u64>,
    v2: vector<u64>,
  ): vector<u64> {
    let result = vector::empty();
    while (!vector::is_empty(&v1) && !vector::is_empty(&v2)) {
      let u1 = *vector::borrow(&v1, vector::length(&v1) - 1);
      let u2 = *vector::borrow(&v2, vector::length(&v2) - 1);
      let popped =
        if (u1 < u2) vector::pop_back(&mut v1)
        else if (u2 < u1) vector::pop_back(&mut v2)
        else break; // Here, `break` has type `u64`
      vector::push_back(&mut result, popped);
    };
 
    result
  }
}
```

```rust
script {
  fun pick(
    indexes: vector<u64>,
    v1: &vector<address>,
    v2: &vector<address>
  ): vector<address> {
    let len1 = vector::length(v1);
    let len2 = vector::length(v2);
    let result = vector::empty();
    while (!vector::is_empty(&indexes)) {
      let index = vector::pop_back(&mut indexes);
      let chosen_vector =
        if (index < len1) v1
        else if (index < len2) v2
        else continue; // Here, `continue` has type `&vector<address>`
      vector::push_back(&mut result, *vector::borrow(chosen_vector, index))
    };
 
    result
  }
}
```

## 表达`for`[](https://aptos.guide/en/build/smart-contracts/book/loops#the-for-expression)

`for`表达式在使用整数类型`lower_bound`（包括）和`upper_bound`（非包括）表达式定义的范围内迭代，为范围的每个元素执行其循环主体。`for`专为循环迭代次数由特定范围决定的场景而设计。

以下是计算`0`到`n-1`范围内元素之和的`for`循环示例：

```rust
script {
  fun sum(n: u64): u64 {
    let sum = 0;
    for (i in 0..n) {
      sum = sum + i;
    };
 
    sum
  }
}
```

循环重现变量（上述示例中的`i`）目前必须是数字类型（从边界推断），这里的边界`0`和`n`可以被任意数字表达式替换。每个在循环开始时只评估一次。迭代器变量`i`被分配为`lower_bound`（在本例中为`0`），并在每次循环迭代后递增；当迭代器`i`达到或超过`upper_bound`（在本例中为`n`）时，循环退出。

### `break`并`continue`循环[](https://aptos.guide/en/build/smart-contracts/book/loops#break-and-continue-in-for-loops)

与`while`循环类似，`break`表达式可用于`for`循环过早退出。`continue`表达式可用于跳过当前迭代并移动到下一个迭代。这里有一个例子，演示了`break`和`continue`的使用。循环将从`0`到`n-1`遍默数字，并将它们汇总起来。它将跳过可被`3`整除的数字（使用`continue`），并在遇到大于`10`的数字时停止（使用`break`）：

```rust
script {
  fun sum_conditional(n: u64): u64 {
    let sum = 0;
    for (iter in 0..n) {
      if (iter > 10) {
        break; // Exit the loop if the number is greater than 10
      };
      if (iter % 3 == 0) {
        continue; // Skip the current iteration if the number is divisible by 3
      };
 
      sum = sum + iter;
    };
 
    sum
  }
}
```

## `loop`表达式[](https://aptos.guide/en/build/smart-contracts/book/loops#the-loop-expression)

`loop`表达式重复循环主体（类型为`()`的表达式），直到它击中`break`

没有`break`，循环将永远持续下去

```
script {
  fun foo() {
    let i = 0;
    loop { i = i + 1 }
  }
}
 
```

以下是一个使用`loop`写求和函数的示例：

```
script {
  fun sum(n: u64): u64 {
    let sum = 0;
    let i = 0;
    loop {
      i = i + 1;
      if (i > n) break;
      sum = sum + i
    };
 
    sum
  }
}
```

正如您所期望的那样，`continue`也可以在`loop`内使用。这是上面的`sum_intermediate`，使用`loop`而不是`while`

```rust
script {
  fun sum_intermediate(n: u64): u64 {
    let sum = 0;
    let i = 0;
    loop {
      i = i + 1;
      if (i % 10 == 0) continue;
      if (i > n) break;
      sum = sum + i
    };
 
    sum
  }
}
```

## `while`、`loop`和`for`表达式的类型[](https://aptos.guide/en/build/smart-contracts/book/loops#the-type-of-while-loop-and-for-expression)

移动循环是类型表达式。`while`和`for`表达式总是有类型`()`

```rust
script {
  fun example() {
    let () = while (i < 10) { i = i + 1 };
    let () = for (i in 0..10) {};
  }
}
```

如果`loop`包含`break`，则表达式具有类型单元`()`

```rust
script {
  fun example() {
    (loop { if (i < 10) i = i + 1 else break }: ());
    let () = loop { if (i < 10) i = i + 1 else break };
  }
}
```

如果`loop`没有`break`，`loop`可以有任何类型，就像`return`、`abort`、`break`和`continue`。

```rust
script {
  fun example() {
    (loop (): u64);
    (loop (): address);
    (loop (): &vector<vector<u8>>);
  }
}
```