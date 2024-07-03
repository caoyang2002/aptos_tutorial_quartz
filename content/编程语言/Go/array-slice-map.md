---
title: 数组、切片和映射
draft: 
aliases: 
date: 2024-07-02
description: Go 语言中的数组切片和映射
tags:
  - Golang
---
# 数组 array
## 声明数组
```go
// 变量关键字 数组名 [数组长度]数组类型
var name [2]string
```
## 元素赋值
```go
name[0] = "lisa" // 数组索引从零开始
name[1] = "mielgo"
```
## 使用数组
```go
// 打印数组单个元素（使用 数组名[索引]）
fmt.Println(name[0])
fmt.Println(name[1])

// 打印数组所有元素（使用 数组名）
fmt.Println(name)
```

>[!WARNING]
> 声明数组长度后就不能给他添加元素了，如果在数组 name 的索引 2 处添加一个值会报错：
> ```error
> ./main.go:9:　invalid array index 2 (out of bounds for 2-element array)
> ```


# 切片 slice
## 定义切片
你可以声明一个未指定大小的数组来定义切片：
```go
var name []type
```
> 切片不需要说明长度。

使用 **make()** 函数来创建切片:
```go
var name []type = make([]type, len)
```
也可以简写为
```go
name := make([]type, len)
```

也可以指定容量，其中 **capacity** 为可选参数。
```go
make([]T, length, capacity)
```
> 这里 len 是数组的长度并且也是切片的初始长度。


#### 常用的定义切片
```go
// var name []type = make([]type, len)
// 变量关键字 切片名 make([]类型, 长度)
var name = make([]string, 2)

name := make([]string, 2)
```
`make()` 是 Go 的内置函数


## 切片初始化
```go
// 变量名 :=  []元素类型{元素1,元素2,元素3,更多元素}
// [] 表示切片类型
s := []int {1,2,3 }
```

初始化切片 `s`，是数组 `arr` 的引用。
```go
s := arr[:] 
```

将 `arr` 中从下标 `startIndex` 到 `endIndex-1` 下的元素创建为一个新的切片。
```go
s := arr[startIndex:endIndex] 
```


默认 `endIndex` 时将表示一直到 `arr` 的最后一个元素。
```go
s := arr[startIndex:] 
```

默认 `startIndex` 时将表示从 `arr` 的第一个元素开始。
```go
s := arr[:endIndex] 
```

通过切片 `s` 初始化切片 `s1`。
```go
s1 := s[startIndex:endIndex] 
```

通过内置函数 `make()` 初始化切片`s`，`[]int` 标识为其元素类型为 `int` 的切片。
```go
s :=make([]int,len,cap) 
```


## 使用方法与数组相同
```go
name[0] = "lisa" // 切片索引从零开始
name[1] = "mielgo"\// 打印切片单个元素（使用 切片名[索引]）
fmt.Println(name[0])
fmt.Println(name[1])
// 打印切片的所有元素（使用 切片名）
fmt.Println(name)
```

## 切片截取
```go
package main

import "fmt"

func main() {
   /* 创建切片 */
   numbers := []int{0,1,2,3,4,5,6,7,8}   
   printSlice(numbers)

   /* 打印原始切片 */
   fmt.Println("numbers ==", numbers)

   /* 打印子切片从索引1(包含) 到索引4(不包含)*/
   fmt.Println("numbers[1:4] ==", numbers[1:4])

   /* 默认下限为 0*/
   fmt.Println("numbers[:3] ==", numbers[:3])

   /* 默认上限为 len(s)*/
   fmt.Println("numbers[4:] ==", numbers[4:])

   numbers1 := make([]int,0,5)
   printSlice(numbers1)

   /* 打印子切片从索引  0(包含) 到索引 2(不包含) */
   number2 := numbers[:2]
   printSlice(number2)

   /* 打印子切片从索引 2(包含) 到索引 5(不包含) */
   number3 := numbers[2:5]
   printSlice(number3)

}

func printSlice(x []int){
   fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)
}
```
输出：
```go
len=9 cap=9 slice=[0 1 2 3 4 5 6 7 8]
numbers == [0 1 2 3 4 5 6 7 8]
numbers[1:4] == [1 2 3]
numbers[:3] == [0 1 2]
numbers[4:] == [4 5 6 7 8]
len=0 cap=5 slice=[]
len=2 cap=9 slice=[0 1]
len=3 cap=7 slice=[2 3 4]

```
## 添加元素
```go
name = append(name,"simons")
fmt.Println(name[2])
```
append 会在必要时调整切片的长度，但它对程序员隐藏了这种复杂性。在这里，将切片的长度从 2 调整为 3，并将值 “Camembert” 赋给了新创建的元素（其索引为 2 ）。

在编程接口方面，程序员只需使用新创建的索引来引用这个元素即可。这样，只需一行代码，就调整了切片的长度，并给新元素赋值了。
```go
package main
import "fmt"
func main(){
	var name = make([]string,2)
	fmt.Println(name)
    name[0] = "lisa"
	name[1] = "mielgo"
	fmt.Println(name)
	// 添加元素
	name = append(name,"alice")
	fmt.Println(name)
    name = append(name,"alberto","lion","mielgo","thompson","reggie","kan")
    fmt.Println(name)
}
```
输出：
```go
[ ]
[lisa mielgo]
[lisa mielgo alice]
[lisa mielgo alice alberto lion mielgo thompson reggie kan]
```

