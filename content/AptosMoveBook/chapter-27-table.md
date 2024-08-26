---
title: 第二十七章 表
aliases:
  - 第二十七章 表
tags:
  - Move
---
`Table` 提供了一种灵活高效的以表格格式管理大量数据的方式。每个表项都被表示为一个单独的全局状态项，从而实现可扩展的存储解决方案。


# 1. 结构

`Table` 结构体被设计为高效地处理大规模存储：

- `handle`：一个唯一标识表的地址。

# 2. 常量

以下常量定义了模块内使用的各种错误代码（这些在提供的代码中是隐含的，未明确说明）：

- `ENOT_FOUND`：表中未找到键。
- `EALREADY_EXIST`：表中键已存在。
- `EINVALID_ARGUMENT`：传递给函数的参数无效。

## 1.3 API 概述

### 1.3.1 创建表

- `new<K: copy + drop, V: store>(): Table<K, V>`：创建一个新表。

#### 管理条目

- `add<K: copy + drop, V>(table: &mut Table<K, V>, key: K, val: V)`：向表中添加键值对。如果键已存在则中止。
- `remove<K: copy + drop, V>(table: &mut Table<K, V>, key: K): V`：移除并返回与键相关联的值。如果未找到键则中止。
- `upsert<K: copy + drop, V: drop>(table: &mut Table<K, V>, key: K, value: V)`：插入或更新键值对。

#### 检索条目

- `borrow<K: copy + drop, V>(table: &Table<K, V>, key: K): &V`：返回与键相关联的值的不可变引用。如果未找到键则中止。
- `borrow_with_default<K: copy + drop, V>(table: &Table<K, V>, key: K, default: &V): &V`：返回与键相关联的值或默认值（如果未找到键）。
- `borrow_mut<K: copy + drop, V>(table: &mut Table<K, V>, key: K): &mut V`：返回与键相关联的值的可变引用。如果未找到键则中止。
- `borrow_mut_with_default<K: copy + drop, V: drop>(table: &mut Table<K, V>, key: K, default: V): &mut V`：如果未找到键则插入键值对，然后返回值的可变引用。

#### 实用函数

- `contains<K: copy + drop, V>(table: &Table<K, V>, key: K): bool`：检查表中是否包含键。

## 示例用法

### 创建和使用表

`table.move`

```rust
module example::table_usage {
    use aptos_std::table::{Self, Table};
 
    public entry fun main() {
        let mut table = Table::new<u64, u64>();
        Table::add(&mut table, 1, 100);
        Table::add(&mut table, 2, 200);
        
        let value1 = Table::borrow(&table, 1);
        assert!(*value1 == 100, 0);
        
        let value2 = Table::borrow(&table, 2);
        assert!(*value2 == 200, 0);
        
        let removed_value = Table::remove(&mut table, 1);
        assert!(removed_value == 100, 0);
        
        let contains_key = Table::contains(&table, 2);
        assert!(contains_key, 0);
        
        Table::destroy(table);
    }
}
```

### 添加多个条目和更新插入

`table.move`

```rust
module example::table_usage {
    use aptos_std::table::{Self, Table};
 
    public fun add_and_upsert_entries() {
		let mut table = Table::new<u64, u64>();
		Table::add(&mut table, 1, 100);
		Table::upsert(&mut table, 1, 200);
		Table::upsert(&mut table, 2, 300);
		
		let value1 = Table::borrow(&table, 1);
		assert!(*value1 == 200, 0);
		
		let value2 = Table::borrow(&table, 2);
		assert!(*value2 == 300, 0);
		
		Table::destroy(table);
	}
}
```

### 借用可变引用

`table.move`

```rust
module example::table_usage {
    use aptos_std::table::{Self, Table};
 
    public fun borrow_mutable_references() {
		let mut table = Table::new<u64, u64>();
		Table::add(&mut table, 1, 100);
		
		let value_mut = Table::borrow_mut(&mut table, 1);
		*value_mut = 200;
		
		let value = Table::borrow(&table, 1);
		assert!(*value == 200, 0);
		
		Table::destroy(table);
	}
}
```

## 源代码

- [table.move](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-stdlib/sources/table.move)

## 其他示例

- [Move Spiders Tables 教程](https://movespiders.com/courses/modules/datastructures/lessonId/4)
- [通过 FullNode 查询 Move Spiders 表](https://movespiders.com/courses/modules/datastructures/lessonId/9)
- [通过视图函数查询 Move Spiders 表](https://movespiders.com/courses/modules/datastructures/lessonId/10)
