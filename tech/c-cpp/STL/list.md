# list
双向链表

## 实现方式

## 迭代器
双向迭代器

## 使用
```
#include <list>
```

### 构造器
4种构造器（空、拷贝、同值、区间）
同vector

### 方法
+ 重载=
+ assign()
赋值（同构造函数的方式）

#### 访问
+ front()
返回第一个元素的引用
+ back()
返回最后一个元素的引用

#### 增删
除被修改的元素外，其他元素的迭代器都有效
+ insert
	- insert(pos, val)
	- insert(pos, n, val)
	- insert(pos, first, last)
	- insert(pos, initializer_list)
+ erase
	- erase(pos)
	- erase(first, last)
+ clear

+ push_back(val)
把一个对象放到最后
+ pop_back()
表尾删除一个元素

+ push_front(val)
把对象放到第一个位置
+ pop_front()
表头删除一个元素

+ remove(val)
等值删除：删除列表中所有等于参数值的元素
+ remove_if(func)
自定义匹配删除：func是一个一元谓词函数对象，如果返回为true将被删除

+ splice
	- splice(iterator, list<T>)
	- splice(iterator, list<T>, iterator)
	- splice(iterator, list<T>, first, last)
将列表中的元素**移动**到本列表中的指定位置
第一个参数就是指定的位置
第二个参数是来源（在第二和第三个版本中如果指定的范围不包括目标位置的话，来源可以是自身）
第二个版本的第三个参数是指定来源的位置（即只移动一个元素）
第三个版本的第三四个参数是指定来源的一个范围（移动该范围中的元素）

#### 容量
+ empty()
容器是否是空
+ size()
返回元素个数，其返回值类型为list<T>::size_type，可以用int接收
+ resize(n, val=default)
调整链表长度，如果n 小于当前长度会截断，如果大于当前长度，会使用默认值0或默认构造函数补足，也可以使用第二个参数指定补足值

+ max_size()
返回该容器所能容许的最大长度

#### 其他
+ sort([comp])
如果没有comp，则使用`<`进行比较，即默认为升序排序，可以使用一个二元谓词作为参数，例如使用greater<T>()实现降序
稳定排序，算法复杂度为`O(N*logN)`

+ unique([comp])
删除相邻相同的元素，一般先用sort排序，来保证实现唯一性
默认使用等值比较，也可以传入一个二元谓词函数对象来进行等值判断，返回为true将被视为相等

+ merge(List<T> [, comp])
将另一个列表合并到本列表（要求两个列表都是有序的，实现归并排序）
如果没有comp，则使用`<`进行比较，即默认为升序排序，可以使用一个二元谓词作为参数，例如使用greater<T>()实现降序
合并后，作为参数的链表为空
稳定排序，算法复杂度至多为sum(listThis, listArg)-1

+ reverse()
反转链表
