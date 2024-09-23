---
title: 语句
---
# 语句

回调处理器可以包含复杂的语句：

赋值：

```ini
clicked => { some-property = 42; }
```

自我赋值，使用 `+=`、`-=`、`*=`、`/=`：

```ini
clicked => { some-property += 42; }
```

调用回调：

```ini
clicked => { root.some-callback(); }
```

条件语句：

```bash
clicked => {
    if (condition) {
        foo = 42;
    } else if (other-condition) {
        bar = 28;
    } else {
        foo = 4;
    }
}
```

空表达式：

```slint
clicked => { }
// 或者
clicked => { ; }
```