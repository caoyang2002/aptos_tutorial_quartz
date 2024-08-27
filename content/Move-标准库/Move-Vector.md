---
title: Move-stdlib-Vector
---

> 参考：
>
> - [支持资源](https://aptos.dev/move/prover/supporting-resources)
> - [查询](https://aptos.dev/reference/move)

[toc]

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

### 1.`empty`

创建一个空的向量

```rust
#[bytecode_instruction]
public fun empty<Element>(): vector<Element>
```

实现

```rust
native public fun empty<Element>(): vector<Element>;
```


### 2. `length`

返回 vector 的长度。

```rust
#[bytecode_instruction]
public fun length<Element>(v: &vector<Element>): u64
```

实现

```rust
native public fun length<Element>(v: &vector<Element>): u64;
```

### 3. `borrow`

获取向量 `v` 的第 `i` 个元素的不可变引用。如果 `i` 超出边界，则中止。

```rust
#[bytecode_instruction]
public fun borrow<Element>(v: &vector<Element>, i: u64): &Element
```

实现

```rust
native public fun borrow<Element>(v: &vector<Element>, i: u64): ∈
```

### 4. `push_back`

在向量 `v` 的末尾添加元素 `e`

```rust
#[bytecode_instruction]
public fun push_back<Element>(v: &mut vector<Element>, e: Element)
```

实现

```rust
native public fun push_back<Element>(v: &mut vector<Element>, e: Element);
```

### 5. `borrow_mut`：返回向量 `v` 中第 `i` 个元素的可变引用。如果 `i` 出界了就中止。

```rust
#[bytecode_instruction]
public fun borrow_mut<Element>(v: &mut vector<Element>, i: u64): &mut Element
```

实现

```rust
native public fun borrow_mut<Element>(v: &mut vector<Element>, i: u64): &mut Element;
```

### 6. `pop_back`：从矢量 `v` 的末尾弹出一个元素。如果 `v` 为空，则中止。

```rust
#[bytecode_instruction]
public fun pop_back<Element>(v: &mut vector<Element>): Element
```

实现

```rust
native public fun pop_back<Element>(v: &mut vector<Element>): Element;
```

### 7. `destroy_empty`：销毁向量 `v`。如果 `v` 不为空，则中止。

```rust
#[bytecode_instruction]
public fun destroy_empty<Element>(v: vector<Element>)
```

实现

```rust
native public fun destroy_empty<Element>(v: vector<Element>);
```

### 8. `swap`：交换向量 `v` 中第 `i` 个和第 `j` 个索引处的元素。如果 `i` 或 `j` 超出边界，则中止。

```rust
#[bytecode_instruction]
public fun swap<Element>(v: &mut vector<Element>, i: u64, j: u64)
```

实现

```rust
native public fun swap<Element>(v: &mut vector<Element>, i: u64, j: u64);
```

### 9. `singleton`：返回一个包含元素 `e` 的大小为一的向量。


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

### 10. `reverse`：反转向量 `v` 中元素的顺序。

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

### 11. `reverse_slice`：反转向量v中元素[左，右)的顺序。

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

### 12. `append`：将 `other` 向量的所有元素推入 `lhs` 向量。

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


### 13. `reverse_append`：将 `other` 向量的所有元素推入 `lhs` 向量。

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

### 14. `trim`：将向量修剪到较小的大小，并按顺序返回被移除的元素。

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

### 15. `trim_reverse`：将向量修剪到较小的大小，并按相反的顺序返回被移除的元素。

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

### 16. `is_empty`：如果向量 `v` 没有元素，则返回 `true`，否则返回 `false`。

```rust
public fun is_empty<Element>(v: &vector<Element>): bool
```

实现

```rust
public fun is_empty<Element>(v: &vector<Element>): bool {
    length(v) == 0
}
```

### 17. `contains`：如果 `e` 在向量 `v` 中，则返回 `true`。

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

### 18. `index_of`：如果 `e` 在索引 `i` 的向量 `v` 中，则返回 `(true, i)` 否则，返回 `(false, 0)`

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

### 19. `find`：如果存在与条件匹配的元素，则返回 `(true, i)`。如果有多个与条件匹配的元素，则只返回第一个的索引。否则，返回 `(false, 0)`。

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
### 20. `insert`：在位置 $0 <= i <= length$ 处插入一个新元素，时间复杂度为 $O(length - i)$。如果越界则中止。

```rust
public fun insert<Element>(v: &mut vector<Element>, i: u64, e: Element)
```

实现

```rust
public fun insert<Element>(v: &mut vector<Element>, i: u64, e: Element) {
    let len = length(v);
    assert!(i <= len, EINDEX_OUT_OF_BOUNDS);
    push_back(v, e);
    while (i < len) {
        swap(v, i, len);
        i = i + 1;
    };
}
```


### 21. `remove`：移除向量 `v` 的第 `i` 个元素，将所有后续元素向前移动。这是 $O(n)$ 的操作，并保持向量中元素的顺序。如果 `i` 越界则中止。

```rust
public fun remove<Element>(v: &mut vector<Element>, i: u64): Element
```

实现

```rust
public fun remove<Element>(v: &mut vector<Element>, i: u64): Element {
    let len = length(v);
    // i out of bounds; abort
    if (i >= len) abort EINDEX_OUT_OF_BOUNDS;

    len = len - 1;
    while (i < len) swap(v, i, { i = i + 1; i });
    pop_back(v)
}
```


### 22. `remove_value`

从向量 `v` 中移除给定值的第一个出现，并将其返回为一个新的向量，同时将所有后续元素向前移动。这是$ O(n)$ 的操作，并保持向量中元素的顺序。如果值在向量中不存在，则返回一个空向量。请注意，这不能返回一个选项，因为选项使用向量，这将导致选项和向量之间出现循环依赖。

```rust
public fun remove_value<Element>(v: &mut vector<Element>, val: &Element): vector<Element>
```

实现

```rust
public fun remove_value<Element>(v: &mut vector<Element>, val: &Element): vector<Element> {
    // This doesn't cost a O(2N) run time as index_of scans from left to right and stops when the element is found,
    // while remove would continue from the identified index to the end of the vector.
    let (found, index) = index_of(v, val);
    if (found) {
        vector[remove(v, index)]
    } else {
       vector[]
    }
}
```

## 23. `swap_remove`
交换向量 `v` 的第 `i` 个元素与最后一个元素，然后弹出向量。这是 $O(1)$ 的操作，但不保持向量中元素的顺序。如果 `i` 越界则中止。

```rust
public fun swap_remove<Element>(v: &mut vector<Element>, i: u64): Element
```

实现

```rust
public fun swap_remove<Element>(v: &mut vector<Element>, i: u64): Element {
    assert!(!is_empty(v), EINDEX_OUT_OF_BOUNDS);
    let last_idx = length(v) - 1;
    swap(v, i, last_idx);
    pop_back(v)
}
```

24. `for_each`：将函数应用于向量中的每个元素，并消耗该向量。

```rust
public fun for_each<Element>(v: vector<Element>, f: |Element|())
```

实现

```rust
public inline fun for_each<Element>(v: vector<Element>, f: |Element|) {
    reverse(&mut v); // We need to reverse the vector to consume it efficiently
    for_each_reverse(v, |e| f(e));
}
```

25. `for_each_reverse`：将函数应用于向量中的每个元素，并消耗该向量。

```rust
public fun for_each_reverse<Element>(v: vector<Element>, f: |Element|())
```

实现

```rust
public inline fun for_each_reverse<Element>(v: vector<Element>, f: |Element|) {
    let len = length(&v);
    while (len > 0) {
        f(pop_back(&mut v));
        len = len - 1;
    };
    destroy_empty(v)
}
```

26. `for_each_ref`：将函数应用于向量中每个元素的引用。

```rust
public fun for_each_ref<Element>(v: &vector<Element>, f: |&Element|())
```

实现

```rust
public inline fun for_each_ref<Element>(v: &vector<Element>, f: |&Element|) {
    let i = 0;
    let len = length(v);
    while (i < len) {
        f(borrow(v, i));
        i = i + 1
    }
}
```

27. `zip`：将函数应用于两个给定向量中每一对元素，同时消耗这些向量。

```rust
public fun zip<Element1, Element2>(v1: vector<Element1>, v2: vector<Element2>, f: |(Element1, Element2)|())
```

实现

```rust
public inline fun zip<Element1, Element2>(v1: vector<Element1>, v2: vector<Element2>, f: |Element1, Element2|) {
    // We need to reverse the vectors to consume it efficiently
    reverse(&mut v1);
    reverse(&mut v2);
    zip_reverse(v1, v2, |e1, e2| f(e1, e2));
}
```

28. `zip_reverse`：在给定的两个向量中以相反顺序将函数应用于每一对元素，并同时消耗这些向量。如果向量的长度不相等，则会产生错误。

```rust
public fun zip_reverse<Element1, Element2>(v1: vector<Element1>, v2: vector<Element2>, f: |(Element1, Element2)|())
```

实现

```rust
public inline fun zip_reverse<Element1, Element2>(
    v1: vector<Element1>,
    v2: vector<Element2>,
    f: |Element1, Element2|,
) {
    let len = length(&v1);
    // We can't use the constant EVECTORS_LENGTH_MISMATCH here as all calling code would then need to define it
    // due to how inline functions work.
    assert!(len == length(&v2), 0x20002);
    while (len > 0) {
        f(pop_back(&mut v1), pop_back(&mut v2));
        len = len - 1;
    };
    destroy_empty(v1);
    destroy_empty(v2);
}
```

29. `zip_ref`：将函数应用于两个给定向量中每一对元素的引用。如果向量的长度不相等，则会产生错误。

```rust
public fun zip_ref<Element1, Element2>(v1: &vector<Element1>, v2: &vector<Element2>, f: |(&Element1, &Element2)|())
```

实现

```rust
public inline fun zip_ref<Element1, Element2>(
    v1: &vector<Element1>,
    v2: &vector<Element2>,
    f: |&Element1, &Element2|,
) {
    let len = length(v1);
    // We can't use the constant EVECTORS_LENGTH_MISMATCH here as all calling code would then need to define it
    // due to how inline functions work.
    assert!(len == length(v2), 0x20002);
    let i = 0;
    while (i < len) {
        f(borrow(v1, i), borrow(v2, i));
        i = i + 1
    }
}
```

30. `enumerate_ref`：将函数应用于向量中每个元素的引用以及其索引。

```rust
public fun enumerate_ref<Element>(v: &vector<Element>, f: |(u64, &Element)|())
```

实现

```rust
public inline fun enumerate_ref<Element>(v: &vector<Element>, f: |u64, &Element|) {
    let i = 0;
    let len = length(v);
    while (i < len) {
        f(i, borrow(v, i));
        i = i + 1;
    };
}
```

31. `for_each_mut`：将函数应用于向量中每个元素的可变引用。

```rust
public fun for_each_mut<Element>(v: &mut vector<Element>, f: |&mut Element|())
```

实现

```rust
public inline fun for_each_mut<Element>(v: &mut vector<Element>, f: |&mut Element|) {
    let i = 0;
    let len = length(v);
    while (i < len) {
        f(borrow_mut(v, i));
        i = i + 1
    }
}
```

32. `zip_mut`：将函数应用于两个给定向量中每一对元素的可变引用。如果向量的长度不相等，则会产生错误。

```rust
public fun zip_mut<Element1, Element2>(v1: &mut vector<Element1>, v2: &mut vector<Element2>, f: |(&mut Element1, &mut Element2)|())
```

实现

```rust
public inline fun zip_mut<Element1, Element2>(
    v1: &mut vector<Element1>,
    v2: &mut vector<Element2>,
    f: |&mut Element1, &mut Element2|,
) {
    let i = 0;
    let len = length(v1);
    // We can't use the constant EVECTORS_LENGTH_MISMATCH here as all calling code would then need to define it
    // due to how inline functions work.
    assert!(len == length(v2), 0x20002);
    while (i < len) {
        f(borrow_mut(v1, i), borrow_mut(v2, i));
        i = i + 1
    }
}
```

33. `enumerate_mut`：将函数应用于向量中每个元素的可变引用以及其索引。

```rust
public fun enumerate_mut<Element>(v: &mut vector<Element>, f: |(u64, &mut Element)|())
```

实现

```rust
public inline fun enumerate_mut<Element>(v: &mut vector<Element>, f: |u64, &mut Element|) {
    let i = 0;
    let len = length(v);
    while (i < len) {
        f(i, borrow_mut(v, i));
        i = i + 1;
    };
}
```

34. `fold`：执行函数的折叠操作，将函数作用于元素上。例如，`fold(vector[1,2,3], 0, f)` 将执行 `f(f(f(0, 1), 2), 3)`。

```rust
public fun fold<Accumulator, Element>(v: vector<Element>, init: Accumulator, f: |(Accumulator, Element)|Accumulator): Accumulator
```


35. `foldr`：执行右折叠操作，类似于上面的折叠，但是从右到左进行。例如，`fold(vector[1,2,3], 0, f)` 将执行 `f(1, f(2, f(3, 0)))`。

```rust
public fun foldr<Accumulator, Element>(v: vector<Element>, init: Accumulator, f: |(Element, Accumulator)|Accumulator): Accumulator
```

实现

```rust
public inline fun foldr<Accumulator, Element>(
    v: vector<Element>,
    init: Accumulator,
    f: |Element, Accumulator|Accumulator
): Accumulator {
    let accu = init;
    for_each_reverse(v, |elem| accu = f(elem, accu));
    accu
}
```

36. `map_ref`：将函数映射到向量元素的引用上，生成一个新的向量，而不修改原始向量。

```rust
public fun map_ref<Element, NewElement>(v: &vector<Element>, f: |&Element|NewElement): vector<NewElement>
```

实现

```rust
public inline fun map_ref<Element, NewElement>(
    v: &vector<Element>,
    f: |&Element|NewElement
): vector<NewElement> {
    let result = vector<NewElement>[];
    for_each_ref(v, |elem| push_back(&mut result, f(elem)));
    result
}
```

37. `zip_map_ref`：将函数映射到两个向量元素对的引用上，生成一个新的向量，其元素由返回值组成，而不修改原始向量。

```rust
public fun zip_map_ref<Element1, Element2, NewElement>(v1: &vector<Element1>, v2: &vector<Element2>, f: |(&Element1, &Element2)|NewElement): vector<NewElement>
```

实现

```rust
public inline fun zip_map_ref<Element1, Element2, NewElement>(
    v1: &vector<Element1>,
    v2: &vector<Element2>,
    f: |&Element1, &Element2|NewElement
): vector<NewElement> {
    // We can't use the constant EVECTORS_LENGTH_MISMATCH here as all calling code would then need to define it
    // due to how inline functions work.
    assert!(length(v1) == length(v2), 0x20002);

    let result = vector<NewElement>[];
    zip_ref(v1, v2, |e1, e2| push_back(&mut result, f(e1, e2)));
    result
}
```

38. `map`：将函数映射到向量的每个元素上，生成一个新的向量。

```rust
public fun map<Element, NewElement>(v: vector<Element>, f: |Element|NewElement): vector<NewElement>
```

实现

```rust
public inline fun map<Element, NewElement>(
    v: vector<Element>,
    f: |Element|NewElement
): vector<NewElement> {
    let result = vector<NewElement>[];
    for_each(v, |elem| push_back(&mut result, f(elem)));
    result
}
```
39. `zip_map`：将函数映射到两个向量的每一对元素上，生成一个新的向量。

```rust
public fun zip_map<Element1, Element2, NewElement>(v1: vector<Element1>, v2: vector<Element2>, f: |(Element1, Element2)|NewElement): vector<NewElement>
```

实现

```rust
public inline fun zip_map<Element1, Element2, NewElement>(
    v1: vector<Element1>,
    v2: vector<Element2>,
    f: |Element1, Element2|NewElement
): vector<NewElement> {
    // We can't use the constant EVECTORS_LENGTH_MISMATCH here as all calling code would then need to define it
    // due to how inline functions work.
    assert!(length(&v1) == length(&v2), 0x20002);

    let result = vector<NewElement>[];
    zip(v1, v2, |e1, e2| push_back(&mut result, f(e1, e2)));
    result
}
```

40. `filter`：使用布尔函数过滤向量，移除所有使得 `p(e)` 不为真的元素。

```rust
public fun filter<Element: drop>(v: vector<Element>, p: |&Element|bool): vector<Element>
```

实现

```rust
public inline fun filter<Element:drop>(
    v: vector<Element>,
    p: |&Element|bool
): vector<Element> {
    let result = vector<Element>[];
    for_each(v, |elem| {
        if (p(&elem)) push_back(&mut result, elem);
    });
    result
}
```

41. `partition`：对向量进行分区，将所有使得 pred 为真的元素排序到前面。保留使得 pred 为真的元素的相对顺序，但不保留使得 pred 为假的元素的相对顺序。

```rust
public fun partition<Element>(v: &mut vector<Element>, pred: |&Element|bool): u64
```

实现

```rust
public inline fun partition<Element>(
    v: &mut vector<Element>,
    pred: |&Element|bool
): u64 {
    let i = 0;
    let len = length(v);
    while (i < len) {
        if (!pred(borrow(v, i))) break;
        i = i + 1;
    };
    let p = i;
    i = i + 1;
    while (i < len) {
        if (pred(borrow(v, i))) {
            swap(v, p, i);
            p = p + 1;
        };
        i = i + 1;
    };
    p
}
```

42. `rotate`：这个函数是在原地对给定的切片进行旋转，向右移动指定的步数。例如，对于 `[1, 2, 3, 4, 5]` 这个切片，向右旋转2步后会得到 `[3, 4, 5, 1, 2]`。函数会返回分割点，即旋转后切片的起始元素，对于这个例子就是3。

```rust
public fun rotate<Element>(v: &mut vector<Element>, rot: u64): u64
```

实现

```rust
public fun rotate<Element>(
    v: &mut vector<Element>,
    rot: u64
): u64 {
    let len = length(v);
    rotate_slice(v, 0, rot, len)
}
```


43. `rotate_slice`：同上，但对数组的子切片 `[left, right)` 进行操作，其中 `left <= rot <= right`，并返回分割点。

```rust
public fun rotate_slice<Element>(v: &mut vector<Element>, left: u64, rot: u64, right: u64): u64
```

实现

```rust
public fun rotate_slice<Element>(
    v: &mut vector<Element>,
    left: u64,
    rot: u64,
    right: u64
): u64 {
    reverse_slice(v, left, rot);
    reverse_slice(v, rot, right);
    reverse_slice(v, left, right);
    left + (right - rot)
}
```

44. `stable_partition`：根据条件 p 对数组进行分区，该过程是稳定的，因此保持了两个分区中元素的相对顺序。

```rust
public fun stable_partition<Element>(v: &mut vector<Element>, p: |&Element|bool): u64
```

实现

```rust
public inline fun stable_partition<Element>(
    v: &mut vector<Element>,
    p: |&Element|bool
): u64 {
    let len = length(v);
    let t = empty();
    let f = empty();
    while (len > 0) {
        let e = pop_back(v);
        if (p(&e)) {
            push_back(&mut t, e);
        } else {
            push_back(&mut f, e);
        };
        len = len - 1;
    };
    let pos = length(&t);
    reverse_append(v, t);
    reverse_append(v, f);
    pos
}
```

45. `any`：如果向量中的任何元素满足条件，则返回 true。

```rust
public fun any<Element>(v: &vector<Element>, p: |&Element|bool): bool
```

实现

```rust
public inline fun any<Element>(
    v: &vector<Element>,
    p: |&Element|bool
): bool {
    let result = false;
    let i = 0;
    while (i < length(v)) {
        result = p(borrow(v, i));
        if (result) {
            break
        };
        i = i + 1
    };
    result
}
```
46. `all`：如果向量中的所有元素都满足条件，则返回true。

```rust
public fun all<Element>(v: &vector<Element>, p: |&Element|bool): bool
```

实现

```rust
public inline fun all<Element>(
    v: &vector<Element>,
    p: |&Element|bool
): bool {
    let result = true;
    let i = 0;
    while (i < length(v)) {
        result = p(borrow(v, i));
        if (!result) {
            break
        };
        i = i + 1
    };
    result
}
```

47. `destroy`：销毁一个向量，仅是在销毁向量时使用的一个具有描述性名称的包装器，其内部实现使用 for_each_reverse

```rust
public fun destroy<Element>(v: vector<Element>, d: |Element|())
```

实现

```rust
public inline fun destroy<Element>(
    v: vector<Element>,
    d: |Element|
) {
    for_each_reverse(v, |e| d(e))
}
```

48. `range`：

```rust
public fun range(start: u64, end: u64): vector<u64>
```

实现

```rust
public fun range(start: u64, end: u64): vector<u64> {
    range_with_step(start, end, 1)
}
```

49. `range_with_step`

```rust
public fun range_with_step(start: u64, end: u64, step: u64): vector<u64>
```

实现


```rust
public fun range_with_step(start: u64, end: u64, step: u64): vector<u64> {
    assert!(step > 0, EINVALID_STEP);

    let vec = vector[];
    while (start < end) {
        push_back(&mut vec, start);
        start = start + step;
    };
    vec
}
```

50. `slice`

```rust
public fun slice<Element: copy>(v: &vector<Element>, start: u64, end: u64): vector<Element>
```

实现

```rust
public fun slice<Element: copy>(
    v: &vector<Element>,
    start: u64,
    end: u64
): vector<Element> {
    assert!(start <= end && end <= length(v), EINVALID_SLICE_RANGE);

    let vec = vector[];
    while (start < end) {
        push_back(&mut vec, *borrow(v, start));
        start = start + 1;
    };
    vec
}
```


## 技术规格

### 助手功能

1. 检查 `v1` 是否等于在末尾添加 `e` 的结果 `v2`

```rust
fun eq_push_back<Element>(v1: vector<Element>, v2: vector<Element>, e: Element): bool {
    len(v1) == len(v2) + 1 &&
    v1[len(v1)-1] == e &&
    v1[0..len(v1)-1] == v2[0..len(v2)]
}
```

2. 检查 `v` 是否等于连接 `v1` 的结果，并且 `v2`

```rust
fun eq_append<Element>(v: vector<Element>, v1: vector<Element>, v2: vector<Element>): bool {
    len(v) == len(v1) + len(v2) &&
    v[0..len(v1)] == v1 &&
    v[len(v1)..len(v)] == v2
}
```

3. 检查 `v1` 等于删除第一个元素的结果 `v2`

```rust
fun eq_pop_front<Element>(v1: vector<Element>, v2: vector<Element>): bool {
    len(v1) + 1 == len(v2) &&
    v1 == v2[1..len(v2)]
}
```

4. 检查 `v1` 是否等于从 `v2` 中删除索引 `i` 的元素的结果。

```rust
fun eq_remove_elem_at_index<Element>(i: u64, v1: vector<Element>, v2: vector<Element>): bool {
    len(v1) + 1 == len(v2) &&
    v1[0..i] == v2[0..i] &&
    v1[i..len(v1)] == v2[i + 1..len(v2)]
}
```

5. 检查 `v` 是否包含 `e`

```rust
fun spec_contains<Element>(v: vector<Element>, e: Element): bool {
    exists x in v: x == e
}
```

### 函数

`singleton`

```rust
public fun singleton<Element>(e: Element): vector<Element>
```

```rust
aborts_if false;
ensures result == vec(e);
```

`reverse`

```rust
public fun reverse<Element>(v: &mut vector<Element>)
```

```rust
pragma intrinsic = true;
```

`reverse_slice`

```rust
public fun reverse_slice<Element>(v: &mut vector<Element>, left: u64, right: u64)
```

```rust
pragma intrinsic = true;
```

`append`

```rust
public fun append<Element>(lhs: &mut vector<Element>, other: vector<Element>)
```

```rust
pragma intrinsic = true;
```


`reverse_append`

```rust
public fun reverse_append<Element>(lhs: &mut vector<Element>, other: vector<Element>)
```

```rust
pragma intrinsic = true;
```

`trim`

```rust
public fun trim<Element>(v: &mut vector<Element>, new_len: u64): vector<Element>
```

```rust
pragma intrinsic = true;
```

`trim_reverse`

```rust
public fun trim_reverse<Element>(v: &mut vector<Element>, new_len: u64): vector<Element>
```

```rust
pragma intrinsic = true;
```

`is_empty`

```rust
public fun is_empty<Element>(v: &vector<Element>): bool
```

```rust
pragma intrinsic = true;
```

`contains`

```rust
public fun contains<Element>(v: &vector<Element>, e: &Element): bool
```

```rust
pragma intrinsic = true;
```

`index_of`

```rust
public fun index_of<Element>(v: &vector<Element>, e: &Element): (bool, u64)
```

```rust
pragma intrinsic = true;
```

`insert`

```rust
public fun insert<Element>(v: &mut vector<Element>, i: u64, e: Element)
```

```rust
pragma intrinsic = true;
```

`remove`

```rust
public fun remove<Element>(v: &mut vector<Element>, i: u64): Element
```

```rust
pragma intrinsic = true;
```


`remove_value`

```rust
public fun remove_value<Element>(v: &mut vector<Element>, val: &Element): vector<Element>
```

```rust
pragma intrinsic = true;
```


`swap_remove`

```rust
public fun swap_remove<Element>(v: &mut vector<Element>, i: u64): Element
```

```
pragma intrinsic = true;
```

`rotate`

```rust
public fun rotate<Element>(v: &mut vector<Element>, rot: u64): u64
```

```rust
pragma intrinsic = true;
```

`rotate_slice`

```rust
public fun rotate_slice<Element>(v: &mut vector<Element>, left: u64, rot: u64, right: u64): u64
```

```rust
pragma intrinsic = true;
```