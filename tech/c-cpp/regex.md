# 正则表达式

## GNU Regex Library
glibc(GNU C Library)的一部分，提供与POSIX标准兼容的正则表达式匹配的接口
[主页](http://www.gnu.org/s/libc/manual/html_node/Regular-Expressions.html)

### 头文件
```
#include <sys/types.h>
#include <regex.h>
```

### 接口
```
int regcomp (regex_t * compiled, const char * pattern, int cflags);
```
将正则表达式字符串pattern编译为一个正则表达式对象compiled
cflags是编译参数，使用默认可以设为0，还可以是以下值的组合：
`REG_EXTENDED`    使用ERE正则（默认使用BRE）
`REG_ICASE`       忽略大小写匹配
`REG_NOSUB`       不保存分组（默认保存，可以通过`compiled->re_nsub`获得保存分组的个数）
`REG_NEWLINE`     多行模式
如果成功返回0；否则，返回一个非0值，并可以使用regerror去获取错误信息。

```
int regexec (const regex_t * compiled, const char * str, size_t nmatch, regmatch_t matchptr[], int eflags);
```
使用编译好的正则表达式对象compiled对字符串str进行匹配
如果想获得分组信息，可以设置nmatch和matchptr两个参数（否则设为0和NULL），nmatch用于指定matchptr数组的长度，matchptr是一个保存分组信息的数组，如果足够长的话（nmatch >= 实际的分组数），索引0保存compiled整体匹配的子串，索引1、2、...保存其中各个分组的子串信息，其中子串信息是通过`regmatch_t`这个类型的两个域来确定的，`rm_so`是子串首的偏移，`rm_eo`是子串尾的偏移（在最后一个匹配字符之后的位置，如果已经到串尾则记为-1），他们是`regoff_t`类型（是int的别名）当一个分组因为计数的原因被匹配多次，那么最终保存的是最后一次匹配的位置。
eflags可以是以下值的组合：
`REG_NOTBOL`      不会把给定字符串首当做行首，而且也不会假定在给定字符串之前有任何内容
`REG_NOTEOL`      不会把给定字符串尾当做行尾，而且也不会假定在给定字符串之后有任何内容
如果成功匹配返回0；否则，返回一个非0值，并可以使用regerror去获取错误信息。

```
void regfree (regex_t *compiled);
```
释放对象

```
size_t regerror (int errcode, const regex_t * compiled, char * buffer, size_t length);
```
将regcomp 或 regexec 返回的错误码转换为错误信息保存到buffer，length是buffer的长度，如果长度不足会发生截断，返回值是错误信息所需的最小字节数。

## Boost.Regex
[主页](http://www.boost.org/doc/libs/1_61_0/libs/regex/doc/html/index.html)