## 删除元素
```go
// 删除第二个元素
name = append(name[:2],name[2+1]...)
```
示例：
```go
package main
import "fmt"
func main(){
	var name = make([]string,2)
	fmt.Println(name)
    name[0] = "lisa"
	name[1] = "mielgo"
	fmt.Println(name)
	// 添加元素
    name = append(name,"alberto","lion","mielgo","thompson","reggie","kan")
	fmt.Println(name)
    name = append(name[:2],name[2+1:]...) // 删除第二个元素
    // append(name[从首个元素开始到索引为 2 的元素],name[从索引为 2+1 的元素开始到末尾])
    // 取舍为左闭右开区间  [含 : 不含]
	fmt.Println(name)
}
```
输出：
```go
[ ]
[lisa mielgo]
[lisa mielgo alberto lion mielgo thompson reggie kan]
[lisa mielgo lion mielgo thompson reggie kan]
```

## 复制切片中的元素
使用内置函数 `copy()`

在复制切片中的元素前，必须再声明一个类型与该切片相同的切片，例如，不能将字符串切片中的元素复制到整数切片中。程序清单6.5演示了如何将一个切片中的元素复制到另一个切片中。

```go
package main
import "fmt"
func main(){
	var name = make([]string,3)
	name[0] = "lisa"
	name[1] = "ken"
	var smellyName = make([]string,2)
	copy(smellyName,name)
	fmt.Println(smellyName)
}
```
输出：
```go
[lisa ken]
```

函数 `copy()` 在新切片中创建元素的副本，因此修改一个切片中的元素不会影响另一个切片。还可将单个元素或特定范围内的元素复制到新切片中，下面的示例复制索引 `1` 处的元素。
```go
package main
import "fmt"
func main(){
	var name = make([]string,3)
	name[0] = "lisa"
	name[1] = "ken"
	var smellyName = make([]string,2)
	// copy(新的切片, 旧的切片[从索引为 1 开始到末尾])
	copy(smellyName,name[1:])
	fmt.Println(smellyName)
}
```
输出：
```go
[ken ]
```



## 附录
切片的数据结构中，包含一个指向数组的指针 `array` ，当前长度 `len` ，以及最大容量 `cap` 。在使用 `make([]int, len)` 创建切片时，实际上还有第三个可选参数 `cap` ，也即 `make([]int, len, cap)` 。在不声明 `cap` 的情况下，默认 `cap=len` 。当切片长度没有超过容量时，对切片新增数据，不会改变 `array` 指针的值。

当对切片进行 `append` 操作，导致长度超出容量时，就会创建新的数组，这会导致和原有切片的分离。

append() 函数可以向 slice 尾部添加数据，可以自动为切片扩容。常常会返回新的 slice 对象。

append函数会智能的将底层数组的容量增长，一旦超过原底层数组容量，通常以2倍（1024以下）容量重新分配底层数组，并复制原来的数据。因此，使用append 给切片做扩充时，切片的地址可能发生变化。但，数据都被重新保存了，不影响使用。

### `len()` 和 `cap()` 函数
切片是可索引的，并且可以由 `len()` 方法获取长度。

切片提供了计算容量的方法 `cap()` 可以测量切片最长可以达到多少。

以下为具体实例：
```go
package main  
import "fmt"  
func main() {  
   var numbers = make([]int,3,5)  
   printSlice(numbers)  
}  
  
func printSlice(x []int){  
   fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)  
}  
```
以上实例运行输出结果为:
```go
len=3 cap=5 slice=[0 0 0]
```

### 空(nil)切片

一个切片在未初始化之前默认为 nil，长度为 0，实例如下：
```go
package main  
import "fmt"  
func main() {  
   var numbers []int  
   printSlice(numbers)  
   if(numbers == nil){  
      fmt.Printf("切片是空的")  
   }  
}  
  
func printSlice(x []int){  
   fmt.Printf("len=%d cap=%d slice=%v\n",len(x),cap(x),x)  
}  
```
以上实例运行输出结果为:
```go
len=0 cap=0 slice=[]
```
切片是空的

# 映射 map
数组和切片是可通过索引值访问的元素集合，而映射是通过键来访问的无序元素编组。大多数编程语言都支持数组；在其他编程语言中，映射也被称为关联数组、字典或散列。映射在信息查找方面的效率非常高，因为可直接通过键来检索数据。简单地说，映射可视为键-值对集合。

## 创建 map
使用内置函数 make 和 map 关键字定义 Map
```go
/* 使用 make 函数 */
map_variable := make(map[KeyType]ValueType, initialCapacity)
```
> 其中 KeyType 是键的类型，ValueType 是值的类型，initialCapacity 是可选的参数，用于指定 Map 的初始容量。Map 的容量是指 Map 中可以保存的键值对的数量，当 Map 中的键值对数量达到容量时，Map 会自动扩容。如果不指定 initialCapacity，Go 语言会根据实际情况选择一个合适的值。


