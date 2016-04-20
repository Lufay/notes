[TOC]
# Google Test
Google开源C++单元测试框架
[开源项目地址](https://github.com/google/googletest)

## 编译
### 直接编译
```
g++ -isystem ${GTEST_DIR}/include -I${GTEST_DIR} \
    -pthread -c ${GTEST_DIR}/src/gtest-all.cc
ar -rv libgtest.a gtest-all.o
```
得到的libgtest.a就可以用于联编你的测试代码了：
```
g++ -isystem ${GTEST_DIR}/include -pthread path/to/your_test.cc libgtest.a \
    -o your_test
```

### sample 编译
`${GTEST_DIR}/make/Makefile` 可以编译出 lib 库和 sample 的测试样例
因此，也就可以直接 make TARGET 获得lib 库：
```
make gtest_main.a
make gtest.a
```
联编前者的测试代码可以不必写main() 函数，而后者需要自己写（前面直接编译得到的 libgtest.a 就是 gtest.a 差别只是 gtest.a 没有-pthread。

### 使用CMake
CMake 是一个跨平台的编译、安装工具，通过编写CMakeLists.txt，可以控制生成的Makefile，从而控制编译过程。
```
mkdir mybuild       # Create a directory to hold the build output.
cd mybuild
cmake ${GTEST_DIR}  # Generate native build scripts.
```
如果也要编译 sample，可以使用下面的命令替换上面：
```
cmake -Dgtest_build_samples=ON ${GTEST_DIR}
```

## 使用
测试代码要使用头文件：
```
#include "gtest/gtest.h"
```
而后使用 TEST 宏构造case：
```
TEST(TestSuiteName, TestCaseName) {
    // ...
}
```
如果联编`gtest_main.a`库，则无需`main()`，而如果联编的是`gtest.a`，则还需要自己写：
```
int main(int argc, char *argv[]) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();     // 若所有测试成功返回0，否则返回1
}
```

### 使用断言
`EXPECT_*` 宏失败时，case继续往下执行
`ASSERT_*` 宏失败时，直接在当前函数中返回，当前函数中`ASSERT_*`后面的语句将不会执行

断言返回的是一个 ostream& ，所以可以跟 `<<` 输出更多内容

下面就以`EXPECT_*`系列为例介绍各种断言
#### 布尔检查
```
EXPECT_TRUE(condition);
EXPECT_FALSE(condition);
```

#### 数值检查
```
EXPECT_EQ(expected, actual);
EXPECT_NE(val1, val2);
EXPECT_LT(val1, val2);
EXPECT_LE(val1, val2);
EXPECT_GT(val1, val2);
EXPECT_GE(val1, val2);
```

#### 浮点检查
```
EXPECT_FLOAT_EQ(expected, actual);		// almost equal
EXPECT_DOUBLE_EQ(expected, actual);
EXPECT_NEAR(val1, val2, abs_error);		// 差值不超过abs_error
```

#### 字符串检查
```
EXPECT_STREQ(expected_str, actual_str);     // 支持 char* 和 wchar_t*
EXPECT_STRNE(str1, str2);
EXPECT_STRCASEEQ(expected_str, actual_str); // ignoring case, 只支持char*
EXPECT_STRCASENE(str1, str2);
```

#### 异常检查
```
EXPECT_THROW(statement, exception_type);    // 抛指定类型的异常
EXPECT_ANY_THROW(statement);                // 抛任意异常
EXPECT_NO_THROW(statement);                 // 不抛异常
```

#### 谓词检查
```
EXPECT_PRED1(pred1, val1);          // 一元谓词 pred1(val1) == true
EXPECT_PRED2(pred2, val1, val2);    // 二元谓词 pred2(val1, val2) == true
...
```
最大支持5个

#### 自定义
```
EXPECT_PRED_FORMAT1(pred_format1, val1);
EXPECT_PRED_FORMAT2(pred_format2, val1, val2);
...
```
`pred_format1`是自定义的检查器，内置的有testing::FloatLE，testing::DoubleLE，自定义的例子如下：
```
testing::AssertionResult AssertFoo(const char* m_expr, const char* n_expr, const char* k_expr, int m, int n, int k) {
    if (Foo(m, n) == k)
        return testing::AssertionSuccess();
    testing::Message msg;
    msg << m_expr << " 和 " << n_expr << " 的最大公约数应该是：" << Foo(m, n) << " 而不是：" << k_expr;
    return testing::AssertionFailure(msg);
}

TEST(AssertFooTest, HandleFail)
{
    EXPECT_PRED_FORMAT3(AssertFoo, 3, 6, 2);
}

TEST(AssertFooTest, HandleFail)
{
	EXPECT_PRED_FORMAT3(AssertFoo, 3, 6, 2);
}
```

#### 类型检查
例子：
```
template <typename T>
class FooType {
public:
    void Bar() {
        testing::StaticAssertTypeEq<int, T>();
    }
};

TEST(TypeAssertionTest, Demo)
{
    FooType<bool> fooType;
    fooType.Bar();
}
```

#### 直接返回
```
SUCCEED();      // 直接返回成功
ADD_FAILURE();  // EXPECT_型的失败
FAIL();         // ASSERT_型的失败
```

### 事件
#### 全局事件
需要写一个继承testing::Environment类的类，实现 SetUp 和 TearDown 方法。而后将该类的一个实例通过 testing::AddGlobalTestEnvironment 方法进行注册（该方法可以注册多个这样的类）。例如：
```
class FooEnvironment : public testing::Environment
{
public:
    virtual void SetUp()
    {
        std::cout << "Foo FooEnvironment SetUP" << std::endl;
    }

    virtual void TearDown()
    {
        std::cout << "Foo FooEnvironment TearDown" << std::endl;
    }
};

int main(int argc, char *argv[])
{
    testing::AddGlobalTestEnvironment(new FooEnvironment);
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
```

#### TestSuite事件
需要写一个继承testing::Test的类，实现两个静态方法：
`static void SetUpTestCase()`：在一个TestSuite所有case执行前执行
`static void TearDownTestCase()`：在一个TestSuite所有case执行后执行
对应的，构造case需要使用`TEST_F`这个宏，TestSuiteName就是这个类的名字。

#### TestCase事件
同上，不过实现的是另两个方法：
`virtual void SetUp()`：在一个TestSuite每个case执行前执行
`virtual void TearDown()`：在一个TestSuite每个case执行后执行

### 参数化
用于需要列举或组合多种参数情况使用
1. 首先需要一个参数化的测试类，继承testing::TestWithParam<T>，其中T就是需要参数化的参数类型
2. 编写caes 模式，使用`TEST_P`宏，使用`GetParam()`获取到当前的参数值
3. 参数测试的范围，使用`INSTANTIATE_TEST_CASE_P(casePrefix, TestSuiteName, ParamGen)`宏，其中casePrefix是case前缀，可以任取；TestSuiteName是前面参数化测试类的类名；ParamGen是参数生成器，内置了：
	1. `testing::Values(v1, v2, ..., vN)`：枚举参数值
	2. `testing::Range(begin, end[, step])`
	3. `testing::Bool()`：true 和 false
	4. `testing::ValuesIn(container)` 和 `testing::ValuesIn(begin, end)`：container可以是 C 数组或STL容器，begin, end是迭代器
	4. `testing::Combine(g1, g2, ..., gN)`：g1, g2, ..., gN 每个都是一个参数生成器，每次从中各取一个值，组成一个Tuple作为一个参数，从而形成各种组合。（这个功能需要使用tr1/tuple，如果编译器没有提供该功能，gtest就会使用自己实现的一个简易的tr1/tuple）

#### 类型参数化
参见<http://www.cnblogs.com/coderzh/archive/2009/04/08/1431297.html>

### 死亡测试
程序是否能按预期方式挂掉
```
EXPECT_DEATH(statement, regex`);
EXPECT_EXIT(statement, predicate, regex`);
```
statement 是被测代码语句；
predicate 是一个委托，接受int参数，返回bool，判断其返回值为true时测试通过。
regex 是一个正则，用于匹配异常时在stderr中输出的内容
在使用TEST宏时，其第一个参数使用DeathTest后缀，因为死亡测试优先运行（为线程安全考虑）
内置predicate：
`testing::ExitedWithCode(exit_code)`：当程序正常退出，返回码为`exit_code`时，返回true
`testing::KilledBySignal(signal_number)`：当程序被信号`signal_number`中断，返回true
DEATH断言就是把predicate固定为判断进程是否以非 0 退出码退出，或被一个信号杀死。

在POSIX系统中，使用的是POSIX的正则，而在Windows系统中使用的是gtest自己实现的一个简易正则（不支持`() [] | {}`）

运行方式
+ fast方式（默认）
```
testing::FLAGS_gtest_death_test_style = "fast";
```
+ threadsafe方式
```
testing::FLAGS_gtest_death_test_style = "threadsafe";
```
可以在case里设置，也可以在全局设置（InitGoogleTest之后）

### 运行参数
有三种：
+ 系统环境变量
+ 命令行参数
+ 代码中指定FLAG

那个最后设置，那个生效，理想的顺序是：
> 命令行 > 代码 > 环境变量

为了达到这个顺序，代码中指定都要放在InitGoogleTest之前

例如对于命令行参数`--gtest_output`，在代码中可以设置
```
testing::GTEST_FLAG(output) = "xml:";
```
对应的环境变量为`GTEST_OUTPUT`

参数列表：
`--gtest_list_tests`：不执行case，而是列出其中的case
`--gtest_filter`：按TestSuiteName.TestCaseName对case进行过滤，支持特殊字符：`?` 匹配单个字符；`*` 匹配任意字符；- 表示排除；: 表示或
`--gtest_also_run_disabled_tests`：也执行被标记为无效的case（在TestSuiteName 或 TestCaseName 加前缀 `DISABLED_`就标记为无效，默认不执行）
`--gtest_repeat=[COUNT]`：设置重复执行次数，负数表示无限执行
`--gtest_break_on_failure`：在第一个错误发生时立即停止。
`--gtest_color=(yes|no|auto)`：输出结果是否显色，默认auto
`--gtest_print_time`：打印每个case的执行时间
`--gtest_output=xml:[PATH]`：将测试结果输出到XML中（PATH指定路径，默认是当前目录）


******
## 附 单测设计
每个case 确保独立性，即一个case 对环境的影响应确保在离开后恢复，而不至影响后面的case；case 之间也不要有依赖和顺序关系
好的习惯是把这些用例以层次结构的形式组织起来，并使用清晰的命名，使得我们通过阅读用例名称即可明了该用例的功能
对于优秀的测试，我们也期望做到在不同的操作系统、编译器间进行方便地移植


> 另：Google Mock
