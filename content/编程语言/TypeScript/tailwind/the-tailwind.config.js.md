---
title: tailwind.config.js 配置
tags:
  - tailwind
  - ts
---
[The Docs](https://tailwind.nodejs.cn/docs/)

[GitHub](https://github.com/tailwindlabs/tailwindcss/)

`tailwind.config.js` 文件的 `theme` 部分是你定义项目的调色板、类型比例、字体、断点、边框半径值等的地方。

```ts
/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    screens: {
      sm: '480px',
      md: '768px',
      lg: '976px',
      xl: '1440px',
    },
    colors: {
      'blue': '#1fb6ff',
      'purple': '#7e5bef',
      'pink': '#ff49db',
      'orange': '#ff7849',
      'green': '#13ce66',
      'yellow': '#ffc82c',
      'gray-dark': '#273444',
      'gray': '#8492a6',
      'gray-light': '#d3dce6',
    },
    fontFamily: {
      sans: ['Graphik', 'sans-serif'],
      serif: ['Merriweather', 'serif'],
    },
    extend: {
      spacing: {
        '128': '32rem',
        '144': '36rem',
      },
      borderRadius: {
        '4xl': '2rem',
      }
    }
  }
}
```

## `screens` 键允许你自定义项目中的响应式断点。

```ts
/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    screens: {
      'sm': '640px',
      'md': '768px',
      'lg': '1024px',
      'xl': '1280px',
      '2xl': '1536px',
    }
  }
}
```



## `colors` 键允许你为项目自定义全局调色板。

```ts
/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    colors: {
      transparent: 'transparent',
      black: '#000',
      white: '#fff',
      gray: {
        100: '#f7fafc',
        // ...
        900: '#1a202c',
      },

      // ...
    }
  }
}
```



## `spacing` 键允许你为项目自定义全局间距和大小比例。

```ts
/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    spacing: {
      px: '1px',
      0: '0',
      0.5: '0.125rem',
      1: '0.25rem',
      1.5: '0.375rem',
      2: '0.5rem',
      2.5: '0.625rem',
      3: '0.75rem',
      3.5: '0.875rem',
      4: '1rem',
      5: '1.25rem',
      6: '1.5rem',
      7: '1.75rem',
      8: '2rem',
      9: '2.25rem',
      10: '2.5rem',
      11: '2.75rem',
      12: '3rem',
      14: '3.5rem',
      16: '4rem',
      20: '5rem',
      24: '6rem',
      28: '7rem',
      32: '8rem',
      36: '9rem',
      40: '10rem',
      44: '11rem',
      48: '12rem',
      52: '13rem',
      56: '14rem',
      60: '15rem',
      64: '16rem',
      72: '18rem',
      80: '20rem',
      96: '24rem',
    },
  }
}
```



## `theme` 部分的其余部分用于配置哪些值可用于每个单独的核心插件。

例如，`borderRadius` 键可让你自定义将生成哪些边框半径工具：

```ts
module.exports = {
  theme: {
    borderRadius: {
      'none': '0',
      'sm': '.125rem',
      DEFAULT: '.25rem',
      'lg': '.5rem',
      'full': '9999px',
    },
  }
}
```

键确定生成类的后缀，值确定实际 CSS 声明的值。

上面的示例 `borderRadius` 配置将生成以下 CSS 类：

```ts
.rounded-none { border-radius: 0 }
.rounded-sm   { border-radius: .125rem }
.rounded      { border-radius: .25rem }
.rounded-lg   { border-radius: .5rem }
.rounded-full { border-radius: 9999px }
```

如果你想保留主题选项的默认值，但还想添加新值，请在配置文件中的 `theme.extend` 键下添加扩展。该键下的值将与现有的 `theme` 值合并，并自动成为可供你使用的新类。

例如，这里我们扩展 `fontFamily` 属性以添加 `font-display` 类，该类可以更改元素上使用的字体：

```ts
/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        display: 'Oswald, ui-serif', // Adds a new `font-display` class
      }
    }
  }
}
```

将其添加到主题后，你可以像任何其他字体系列工具一样使用它：

```html
<h1 class="font-display">
  This uses the Oswald font
</h1>
```

在某些情况下，属性映射到 [variants](https://tailwind.nodejs.cn/docs/hover-focus-and-other-states)，可以将其放置在工具前面以有条件地应用其样式。例如，要添加与现有响应式屏幕一样工作的 `3xl` 屏幕尺寸，请在 `screens` 键下添加一个属性：

```ts
/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    extend: {
      screens: {
        '3xl': '1600px', // Adds a new `3xl:` screen variant
      }
    }
  }
}
```

通过此添加，新的 `3xl` 屏幕尺寸与现有的响应式变体（如 `sm`、`md`、`lg` 等）一起提供。你可以通过将其放置在工具类之前来使用此新变体：

```html
<blockquote class="text-base md:text-md 3xl:text-lg">
  Oh I gotta get on that internet, I'm late on everything!
</blockquote>
```

要覆盖默认主题中的选项，请直接在 `tailwind.config.js` 的 `theme` 部分下添加你的覆盖：

```ts
/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    // Replaces all of the default `opacity` values
    opacity: {
      '0': '0',
      '20': '0.2',
      '40': '0.4',
      '60': '0.6',
      '80': '0.8',
      '100': '1',
    }
  }
}
```

你当然可以覆盖默认主题的某些部分并在同一配置中扩展默认主题的其他部分：

```ts
/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    opacity: {
      '0': '0',
      '20': '0.2',
      '40': '0.4',
      '60': '0.6',
      '80': '0.8',
      '100': '1',
    },
    extend: {
      screens: {
        '3xl': '1600px',
      }
    }
  }
}
```

如果你需要在主题中引用另一个值，你可以通过提供闭包而不是静态值来实现。闭包将接收一个包含 `theme()` 函数的对象，你可以使用该函数使用点表示法查找主题中的其他值。

例如，你可以通过在 `backgroundSize` 配置中引用 `theme('spacing')` 为间距比例中的每个值生成 `background-size` 工具：

```js
/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    spacing: {
      // ...
    },
    backgroundSize: ({ theme }) => ({
      auto: 'auto',
      cover: 'cover',
      contain: 'contain',
      ...theme('spacing')
    })
  }
}
```

一个有用的示例是，如果你想将字体系列添加到 Tailwind 的默认字体堆栈之一：

```js
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: [
          'Lato',
          ...defaultTheme.fontFamily.sans,
        ]
      }
    }
  }
}
```



# 配置参考

除了 `screens`、`colors` 和 `spacing`，`theme` 对象中的所有键都映射到 Tailwind 的 [核心插件](https://tailwind.nodejs.cn/docs/configuration#core-plugins) 之一。由于许多插件负责只接受一组静态值的 CSS 属性（例如 `float`），请注意并非每个插件在 `theme` 对象中都有相应的键。

所有这些键也可以在 `theme.extend` 键下使用以启用 [扩展默认主题](https://tailwind.nodejs.cn/docs/theme#extending-the-default-theme)。

| 键                           | 描述                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `accentColor`                | Values for the `accent-color` property                       |
| `animation`                  | Values for the `animation` property                          |
| `aria`                       | Values for the `aria` property                               |
| `aspectRatio`                | Values for the `aspect-ratio` property                       |
| `backdropBlur`               | Values for the `backdropBlur` plugin                         |
| `backdropBrightness`         | Values for the `backdropBrightness` plugin                   |
| `backdropContrast`           | Values for the `backdropContrast` plugin                     |
| `backdropGrayscale`          | Values for the `backdropGrayscale` plugin                    |
| `backdropHueRotate`          | Values for the `backdropHueRotate` plugin                    |
| `backdropInvert`             | Values for the `backdropInvert` plugin                       |
| `backdropOpacity`            | Values for the `backdropOpacity` plugin                      |
| `backdropSaturate`           | Values for the `backdropSaturate` plugin                     |
| `backdropSepia`              | Values for the `backdropSepia` plugin                        |
| `backgroundColor`            | Values for the `background-color` property                   |
| `backgroundImage`            | Values for the `background-image` property                   |
| `backgroundOpacity`          | Values for the `background-opacity` property                 |
| `backgroundPosition`         | Values for the `background-position` property                |
| `backgroundSize`             | Values for the `background-size` property                    |
| `blur`                       | Values for the `blur` plugin                                 |
| `borderColor`                | Values for the `border-color` property                       |
| `borderOpacity`              | Values for the `borderOpacity` plugin                        |
| `borderRadius`               | Values for the `border-radius` property                      |
| `borderSpacing`              | Values for the `border-spacing` property                     |
| `borderWidth`                | Values for the `borderWidth` plugin                          |
| `boxShadow`                  | Values for the `box-shadow` property                         |
| `boxShadowColor`             | Values for the `boxShadowColor` plugin                       |
| `brightness`                 | Values for the `brightness` plugin                           |
| `caretColor`                 | Values for the `caret-color` property                        |
| `colors`                     | Your project's color palette                                 |
| `columns`                    | Values for the `columns` property                            |
| `container`                  | Configuration for the `container` plugin                     |
| `content`                    | Values for the `content` property                            |
| `contrast`                   | Values for the `contrast` plugin                             |
| `cursor`                     | Values for the `cursor` property                             |
| `divideColor`                | Values for the `divideColor` plugin                          |
| `divideOpacity`              | Values for the `divideOpacity` plugin                        |
| `divideWidth`                | Values for the `divideWidth` plugin                          |
| `dropShadow`                 | Values for the `dropShadow` plugin                           |
| `fill`                       | Values for the `fill` plugin                                 |
| `flex`                       | Values for the `flex` property                               |
| `flexBasis`                  | Values for the `flex-basis` property                         |
| `flexGrow`                   | Values for the `flex-grow` property                          |
| `flexShrink`                 | Values for the `flex-shrink` property                        |
| `fontFamily`                 | Values for the `font-family` property                        |
| `fontSize`                   | Values for the `font-size` property                          |
| `fontWeight`                 | Values for the `font-weight` property                        |
| `gap`                        | Values for the `gap` property                                |
| `gradientColorStops`         | Values for the `gradientColorStops` plugin                   |
| `gradientColorStopPositions` | Values for the `gradient-color-stop-positions` property      |
| `grayscale`                  | Values for the `grayscale` plugin                            |
| `gridAutoColumns`            | Values for the `grid-auto-columns` property                  |
| `gridAutoRows`               | Values for the `grid-auto-rows` property                     |
| `gridColumn`                 | Values for the `grid-column` property                        |
| `gridColumnEnd`              | Values for the `grid-column-end` property                    |
| `gridColumnStart`            | Values for the `grid-column-start` property                  |
| `gridRow`                    | Values for the `grid-row` property                           |
| `gridRowEnd`                 | Values for the `grid-row-end` property                       |
| `gridRowStart`               | Values for the `grid-row-start` property                     |
| `gridTemplateColumns`        | Values for the `grid-template-columns` property              |
| `gridTemplateRows`           | Values for the `grid-template-rows` property                 |
| `height`                     | Values for the `height` property                             |
| `hueRotate`                  | Values for the `hueRotate` plugin                            |
| `inset`                      | Values for the `top`, `right`, `bottom`, and `left` properties |
| `invert`                     | Values for the `invert` plugin                               |
| `keyframes`                  | Keyframe values used in the `animation` plugin               |
| `letterSpacing`              | Values for the `letter-spacing` property                     |
| `lineHeight`                 | Values for the `line-height` property                        |
| `listStyleType`              | Values for the `list-style-type` property                    |
| `listStyleImage`             | Values for the `list-style-image` property                   |
| `margin`                     | Values for the `margin` property                             |
| `lineClamp`                  | Values for the `line-clamp` property                         |
| `maxHeight`                  | Values for the `max-height` property                         |
| `maxWidth`                   | Values for the `max-width` property                          |
| `minHeight`                  | Values for the `min-height` property                         |
| `minWidth`                   | Values for the `min-width` property                          |
| `objectPosition`             | Values for the `object-position` property                    |
| `opacity`                    | Values for the `opacity` property                            |
| `order`                      | Values for the `order` property                              |
| `outlineColor`               | Values for the `outline-color` property                      |
| `outlineOffset`              | Values for the `outline-offset` property                     |
| `outlineWidth`               | Values for the `outline-width` property                      |
| `padding`                    | Values for the `padding` property                            |
| `placeholderColor`           | Values for the `placeholderColor` plugin                     |
| `placeholderOpacity`         | Values for the `placeholderOpacity` plugin                   |
| `ringColor`                  | Values for the `ringColor` plugin                            |
| `ringOffsetColor`            | Values for the `ringOffsetColor` plugin                      |
| `ringOffsetWidth`            | Values for the `ringOffsetWidth` plugin                      |
| `ringOpacity`                | Values for the `ringOpacity` plugin                          |
| `ringWidth`                  | Values for the `ringWidth` plugin                            |
| `rotate`                     | Values for the `rotate` plugin                               |
| `saturate`                   | Values for the `saturate` plugin                             |
| `scale`                      | Values for the `scale` plugin                                |
| `screens`                    | Your project's responsive breakpoints                        |
| `scrollMargin`               | Values for the `scroll-margin` property                      |
| `scrollPadding`              | Values for the `scroll-padding` property                     |
| `sepia`                      | Values for the `sepia` plugin                                |
| `skew`                       | Values for the `skew` plugin                                 |
| `space`                      | Values for the `space` plugin                                |
| `spacing`                    | Your project's spacing scale                                 |
| `stroke`                     | Values for the `stroke` property                             |
| `strokeWidth`                | Values for the `stroke-width` property                       |
| `supports`                   | Values for the `supports` property                           |
| `data`                       | Values for the `data` property                               |
| `textColor`                  | Values for the `text-color` property                         |
| `textDecorationColor`        | Values for the `text-decoration-color` property              |
| `textDecorationThickness`    | Values for the `text-decoration-thickness` property          |
| `textIndent`                 | Values for the `text-indent` property                        |
| `textOpacity`                | Values for the `textOpacity` plugin                          |
| `textUnderlineOffset`        | Values for the `text-underline-offset` property              |
| `transformOrigin`            | Values for the `transform-origin` property                   |
| `transitionDelay`            | Values for the `transition-delay` property                   |
| `transitionDuration`         | Values for the `transition-duration` property                |
| `transitionProperty`         | Values for the `transition-property` property                |
| `transitionTimingFunction`   | Values for the `transition-timing-function` property         |
| `translate`                  | Values for the `translate` plugin                            |
| `size`                       | Values for the `size` property                               |
| `width`                      | Values for the `width` property                              |
| `willChange`                 | Values for the `will-change` property                        |
| `zIndex`                     | Values for the `z-index` property                            |