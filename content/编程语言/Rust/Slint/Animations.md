---
title: 动画
---
# 动画

使用 `animate` 关键字为属性声明动画，如下所示：

```slint
export component Example inherits Window {
    preferred-width: 100px;
    preferred-height: 100px;

    background: area.pressed ? blue : red;
    animate background {
        duration: 250ms;
    }

    area := TouchArea {}
}
```

这将在颜色属性变化时动画持续 250 毫秒。

使用以下参数微调动画：

- `delay`: 开始动画前的等待时间
- `duration`: 动画完成所需的时间
- `iteration-count`: 动画应运行的次数。负值表示无限次重播，允许分数值。要实现永久运行的动画，请参见 [`animation-tick()`](https://releases.slint.dev/1.7.2/docs/slint/src/language/builtins/functions#animation-tick-duration)。
- `easing`: 可为以下任意一种，详见 [`easings.net`](https://easings.net/)：

  - `linear`
  - `ease-in-quad`
  - `ease-out-quad`
  - `ease-in-out-quad`
  - `ease`
  - `ease-in`
  - `ease-out`
  - `ease-in-out`
  - `ease-in-quart`
  - `ease-out-quart`
  - `ease-in-out-quart`
  - `ease-in-quint`
  - `ease-out-quint`
  - `ease-in-out-quint`
  - `ease-in-expo`
  - `ease-out-expo`
  - `ease-in-out-expo`
  - `ease-in-sine`
  - `ease-out-sine`
  - `ease-in-out-sine`
  - `ease-in-back`
  - `ease-out-back`
  - `ease-in-out-back`
  - `ease-in-circ`
  - `ease-out-circ`
  - `ease-in-out-circ`
  - `ease-in-elastic`
  - `ease-out-elastic`
  - `ease-in-out-elastic`
  - `ease-in-bounce`
  - `ease-out-bounce`
  - `ease-in-out-bounce`
  - `cubic-bezier(a, b, c, d)`（与 CSS 相同）

多个属性也可以使用相同的动画，因此：

```slint
animate x, y { duration: 100ms; easing: ease-out-bounce; }
```

与：

```slint
animate x { duration: 100ms; easing: ease-out-bounce; }
animate y { duration: 100ms; easing: ease-out-bounce; }
```

是相同的。