# Google Guava
<https://github.com/google/guava>
<https://ifeve.com/google-guava/>

## 前置检查
Preconditions 类，每个静态方法都有三个版本：
1. 默认版本，抛出的异常不带错误信息
2. 带有errMsg版本，抛出的异常使用Object.toString() 作为错误消息
3. template+errArgs版本，考虑GWT的兼容性和效率，template只支持%s指示符

### 静态方法
checkArgument(boolean): `arg == true` 否则IllegalArgumentException
checkNotNull(T): `arg != null` 返回arg，否则NullPointerException。JDK7 引入了Objects.requireNonNull 与之类似
checkState(boolean): `arg == true` 否则IllegalStateException
checkElementIndex(int index, int size): `index>=0 && index<size` 否则IndexOutOfBoundsException
checkPositionIndex(int index, int size)
checkPositionIndexes(int start, int end, int size): `start >=0 && end <= size` 否则IndexOutOfBoundsException

## 工具
### ComparisonChain
短路比较器，发现非零结果则结束比较，返回该非零值，否则完成所有比较都相等，则返回0

### Ordering
排序器，继承自Comparator

## 集合
### 不可变集合

### 集合工具类
Collections2
Iterables
#### Lists
partition(List, int n): 把list 每n 个元素分为一组，由每一组组成一个list

Sets
Maps
Queues
Multisets
Multimaps
Tables

