# C 语言

## 一些标识符

NULL: 空指针（定义在sys/_types/_null.h中，包含在stdio.h 和 stdlib.h 中）
`__FILE__, __LINE__, __func__`: 当前的文件名（字符串），行数（整数），函数名（字符串）
`__STDC_VERSION__`: 代表C的版本，例如199991L 表示C99, 201112L 表示C11
`size_t`: sizeof 运算符的返回类型
`ptrdiff_t`: 两个指针相减运算的结果类型，是某个有符号整型
`wchar_t`: 宽字符类型，是一个整型

### const
```c
const int *p1;	// 常量指针（指向一个常量的指针: *p1 不可修改）
int const *p2;	// 等价于p1
int * const p3;	//	指针常量（固定指向的指针: p3 自身不可修改）
```

### volatile
忽略编译优化和寄存器缓存，每次访问都必须从内存读取

### restrict
`int * restrict p` 指在p 所在作用域中对目标对象的访问是独占的
非强制检查，用于编译器优化
<https://www.apiref.com/cpp-zh/c/language/restrict.html>

## 数据类型

### 数值型

#### bool
`<stdbool.h>`: 定义了bool 类型 和true (1) false (0)

#### 64位整型（C99 支持）
long long int 或unsigned long long int
在整数的后面加上‘LL’，后者则加上‘ULL’

#### 复数（C99 支持）
`<complex.h>`：包括复数类型，虚数单位，还有复数相关的数学函数
```c
float complex 
double complex cm = 1.3 + 2.3*I;	// I 虚数单位
long double complex
```

数值限制: `<limits.h>`和`<float.h>`中指定

### 数学计算
`<math.h>`
`<tgmath.h>` 将`<math.h>` 中定义的函数进行泛型化，通过宏扩展成对应的类型的函数

C11 还引入了`_Gerneric` 可以将一族相似功能的函数聚合成一个对外接口
```c
#define GENERAL_ABS(x) _Generic((x),int:abs,float:fabsf,double:fabs)(x)		// 根据x 的类型，匹配使用对应的函数

GENERAL_ABS(1);
GENERAL_ABS(1.1);

int a=10;
int b=0,c=0;

_Generic(a+0.1f,int:b,float:c,default:b)++;
```

### 字符 & 字符串
字符判断和转换: `<ctype.h>`
字符串: `<string.h>`

#### 宽字节字符
`<wchar.h>` 定义了宽字节字符类型`wint_t`（也是一种整数值）和对应的IO 和字符串操作
使用btowc 和 wctob 将其和对应整数（单字节字符）做转换
`<wctype.h>` 是`<ctype.h>` 对应的宽字节版本
C11 还有`<uchar.h>`: UTF8字符直接通过char来定义，字面量前缀使用u8; UTF16字符直接通过`char16_t`来定义，字面量前缀使用u, UTF32字符直接通过`char32_t`来定义，字面量前缀使用U

### 指针
void* 可以接受任何特定类型的指针，可以看做一种抽象的指针类型，但它不支持算数运算（++/+=等)，因为这些算数运算是以特定类型的字节宽度作为单位标度的

### 数组
#### 多维数组
越接近变量，维度越高，最高维度的长度可以省略
```c
int arr3[][2] = {{1, 2}, {3, 4}, {5, 6}};	// 内层的{} 可以省略
```

#### 复合字面值（C99 支持）
格式：`( type ) {  initializer-list }` 返回一个匿名对象，并用初始化列表完成初始化
可以用& 取其地址，所以也可以用这种方式用到标量类型上
字面值有点像const 常量，唯一的差别是使用& 取地址，是先分配一个匿名变量空间，然后初始化，而后将其地址返回
数组长度只能用常量表达式
若在文件作用域，则初始化列表只能使用常量表达式，该字面值具有静态生存期（全局数据区）；若定义在函数或块内，则具有块生存期（栈）
```c
int arr1[] = (int []){1, 2, 3};		// 长度为3，若指定arr1 长度需要与常量一致，即arr1[3]
int arr2[] = (int [10]){1, 2, 3};	// 长度为10，若指定arr2 长度需要与常量一致，即arr2[10]
```

#### 指定初始化（C99 支持）
```c
int a[6] = { [4] = 29, [2] = 15 };
int a[10] = { [1] = 1, [8 ... 9] = 10 };
```

