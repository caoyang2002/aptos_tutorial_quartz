---
title: 模块
---
# 模块

在 `.slint` 文件中声明的组件可以通过导出和导入的方式在其他 `.slint` 文件中使用。

默认情况下，`.slint` 文件中声明的每种类型都是私有的。使用 `export` 关键字可以改变这一点。

```slint
component ButtonHelper inherits Rectangle {
    // ...
}

component Button inherits Rectangle {
    // ...
    ButtonHelper {
        // ...
    }
}

export { Button }
```

在上面的例子中，`Button` 可以从其他 `.slint` 文件访问，但 `ButtonHelper` 则不行。

也可以仅为了导出而更改名称，而不影响内部使用：

```slint
component Button inherits Rectangle {
    // ...
}

export { Button as ColorButton }
```

在此示例中，`Button` 在外部不可访问，但可以通过名称 `ColorButton` 使用。

为了方便，可以立即声明一个组件为导出：

```slint
export component Button inherits Rectangle {
    // ...
}
```

同样，从其他文件导出的组件也可以被导入：

```slint
import { Button } from "./button.slint";

export component App inherits Rectangle {
    // ...
    Button {
        // ...
    }
}
```

如果两个文件导出同名类型，可以在导入时分配不同的名称：

```typescript
import { Button } from "./button.slint";
import { Button as CoolButton } from "../other_theme/button.slint";

export component App inherits Rectangle {
    // ...
    CoolButton {} // 来自 other_theme/button.slint
    Button {} // 来自 button.slint
}
```

元素、全局变量和结构体都可以导出和导入。

还可以导出从其他文件导入的全局变量（参见 [全局单例](https://releases.slint.dev/1.7.2/docs/slint/src/language/syntax/globals)）：

```typescript
import { Logic as MathLogic } from "math.slint";
export { MathLogic } // 在使用本地 API 访问全局变量时称为 "MathLogic"
```

## 模块语法

导入类型的语法如下：

```typescript
import { export1 } from "module.slint";
import { export1, export2 } from "module.slint";
import { export1 as alias1 } from "module.slint";
import { export1, export2 as alias2, /* ... */ } from "module.slint";
```

导出类型的语法如下：

```slint
// 导出声明
export component MyButton inherits Rectangle { /* ... */ }

// 导出列表
component MySwitch inherits Rectangle { /* ... */ }
export { MySwitch }
export { MySwitch as Alias1, MyButton as Alias2 }

// 从其他模块重新导出类型
export { MyCheckBox, MyButton as OtherButton } from "other_module.slint";

// 从其他模块重新导出所有类型（每个文件仅允许一次）
export * from "other_module.slint";
```

## 组件库

将代码库拆分为单独的模块文件有助于重用，并通过隐藏辅助组件来提高封装性。这在项目的目录结构内效果良好。要在项目之间共享组件库，而不硬编码其相对路径，可以使用组件库语法：

```typescript
import { MySwitch } from "@mylibrary/switch.slint";
import { MyButton } from "@otherlibrary";
```

在上面的示例中，`MySwitch` 组件将从名为 `mylibrary` 的组件库中导入，Slint 将查找 `switch.slint` 文件。因此，必须声明 `mylibrary` 指向一个目录，以便随后的 `switch.slint` 查找成功。`MyButton` 将从 `otherlibrary` 中导入，因此 `otherlibrary` 必须声明为指向导出 `MyButton` 的 `.slint` 文件。

每个库的路径（作为文件或目录）必须在编译时单独定义。使用以下方法之一帮助 Slint 编译器将库解析到磁盘上的正确路径：

- 在使用 Rust 和 `build.rs` 时，调用 [`with_library_paths`](https://slint.dev/releases/1.7.2/docs/rust/slint_build/struct.CompilerConfiguration) 提供库名与路径的映射。

- 在使用 C++ 时，使用 `LIBRARY_PATHS` 与 [`slint_target_sources`](https://slint.dev/releases/1.7.2/docs/cpp/cmake_reference) 配合使用。

- 当从命令行调用 `slint-viewer` 时，为每个组件库传递 `-Lmylibrary=/path/to/my/library`。

- 在使用 VS Code 扩展时，使用 `Slint: Library Paths` 设置配置 Slint 扩展的库路径。示例如下：

  ```
  "slint.libraryPaths": {
      "mylibrary": "/path/to/my/library",
      "otherlibrary": "/path/to/otherlib/index.slint",
  },
  ```

- 对于其他编辑器，可以将它们配置为像 `slint-viewer` 一样传递 `-L` 参数给 `slint-lsp`。