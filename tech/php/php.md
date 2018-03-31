# PHP
[TOC]

## 简介
PHP is Hypertext Preprocessor，可嵌入到 HTML中，尤其适合 web 开发
```
<?php
    php code
?>
```
运行于服务端，通过服务端的PHP解释器解析代码为HMTL文本返回给客户端。
HTML文本可以和PHP代码块相互穿插，完全可以把HTML文本，当做`echo 'HTML text'`的PHP语句。但穿插文本比echo更有效率。
而如果是一个纯PHP文件，建议去掉结尾的 `?>` 标记，这样就避免意外输出了该标记之后的空白内容
> 自 PHP 5.4 起，短格式的 echo 标记 <?= 总会被识别并且合法，而不管php.ini中`short_open_tag`的设置是什么。

### 语言特性
语句使用分号结束（除非是一个代码块的最后一行）

### 代码规范
PSR-0 autoload
PSR-1 基本代码规范
PSR-2 代码样式
PSR-3 日志接口
PSR-4 autoload补充
全局变量——`g_`打头
常量——大写+下划线
普通函数——小写+下划线
类名、方法名、变量——驼峰
花括号：
类、方法——自成一行
控制结构——同行
数组方括号：
赋值时，左括号和变量同行，右括号和变量首字符对齐
作为参数时，左括号独立成行，右括号和左括号对齐

### 注释
支持 `//` 、 `/*...*/` 和 `#` 的注释
#### 注释规范
文档注释是和被注释目标关联的，因此文档注释写在被注释目标之前（之间不要空行），格式如下：
```PHP
/**
 * Description          概要描述
 *                      用空行和下面分隔
 * detail               详细描述
 *                      同样用空行分隔
 * @author name <email> 声明作者和邮箱
 * @copyright Copyright (c) 2008 Yii Software LLC   版权信息
 * @license http://www.yiiframework.com/license/    证书
 * @version xx.xx       声明该文件、类型、函数加入的版本号
 * @var datatype xxx    描述类成员变量
 * @const               用于define定义的常量
 * @global datatype xxx 声明在函数中使用的全局变量
 * @static datatype xxx 声明使用的静态变量
 * @param datatype xxx  声明函数的参数
 * @return datatype xxx 声明函数的返回值
 * @throws              声明函数可能抛出的异常
 * @todo                声明应该改进或还没实现的内容
 * @deprecated          声明废弃
 * @link                声明一个链接或文档中的一个关键字（使用的函数、类、变量）
 * @see                 声明一个参考链接或文档中的一个关键字
 */
```

### 输出语句
+ echo不带换行，可以输出用逗号分隔的多个表达式（在输出时，这些部分会连接在一起），没有返回值
+ print不带换行，只能输出一个表达式，并返回1

#### 相关函数
+ printf ( string $format [, $args, ...] )：将格式化的字符串输出。
占位符格式：`%[填充字符][-][width][.precision]type`
其中
	- 填充字符默认是空格，也可以指定为0，但如果指定为其他字符必须使用 `'` 作为前缀
	- `-` 表示使用左对齐（默认右对齐）
	- width指定显示的最小字符宽度
	- precision指定小数点后保存的位数或显示的最大字符长度，
	- 最后的类型转换码支持 c（字符）s（字符串）b（整数二进制）o（八进制整数）x（十六进制整数）d（十进制有符号整数）u（十进制无符号整数）f（浮点数）e（指数形式浮点数）p（指针值）g（自动选择合适的表示法）；
	- 此外，还可以在%后使用1$、2$这种标识来指定使用第几个参数作为替换变量（如果使用双引号字符串作为format，则$需要转义，即1\$），这种指定位置并不会影响按序定位的顺序
+ vprintf ( string $format , array $args )：printf 的数组版本
+ `print_r ( $expression [, bool $return ] )`：可以打印数组和对象，默认返回TRUE，如果第二个参数为TRUE，则返回字符串
+ `var_dump ( $expression, ... )`：可以将多个表达式的的类型、值详细显示出来
+ `var_export ( $expression [, bool $return ] )`：打印对象的可解析字符串（该字符串是合法的PHP代码），默认返回NULL，如果第二个参数为TRUE，则返回字符串


## 数据类型
### 类型
#### boolean
true 和 false
不区分大小写

