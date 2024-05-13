---
title: move-std
---

> 参考：
>
> - [支持资源](https://aptos.dev/move/prover/supporting-resources)
> - [查询](https://aptos.dev/reference/move)





# Vector 向量

> 地址：`0x1::vector`
>
> 一个可变大小的容器，可以容纳任何类型。索引是基于0的，向量是可增长的。这个模块有许多本机功能。验证使用这个模块的模块使用直接在Boogie中实现的模型函数。规范语言内置函数操作，如`singleton_vector`。这里也为其他模块中的规范定义了一些辅助功能。
>
> > 注意：我们没有在这里验证大多数移动函数，因为许多函数都有循环，需要循环不变量来证明，对于这些简单的函数来说，投资回报似乎不值得。


## 常量

1. 向量的索引越界了

```rust
const EINDEX_OUT_OF_BOUNDS: u64 = 131072;
```
2. 向量的索引越界了

```rust
const EINVALID_RANGE: u64 = 131073;
```

3. slice中的范围无效。

```rust
const EINVALID_SLICE_RANGE: u64 = 131076;
```


4. range提供的步骤无效，必须大于零。

```rust
const EINVALID_STEP: u64 = 131075;
```

5. 矢量的长度不相等。

```rust
const EVECTORS_LENGTH_MISMATCH: u64 = 131074;
```

## 函数 



1.`empty`：创建一个空的向量

```rust
#[bytecode_instruction]
public fun empty<Element>(): vector<Element>
```

实现

```rust
native public fun empty<Element>(): vector<Element>;
```


2. `length`：返回 vector 的长度。

```rust
#[bytecode_instruction]
public fun length<Element>(v: &vector<Element>): u64
```

实现

```rust
native public fun length<Element>(v: &vector<Element>): u64;
```

3. `borrow`：获取向量 `v` 的第 `i` 个元素的不可变引用。如果 `i` 超出边界，则中止。

```rust
#[bytecode_instruction]
public fun borrow<Element>(v: &vector<Element>, i: u64): &Element
```

实现

```rust
native public fun borrow<Element>(v: &vector<Element>, i: u64): ∈
```

4. `push_back`：在向量v的末尾添加元素e

```rust
#[bytecode_instruction]
public fun push_back<Element>(v: &mut vector<Element>, e: Element)
```

实现

```rust
native public fun push_back<Element>(v: &mut vector<Element>, e: Element);
```

5. `borrow_mut`：返回向量 `v` 中第 `i` 个元素的可变引用。如果 `i` 出界了就中止。

```rust
#[bytecode_instruction]
public fun borrow_mut<Element>(v: &mut vector<Element>, i: u64): &mut Element
```

实现

```rust
native public fun borrow_mut<Element>(v: &mut vector<Element>, i: u64): &mut Element;
```

6. `pop_back`：从矢量 `v` 的末尾弹出一个元素。如果 `v` 为空，则中止。

```rust
#[bytecode_instruction]
public fun pop_back<Element>(v: &mut vector<Element>): Element
```

实现

```rust
native public fun pop_back<Element>(v: &mut vector<Element>): Element;
```

7. `destroy_empty`：销毁向量 `v`。如果 `v` 不为空，则中止。

```rust
#[bytecode_instruction]
public fun destroy_empty<Element>(v: vector<Element>)
```

实现

```rust
native public fun destroy_empty<Element>(v: vector<Element>);
```

8. `swap`：交换向量 `v` 中第 `i` 个和第 `j` 个索引处的元素。如果 `i` 或 `j` 超出边界，则中止。

```rust
#[bytecode_instruction]
public fun swap<Element>(v: &mut vector<Element>, i: u64, j: u64)
```

实现

```rust
native public fun swap<Element>(v: &mut vector<Element>, i: u64, j: u64);
```

9. `singleton`：返回一个包含元素 `e` 的大小为一的向量。


```rust
public fun singleton<Element>(e: Element): vector<Element>
```

实现

```rust
public fun singleton<Element>(e: Element): vector<Element> {
    let v = empty();
    push_back(&mut v, e);
    v
}
```

10. `reverse`：反转向量 `v` 中元素的顺序。

```rust
public fun reverse<Element>(v: &mut vector<Element>)
```

实现

```rust
public fun reverse<Element>(v: &mut vector<Element>) {
    let len = length(v);
    reverse_slice(v, 0, len);
}
```

11. `reverse_slice`：反转向量v中元素[左，右)的顺序。

```rust
public fun reverse_slice<Element>(v: &mut vector<Element>, left: u64, right: u64)
```

实现

```rust
public fun reverse_slice<Element>(v: &mut vector<Element>, left: u64, right: u64) {
    assert!(left <= right, EINVALID_RANGE);
    if (left == right) return;
    right = right - 1;
    while (left < right) {
        swap(v, left, right);
        left = left + 1;
        right = right - 1;
    }
}
```

12. `append`：将 `other` 向量的所有元素推入 `lhs` 向量。

```rust
public fun append<Element>(lhs: &mut vector<Element>, other: vector<Element>)
```

实现

```rust
public fun append<Element>(lhs: &mut vector<Element>, other: vector<Element>) {
    reverse(&mut other);
    reverse_append(lhs, other);
}
```


13. `reverse_append`：将 `other` 向量的所有元素推入 `lhs` 向量。

```rust
public fun reverse_append<Element>(lhs: &mut vector<Element>, other: vector<Element>)
```

实现

```rust
public fun reverse_append<Element>(lhs: &mut vector<Element>, other: vector<Element>) {
    let len = length(&other);
    while (len > 0) {
        push_back(lhs, pop_back(&mut other));
        len = len - 1;
    };
    destroy_empty(other);
}
```

14. `trim`：将向量修剪到较小的大小，并按顺序返回被移除的元素。

```rust
public fun trim<Element>(v: &mut vector<Element>, new_len: u64): vector<Element>
```

实现

```rust
public fun trim<Element>(v: &mut vector<Element>, new_len: u64): vector<Element> {
    let res = trim_reverse(v, new_len);
    reverse(&mut res);
    res
}
```

15. `trim_reverse`：将向量修剪到较小的大小，并按相反的顺序返回被移除的元素。

```rust
public fun trim_reverse<Element>(v: &mut vector<Element>, new_len: u64): vector<Element>
```

实现

```rust
public fun trim_reverse<Element>(v: &mut vector<Element>, new_len: u64): vector<Element> {
    let len = length(v);
    assert!(new_len <= len, EINDEX_OUT_OF_BOUNDS);
    let result = empty();
    while (new_len < len) {
        push_back(&mut result, pop_back(v));
        len = len - 1;
    };
    result
}
```

16. `is_empty`：如果向量 `v` 没有元素，则返回 `true`，否则返回 `false`。

```rust
public fun is_empty<Element>(v: &vector<Element>): bool
```

实现

```rust
public fun is_empty<Element>(v: &vector<Element>): bool {
    length(v) == 0
}
```

17. `contains`：如果 `e` 在向量 `v` 中，则返回 `true`。

```rust
public fun contains<Element>(v: &vector<Element>, e: &Element): bool
```

实现

```rust
public fun contains<Element>(v: &vector<Element>, e: &Element): bool {
    let i = 0;
    let len = length(v);
    while (i < len) {
        if (borrow(v, i) == e) return true;
        i = i + 1;
    };
    false
}
```

18. `index_of`：如果 `e` 在索引 `i` 的向量 `v` 中，则返回 `(true, i)` 否则，返回 `(false, 0)`

```rust
public fun index_of<Element>(v: &vector<Element>, e: &Element): (bool, u64)
```

实现

```rust
public fun index_of<Element>(v: &vector<Element>, e: &Element): (bool, u64) {
    let i = 0;
    let len = length(v);
    while (i < len) {
        if (borrow(v, i) == e) return (true, i);
        i = i + 1;
    };
    (false, 0)
}
```

19. `find`：如果存在与条件匹配的元素，则返回 `(true, i)`。如果有多个与条件匹配的元素，则只返回第一个的索引。否则，返回 `(false, 0)`。

```rust
public fun find<Element>(v: &vector<Element>, f: |&Element|bool): (bool, u64)
```

实现

```rust
public inline fun find<Element>(v: &vector<Element>, f: |&Element|bool): (bool, u64) {
    let find = false;
    let found_index = 0;
    let i = 0;
    let len = length(v);
    while (i < len) {
        // Cannot call return in an inline function so we need to resort to break here.
        if (f(borrow(v, i))) {
            find = true;
            found_index = i;
            break
        };
        i = i + 1;
    };
    (find, found_index)
}
```
功能insert

在位置0 <= i <=长度时插入一个新元素，使用O（长度-i）时间。如果出界，则中止。

public fun insert<Element>(v: &mut vector<Element>, i: u64, e: Element)
实施
功能remove

删除向量v的ith元素，移动所有后续元素。这是O(n)，并保留了向量中元素的顺序。i出界了，就中止。

public fun remove<Element>(v: &mut vector<Element>, i: u64): Element
实施
功能remove_value

删除向量v中给定值的首次出现，并在向量中返回，移动所有后续元素。这是O(n)，并保留了向量中元素的顺序。如果该值不存在于向量中，则返回一个空向量。请注意，这不能返回选项，因为选项使用矢量，并且选项和矢量之间存在循环依赖关系。

public fun remove_value<Element>(v: &mut vector<Element>, val: &Element): vector<Element>
实施
功能swap_remove

将向量v的ith元素与最后一个元素交换，然后弹出向量。这是O（1），但不保留向量中元素的顺序。i出界了，就中止。

public fun swap_remove<Element>(v: &mut vector<Element>, i: u64): Element
实施
功能for_each

将函数应用于向量中的每个元素，消耗它。

public fun for_each<Element>(v: vector<Element>, f: |Element|())
实施
功能for_each_reverse

将函数应用于向量中的每个元素，消耗它。

public fun for_each_reverse<Element>(v: vector<Element>, f: |Element|())
实施
功能for_each_ref

将该函数应用于向量中每个元素的引用。

public fun for_each_ref<Element>(v: &vector<Element>, f: |&Element|())
实施
功能zip

将该函数应用于两个给定向量中的每对元素，消耗它们。

public fun zip<Element1, Element2>(v1: vector<Element1>, v2: vector<Element2>, f: |(Element1, Element2)|())
实施
功能zip_reverse

将该函数以相反顺序应用于两个给定向量中的每对元素，消耗它们。如果向量的长度不相同，则会出现此错误。

public fun zip_reverse<Element1, Element2>(v1: vector<Element1>, v2: vector<Element2>, f: |(Element1, Element2)|())
实施
功能zip_ref

将该函数应用于两个给定向量中每对元素的引用。如果向量的长度不相同，则会出现此错误。

public fun zip_ref<Element1, Element2>(v1: &vector<Element1>, v2: &vector<Element2>, f: |(&Element1, &Element2)|())
实施
功能enumerate_ref

将该函数应用于向量中每个元素及其索引的引用。

public fun enumerate_ref<Element>(v: &vector<Element>, f: |(u64, &Element)|())
实施
功能for_each_mut

将该函数应用于向量中每个元素的可变引用。

public fun for_each_mut<Element>(v: &mut vector<Element>, f: |&mut Element|())
实施
功能zip_mut

将该函数应用于两个给定向量中每对元素的可变引用。如果向量的长度不相同，则会出现此错误。

public fun zip_mut<Element1, Element2>(v1: &mut vector<Element1>, v2: &mut vector<Element2>, f: |(&mut Element1, &mut Element2)|())
实施
功能enumerate_mut

将该函数应用于矢量中每个元素及其索引的可变引用。

public fun enumerate_mut<Element>(v: &mut vector<Element>, f: |(u64, &mut Element)|())
实施
功能fold

将函数折叠在元素上。例如，fold(vector[1,2,3], 0, f)将执行f(f(f(0, 1), 2), 3)

public fun fold<Accumulator, Element>(v: vector<Element>, init: Accumulator, f: |(Accumulator, Element)|Accumulator): Accumulator
实施
功能foldr

向右折叠，就像在上面折叠一样，但从右到左工作。例如，fold(vector[1,2,3], 0, f)将执行f(1, f(2, f(3, 0)))

public fun foldr<Accumulator, Element>(v: vector<Element>, init: Accumulator, f: |(Element, Accumulator)|Accumulator): Accumulator
实施
功能map_ref

将函数映射到矢量元素的引用上，在不修改原始矢量的情况下生成一个新的矢量。

public fun map_ref<Element, NewElement>(v: &vector<Element>, f: |&Element|NewElement): vector<NewElement>
实施
功能zip_map_ref

将函数映射到两个向量的元素对的引用上，从返回值生成一个新的向量，而无需修改原始向量。

public fun zip_map_ref<Element1, Element2, NewElement>(v1: &vector<Element1>, v2: &vector<Element2>, f: |(&Element1, &Element2)|NewElement): vector<NewElement>
实施
功能map

将函数映射到向量的元素上，生成一个新的向量。

public fun map<Element, NewElement>(v: vector<Element>, f: |Element|NewElement): vector<NewElement>
实施
功能zip_map

将函数映射到两个向量的元素对上，生成一个新的向量。

public fun zip_map<Element1, Element2, NewElement>(v1: vector<Element1>, v2: vector<Element2>, f: |(Element1, Element2)|NewElement): vector<NewElement>
实施
功能filter

使用布尔函数过滤向量，删除所有p(e)不为真的元素。

public fun filter<Element: drop>(v: vector<Element>, p: |&Element|bool): vector<Element>
实施
功能partition

分区，对所有pred忠实于前面的元素进行排序。保留pred为真元素的相对顺序，但不保留pred为假的元素的相对顺序。

public fun partition<Element>(v: &mut vector<Element>, pred: |&Element|bool): u64
实施
功能rotate

rotate(&mut [1, 2, 3, 4, 5], 2) -> [3, 4, 5, 1, 2] 到位，返回上例中的分裂点，即3

public fun rotate<Element>(v: &mut vector<Element>, rot: u64): u64
实施
功能rotate_slice

与上述相同，但在数组[左，右）的子片上，左<= rot <= 右返回

public fun rotate_slice<Element>(v: &mut vector<Element>, left: u64, rot: u64, right: u64): u64
实施
功能stable_partition

根据谓词p对数组进行分区，此例程是稳定的，因此保留了两个分区中元素的相对顺序。

public fun stable_partition<Element>(v: &mut vector<Element>, p: |&Element|bool): u64
实施
功能any

如果向量中的任何元素满足谓词，则返回true。

public fun any<Element>(v: &vector<Element>, p: |&Element|bool): bool
实施
功能all

如果向量中的所有元素都满足谓词，则返回true。

public fun all<Element>(v: &vector<Element>, p: |&Element|bool): bool
实施
功能destroy

销毁一个向量，只是在销毁矢量的上下文中使用时，围绕for_each_reverse的包装器，带有描述性名称。

public fun destroy<Element>(v: vector<Element>, d: |Element|())
实施
功能range

public fun range(start: u64, end: u64): vector<u64>
实施
功能range_with_step

public fun range_with_step(start: u64, end: u64, step: u64): vector<u64>
实施
功能slice

public fun slice<Element: copy>(v: &vector<Element>, start: u64, end: u64): vector<Element>
实施
技术规格

助手功能

检查v1是否等于在末尾添加e的结果v2

fun eq_push_back<Element>(v1: vector<Element>, v2: vector<Element>, e: Element): bool {
    len(v1) == len(v2) + 1 &&
    v1[len(v1)-1] == e &&
    v1[0..len(v1)-1] == v2[0..len(v2)]
}
检查v是否等于连接v1的结果，并且v2

fun eq_append<Element>(v: vector<Element>, v1: vector<Element>, v2: vector<Element>): bool {
    len(v) == len(v1) + len(v2) &&
    v[0..len(v1)] == v1 &&
    v[len(v1)..len(v)] == v2
}
检查v1等于删除第一个元素的结果v2

fun eq_pop_front<Element>(v1: vector<Element>, v2: vector<Element>): bool {
    len(v1) + 1 == len(v2) &&
    v1 == v2[1..len(v2)]
}
检查v1是否等于从v2中删除索引i的元素的结果。

fun eq_remove_elem_at_index<Element>(i: u64, v1: vector<Element>, v2: vector<Element>): bool {
    len(v1) + 1 == len(v2) &&
    v1[0..i] == v2[0..i] &&
    v1[i..len(v1)] == v2[i + 1..len(v2)]
}
检查v是否包含e。

fun spec_contains<Element>(v: vector<Element>, e: Element): bool {
    exists x in v: x == e
}
功能singleton

public fun singleton<Element>(e: Element): vector<Element>
aborts_if false;
ensures result == vec(e);
功能reverse

public fun reverse<Element>(v: &mut vector<Element>)
pragma intrinsic = true;
功能reverse_slice

public fun reverse_slice<Element>(v: &mut vector<Element>, left: u64, right: u64)
pragma intrinsic = true;
功能append

public fun append<Element>(lhs: &mut vector<Element>, other: vector<Element>)
pragma intrinsic = true;
功能reverse_append

public fun reverse_append<Element>(lhs: &mut vector<Element>, other: vector<Element>)
pragma intrinsic = true;
功能trim

public fun trim<Element>(v: &mut vector<Element>, new_len: u64): vector<Element>
pragma intrinsic = true;
功能trim_reverse

public fun trim_reverse<Element>(v: &mut vector<Element>, new_len: u64): vector<Element>
pragma intrinsic = true;
功能is_empty

public fun is_empty<Element>(v: &vector<Element>): bool
pragma intrinsic = true;
功能contains

public fun contains<Element>(v: &vector<Element>, e: &Element): bool
pragma intrinsic = true;
功能index_of

public fun index_of<Element>(v: &vector<Element>, e: &Element): (bool, u64)
pragma intrinsic = true;
功能insert

public fun insert<Element>(v: &mut vector<Element>, i: u64, e: Element)
pragma intrinsic = true;
功能remove

public fun remove<Element>(v: &mut vector<Element>, i: u64): Element
pragma intrinsic = true;
功能remove_value

public fun remove_value<Element>(v: &mut vector<Element>, val: &Element): vector<Element>
pragma intrinsic = true;
功能swap_remove

public fun swap_remove<Element>(v: &mut vector<Element>, i: u64): Element
pragma intrinsic = true;
功能rotate

public fun rotate<Element>(v: &mut vector<Element>, rot: u64): u64
pragma intrinsic = true;
功能rotate_slice

public fun rotate_slice<Element>(v: &mut vector<Element>, left: u64, rot: u64, right: u64): u64
pragma intrinsic = true;