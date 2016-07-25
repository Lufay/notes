# 函数包装器
[文档](http://www.boost.org/doc/libs/1_61_0/doc/html/function.html)

函数包装器为可调用对象（函数指针、函数对象、成员函数）提供了一致的抽象。也就是说这些可调用对象都可以给函数包装器赋值，进而使用相同的方式进行调用（可以使用函数适配器进行适配）
C++11 已支持

## 定义
```
boost::function<float (int x, int y)> f;

struct int_div {
    float operator()(int x, int y) const { return ((float)x)/y; };
};
f = int_div();

float mul_ints(int x, int y) { return ((float)x) * y; }
f = &mul_ints;

std::cout << f(5, 3) << std::endl;
```
定义一个函数包装器只需要在模板参数中给出返回类型和参数列表即可
如果函数对象不能拷贝或拷贝成本大，可以使用boost::ref()构造一个函数对象的引用赋值给函数包装器

### 成员函数
```
struct X {
    int foo(int);
};

boost::function<int (X*, int)> f;
f = &X::foo;
X x;
f(&x, 5);
```

## 方法
可以直接进行布尔判断，空的包装器为false，否则为true
可以将包装器和任意函数对象（但不包括包装器类型）进行`==`, `!=`比较，将转化为包装器内的可调用对象进行比较（对于函数对象，需要支持等值比较，或重载一个 `boost::function_equal`）
empty(): 同上
clear(): 清空包装器中的可调用对象（也可以直接给包装器赋值为0）

注意：
如果调用一个空的函数包装器，将抛出 `bad_function_call` 异常
