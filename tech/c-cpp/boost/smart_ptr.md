# 智能指针
[文档](http://www.boost.org/doc/libs/1_61_0/libs/smart_ptr/smart_ptr.htm)

## `scoped_ptr`
`boost::scoped_ptr`和`std::auto_ptr`非常类似，是一个简单的智能指针，它能够保证在离开作用域后对象被自动释放。
例如：
```
#include <boost/scoped_ptr.hpp>
class implementation
{
public:
    ~implementation() { std::cout <<"destroying implementation\n"; }
    void do_something() { std::cout << "did something\n"; }
};

void test()
{
    boost::scoped_ptr<implementation> impl(new implementation());
    impl->do_something();
}
```
当impl失效后，其持有的指针也会被delete掉

和`std::auto_ptr`不同的是
1. `boost::scoped_ptr`有着更严格的使用限制——不能拷贝，于是也就不能用于STL容器中
2. 由于其本质是用一个栈对象管理一个堆对象，所以，这个栈对象也不能作为函数返回值
3. 由于`boost::scoped_ptr`是通过delete来删除所管理对象的，而数组对象必须通过deletep[]来删除，因此`boost::scoped_ptr`是不能管理数组对象的，如果要管理数组对象需要使用`boost::scoped_array`类

### 该智能指针对象可进行的操作
`*`     同普通指针
`->`    同普通指针
`get()`    取回普通指针
`reset(T* p=0)`    释放所管理的对象，管理另一个对象（p所指向）
`swap(scoped_ptr& b)`    交换两个智能指针所管理的对象。


## `scoped_ptr`
### `boost::shared_ptr`可进行的操作：
`=`         会使引用计数+1；支持将子类的智能指针赋给父类的智能指针
`==`        判断是否指向同一对象
`!`         可以作为布尔判断，如果持有指针，则为真
`*`         同普通指针
`->`        同普通指针
`use_count()`   返回当前引用计数个数
`unique()`      该智能指针是否是对象的唯一持有者
`reset()`       本智能指针放弃持有（引用计数-1）

### 构造函数
默认构造函数将生成一个持有空指针的智能指针，而后可以使用`make_shared<T>()`赋值
也可以直接用一个new出的T或T的子类指针进行构造
支持拷贝（可以用于STL容器中），也支持使用`boost::weak_ptr`、`std::auto_ptr`、`std::unique_ptr`进行构造

构造器还可以指定第二个参数（删除器）和第三个参数（分配器），比如：
1.
```
struct Test_Deleter {
    void operator()(Test* p) {
        ::free(p);
    }
};
Test* t = (Test*)malloc(sizeof(Test));
new (t) Test;
shared_ptr<Test> sp( t , Test_Deleter() ); //删除器可以改变share_ptr销毁对象行为
```
2.
```
template<class T>
struct Array_Deleter
{
    void operator ()( T*){ delete[] p; }
};
int* pint = new int[100];
shared_ptr<int> p (pint, Array_Deleter<int>() );
```
可以在删除器中处理和资源有关的其他释放操作。

引用计数存放于堆中，为避免大量使用智能指针造成的内存碎片问题可以自定义分配器：
```
template <typename T>
class Mallocator {
    //......
    T * allocate(const size_t n) const {
        return singleton_pool<T,sizeof(T)>::malloc();
    }
};
shared_ptr<Test> p( (new Test), Test_Deleter(), Mallocator<Test>() );
```
引用计数是线程安全且无锁的（lock-free的整数原子操作），但对对象的读写不是
原子操作虽然比加锁代价小，但也是有代价的，所以不要滥用指针指针，比如在参数传递的时候，如果可以确定该对象不会被析构，而函数调用结束后有不会影响智能指针的引用计数，于是就可以使用普通指针代替智能智能进行参数传递

### 注意事项
1. 不要将一个new的指针构造两个智能指针管理（会被double free）
2. 不要使用智能指针去管理不同代码块的指针（包括了外层的指针和外部传入的指针）（因为内部的智能指针析构后，会连带该指针指向对象的析构）
**结合前两条，就是只用智能指针去管理那些当前直接 new 出的指针**
3. 不能对循环引用的对象内存自动管理（引用计数管理的通病）
4. 避免对其所管理的对象直接内存管理操作，以免该对象的重释放
5. 不要用一个`shared_ptr`的临时对象作为函数的参数，而应该先声明`shared_ptr`的一个变量，将该变量作为参数。（因为可能在new出指针之后，智能指针管理之前引发问题，导致智能指针没能完成管理，就会有内存泄露）

#### 类型转换
如果想要将基类的智能指针动态转为子类的智能指针，可以使用`shared_dynamic_cast<T>()`函数（由于该函数只能适用于`shared_ptr`，而不适用更一般的指针语境，将被废弃而使用下列函数）
`static_pointer_cast`
`const_pointer_cast`
`dynamic_pointer_cast`
`reinterpret_pointer_cast`

#### 对象数组
`shared_ptr`内部是是用delete清理内存的，因此它也仅仅适用于管理单对象指针的情形，如果想要管理一个对象数组，则应使用`shared_array<T>`，它对应的是delete[]清理内存

#### this指针的智能指针
由于this指针不是被new出的（该对象肯定是类的外部new出的），所以基于以上的注意事项，我们不能直接用this指针构造一个智能指针出来。因此，就需要一种机制，让外部用智能智能管理new出的指针，能够让内部获得，这里就必须打破智能指针的非侵入特性了，需要对类本身进行一些改造，所幸改造并不复杂，只需让有这种需求的类继承`boost::enable_shared_from_this<T>`即可（T为这个类的名字），那么该类的内部就可以调用`shared_from_this()`获得this指针的智能指针。

## `weak_ptr`
### 循环引用的问题
比如：两个对象都持有对方的智能指针，则即使这两个对象都失效后，引用计数仍都是1，而无法自动释放
解决循环引用的方法：
1. 当只剩下最后一个引用的时候需要手动打破循环引用释放对象
2. 当A的生存期超过B的生存期的时候，B改为使用一个普通指针指向A
3. 使用弱引用的智能指针打破这种循环引用

+ 强引用的智能指针`boost::share_ptr`：当至少有一个强引用，那么这个对象就不能被释放
+ 弱引用的智能指针`boost::weak_ptr`：只能从一个`boost::share_ptr`或另一个`boost::weak_ptr`转换而来，由于它既不进行引用计数，不影响强引用的引用计数，也不管理内存，所以有可能对象已被`share_ptr`析构，因此，在使用`weak_ptr`前必须expired()检查有效性
弱引用功能上类似普通指针，只不过弱引用检查对象是否已被释放，从而避免访问非法内存。

### 可进行的操作
`bool expired()`            测试所管理的对象是否已释放
`shared_ptr<T> lock()`      获取所管理对象的强引用指针
`T* get()`                  取回普通指针

对于循环引用，弱引用的解决方案是将一个对象的`share_ptr`改为`weak_ptr`，但这种方式仅仅在可以预见循环引用的情形才能有效