#### integer
支持10，16，8，2进制，[格式](http://php.net/manual/zh/language.types.integer.php)
不支持无符号数，最大值的常量是`PHP_INT_SIZE`

#### double（float是别名）
永远不要比较两个浮点数是否相等，如果确实需要更高的精度，应该使用[BC数学函数](http://php.net/manual/zh/ref.bc.php)或者[gmp 函数](http://php.net/manual/zh/ref.gmp.php)）

##### 相关函数
+ round()
+ abs()
+ `number_format($num, $dec=0, $dec_point='.', $sep=',')`：来自于Math库，格式化数字为小数点后dec位，还可以指定小数点和千位分隔符

*注*: 某些数学运算会产生一个由常量 NAN 所代表的结果，不应拿 NAN 去和其它值进行比较，包括其自身（都是false）应该用 `is_nan()` 来检查。

#### string
<http://php.net/manual/zh/language.types.string.php>
每个字符一个字节，最大2GB，不支持Unicode
字符串会被按照该脚本文件相同的编码方式来编码。不过这并不适用于激活了 Zend Multibyte 时；此时脚本可以是以任何方式编码的（明确指定或被自动检测）然后被转换为某种内部编码，然后字符串将被用此方式编码。注意脚本的编码有一些约束（如果激活了 Zend Multibyte 则是其内部编码）- 这意味着此编码应该是 ASCII 的兼容超集
变量可以直接置于字符串的双引号之内，不过单引号不行（类似shell，对单引号字符串不解析$和\）

##### heredoc
可以方便的书写多行文本
```
<<<theEnd
line1
line2
line3
theEnd
```
在<<<之后指定一个结束标记字符串，则当某行只有该字符串时（注意：连空白符也不能多），表示heredoc字符串的终止（类似双引号，也会解析变量）

##### 字符串连接
操作符为`.`：可以连接字符串和变量（转换为字符串）

##### 相关函数
+ strlen ( $str )：获得字符串长度（字节数）
+ `mb_strlen ( $str [, string $encoding = mb_internal_encoding() ] )`：获得字符串长度，多字节版本，可以指定字符串编码（多字节字符被记为1）
+ strpos ( $str , mixed $find, $offset = 0 )：返回从offset位置开始，$find在$str中首次出现的位置（注：如果$find不是string，那么就会将其转换为int，并视为字符的ASCII值），offset非负。如果找不到就返回false（为了和0返回值相区分，应使用===进行判断）不区分大小写的版本stripos、最后一次出现的版本strrpos和strripos
+ strcmp ( $str1 , $str2 )：区分大小写比较（按字典序）。反之strcasecmp
+ strnatcmp ( $str1 , $str2 ) ：区分大小写比较（按自然序，比如数字串按数字比较）。反之strnatcasecmp
+ `start_with($str, $needle) { return strpos($str, $needle) === 0; }`
+ `end_with($str, $needle) { $len = strlen($needle); if($len == 0) return true; return (substr($str, -$len) === $needle);}`

+ strrev( $str )：反转字符串
+ trim ( $str, $charlist = " \t\n\r\0\x0B" )：返回字符串两边的空白符去除后的字符串，可以通过指定第二个参数改变过滤的字符（默认是空格、制表、换行、回车、空字节、垂直制表）。从单侧滤除ltrim和rtrim（别名chop）
+ strtoupper ( $str )：转换为大写字母的字符串返回。
+ strtolower ( $str )：转换为小写字母的字符串返回。
+ ucfirst ( $str )：首字母大写返回。反之lcfirst
+ ucwords ( $str )：字符串每个单词的首字母大写返回。
+ addslashes ( $str )：对字符串中每个需要转义的字符前加上反斜杠进行转义
+ `nl2br ( $str, $is_xhtml = true )`：将\n或\r或其组合字符替换为`<br />`
+ strtr($str, $from, $to)：将$str字符串中出现在$from串中的字符替换为$to串中的对应字符（若$from和$to两个串不等长，则忽略多余字符。）
+ strtr($str, $replace_pairs)：$replace_pairs是对$str替换的映射表，和str_replace不同的是，strtr对已经替换的内容不进行二次匹配，另外，strtr会使用长key优先匹配。
+ `str_replace ( mixed $search , mixed $replace , mixed $subject [, int &$count ] )`：subject可以是字符串或数组，如果是数组则对每个元素进行字符串替换，返回一个数组。search也可以是字符串或数组，如果是数组，就进行多重查找。replace也可以是字符串或数组，如果是数组，且长度不小于search，则进行对应替换，如果长度小于search，则不足部分视为空串。如果search是数组，而replace是字符串，则都用replace进行替换。count设置为替换发生的次数，默认全部替换。不区分大小写的版本`str_ireplace`
+ `substr_replace ( mixed $string , mixed $replacement , mixed $start [, mixed $length ] )`：$string可以是字符串或数组，如果是数组则对每个元素进行字符串替换，返回一个数组，此时，start和length如果是标量的话，就作用于数组中每个字符串，如果也是数组的话，则作用于数组对应的字符串。start支持负数倒数，length也支持负数倒数，表示替换结束的位置（不含该位置），缺省为到串尾，若为0，表示插入。

+ sprintf：将格式化的字符串返回
+ `str_repeat ( $str , int $n )`：返回str重复n次连接的结果
+ substr ( $str , int $start [, int $length ] )：提取str从start（从0计）开始长为length（默认到串尾）的子串，注意：若start为负数则表示倒数第几个，若start落在串外则返回false，length若为负数，表示str串尾的-length个字符将被忽略（如果start落在这部分，则返回空串）
+ strstr ( $str , mixed $find, $before = false )：在$str中查找$find，并返回$str中$find及后面的子串；若$before为true，则返回$str中$find之前的子串。若找不到则返回false。函数别名strchr。不区分大小写的版本stristr。反向查找的版本strrchr（不支持$before参数）
+ strtok ( $str , string $token )：使用$token对$str进行拆分，返回token左侧的第一组子串。$token可以是一个字符串，则其中每个字符都被当做定界符，即遇到任何一个都将被定界；不过，如果第一组子串为空时，则忽略重新找定界符。下次对该字符串调用该函数可以省去$str，则将继续上次位置进行下次拆分。如果上次拆分已经到达串尾，则继续调用strtok ( $token )将返回false
+ explode ( $delimiter , $str [, int $limit ] )：使用delimiter字符串作为边界点，将str分为最多limit个元素的数组（当limit为正时），最后一个元素包含分割剩下的部分。若limit为负时，则最后-limit个元素会排除在外；如果limit为0，将被视为1
+ implode ( [ string $glue ,] array $pieces )：将数组元素用glue字符串连接成一个字符串返回，glue默认是一个空串。函数别名join

##### 正则
ereg ( $pattern , $str [, array &$regs ] )：用大小写敏感的正则pattern匹配字符串str，并以左括号为标识，将各个匹配子模式的字符串填入填入数组regs中（0是整个pattern的匹配，1、2、3、...是各个子模式的匹配），返回匹配字符串的长度（如果没有传入regs参数或者匹配长度为0，则返回1），如果无匹配返回false。POSIX函数，PHP5.3后废弃，可以使用mb_ereg（用法一致，只不过返回的是匹配的字节数）或preg_match替代。不区分大小写的版本eregi（也已废弃，用mb_eregi或preg_match替代）
ereg_replace ( $pattern , $replacement , $str )：用大小写敏感的正则pattern匹配字符串str，用replacement替换被匹配部分后返回。replacement中可用使用\0、\1、...引用被匹配的子模式。 不区分大小写的版本eregi_replace（也已废弃，用mb_eregi_replace或preg_replace替代）
split ( $pattern , $str , $limit = -1 )：用大小写敏感的正则pattern作为定界，去拆分字符串str，返回拆分的字符串数组，如果指定limit，则最多拆分limit个，最后一个元素包含剩下的。POSIX函数，PHP5.3后废弃，可以使用 preg_split 代替。


#### array
数组，同时支持数字索引和关联数组，也支持异构类型在一个数组中（key只支持整数和字符串，可以使用浮点和bool，但会转换为整数）

##### 定义
数字索引从0开始，使用array('a', 'b', 'c')构造
关联数组使用array('a'=>1, 'b'=>2, 'c'=>3)构造
从PHP5.4开始，可以使用[]代替array()
将一个数组赋值给另一个数组，会连同数组内置指针位置也赋值，但两者独立

##### 访问
如果使用var[3]这种作为左值时，如果var这个变量未声明，则将视为创建这样的一个数组，如果已声明为一个数组，则视为动态添加元素或修改元素；而作为右值时，如果对应的索引未定义，则会报错

##### 多元赋值
可用list结构实现利用数组进行多元赋值，如：
list($a, $b, $c) =  array('a', 'b', 'c')
这样就可用将$a赋值数组索引为0的元素， $b赋值数组索引为1的元素....
此外，list还可以空缺元素，如list(, , $c)，这样就只取到数组索引为2的元素

##### 操作
`+`：联合，以左操作数为基准，添加右操作数的内容，拒绝键冲突
`==`：有相同的键值对，不关心顺序，反之!=或<>
`===`：有相同的键值对和顺序，反之!==

##### 相关函数
+ `count ( $var, $mode = COUNT_NORMAL )`：计算数组中元素个数或对象中属性的个数。函数别名sizeof
+ `array_key_exists($key, $arr)`：判断数组中是否有该键，一般使用isset($arr[$key]) 判断，因为性能更好，但当这儿键的值是null的时候，`array_key_exists` 返回true，而isset 返回false
+ `in_array($needle, $arr, $strict=FALSE)`：区分大小写，判断$needle是否在数组$arr中，若$strict为TRUE，则判断类型相同
+ `array_count_values ( $arr )`：返回一个关联数组，键为$arr中出现的值，值为每个值在$arr中出现的次数。（注意：如果数组的元素不是int或string则会抛出一个`E_WARNING`）

+ each ( $arr )：取出数组内置指针指向的当前元素构造成一个新的数组：索引0和'key'这个键的值为该元素的key，索引1和'value'这个键的值是该元素的value。而后数组指针后移一位，如果到达数组结尾，该函数返回false，数组指针停留在最后一个元素。
+ reset( $arr )：重置数组指针到第一个元素的位置，并返回其值。
+ end ( $arr )：将数组指针移到最后一个元素，并返回其值。
+ current ( $arr )：返回数组指针指向数组当前元素其值，但数组指针指向不变。当数组指针已经超出数组末端，返回false。函数别名pos
+ next ( $arr )：将数组指针前移一位后，返回当前元素其值。如果没有更多元素返回false
+ prev ( $arr )：将数组指针回移一位后，返回当前元素其值。

+ `array_push ( $arr , mixed $var... )`：数组尾端入栈多个元素
+ `array_pop ( $arr )`：将数组尾端一个元素弹出，数组为空则返回NULL（注：该操作也会reset数组指针）
+ `array_shift ( $arr )`：数组头一个元素弹出，数组为空则返回NULL
+ `array_unshift ( $arr, $var, ... )`：数组头插入多个元素
+ range ( mixed $start , mixed $limit, number $step = 1 )：创建从start到limit步进step的数组，常用数字和字符
+ `array_slice ($arr, $offset, $len)`：截取从$offset位置开始，长为$len的子数组，$offset若为负表示倒数，若$len为负，表示不要结尾的$len个元素
+ `array_splice ($arr, $offset, $len)`：和上面相反，去掉上面截取的部分，接合起来组成新shu'zu
+ `array_merge_recursive ( $arr, ... )`：递归合并一个或多个数组
+ `array_combine($arr_key, $arr_val)`：合并两个数组来创建一个新数组，其中的一个数组元素为键名，另一个数组元素为键值
+ `array_keys ($array, mixed $search_value = null, $strict = false ]] )`：返回数组的所有键（数字和字符串）组成数组。如果指定`$search_value`，则返回指定值的所有键，默认使用`==`做比较，strict为true 时，使用`===`
+ `array_values($array)`：返回数组所有值，组成数组。
+ `array_flip($arr)`：交换数组中的键和值，如果键类型不对，将出现一个警告，并且有问题的键／值对将不会出现在结果里。如果同一个值出现多次，则最后一个键名将作为它的值，其它键会被丢弃。

+ `array_reverse ( $arr, $preserve_keys = false )`：返回一个反序数组（对于关联数组总是保持关联的）。`preserve_keys`若为false，则数字键也会保持
+ `array_unique ($arr)`：数组去重后，返回新数组（每个值只保留第一个遇到的键名，按字符串比较）
+ `sort ( $arr, $sort_flags = SORT_REGULAR )`：将元素升序排列，返回成功与否。`sort_flags`可以是`SORT_REGULAR`（不改变类型比较）、`SORT_NUMERIC`（作为数字比较）、`SORT_STRING`（作为字符串比较）、`SORT_NATURAL`（已自然顺序进行字符串排序）。降序用rsort
+ `ksort ( $arr, $sort_flags = SORT_REGULAR )`：保持键值关联，对键排序。降序用krsort
+ `asort (  $arr, $sort_flags = SORT_REGULAR )`：保持键值关联，对值排序。降序用 arsort
+ `usort (  $arr , callable $cmp_function )`：可以自定义比较函数（使用函数名的字符串作为第二个参数，返回一个整数，如果两个元素比较结果=0，则它们在数组中的顺序未定；如果使用类的静态函数做比较函数，可以用`array("ClassName", "static_func_name")`做 第二个参数）。另外对应还有 uksort、 uasort
+ shuffle ( $arr )：随机打乱一个数组，返回成功与否

+ `array_walk ( $arr , callable $funcname, $userdata = NULL )`：用函数funcname作用于数组的每个元素，该函数以每个元素的值、键，以及$userdata作为参数，注意，如果想要对数组进行修改，函数的第一个参数需要使用引用（使用&在变量前）
+ `array_map`
+ `array_reduce`
+ `array_filter ( input, callback )`：通过callback指定的函数名（字符串），依次对input数组的每个值传给该函数，然后就回调函数返回true的成员组成数组返回（键名保留）。若未指定callback，就直接用数组元素进行判断。

+ `extract ( $arr , $extract_type = EXTR_OVERWRITE , $prefix = NULL )`：将数组的元素导入符号表中，成为变量，其中，元素的键作为变量名，元素的值作为变量的值。`extract_type`指定冲突的处理方法，`EXTR_OVERWRITE`（冲突覆盖）、`EXTR_SKIP`（冲突忽略）、`EXTR_PREFIX_SAME`（冲突加前缀prefix）、`EXTR_PREFIX_ALL`（统一加前缀prefix）、`EXTR_PREFIX_INVALID`（仅在非法变量名前加前缀prefix）、`EXTR_IF_EXISTS`（仅导入冲突，并覆盖）、`EXTR_PREFIX_IF_EXISTS`（仅导入冲突，并加前缀prefix）、`EXTR_REFS`（将变量作为引用提取数组中的值，该项可以和前面使用OR联用）。加上前缀prefix后会带上一个下划线。
<http://php.net/manual/zh/book.array.php>
<http://justcoding.iteye.com/blog/1181962/>


#### object

#### NULL
未被赋值或已被unset的变量

#### resource
特定的内置函数（如数据库函数）返回resource类型的变量，代表外部资源，这种变量无法直接操作，是一个标识资源的句柄

#### 时间
**注：如果返回的时间和本地时间不同，可以修改php.ini中的date.timezone = PRC 或 date.timezone = Asia/Shanghai
如果没有权限修改php.ini，则可以使用下面的date_default_timezone_set函数**
+ time()：返回当前时间戳（从 Unix 纪元（格林威治时间 1970 年 1 月 1 日 00:00:00）到当前时间的秒数）
+ date( $format [, $timestamp = time() ] )：format是格式字符串，其中特定字符为：Y是4位年份，F是月份全称，M是月份简称，m是2位月份，n是1位月份，d是2位月内日期，j是1位月内日期，l是星期全称，D是星期简称，N星期编号（1-7），w星期编号（0-6），z是年内日期（0-365），S是序数后缀，如“th“，H是2位24小时制的小时，i是两位分钟，s是两位秒。timestamp是转换的时间戳，返回其格式化字符串。
+ strftime( $format [, $timestamp = time() ] )：格式化字符串中的特殊字符与上面不同：%Y是4位年份，%B是月份全称，%b是月份简称，%m是2位月份，%d是2位月内日期，%e是1位月内日期，%A是星期全称，%a是星期简称，%u星期编号（1-7），%w星期编号（0-6），%j是年内日期（001-366），%H是2位24小时制的小时，%M是两位分钟，%S是两位秒。timestamp是转换的时间戳，它的好处是可以使用setlocale函数得到相应语言的月份名称，而且大部分可以和C库通用，返回格式化时间字符串。
+ getdate( [ $timestamp = time() ] )：返回时间的关联数组，key有“seconds”, “minutes”, “hours”, “mday”(月内日期), “wday”（星期0-6）, “mon”, “year”, “yday”（年内天数）, “weekday”（星期全称）, “month”（月份全称）,0（时间戳）
+ mktime( $hour=date(“H”), $minute=date(“i”), $second=date(“s), $mouth=date(“n”), $day=date(“j”), $year=date(“Y”), $is_dst=-1 )：返回给出时间的Unix时间戳，$is_dst若为1，表示夏时制，0表示不是，-1表示未知（PHP自己获取）；若给定的值超过范围，mktime可以自动进位。
+ strtotime( $str_time [, $timestamp = time() ] )：将文本描述的时间解析为Unix时间戳，文本中，日期（年月日）可以使用 - 或 / 分割，时间（时分秒）可以使用 : 或 . 分割，日期和时间之间可以用空格分隔，相对时间now，today，yesterday，tomorrow，midnight，noon，+/-5 days，second mouth，2 days ago；$timestamp是相对时间的基准
+ date_default_timezone_set('UTC');：如果调用date函数出现关于该函数不安全的警告，提示要求设置date.timezone，就调用本函数进行设置（另：'prc'）。

##### DateTime 类
class DateTime($str_time="now")
###### 方法
setDate($year, $month, $day=1)
setTime($hour, $minute, $second=0)
setTimestamp($unixts)
format($format)：同date()函数
modify($str_time)：同strtotime()函数
add($interval)：$interval是一个DateInterval对象
sub($interval)：
diff($dt)

##### DateInterval 类
class DateInterval($str_interval)：$str_interval字符串以P打头，数字后跟YMDWHMS表示各种时间间隔（其中W和D不联用），日期和时间之间以T分隔。内部ymdhis每个字母都是其属性，可以访问。也可以用该类的createFromDateString静态函数将文本描述的时间间隔转换为该类型。


### 类型判断
+ `is_*`类函数
除了上述每种类型都有其类型判断函数外，还有
`is_scalar()`判断是否是四种标量类型（布尔、整型、浮点、字符串）
`is_numeric()`：判断是否是数值类型或数字字符串
`is_callable()`判断是否是有效的函数名称
isset()判断指定的这些变量是否都存在（检查是否是NULL）（可变个数参数）
`is_null()`检查是否为NULL
+ empty()：检测一个变量是否存在，以及它的值是否是非空（空串、空数组）和非0（0，false，”0”,），是为false，否则为true

#### is_callable 支持的场景
函数名字符串（如果在namespace中，需带有完整的namespace路径）
[类名字符串, 静态方法名字符串]
[类的一个实例, 该类的一个方法名字符串]（该方法可以是用`__call($name, $args)`魔术方法生成的）
类的一个实例（该类需有`__invoke()`这个魔术方法）
匿名函数

类似：
`function_exists(string functionname)`
`method_exists ( object object, string method_name )`
`call_user_func`
`call_user_func_array`


### 类型转换
#### 自动转换
当需要一个布尔值的时候，会自动转换：
integer的0
double的0.0
空串和'0'
空数组
NULL
将被转换为false，其他的都是true。

整数溢出将转换为double

#### 显式转换
(type)var

#### 相关函数
+ gettype ( $var )：获得变量类型的字符串表示，如果类型非标准类型，则返回unknown type
+ settype ( $var, $type )：将变量的类型设置为指定类型（返回bool）
+ intval ( $var, $base=10 ) ：转换为int，可以指定进制base（var的进制通过查看其是否有0或0x的前缀）
+ floatval ( $var )：函数别名doubleval
+ boolval ( $var )：
+ strval ( $var ) ：


## 运算符、表达式、语句
### 变量和常量
变量名区分大小写
函数名不区分大小写

赋值运算符，和C一样，赋值表达式的值是被赋予的值

unset ( $var )：销毁变量

`define('CONST_VAR', 434)`：定义一个常量`CONST_VAR`，值为434（只能是4种标量类型），引用常量不需要$（返回成功与否的布尔值）
`defined('CONST_VAR')`：检查一个常量是否已设置

#### eval
可以直接使用字符串作为变量名（类似shell）：
```
echo $hhhh."\n";
$a = 'hhhh';
$$a = 43;
echo $hhhh."\n";
```

eval($str)：把字符串当做PHP 代码执行，$str 必须使用分号结尾。如果字符串代码中没有return，则返回NULL，如果代码解析错误，返回false。该函数存在安全问题。

#### 作用域和生命期
+ 函数中声明的变量，只在函数中可见；除非给以global进行修饰，则该变量获得文件级作用域
+ 函数外声明的变量在整个脚本文件中（函数体内除外）可见
+ 内置超级全局变量（如`_GET`、`_POST`数组）和常量全局可见
+ 函数内创建的静态变量，外部不可见，但有静态的生命期

注意：函数内是无法引用外部变量（如果赋值的话，相当于声明一个新的局部变量），除非在函数内使用global来声明该变量，来可以引用。

##### 超级全局变量
`GLOBALS`：所有全局变量数组（就像global关键字）
`_SERVER`：服务器环境变量数组，比如`$_SERVER['DOCUMENT_ROOT']`指向Web服务器文档树的根。
`_GET`：通过get方式转发给该脚本的表单变量数组
`_POST `：通过post方式转发给该脚本的表单变量数组
`_COOKIE`：cookie变量数组
`_REQUEST`：所有用户输入的变量数组（含`_GET`、`_POST`和`_COOKIE`所包含的输入内容）
`_FILES`：与文件上传相关的变量数组
`_ENV`：环境变量数组
`_SESSION`：会话变量数组
`__FILE__`：当前文件的完整路径
`__DIR__`：当前目录的完整路径，即dirname(`__FILE__`)
`__LINE__`：当前行号
`__CLASS__`：当前类的类名、
`__NAMESPACE__`：当前的名空间，全局环境则返回空串
`__METHOD__`：当前方法
`__FUNCTION__`：当前函数
##### 表单变量（全局的）
下面的`var_name`，就是表单输入框指定的name属性
`$var_name`：需要配置`register_globals`为on（默认为off），这种风格常用于自定义变量，易混淆，不推荐
`$_POST['var_name']、$_GET[]、$_REQUEST[]`：推荐使用，数组形式，前两种受限于表单数据的转发方式，而第三种则不限，提交的所有数据都可以使用其检索
`$HTTP_POST_VARS['var_name']`：已废弃的用法
自定义变量使用前必须初始化，而表单变量则不必

### 算术运算符
同C，支持自增自减
当有字符串参与时，会试图将字符串转换为一个数字（从字符串开始处查看是否是数字，遇到e或E被视为科学计数法，不过指数只支持整数，直到遇到第一个不合理的字符停止转换，如果不是数字开头，则视为0

### 比较运算符
==会进行类型转换为一致再比较，反之是!=或<>
===直接进行比较，如果类型不一致则直接false。反之是!==
不能将四种标量类型和数组进行比较

### 逻辑运算符
返回布尔值
既支持C的符号!、&&、|| （优先级从高到底排列）
也支持文字式的and 、xor、or（优先级从高到底排列），只不过优先级较低（仅仅高于逗号，也就是说低于赋值）
具有短路求值特性，如果不想要该特性，可以对每个值强转为(bool)，而后使用 min() 函数替代 and，使用 max() 函数替代 or。

### 位运算
从高到低：<< >> & ^ |

### 三目表达式
三目表达式的中间那一目可以不写，那么将使用第一目作为返回（这样就避免了两次求值的问题）

### 逗号运算符
优先级最低

### 取引用运算符&
直接的变量间赋值是值传递，而对变量取引用后再赋值，则将指向同一副本
解引用使用unset()函数，使用该函数，将使引用计数-1
& 可以用于一切赋值的右值上，只不过，new自动返回的就是一个引用（对象间的赋值都是引用传递，因此，才有clone语句），无需在使用&
& 作用于一个未定义的变量之上时，将创建该变量
（说明：即使不使用引用，也不会因为数据拷贝而性能变差，因为Zend核心采用的是COW，写时拷贝的策略，也就是说，只要不改写，实际上指向的都是同一份数据）
（注意：如果一个数组中某个成员被引用了，那么该成员就不再是值存储，而是引用存储，于是当拷贝这个数组时，会一并把引用也给拷贝走了，也就是说，拷贝了一个引用）

### instanceof
检测一个变量（左侧）是否是一个类（包括其派生类）或接口（右侧）的实例。

### 执行运算符反引号``` `` ```
两个反引号内的命令会被当做服务器端命令来执行，表达式的值就是命令执行的结果（类似shell，命令也同样是shell命令）

### 错误抑制操作符@
可以用在任何有值的表达式前，将抑制该表达式可能产生的错误警告。一旦遇到一个警告，就要写一些错误处理代码。如果PHP配置文件中的`track_errors`特性被启用，错误信息将保存在全局变量`$php_errormsg`中

### 优先级
+ 优先级
逗号 < 文字式的逻辑运算符 < print（比echo慢） < 赋值类 < 三目 < 双目逻辑符 < 位逻辑 < 等价判断 < 比较判断 < 移位  < `+-. < */%` < 单目运算符和类型转换 < 数组[] < new < 函数调用()
+ 结合性
除单目和[]外都是左结合

### 语句
和C相同的 if 结构，不过 else if 可以连写为 elseif
和C相同的 switch-case 结构（当然也需要break），不过，switch的表达式支持所有标量类型
和C相同的 while和for 结构，此外，还有为遍历数组的 foreach 循环
和C相同的 break和continue 结构，不过，后面还可以跟上一个整数，以表示跳出的层数，默认是1；此外，如果想结束整个脚本的执行，可以使用exit语句

```
foreach( $arr as $var ) {        或        foreach($arr as $key => $value) {
    // block
}
```
$arr 除了可以使用数组外，还可以使用对象，则将遍历对象的所有公有属性
如果要使用引用：
```
foreach($arr as &$var)
```
但要注意的是，在使用完以后，需要unset($var)，否则引用一直存在

#### 分离模式
PHP还提供了类似shell的结构，即不适用花括号
用冒号（:）表示块结构开始
用endif、endswitch等等表示块结构的结束，不过endxxx这种语句后面同样需要使用分号结束
*注：do...while没有这种结构*

### declare
```
declare ( directive );		//作用于下面全部代码，如果被include，则不会作用到父文件

declare ( directive ) {		//作用于block 中的代码
    // block
}
```
directive 常用的有
+ ticks=N：Zend引擎每执行N条低级语句就去执行一次 `register_tick_function()` 注册的函数。
`register_tick_function()`，第一个参数是注册的函数（可以是函数名字符串），更多的参数是传给这个注册函数的参数
+ encoding
+ `strict_types=1`：严格类型校验模式，必须是文件的第一个语句。


## 函数
### 定义函数
```
function func_name($a, $b) {
    //  block
    return 0;
}
```
参数默认以值传递，想要以引用传递，可以在参数声明前加上&；如果要将返回值也用引用返回，则需要在函数定义时，在函数名前加上 &，并且，在函数调用时，在调用表达式前加上&。（注意：如果要用引用返回，则返回必须是一个变量，而不能是一个表达式）
不支持重载
支持默认值设置（自右而左给出）
支持可变参数（参数表中给出的参数仅仅表示必选参数，可以给以更多的参数，这些参数都可以通过func_num_args()获得总个数，通过func_get_args()获得参数数组，以及通过 func_get_arg($n)来获得对应的参数（n从0计）。
支持递归调用

### 函数调用
脚本内可见
在函数调用时，函数名可以使用变量给出
每个参数前可以指定类型，则在调用时，必须受限于指定类型，否则将产生Fatal error（是使用instanceof进行的检测）

#### 回调
`call_user_func_array ( callable $callback , array $param_arr )`：把数组作为回调函数的参数进行调用

### 匿名函数和闭包
可以不写`func_name`，就表示一个匿名函数，可以将其赋值给一个变量，或者作为参数传递。
定义一个匿名函数可以使用当前域内的变量（闭包），通过use语句，使用的值就是定义匿名函数位置的值（不是调用匿名函数的位置），不过，可以通过use一个引用来保持实时更新，如：
```
$func = function () use (&$outer) {
    // block
};
```

`create_function ( string $args , string $code )`：给出参数列表和执行代码，返回一个唯一的名字。内部执行eval()，因此也有着eval的安全问题，而且性能和内存效率都不好，php5.3后有新的匿名函数表示


## 对象和类
### 接口
```
interface itfc
{
    function operation();
}
```
实现一个接口必须实现其所有方法。

### 类
#### 定义
```
class class_name [extends base_class] [impements itfc, ...]
{
    public $a = "default value";
    protected $b;
    private $c;
    const d = 343.535;                            //类常量，用 class_name::d 访问
    function __construct($param) {        //没有指定访问控制，默认是public
    }
    function __destruct() {
    }
    function __set($name, $value) {
        if ( $name == "c" && ...... )
            $this->$name = $value;            //注意：在使用->运算符时，后面的标识符前是不带$的，但是，这里是通过$name动态获取访问的标识符名，故需要带$
    }
    function __get($name) {
        if ( $name == "c" && ...... )
            return $this->$name;
    }
    function op_a($param) {
        $this->c = $param;
    }
    static function op_b($param) {        //静态方法，用 class_name::op_b() 调用
        // 不能使用 $this
    }
}
```
可以手动调用构造函数

类内调用：
new self()：在类内构造一个当前对象类的实例
new static()：在类内构造一个当前类的实例

#### 实例化、调用
```
$obj = new class_name("aa");

$obj->a = "bb";
```
public 可以直接进行变量访问；如果无法直接访问，但如果类定义了`__set`函数，则该赋值语句将隐式调用`__set`函数；如果类定义了`__get`函数，则该取值将隐式调用`__get`函数。

##### 方法的调用前缀
1. 类外
`$obj->`：非转发
`class_name::`：非转发
1. 类内
`$this->`：非转发（$this指实例化的对象）
`self::`：指代码定义位置的类（比如调用从父类继承的方法，self指的是父类）
`parent::`：指代码定义位置的父类（比如调用从父类继承的方法，parent指的是父类的父类）
`static::`：代码执行位置的类（比如调用从父类继承的方法，static指的是当前子类）

##### 动态方法
定义`__call($method, $param)`方法，$method可以给出动态方法名，而$param则是传递给该方法的数组，于是，在`__call`的内部，可以通过识别$method，将参数转给某个方法处理。有了这些，就可以使用`$obj->$method(...)`进行调用了（注意：动态方法不能和现有方法重名）

#### 克隆
对象克隆：$another = clone $obj;，该语句会浅拷贝对象，如果对象的类定义了`__clone()`方法，则会调用之来进行修正（比如对象成员的clone）。

#### 字符串化
转换为字符串，调用类的`__toString()`方法

#### 继承
支持继承的属性默认值重定义和函数重写（由于默认调用子类重写的方法，故若要调用父类的方法使用`parent::op_a();`），可以使用final修饰方法，禁止重写，final还可以修饰一个类，禁止继承。
不支持多继承
访问控制在继承体系中不能窄化，但可以更大
注意，和C++不同的，如果在父类`$this->foo()`，this指向一个子类对象，而foo是一个在父子类都实现了的公有方法，那么，可以正常调用子类方法，而如果foo是一个私有方法，那么就只能调用父类方法，因为在父类的上下文中看不到子类重写了这个方法。

#### 抽象类
有抽象方法的类就是抽象类
抽象方法是用abstract修饰方法，不实现。有抽象方法的类也必须用 abstract修饰

#### 反射
```
new ReflectionClass(class_name)
```
返回一个类的类型实例

##### 相关函数
`method_exists ( $obj , string $method_name )`：检查指定的方法是否存在于指定的对象中
`property_exists(class, property)`: class是类名字符串（含namespace的全名）或一个对象，property是属性名字符串。该函数只能知道指定类有无指定属性，而不能确定其在当前位置的可访问性（public和private都可以确定，但protected不行），另外使用`__get()`魔术方法创建的属性也无法获知。


## 模块
### 名字空间
#### 定义
```
namespace A\B\C;
```
将作用于整个文件
和目录结构很像，`\`表示全局名空间，`..` 表示上层名空间，不以`\`开头的标识符会首先尝试解析为相对于当前名空间的标识，找不到再去全局名空间中找
虽然任意合法的PHP代码都可以包含在命名空间中，但只有三种类型的代码受命名空间的影响：常量、函数、类。（这里的常量指的是用const修饰方式定义的常量，eg const OK=1，如果用define方式定义的常量则和当前名空间没有关系，而是需要指定所属名空间，如果没有指定则属于全局名空间，eg:define('test\AA', 35)，即常量AA属于test这个名空间中。此外，const定义的常量不能在函数体中，可以在类或全局域内，而define则没这个要求 ）

如果一个文件中包含命名空间，它必须在其它所有代码之前声明命名空间。 在声明命名空间之前唯一合法的代码是用于定义源文件编码方式的 declare 语句。另外，所有非 PHP 代码包括空白符都不能出现在命名空间的声明之前。
允许将同一个命名空间的内容分割存放在不同的文件中，也允许一个文件定义多个名空间（并不提倡）：
格式1 （不推荐）
namespace A;
// block
namespace B;
// block
格式2（如果要在含有名空间的文件中，包含全局名空间，只能使用此种，此时，使用一个匿名名空间就表示全局名空间，即去掉下面的B）
namespace A {
    // block
}
namespace B {
    // block
}

#### 使用
namespace关键字还可以直接用于namespace\func()，则其表示当前名空间中的func()函数
注：导入名空间的use语句紧跟namespace，在大括号之外
```
use a_namespace\b_namespace\c_namespace as abc;
```
除了可以导入一个名空间外，还可以导入一个类，但不能导入函数和常量（注意：导入并不会加载这个类，因为编译期执行导入），导入多个用逗号分隔
use语句中不能使用上面的名空间缩写，此外，也不能对名空间缩写的字符串进行解析（必须使用全名）


### 导入其他文件
并不会导入名空间，名空间需要使用use导入
```
require/ include filename
```
如果filename带有路径，则到指定位置去找文件；否则，则到include_path指定的目录去找，若没有才到脚本所在目录和当前工作目录下去找。如果找不到，require会产生E_COMPILE_ERROR 级别的错误导致脚本中止，而include只产生警告（E_WARNING），脚本会继续运行。
导入文件中的文本将直接输出到标准输出中，PHP代码则会进行解析，其中的代码继承该语句所在行的变量作用域，即 从该行以后，被导入文件中定义的变量视为在该行定义的变量（不过，被导入文件中定义的函数和类则具有全局的作用域）。任何在该行可用的变量都可以在被导入的文件中使用。
尽管该语句并不会检测导入文件的文件名，但如果该文件不是以.php作为扩展名，并且保存在Web文档树中，用户可以在浏览器中直接载入它们，即以文本形式查看到源码，所以要么，就将这种文件保存在文档树之外（推荐），或者以标准文件扩展名保存。

**被导入的脚本使用return语句并不会导致导入结束，依然会继续执行导入脚本的后续代码，而这个return的值可以从require这里返回接收，常用于导入配置（return array()）**

incluce在用到时加载
require在一开始就加载
不同之处在于：对include()语句来说，在执行文件时每次都要进行读取和评估；而对于require()来说，文件只处理一次（实际上，文件内容替换require()语句）。这就意味着如果可能执行多次的代码，则使用require()效率比较高。另外一方面，如果每次执行代码时是读取不同的文件，或者有通过一组文件迭代的循环，就使用include()语句。

为了避免函数重定义、变量重赋值等问题，可以使用require_once/include_once语句
`_once`后缀表示已加载的不加载
PHP系统在加载PHP程序时有一个伪编译过程，可使程序运行速度加快。但incluce的文档仍为解释执行。include的文件中出错了，主程序继续往下执行，require的文件出错了，主程序也停了，所以包含的文件出错对系统影响不大的话（如界面文件）就用include，否则用require。
在 PHP 4.0.2 之前，条件语句不影响require，却影响include，因此在判断循环中，应使用include


## 异常
```
try {
    throw new Exception('message', code);
}catch (typehint $ex) {
    // handle exception.
}
```
throw可以使用任意类型，不过Exception类提供了如下的方法给出错误的详细信息
final getMessage()：获取错误信息，即构造时的第一个参数
final getCode()：获取错误代码，即构造的第二个参数
final getFile()：产生异常的代码文件的完整路径
final getLine()：产生异常的代码行号
final getTrace()：产生异常的代码回退路径的数组
final getTraceAsString()：同上，信息格式化为字符串
`__toString()`：可以执行打印异常对象，给出以上所有方法提供的信息。

## IO相关
### 文件
+ `fopen ( $filename, $mode[, bool $use_include_path = false [, resource $context ]])`
    - 若filename没有指定路径，则默认为脚本所在的目录下（路径可以都写作斜杠分割，而不必为Windows写作反斜杠，因为PHP可以自动识别系统，写成反斜杠首先需要进行反斜杠转移，更严重的是代码只能运行于Windows下），filename还支持文件名以协议名开始的远程文件（可以在php.ini配置文件中通过关闭allow_url_fopen指令来禁用此功能）（注意：URL中的域名不区分大小写，但路径和文件名可能区分）。
    - mode可以使用r只读、w覆盖写、c或x创建写、a追加写，另外还可以带+表示读写，t表示文本模式打开（只对Windows下有效），b表示二进制模式打开（默认）。其中覆盖写和创建写的区别就在于覆盖写会将已存在的文件删除后重写，而创建写如果文件已存在则fopen失败，且生成一条 E_WARNING 级别的错误信息（x会这样，c不会）。
    - 此外，该函数还可以指定第三个参数，如果为true，则将在PHP配置的include_path中搜索文件
    - 打开成功返回文件的resource句柄，如果失败，返回false。
+ fclose( $file_handle )：关闭文件，返回是否成功
+ readfile ( $filename [, bool $use_include_path = false [, resource $context ]] )：读取一个文件并输出到标准输出中。返回读取的字节数
+ file_get_contents ( $filename [, bool $use_include_path = false [, resource $context [, int $offset = -1 [, int $maxlen ]]]] )：使用内存映射技术增强性能的读字符串，第二第三个参数和fopen的第三第四个参数一致（如果忽略可以使用NULL），offset是读文件开始的偏移量（对于远程文件由于使用缓冲，该参数并不有效），maxlen是读取文件的最大量（大于等于0），默认是读到文件尾。返回读取到的内容字符串，失败返回false。
+ file_put_contents ( $filename , mixed $data [, int $flags = 0 [, resource $context ]] )：写入数据data可以是string，array（不能是多维数组）或是stream resource。flags可以是FILE_APPEND（追加写，默认是覆盖写）、FILE_USE_INCLUDE_PATH（搜索include_path）、LOCK_EX（获得独占锁）使用 | 进行组合。
+ file ( $filename [, int $flags = 0 [, resource $context ]] )：将整个文件读入到一个数组中（每行作为一个元素）返回之，flags可选FILE_USE_INCLUDE_PATH（搜索include_path）、FILE_IGNORE_NEW_LINES（数组每个元素末尾不加\n）、FILE_SKIP_EMPTY_LINES（跳过空行）
+ file_exists ( $filename )：检测文件是否存在
+ filesize ( $filename )：返回文件大小（字节数）
+ unlink ( $filename [, resource $context ] )：删除文件，返回成功与否

#### 读写
feof( $file_handle )：测试文件指针是否到文件结束

##### 读
+ fgetc ( $file_handle )：读取一个字符，读到EOF返回false
+ fgets ( $file_handle [, int $length ] )：从文件中读取一行且最大长度为length-1字节的字符串，没有指定length，则默认是1024字节，返回读取的字符串，如果文件指针中没有更多数据，则返回false。
+ fgetss ( $file_handle [, int $length [, string $allowable_tags ]] )：滤掉所有HTML和PHP标记的版本，如果想要哪些标记不被滤掉，可以在第三个参数免过滤
+ fgetcsv ( $file_handle ,$length = 0 ,$delimiter = ',' ,$enclosure = '"' ,$escape = '\\' )：用于读入一行，并解析CSV字段，返回一个包含这些字段的数组，后三个参数都必须是单字符
+ fread ( $file_handle , int $length )：读取length个字符，返回读取的字符串（可能因为EOF或网络数据包结束而不足length个字符）
+ fpassthru (  $file_handle )：给定的文件句柄，从当前位置读到EOF输出到标准输出中，而后将该句柄关闭。如果已向文件写入数据，必须调用rewind来将文件指针指向文件头。返回读取的字节数

##### 写
fwrite ( $file_handle , $outputstring [, $length ] )：向文件写字符串，直到写完或写到length字节数为止，返回写入的字符数，出错返回false。函数别名：fputs

#### 文件操作
+ rewind ( $file_handle )：将文件指针复位到文件头（对于使用追加模式打开的，写入位置总在文件尾，不管指针位置在哪）
+ ftell ( $file_handle )：返回文件指针的位置（字节数）（注意：追加模式打开将返回未定义的错误）
+ fseek ( $file_handle , $offset, $whence = SEEK_SET )：定位文件指针到$whence+$offset的位置，$whence可以是SEEK_SET（文件头）、SEEK_CUR（当前）、SEEK_END（文件尾）。成功返回0，否则返回-1（如果已追加模式打开将忽略位置设置）

+ flock ( $file_handle , int $operation [, int &$wouldblock ] )：operation包括LOCK_SH共享锁（用于读）、LOCK_EX独占锁（用于写）、LOCK_UN释放锁，如果想要非阻塞锁，还可以加上LOCK_NB，返回成功与否

### 目录操作
+ basename
+ dirname ( $path )：返回路径中的目录名（不带最后的 / ），即path的父目录
+ realpath ( $path )：处理路径中的 ./ ../多余的斜杠和符号链接，返回一个规范化的路径，如果路径不存在则返回false
+ rmdir ( $dirname [, resource $context ] )：删除一个空目录
+ mkdir ( $pathname, int $mode = 0777, bool $recursive = false [, resource $context ] )：创建目录
+ scandir ( $dir [, int $sorting_order [, resource $context ]] )：把一个目录下的所有子目录和文件作为数组返回，默认按字母升序排列，如果sorting_order为1时，则按降序排列。

### 配置文件
parse_ini_file($filename, $process_sections = false, $scanner_mode = INI_SCANNER_NORMAL)：解析一个配置文件，并以数组的形式返回其中的设置

### 编解码
### URL
urlencode($str)/urldecode($str)：会将字符串中除了 `-_.` 之外的所有非字母数字字符都将被替换成百分号（%）后跟两位十六进制数，空格则编码为加号（+）。用于将url中的参数值进行编码（不要将全部URL，以及=和&编码）
rawurlencode/rawurldecode：和上面的差别是空格也是百分号（%）后跟两位十六进制数的形式。
http_build_query：通过数组，构造http query格式的字符串
parse_url：解析URL，返回其各个组成部分（数组）

#### HTML
+ htmlspecialchars( $str [, $flags = ENT_COMPAT | ENT_HTML401 [, $encoding = ini_get("default_charset")   [, $double_encode = true  ]]] )：对& " ' < >五种进行HTML编码（其中 ' 如果需要编码，需要设置ENT_QUOTES）
+ htmlspecialchars_decode( $str [, $flags = ENT_COMPAT | ENT_HTML401  ] )
+ htmlentities( $str [, $flags = ENT_COMPAT | ENT_HTML401 [, $encoding = ini_get("default_charset")   [, $double_encode = true  ]]] )：所有HTML实体字符都将被编码
+ html_entity_decode( $str [, $flags = ENT_COMPAT | ENT_HTML401   [, $encoding = ini_get("default_charset")  ]] )

#### JSON
+ json_decode($str_json, $assoc=false, $depth=512, $options=0)：将一个json格式字符串转换为PHP变量，若$assoc为true，则返回array，而非object，$depth指定递归深度，解析失败返回NULL
+ json_encode($val, $options=0)：$val可以是除resource类型之外的任何数据类型（只接受UTF-8编码），成功则返回json字符串，失败返回false
+ json_last_error()：如果有，返回json编解码是最后发生的错误。
+ json_last_error_msg()：如果有，返回json编解码是最后发生的错误信息。


### 数据库
MySQL有mysql 和 mysqli 两套API，后者是前者的增强扩展，但与前者不能兼容。
mysql_pconnect和 mysql_connect() 相似，不过会打开一个常连接，而且不能用mysql_close()关闭


## 系统调用
注意：当用户提供的数据传入这些函数，应该使用 escapeshellarg() 或 escapeshellcmd() 来确保用户不会欺骗系统从而执行任意命令。
### 调用shell
+ shell_exec ( $cmd )：通过shell执行命令，将完整输出以字符串方式返回。若发生错误或无输出，返回NULL。（无法获知是否成功，效果等价于反引号`cmd`）
+ exec ( $cmd, [&$output, [&$return_var]] )：执行命令cmd，返回值保存在return_var中，输出按行以追加方式填充数组output（每行不包括行末空白符，如\n）。返回执行结果的最后一行。
**注意：如果需要$cmd命令在后台执行（包括其调用的其他进程需要在后台执行），必须将后台执行的进程的输出进行重定向，否则起不到后台执行的效果，即调用不会立即返回，而是等待其执行完毕；比如执行是一个脚本a.sh，而该脚本又在后台起了另一个脚本b.sh，则必须将后台脚本b.sh的输出重定向，否则exec不会返回，必须要收集全部的输出才能返回，即使直接调用的脚本a.sh 已经返回。**
+ system ( $cmd[, &$return_var] )：执行命令cmd，返回值保存在return_var中，成功则返回命令输出的最后一行， 失败则返回 FALSE
+ passthru ( $cmd, &$return_var )：执行命令cmd，返回值保存在return_var中，将原始输出直接转送到浏览器（比如attachment文件下载）
+ popen ( $cmd, $mode )：执行命令cmd，并打开一个管道，mode是管道的打开模式，'r'表示该管道可以用以读操作，'w'表示该管道可以用以写操作。返回管道的的resource句柄（无论命令是否成功执行），如果发现错误，返回false。（可以用文件处理函数操作管道句柄，只不过管道是单向的——只能读或只能写，并且需使用 pclose()关闭之）
+ proc_open ( $cmd , array $descriptorspec , array &$pipes [, string $cwd [, array $env [, array $other_options ]]] )
    执行命令cmd；
    descriptorspec数组的key是描述符（0表示stdin，1表示stdout，2表示stderr），value表示PHP如何将该描述符传递给子进程，可以是一个数组：
        如果第一个元素是'pipe'，第二个元素可以使用'r'表示子进程可以从管道中读取或'w'表示子进程可以向管道中写入；
        如果第一个元素是'file'第二个元素就是文件名第三个元素是文件的打开方式。
        value也可以是一个文件描述符（文件句柄、socket、STDIN等）
    pipes就是和子进程通信的管道句柄数组（key在descriptorspec数组指定的）
    cwd是cmd的工作目录（必须用绝对目录），若缺省或为NULL，则为当前PHP进程的目录
    env是cmd运行的环境变量，若缺省或为NULL，则使用和当前PHP进程相同的环境变量。
+ pcntl_exec ( string $path [, array $args [, array $envs ]] )：path为可执行文件的路径，args是要传递给程序的字符串数组，envs是传递给程序作为环境变量的字符串数组（key => value格式）

### 信息
phpinfo()：关于PHP的各种信息，PHP预置常量和变量的列表

### mail
mail ( string $to , string $subject , string $message [, string $additional_headers [, string $additional_parameters ]] )

## 网络编程
+ header(str, replace=true [, http_response_code])：str为发送的包头字符串，replace表示该包头是否替换之前包头的相同信息字段（否则，则添加一个相同字段），http_response_code强制指定相应值。该函数必须位于任何实际输出之前调用（即使是HTML标签）
包头有两种特殊的：“HTTP/“开头的用于发送HTTP状态码，例如”HTTP/1.0 4.4 Not Found”; “Location”的头信息，将返回给浏览器一个302的重定向码。

## 开发框架
ZF：Zend Framework
TP：ThinkPHP，伪OOP
Laravel：代码可读性好
Nette
YII：中文支持，activeform、jQuery绑定、MVC、gii工具、widget
Phalcon：是一个开源的，满栈的 PHP 框架，C开发，性能好
Symfony：受到众多的 web 应用框架启发的：Ruby on Rails，Django 和 Spring ，它可能是最完整的 PHP 框架了
CI：Codelgniter
PHPixie：这个框架源于 Kohana 框架
Kohana
CakePHP：Ruby on Rails（ROR）
Canphp：微内核设计
KYPHP：OOP，MVC
Flight
Medoo
Pop PHP

