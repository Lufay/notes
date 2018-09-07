
一个库的集合
http://www.boost.org/doc/libs/1_59_0/more/getting_started/unix-variants.html


实际常用：
tuple, shared_ptr, bind, function, lambda，any，multi_index

boost的有时是非侵入式的，也就是说你无须修改程序结构以适应框架，而是直接拿来使用即可
boost是有品质保证的，保证其实现是功能正确而且通用高效的
将运行期决议（面向对象）和编译期决议（泛型编程）能获益的地方结合起来

大量使用 模板 这一“静态类生成器”，利用其静态递归特性
模板会在编译期间生成大量对用户不知的静态内容（类，函数），而这些是在编译耗时的，并且会导致目标膨胀。

由于模板参数没有显式是的适配条件，而只有隐含在模板内部的实现中，即模板实现对模板参数进行默写操作隐含着对其的要求。这就导致编译信息冗长而难以解读，即便是一个简单的错误
本预期着可能会引入Concepts (C++)定义，从而完成模板适配的静态检查，使得编译器能更早更简明的提供错误信息，参考：http://en.wikipedia.org/wiki/Concepts_(C%2B%2B)


boost中有一部分是由于C++本身没有提供其他语言内置的一些简洁的语法，而从扩展库的角度构造的语法结构
比如
foreach 是对迭代容器的语法结构扩展
shared_ptr 是对内存管理的一种弥补
tuple 是对函数无法多返回值的弥补
function 为了成员函数指针也能作为函数对象使用
lambda 是为了补充函数式编程的能力
boost.thread提供了一个轻量的跨平台方案
regex正则表达式，string algo对字符串的各种算法
asio，filesystem
bimap
boost::multi_index、boost::python、boost::string_algo、 boost::circular_buffer
这些扩展的能力，在某些情形是关键的，和不可替代的，有些则是可有可无的，而带来的代价是编译时间大大增加，不便于调试，而且由于其实现的结构精巧而复杂，使得你不得不增加很多学习成本和精力去顾及其很多使用模式和禁忌条款，同时也不便于评估其性能代价（可能含有一些因使用不当造成的性能陷阱，这些使用方式或禁忌也就是前面所述的学习成本）

BOOST_FOREACH的最大问题是是用宏定义，就必须附加大量的类型和合法性检查，而这些都会消耗性能

shared_ptr引用计数的原子操作会排空指令流水线？
其实原子操作未必会导致排空流水线，只要保证流水线上的指令不会导致intr就行了

在没有lambda之前，使用函数对象最大的问题是不能原地定义，导致用户必须跳跃去读，破坏了局部性（当然可以用一个unnamed namespace来制造一个“local name”）；而拥有了lambda之后，函数对象可以原地定义，使得类似for_each的函数更加有意义。

简洁的语法可以提高代码可读性，但滥用这些结构就会大大降低可读性
比如，通常使用一句话能表达一个逻辑过程（抽象）总好过描述该过程的各种细枝末节，并且和语言或业务逻辑相关的细节要好，但，同时不要在一个结构中嵌套太多，太深的其他复杂结构
但在另一方面，可读性的评价也与团队的代码一致性、规范性有着密切的关系



C++不认为有任何设施或设计思想可以包治百病，兼容并包而后让用户自己去选择合适他的应用场景才是C++的意图
于是，C++及其库都比较繁杂，并且都带有着看似花哨无用的功能，因为你不可能用到它的全部，但你用不到，并不代表它无用。于是，有种说法是在C++中，一个设施就算解决了30%的问题，也有存在的价值。

noncopyable
function
http://blog.csdn.net/benny5609/article/details/2324474
ptr_container
enable_shared_from_this
http://www.cnblogs.com/lzjsky/archive/2011/05/05/2037363.html
http://www.cnblogs.com/lzjsky/archive/2011/09/09/2172469.html


其他库：
ATL干的领域是单纯有限的
ACE
做科学计算，应该听说过blitz++这个东西，号称效率非常之高，也是将模板技术发挥的淋漓尽致
Loki::SmartPointer
boost spirit、boost xpressive，都是实现一个静态正则文法




其他的说明：
不要认为一些内容成为标准就一定是合格的，有可能是当时还没有出现更好的实现，比如std::auto_ptr以及Java发展过程中那些曾经被废弃的设计
程序员和工程师的差别，就是程序员习惯将自身划分阵营，进而固步自封，什么都想用自己领域内去实现，看到其他的实现，总想找出他的毛病；而工程师则更从实际出发，从解决问题的角度去选择更好的方式和更好的工具，降低工程代价下解决问题。



filter_iterator
MPL, enable_if, type_traits
Boost.Function的调用都和Function包装的Invokable对象松耦合。典型应用：Listener.



bessel函数，使用了 boost/math/special_functions.hpp 中的 cyl_bessel_j(double, double) 这个函数，觉得boost很神奇，直接include头文件就成了，不用链接库；如果用gsl的bessel函数，要链接libgsl 和 gslcblas；
-------------------------------------------------------------------
for_each(vs.begin(), vs.end(), if_then(bind(&shape::visible, _1) ==
true, bind(&shape::draw, _1)(graph));
----------------------------------------------------------------------------
用lambda
#include <boost/lambda/lambda.hpp>
#include <boost/lambda/bind.hpp>
#include <boost/lambda/if.hpp>

using namespace boost::lambda;

    std::for_each(
        vs.begin(), vs.end(),
        if_(bind(&Shape::IsVisible, _1))
        [
            bind(&Shape::draw, _1, graph)
        ]
    );

或者BOOST_FOREACH

BOOST_FOREACH(Sharp* s, vs)
{
    if (s->isVisible())
        s->draw(graph);
}

-----------------------------------------------------------------
switch也有
std::for_each(v.begin(), v.end(),
  (
    switch_statement(
      _1,
      case_statement<0>(std::cout << constant("zero")),
      case_statement<1>(std::cout << constant("one")),
      default_statement(cout << constant("other: ") << _1)
    ),
    cout << constant("\n")
  )
);



    std::for_each(
        vs.begin(), vs.end(),
        if_(_1->* &Shape::IsVisible)[
            bind(&Shape::draw, _1, g)
        ].else_[
            bind(&Shape::draw_hide, _1, g)
        ]
    );

-----------------------------------------------------------------
namespace {            //匿名名字空间
    struct Process {
        void operator()(Sharp* s, Graphics* graph) {
      if(s->IsVisible())
          s->draw(graph);
      else
          s->draw_hide(graph);
        }
    };
}

for_each(vs.begin(), vs.end(), bind2st(Process(), graph));
