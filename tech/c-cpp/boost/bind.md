# 函数适配器
[文档](http://www.boost.org/doc/libs/1_61_0/libs/bind/doc/html/bind.html)

对 std::bind1st and std::bind2nd 的一般化，支持任意函数（函数对象，函数指针，成员函数），支持绑定指定值到任意位置
C++11 已支持

## bind 函数
第一个参数是一个函数对象
而后的参数是该函数对象所需的的参数，可以使用指定值，也可以使用 `_1`, `_2`等之类的占位符，表示返回的这个函数对象所需的参数
返回的函数对象重载了关系和逻辑运算，这些运算会返回一个新的函数对象，该函数对象会将原函数对象调用后的返回值进行关系或逻辑运算后作为返回值。而这个新的函数对象也重载了这些运算符。

### 函数指针
```
int f(int a, int b)
{
    return a + b;
}

int g(int a, int b, int c)
{
    return a + b + c;
}

bind(f, _2, _1)(x, y);                 // f(y, x)
bind(g, _1, 9, _1)(x);                 // g(x, 9, x)
bind(g, _3, _3, _3)(x, y, z);          // g(z, z, z)
bind(g, _1, _1, _1)(x, y, z);          // g(x, x, x)
```
可以发现，占位符的数量可以少于返回函数对象提供的参数的数量

### 函数对象
函数对象的返回类型需要显式指定，除非函数对象的类中包含一个名为`result_type`的类型
```
struct F
{
    int operator()(int a, int b) { return a - b; }
    bool operator()(long a, long b) { return a == b; }
};

F f;
int x = 104;
bind<int>(f, _1, _1)(x);        // f(x, x), i.e. zero
```
如果编译器不支持`bind<R>`格式的话，作为变通方法，可以使用：
```
boost::bind(boost::type<int>(), f, _1, _1)(x);
```

内嵌`result_type`的类型的例子：
```
int x = 8;
bind(std::less<int>(), _1, 9)(x);   // x < 9
```
```
struct F2
{
    int s;

    typedef void result_type;
    void operator()(int x) { s += x; }
};

F2 f2 = { 0 };
int a[] = { 1, 2, 3 };

std::for_each(a, a+3, bind(ref(f2), _1));

assert(f2.s == 6);
```
C++11之前有`std::unary_function` 和 `std::binary_function`
C++11之后有`std::function`
从这些预定义的类继承即可带有`result_type`, `argument_type`, `first_argument_type`, `second_argument_type`的定义

### 成员函数
将对象（或其指针或引用）作为第二个参数
```
struct X
{
    bool f(int a);
};

X x;
shared_ptr<X> p(new X);
int i = 5;

bind(&X::f, ref(x), _1)(i);     // x.f(i)
bind(&X::f, &x, _1)(i);         // (&x)->f(i)
bind(&X::f, x, _1)(i);          // (internal copy of x).f(i)
bind(&X::f, p, _1)(i);          // (internal copy of p)->f(i)
```

### 绑定函数
```
typedef void (*pf)(int);

std::vector<pf> v;
std::for_each(v.begin(), v.end(), bind(apply<void>(), _1, 5));
```