创建一个空的 Map
```go
// 变量关键字 变量名 = make(map[键类型]值类型)
var name = make(map[string]int)
```
创建一个初始容量为 10 的 Map
```go
m := make(map[string]int, 10)
```

使用字面量创建 Map
```go
m := map[string]int{
    "apple": 1,
    "banana": 2,
    "orange": 3,
}
```

## 添加键值对
```go
package main
import "fmt"
func main(){
	name := make(map[string]int)
	name["lisa"] = 1
	name["ken"] = 2
	name["linus"] =3
	fmt.Println(name["lisa"])
	fmt.Println(name["ken"])
	fmt.Println(name)
}
```
输出：
```go
1
2
map[ken:2 linus:3 lisa:1]
```
> 可在映射中动态地添加元素，而无须调整映射的长度。这是Go语言更像Ruby和Python等动态语言，而不像C语言的方面之一。

## 获取元素
```go
// 获取键值对
v1 := m["apple"]
v2, ok := m["pear"]  // 如果键不存在，ok 的值为 false，v2 的值为该类型的零值
```

## 修改元素
```go
// 修改键值对
m["apple"] = 5
```

## 获取 Map 长度
```go
len := len(m)
```

## 遍历  Map
```go
for k, v := range m {
    fmt.Printf("key=%s, value=%d\n", k, v)
}
```

## 删除元素
```go
// 删除键值对
delete(name, "lisa")
```
示例
```go
package main
import "fmt"
func main(){
	name := make(map[string]int)
	name["lisa"] = 1
	name["ken"] = 2
	name["linus"] =3
	delete(name,"ken")
	fmt.Println(name)
}
```
输出：
```go
map[linus:3 lisa:1]
```

## delete() 函数

delete() 函数用于删除集合的元素, 参数为 map 和其对应的 key。实例如下：
```go
package main
import "fmt"
func main() {
	/* 创建map */
	countryCapitalMap := map[string]string{"France": "Paris", "Italy": "Rome", "Japan": "Tokyo", "India": "New delhi"}
	fmt.Println("原始地图")
	/* 打印地图 */
	for country := range countryCapitalMap {
		fmt.Println(country, "首都是", countryCapitalMap [ country ])
	}
	/*删除元素*/ delete(countryCapitalMap, "France")
	fmt.Println("法国条目被删除")
	fmt.Println("删除元素后地图")
	/*打印地图*/
	for country := range countryCapitalMap {
		fmt.Println(country, "首都是", countryCapitalMap [ country ])
	}
}
```

## 附录
### 实现简单的 hashmap
```go
package main

import (
    "fmt"
)

type HashMap struct {
    key string
    value string
    hashCode int
    next *HashMap
}

var table [16](*HashMap)

func initTable() {
    for i := range table{
        table[i] = &HashMap{"","",i,nil}
    }
}

func getInstance() [16](*HashMap){
    if(table[0] == nil){
        initTable()
    }
    return table
}

func genHashCode(k string) int{
    if len(k) == 0{
        return 0
    }
    var hashCode int = 0
    var lastIndex int = len(k) - 1
    for i := range k {
        if i == lastIndex {
            hashCode += int(k[i])
            break
        }
        hashCode += (hashCode + int(k[i]))*31
    }
    return hashCode
}

func indexTable(hashCode int) int{
    return hashCode%16
}

func indexNode(hashCode int) int {
    return hashCode>>4
}

func put(k string, v string) string {
    var hashCode = genHashCode(k)
    var thisNode = HashMap{k,v,hashCode,nil}

    var tableIndex = indexTable(hashCode)
    var nodeIndex = indexNode(hashCode)

    var headPtr [16](*HashMap) = getInstance()
    var headNode = headPtr[tableIndex]

    if (*headNode).key == "" {
        *headNode = thisNode
        return ""
    }

    var lastNode *HashMap = headNode
    var nextNode *HashMap = (*headNode).next

    for nextNode != nil && (indexNode((*nextNode).hashCode) < nodeIndex){
        lastNode = nextNode
        nextNode = (*nextNode).next
    }
    if (*lastNode).hashCode == thisNode.hashCode {
        var oldValue string = lastNode.value
        lastNode.value = thisNode.value
        return oldValue
    }
    if lastNode.hashCode < thisNode.hashCode {
        lastNode.next = &thisNode
    }
    if nextNode != nil {
        thisNode.next = nextNode
    }
    return ""
}

func get(k string) string {
    var hashCode = genHashCode(k)
    var tableIndex = indexTable(hashCode)

    var headPtr [16](*HashMap) = getInstance()
    var node *HashMap = headPtr[tableIndex]

    if (*node).key == k{
        return (*node).value
    }

    for (*node).next != nil {
        if k == (*node).key {
            return (*node).value
        }
        node = (*node).next
    }
    return ""
}

//examples 
func main() {
    getInstance()
    put("a","a_put")
    put("b","b_put")
    fmt.Println(get("a"))
    fmt.Println(get("b"))
    put("p","p_put")
    fmt.Println(get("p"))
}
```