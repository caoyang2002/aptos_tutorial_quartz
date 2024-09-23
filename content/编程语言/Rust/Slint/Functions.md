---
title: 函数
---
# 函数

与其他编程语言类似，Slint 中的函数用于命名、组织和重用一段逻辑/代码。

函数可以作为组件的一部分或作为组件内元素的一部分定义。不能声明全局（顶层）函数，也不能将它们声明为结构体或枚举的一部分。函数也不能嵌套在其他函数内。

## 声明函数

Slint 中的函数使用 `function` 关键字声明。例如：

```slint
export component Example {
    // ...
    function my-function(parameter: int) -> string {
        // 函数代码在这里
        return "result";
    }
}
```

函数可以有参数，这些参数在括号内声明，格式为 `name: type`。在函数体内可以通过名称引用这些参数。参数是按值传递的。

函数还可以返回一个值。返回类型在函数签名中的 `->` 后指定。在函数体内使用 `return` 关键字来返回声明类型的表达式。如果函数没有显式返回一个值，则默认返回最后一条语句的值。

函数可以用 `pure` 关键字进行注解。这表示该函数不引起任何副作用。更多细节可以在[纯度](https://releases.slint.dev/1.7.2/docs/slint/src/language/concepts/purity)章节中找到。

## 调用函数

可以不带元素名称（像其他语言中的函数调用）或带元素名称（像其他语言中的方法调用）来调用函数：

```slint
import { Button } from "std-widgets.slint"; 

export component Example {
    // 不带元素名称调用：
    property <string> my-property: my-function();
    // 带元素名称调用：
    property <int> my-other-property: my_button.my-other-function();

    pure function my-function() -> string {
        return "result";
    }

    Text {
        // 用预定义元素调用：
        text: root.my-function();
    }

    my_button := Button {
        pure function my-other-function() -> int {
            return 42;
        }
    }
}
```

## 名称解析

函数调用的名称解析规则与属性和回调相同。当不带元素名称调用时：

- 如果函数调用所在的元素 (`self`) 定义了该名称的函数，则选择该函数。
- 如果没有，则名称解析继续到其父元素，依此类推，直到根组件。

当带元素名称（或 `self`、`parent` 或 `root`）调用时，函数必须在该元素上定义。在这种情况下，名称解析不查看祖先元素。注意，这意味着不带元素名称的函数调用 *不是* 等价于用 `self` 调用（这在许多语言中是方法的工作方式）。

在同一组件中允许多个同名函数，只要它们在不同元素上定义。因此，函数可以隐藏来自祖先元素的其他函数。

```slint
export component Example {
    property <int> secret_number: my-function();
    public pure function my-function() -> int {
        return 1;
    }

    VerticalLayout {
        public pure function my-function() -> int {
            return 2;
        }

        Text {
            text: "The secret number is " + my-function();
            public pure function my-function() -> int {
                return 3;
            }
        }

        Text {
            text: "The other secret number is " + my-function();
        }
    }
}
```

在上述示例中，属性 `secret_number` 将设置为 1，文本标签将显示“秘密数字是 3”和“另一个秘密数字是 2”。

## 函数可见性

默认情况下，函数是私有的，不能从其他组件访问。

但是，可以使用 `public` 或 `protected` 关键字修改它们的可访问性。

- 使用 `public` 注解的根级函数可以被任何组件访问。

要从不同的组件访问此类函数，您始终需要一个目标，这在实践中意味着调用组件必须将被调用组件声明为其子元素之一。

```slint
export component HasFunction {
    public pure function double(x: int) -> int {
        return x * 2;
    }
}

export component CallsFunction {
    property <int> test: my-friend.double(1);

    my-friend := HasFunction {
    }
}
```

如果函数在子元素中声明，即使标记为公共，也无法从另一个组件调用，因为子元素本身不是公共的，并且不存在有效的函数目标：

```slint
export component HasFunction {
    t := Text {
        public pure function double(x: int) -> int {
            return x * 2;
        }
    }
}

export component CallsFunction {
    // 编译错误！
    // property <int> test: my-friend.t.double(1);

    my-friend := HasFunction {
    }
}
```

在导出组件中标记为 `public` 的函数也可以从后端代码（Rust、C++、JS）调用。有关生成代码的使用，请参阅特定语言的文档。

- 用 `protected` 注解的函数只能被直接继承自它的组件访问。

## 函数与回调

函数和[回调](https://releases.slint.dev/1.7.2/docs/slint/src/language/syntax/callbacks)之间有很多相似之处：

- 它们都是可调用的逻辑/代码块
- 以相同的方式被调用
- 都可以有参数和返回值
- 都可以声明为 `pure`

但也有差异：

- 回调中的代码/逻辑可以在后端代码中设置，并用后端语言（Rust、C++、JS）实现，而函数必须完全在 Slint 中定义
- 定义回调的语法不同
- 回调可以声明而不分配代码块
- 回调具有使用双向绑定运算符 `<=>` 声明别名的特殊语法
- 回调的可见性始终类似于 `public` 函数

一般来说，使用回调的最大原因是能够从后端代码处理它们。如果不需要这样，使用函数即可。