#### 变长数组（C99 支持）
数组初始化长度可以使用变量
注：长度变量仅栈对象可以，即在函数内定义，文件作用域不行，也不能声明为static，也不能在作为结构体成员
```c
char str[strlen (s1) + strlen (s2) + 1];

int sum2d(int rows, int cols, int ar[rows][cols]);	// rows, cols 要先于ar[][]，但由于除最高维外不能省略长度，此时可以使用ar[][*] 用在声明位置
```

### 联合体
#### 指定初始化（C99 支持）
```c
union foo { int i; double d; };

union foo f = { .d = 4 };
```

### 结构体
#### 指定初始化（C99 支持）
```c
struct point { int x, y; };
typedef struct { int x, y; } Point;

struct point p = { .y = yvalue, .x = xvalue };  // 等价于 struct point p = { xvalue, yvalue };
Point p = { y: yvalue, x: xvalue };				// 也可以用冒号
```

#### 柔性数组成员（C99 支持）
结构体中的最后一个元素允许是未知大小的数组（不完整类型），柔性数组成员前面必须至少还有一个其他成员（即不能是唯一成员）
注意：
1. 包含柔性数组成员的结构体或联合体，不能成为数组的元素 或 结构体的成员（最后一个成员可以）
2. 柔性数组成员只作为一个符号地址存在，对包含柔性数组成员的结构体执行sizeof操作，返回的结构大小不包括柔性数组的内存，当然也不能单独对柔性数组成员执行sizeof 操作
3. 由于静态数组成员无法静态分配空间，所以只能用malloc

#### 复合字面值（C99 支持）
```c
Point point = (Point){2, 3}
Point *p = &(Point){2, 3}
```

## 函数
### 可变参数
```c
void func(int a1, double a2, ...);
```

### 数组参数修饰符
```c
void foo(int a [static 10]);		// static 告诉编译器该数组至少包含5个元素，可以进行相应的优化
```
如果使用restrict，指针是初始访问该对象的惟一途径。如果使用const，指针始终指向同一个数组。使用volatile没有任何意义。

### 内联函数（C99 支持）
在返回值类型前声明inline，替代含参宏
含参宏也支持可变参数，同样使用...，而后用`__VA_ARGS__` 替换...参数列表

通过`<stdarg.h>` 定义的函数访问变长参数列表
<https://scc-forge.lancaster.ac.uk/open/char/lang/valist>

### 库函数
`<stdlib.h>` 包括
整数运算
数值字符串转换
动态内存分配：使用 calloc 函数代替 malloc 函数，因为其分配空间时会自动初始化为 0，比 malloc 分配后再使用 memset 高效
随机数：rand() 最大返回为 RAND_MAX
算法库：二分查找bsearch、快排qsort、heapsort、mergesort、psort
环境交互：退出（EXIT_FAILURE, EXIT_SUCCESS）、system、环境变量

## IO
`<stdio.h>`
### 标准输入输出
不要使用gets，因为它并不检测字符串长度是否满足输入，会造成缓冲区溢出，C11 添加了一个可选扩展`gets_s`，可以限定最大读入字符数，如果超出就终止退出，但该扩展并非所有编译器都支持，所有目前最好用fgets(buffer, len, stdin) 替换，不过有个区别是gets 和`gets_s` 都会丢弃输入的换行符，fgets 不会

#### 字符串格式化
`int snprintf(char * str, size_t size, const char * format, ... );` 可以指定目的地str 的size，确保当格式化后的字符串长度大于等于size时，只将 (size-1) 个字符复制到 str 中，而后补充一个`\0`结束符，返回欲写入的字符串长度（即格式化后的字符串长度，不包括结尾的`\0`）。

### 文件输入输出
fopen() 新的创建打开模式"x"，用于表明其对于文件的独占。常常用于文件锁中。


## 线程（C11 支持）
`<thread.h>`
线程创建函数 `thrd_create`, 线程等待合并函数 `thrd_join`, `thrd_exit`
mutex 比如 `mtx_lock(), mtx_unlock()`
`_Thread_local`存储类型标识符

`<stdatomic.h>`
引入了原子类型的相关定义。其中 `_Atomic` 类型修饰符可以用于申明一个类型的相关读写操作是原子的。


## 时间相关
`<time.h>`


## assert
`<assert.h>`
assert(x): 断言x != 0（即bool 为true）
