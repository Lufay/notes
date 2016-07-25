# 迭代器
STL中对底层指针的抽象

## 术语说明
迭代器表示一个iterator类型的变量
迭代子表示一个该类型的一个值

## 分类
迭代器虽然行为很像是一个指针，但
并不是所以容器的迭代器都是可写的（const）
并不是所以容器的迭代器都是可双向遍历的
并不是所以容器的迭代器都是随机访问的

因此迭代器分为五类：
输入、输出、正向、双向、随机访问
对于这五类迭代器，共有的操作是`*`和`==`/`!=`
1. 输入：
`*`操作提供读权限，且当迭代器变化后，再对之前的迭代器值使用`*`可能是无效的
支持++，进行单向访问
保证每个元素都能遍历到，但不保证先后顺序
2. 输出：
`*`操作提供写权限（不能读）
支持++，进行单向访问
3. 正向
支持`*`，具有读写权限（可以通过const限定只读）
支持++，进行单向访问，保证顺序一定，且当迭代器变化后，之前的迭代器值仍可以使用`*`
4. 双向
在正向的基础上
支持--，可进行反向访问
5. 随机
在双向的基础上
支持[n]，相当于`*(it+n)`
支持+n、-n、+=n、-=n，对迭代器进行随机移动
支持迭代器之差（差的结果为`difference_type`类型），表示两者之间的元素数目
支持迭代器比较（<、>、<=、>=）

由此可见，从功能上：（输入，输出）< 正向 < 双向 < 随机
在写算法时，尽可能采用功能较少的迭代器，这样，具有较多功能的容器也可以使用；而如果采用了功能较多的迭代器，则功能较少的容器将无法使用该算法。

### concept & refinement
上面所说的这些都仅仅只是功能上的要求，而并非具体的类型
也就是说它可以是某个容器的迭代器（STL迭代器模板），也可以是数组的指针
也就是说，虽然上面的概念很像类的继承，但却不能那样实现，因为指针作为原始类型无法继承。
在STL文献中，使用concept 这个术语描述这种功能上的要求，而用术语refinement 描述这种功能要求上的递进。

由于各个容器的迭代器都是typedef为iterator这个类型名，所以容器中的迭代器有哪些功能还要看文档

## 使用
```
#include <iterator>
```
该头文件在容器的头文件都有包含

STL 算法的边界通常用两个迭代子的区间表示：`[begin,end)`
前一个迭代子指向区间的的首元素，第二个迭代子指向区间最后一个元素后面的一个位置
如：
区间遍历
```
for(auto xxxIterator=A.begin();xxxIterator!=A.end();++xxxIterator)
	cout<<*xxxIterator<<endl;
```

## 特别的
### IO 迭代器
1. 输入迭代器`istream_iterator<T, C=char>`
其中T类型指这个输出流的读入类型，C类型指的是这个输入流使用的字符类，如char、wchar_t等
默认构造器，构造一个输入流结束的迭代子
还可以使用一个输入流对象进行构造，如cin，其实只要是一个支持>>对象都可以作为参数
支持`*`和`++`操作
`*`是从输入流读入一个T类型对象（并不从输入流中取出）
`++`是从输入流取出一个T对象，如果没有指定类型的对象，则输入失败（即good()返回false），变为一个输入流结束的迭代子
于是，给一个容器赋值：
```
typedef istream_iterator<int, char> iit;
copy(iit(cin), iit(), back_inserter(c));
```
2. 输出迭代器`ostream_iterator<T, C=char>`
构造参数：`(ostream, cstr_delimiter)`
ostream指该迭代器的容器——一个输出流（只要一个支持<<对象都可以）
`cstr_delimiter`是每个数据项之间的分隔串（可以忽略该参数）
支持`*`，`++`，`=`操作，如果用上面定义一个名为`out_iter`的迭代器，则可以用如下方法输出：`*out_iter++ = 32;`这样就将32和一个分隔符显示出来了。
这样，显示一个容器就变成了，将容器要显示的内容拷贝到该迭代器的位置：
```
copy(c.begin(), c.end(), out_iter);
```

### 反向迭代器reverse_iterator
反向迭代器，如rbegin和rend，和iterator一样，`reverse_iterator` 也是容器内typedef的类型。
rbegin 指向的是容器的最后一个元素，rend 指向的是第一个元素的前一个位置
反向迭代器支持`*`，
由于不能对end()迭代子使用`*`，同理，也不能对rend()使用`*`

### 插入迭代器
`front_insert_iterator`、`back_insert_iterator`、`insert_iterator`
由于STL算法对容器的操作是不具有自动调整目标容器容量的能力，而使用这三个迭代器可以向容器中插入新元素而不是覆盖。他们的插入位置分别是容器的前端、尾部、和初始化时指定位置的前面。
#### front_insert_iterator<C>(container)
通过调用容器的`push_front()`成员函数来插入元素
专为可以在前端插入的容器而设计的，因此会比`insert_iterator`在前端插入效率更高，但对于不支持前端快速插入的容器，该容器无法使用，比如vector容器
#### back_insert_iterator<C>(container)
通过调用容器的`push_back()`成员函数来插入元素
#### insert_iterator<C>(container, position)
通过调用insert()成员函数来插入元素，并由用户指定插入位置

例如：
```
copy(vecSrc.begin(), vecSrc.end(), back_insert_iterator<list<int> >(vecDest));
copy(vecSrc.begin(), vecSrc.end(), front_insert_iterator<list<int> >(vecDest));
copy(vecSrc.begin(), vecSrc.end(), insert_iterator<list<int> >(vecDest, ++vecDest.begin()));
```
如果想要使用它们，还有各一个便捷的方法（工厂函数），就是使用
```
front_inserter(container)
back_inserter(container)
inserter(container, position)
```

### 只读迭代器
C++11还提供了begin()、end()、rbegin()和rend()的const版本，只需在这些方法名加上“c”前缀即可。
和iterator一样，`const_iterator` 也是容器内typedef的类型。
