---
title: 重复
---
# 重复

使用 `for`-`in` 语法来创建多个元素。

语法如下：`for name[index] in model : id := Element { ... }`

*model* 可以是以下类型：

- 一个整数，此时元素将重复该次数
- 一个[数组类型或模型](https://releases.slint.dev/1.7.2/docs/slint/src/language/syntax/types#arrays-and-models)声明的原生类型，此时元素将为数组或模型中的每个元素实例化。

*name* 在元素内部可用于查找，像一个伪属性，值为模型的值。*index* 是可选的，设置为该元素在模型中的索引。*id* 也是可选的。

## 示例

```slint
export component Example inherits Window {
    preferred-width: 300px;
    preferred-height: 100px;
    for my-color[index] in [ #e11, #1a2, #23d ]: Rectangle {
        height: 100px;
        width: 60px;
        x: self.width * index;
        background: my-color;
    }
}
```

```slint
export component Example inherits Window {
    preferred-width: 50px;
    preferred-height: 50px;
    in property <[{foo: string, col: color}]> model: [
        {foo: "abc", col: #f00 },
        {foo: "def", col: #00f },
    ];
    VerticalLayout {
        for data in root.model: my-repeated-text := Text {
            color: data.col;
            text: data.foo;
        }
    }
}
```