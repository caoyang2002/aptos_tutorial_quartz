# 添加自定义属性
```tsx
import Developing from '@/src/components/Developing'
import React from 'react'

// 假设 SettingProps 已经被定义
interface SettingProps {
  size: 'small' | 'medium' | 'large'
}

export default function Setting({ size }: SettingProps) {
  // 根据 size 属性设置样式
  const getSizeClass = (sizeKey: keyof typeof sizeMap) => {
    const baseClass = 'flex flex-col bg-black rounded' // 基础样式
    const sizeMap: { [key: string]: string } = {
      small: 'p-2',
      medium: 'p-4',
      large: 'p-6',
    }

    // 使用索引签名来访问 sizeMap 对象
    return `${baseClass} ${sizeMap[sizeKey]}`
  }
  const className = getSizeClass(size) // 根据size获取对应的类名

  return (
    <div className={className}>
      <Developing />
    </div>
  )
}

```


# 添加 className 属性
实际上就是传递
```tsx

```


```css
wallet-button flex flex-col items-center justify-center text-center mt-1 rounded border-t border-b border-l border-r border-gray-300 py-2 px-4 font-semibold text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500
```