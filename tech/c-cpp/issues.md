# C/C++ 里的那些事
[TOC]

## 常量
const int的常量可以作为静态数组的大小
因此，const 变量和宏都可以取消魔数，推荐使用const

## 字符串
### 数值 与 字符串 互转
#### C 标准库函数
```
#include <cstdlib>
int atoi (const char * str);
long atol (const char * str);
double atof (const char* str);

long strtol (const char* str, char** endptr, int base);
unsigned long strtoul (const char* str, char** endptr, int base);
double strtod (const char* str, char** endptr);

#include <cstdio>
int sscanf (const char * s, const char * format, ...);
int sprintf (char * str, const char * format, ... );
int snprintf (char * str, size_t n, const char * format, ... );
```
+ 字符串转数字：忽略开头的空格，而后按目标数值类型进行解析，直到解析失败后返回，如果没有发现数字则返回0。
推荐使用strtol，其中endptr是输出参数，返回指向解析失败位置的指针（如果是NULL，表示不要该返回），base是解析整数的基数（2 到 36，0 表示根据字面值自动判断基数）
另外，如果解析溢出，则返回在 `<climits>` 头文件中定义的最大或最小值，并设置 errno 为 ERANGE.（这一点比atol健壮）
此外，还可以使用sscanf，用法和 [scanf](http://www.cplusplus.com/reference/cstdio/scanf/) 一致，只不过不是使用stdin，而是字符串 s 进行变量赋值。
+ 数字转字符串：和[printf](http://www.cplusplus.com/reference/cstdio/printf/)用法一致，只不过将格式化的字符串保存在str中
另外，需要确保str有足够的空间，以避免缓冲溢出的风险，如果无法保证可以使用snprintf这个更为安全的版本。该函数的参数n，是str的buffer size，那么，将至多填充 n-1 个字符，但。也就是说，无论返回负值还是 >= n 的值都是失败的返回值。
可以使用%d、%x、%o 对应10、16、8进制转换.
返回：
成功，则返回欲写入str中的字符数（不包括尾`\0`字符）
失败，则返回一个负值

其他函数：
ecvt、fcvt、gcvt：为了兼容旧代码
itoa：非标准的C 扩展，主要在Windows平台使用，不能跨平台
#### C++ stringstream方法
```
#include <sstream>
std::istringstream iss(str);
TYPE tmp;
iss >> tmp;
return tmp;

std::string result;
std::ostringstream oss;
oss << a;
result = oss.str();
```
#### C++11
使用-std=c++0x或-std=c++11编译选项
```
std::to_string(val);
int std::stoi(std::string str, size_t* idx=0, int base=10);
stol
stoul
stoll
stoull
stof(s,p)
stod
stold
```
val 是待转换的值类型（所有的整数和浮点类型）

忽略开头的空白符，识别直到遇到第一个非法数字或到达字符串结束时结束，不能转换将抛出`invalid_argument`异常，如果转换得到的数值无法用任何类型表示，则抛出`out_of_range`异常
str 是待转换的字符串
idx 是输出参数，如果不是nullptr，就被赋值为字符串中解析终止的位置（即第一个非法数字的位置）
base 是str表示的基数，如果是0，表示根据格式识别进制，因为内部通过调用strtol实现转换，所以这个规则和strtol一致。
#### boost
```
#include <boost/lexical_cast.hpp>
using boost::lexical_cast;

int n = lexical_cast<int>(s);
double d = lexical_cast<double>(s);
std::string s = lexical_cast<string>(a);
```
内部是使用 stringstream 实现的，当对格式和和精度有较高要求时，最好函数使用stringstream。如果只是数值转换，推荐使用 `numeric_cast`.
使用限制：
1. 使用字符串进行转换，该字符串必须被完整转换，不能含有非法字符，即使是在字符串的尾部；
2. 转换的源类型必须支持 << 输出流运算符；目标类型必须支持 >> 输入流运算符；
3. 源类型和目标类型都必须有拷贝构造函数；
4. 目标类型必须有默认构造函数。
如果转换发生意外，将抛出一个 `boost::bad_lexical_cast` 异常。
为了对上面第1点进行弥补，以确保当一个C 串进行部分转换时的复杂性，可以使用`lexical_cast<int>(s, n)`，参数n 表示截取字符串s 的前n 个字符进行转换。


## 一些运算符
### namespace 和 ::
`::` 这个运算符有点像是Unix目录系统中的斜杠（/）
对于每个标识符总是在一个namespace里，而解析这个标识符就有赖于它所在的namespace和引入的namespace
**注意**，对于任何一个标识符，如果不以::开头，则是相对空间的表示，编译器会从当前所在空间开始，向外逐级解释这个标识符的namespace，如果解释不通则报错
举个例子：在::imp::temp::ver的namespace中引用了temp::ver的namespace，那么引用的这个namespace实际上还是::imp::temp::ver，即使实际上存在一个::temp::ver这样一个namespace，所以想要避免这种相对空间的问题，就要使用绝对空间进行引用，即以 :: 开头来引用namespace，表示始自于根namespace。因为，声明于全局空间的任何标识符都属于这个根namespace

### typedef的用法
在一个变量的声明前，加上typedef，就把变量的声明变为一种类型的别名声明，而这个类型就对于了该变量的类型
**特别的**：函数指针也是一种变量，只不过需要使用括号限定和`*`修饰函数指针变量名
*另*：C++11 的using用法可以替代typedef


