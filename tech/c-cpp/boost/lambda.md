# lambda 表达式
[文档](http://www.boost.org/doc/libs/1_61_0/doc/html/lambda.html)

lambda 表达式实际上是实现了匿名函数，因为boost的 lambda 表达式在编译器求值后会得到一个函数对象。
C++11 已支持

```
using namespace boost::lambda;
```

boost的 lambda 表达式是通过组合`_1`, `_2` 和 `_3` 这三个占位符来实现的
可以将这三个占位符视为生成函数对象的三个参数。他们是实参的引用，即可读写；而且并不限定类型，只要实参支持表达式中的操作即可。

<http://www.boost.org/doc/libs/1_61_0/doc/html/lambda/using_library.html#lambda.parameter_and_return_types>
