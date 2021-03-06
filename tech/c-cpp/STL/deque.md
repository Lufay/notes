# deque
双端队列（首尾两端开放）

## 实现方式
多个C 静态数组实现（分段连续），每段的大小都是固定的（典型值512字节），他们的首地址保存在一个索引数组中，这个索引数组采用类似vector内置数组的方式管理，只不过是双端可扩展的。
在首尾插入一个元素意味着在首或尾部的chunk块中找空闲空间，如果没有，就新申请一个chunk，并将该chunk的首地址登记到索引数组中。如果索引数组空间不足，就触发索引数组的数据迁移。

## 特点
max_size可以更大
内存重分配优于vector

## 迭代器
随机迭代器
但性能不如vector
因此，如果需要进行排序，可以先将其移到vector中排序

## 使用
```
#include <deque>
```

### 方法
基本拥有vector的所有接口（除了capacity和reserve，因为容器自身控制chunk的申请和回收)，但比之多了
+ push_front(T)
把对象放到第一个位置
+ pop_front()
表头删除一个元素
