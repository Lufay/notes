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
echo不带换行，可以输出用逗号分隔的多个表达式（在输出时，这些部分会连接在一起），没有返回值
print不带换行，只能输出一个表达式，并返回1


## 数据类型
### 类型
#### boolean
true 和 false

#### integer
支持10，16，8，2进制，[格式](http://php.net/manual/zh/language.types.integer.php)
不支持无符号数，最大值的常量是`PHP_INT_SIZE`

#### double（float是别名）
永远不要比较两个浮点数是否相等，如果确实需要更高的精度，应该使用[BC数学函数](http://php.net/manual/zh/ref.bc.php)或者[gmp 函数](http://php.net/manual/zh/ref.gmp.php)）

##### 相关函数
round()
abs()
`number_format($num, $dec=0, $dec_point='.', $sep=',')`：来自于Math库，格式化数字为小数点后dec位，还可以指定小数点和千位分隔符

*注*: 某些数学运算会产生一个由常量 NAN 所代表的结果，不应拿 NAN 去和其它值进行比较，包括其自身（都是false）应该用 `is_nan()` 来检查。

#### string
每个字符一个字节，最大2GB，不支持Unicode
字符串会被按照该脚本文件相同的编码方式来编码。不过这并不适用于激活了 Zend Multibyte 时；此时脚本可以是以任何方式编码的（明确指定或被自动检测）然后被转换为某种内部编码，然后字符串将被用此方式编码。注意脚本的编码有一些约束（如果激活了 Zend Multibyte 则是其内部编码）- 这意味着此编码应该是 ASCII 的兼容超集
<http://php.net/manual/zh/language.types.string.php>

##### 相关函数
strlen ( $str )：获得字符串长度（字节数）
`mb_strlen ( $str [, string $encoding = mb_internal_encoding() ] )`：获得字符串长度，多字节版本，可以指定字符串编码（多字节字符被记为1）
strpos ( $str , mixed $find, $offset = 0 )：返回从offset位置开始，$find在$str中首次出现的位置（注：如果$find不是string，那么就会将其转换为int，并视为字符的ASCII值），offset非负。如果找不到就返回false（为了和0返回值相区分，应使用===进行判断）不区分大小写的版本stripos、最后一次出现的版本strrpos和strripos
strcmp ( $str1 , $str2 )：区分大小写比较（按字典序）。反之strcasecmp
strnatcmp ( $str1 , $str2 ) ：区分大小写比较（按自然序，比如数字串按数字比较）。反之strnatcasecmp
`start_with($str, $needle) { return strpos($str, $needle) === 0; }`
`end_with($str, $needle) { $len = strlen($needle); if($len == 0) return true; return (substr($str, -$len) === $needle);}`

strrev( $str )：反转字符串
trim ( $str, $charlist = " \t\n\r\0\x0B" )：返回字符串两边的空白符去除后的字符串，可以通过指定第二个参数改变过滤的字符（默认是空格、制表、换行、回车、空字节、垂直制表）。从单侧滤除ltrim和rtrim（别名chop）
strtoupper ( $str )：转换为大写字母的字符串返回。
strtolower ( $str )：转换为小写字母的字符串返回。
ucfirst ( $str )：首字母大写返回。反之lcfirst
ucwords ( $str )：字符串每个单词的首字母大写返回。
addslashes ( $str )：对字符串中每个需要转义的字符前加上反斜杠进行转义
`nl2br ( $str, $is_xhtml = true )`：将\n或\r或其组合字符替换为`<br />`
strtr($str, $from, $to)：将$str字符串中出现在$from串中的字符替换为$to串中的对应字符（若$from和$to两个串不等长，则忽略多余字符。）
strtr($str, $replace_pairs)：$replace_pairs是对$str替换的映射表，和str_replace不同的是，strtr对已经替换的内容不进行二次匹配，另外，strtr会使用长key优先匹配。
`str_replace ( mixed $search , mixed $replace , mixed $subject [, int &$count ] )`：subject可以是字符串或数组，如果是数组则对每个元素进行字符串替换，返回一个数组。search也可以是字符串或数组，如果是数组，就进行多重查找。replace也可以是字符串或数组，如果是数组，且长度不小于search，则进行对应替换，如果长度小于search，则不足部分视为空串。如果search是数组，而replace是字符串，则都用replace进行替换。count设置为替换发生的次数，默认全部替换。不区分大小写的版本`str_ireplace`
`substr_replace ( mixed $string , mixed $replacement , mixed $start [, mixed $length ] )`：$string可以是字符串或数组，如果是数组则对每个元素进行字符串替换，返回一个数组，此时，start和length如果是标量的话，就作用于数组中每个字符串，如果也是数组的话，则作用于数组对应的字符串。start支持负数倒数，length也支持负数倒数，表示替换结束的位置（不含该位置），缺省为到串尾，若为0，表示插入。

`str_repeat ( $str , int $n )`：返回str重复n次连接的结果
substr ( $str , int $start [, int $length ] )：提取str从start（从0计）开始长为length（默认到串尾）的子串，注意：若start为负数则表示倒数第几个，若start落在串外则返回false，length若为负数，表示str串尾的-length个字符将被忽略（如果start落在这部分，则返回空串）
strstr ( $str , mixed $find, $before = false )：在$str中查找$find，并返回$str中$find及后面的子串；若$before为true，则返回$str中$find之前的子串。若找不到则返回false。函数别名strchr。不区分大小写的版本stristr。反向查找的版本strrchr（不支持$before参数）
strtok ( $str , string $token )：使用$token对$str进行拆分，返回token左侧的第一组子串。$token可以是一个字符串，则其中每个字符都被当做定界符，即遇到任何一个都将被定界；不过，如果第一组子串为空时，则忽略重新找定界符。下次对该字符串调用该函数可以省去$str，则将继续上次位置进行下次拆分。如果上次拆分已经到达串尾，则继续调用strtok ( $token )将返回false
explode ( $delimiter , $str [, int $limit ] )：使用delimiter字符串作为边界点，将str分为最多limit个元素的数组（当limit为正时），最后一个元素包含分割剩下的部分。若limit为负时，则最后-limit个元素会排除在外；如果limit为0，将被视为1
implode ( [ string $glue ,] array $pieces )：将数组元素用glue字符串连接成一个字符串返回，glue默认是一个空串。函数别名join


#### array
数组，同时支持数字索引和关联数组，也支持异构类型在一个数组中（key只支持整数和字符串，可以使用浮点和bool，但会转换为整数）
数字索引从0开始，使用array('a', 'b', 'c')构造
关联数组使用array('a'=>1, 'b'=>2, 'c'=>3)构造
如果使用var[3]这种作为左值时，如果var这个变量未声明，则将视为创建这样的一个数组，如果已声明为一个数组，则视为动态添加元素或修改元素；而作为右值时，如果对应的索引未定义，则会报错
可用list结构实现利用数组进行多元赋值，如：
list($a, $b, $c) =  array('a', 'b', 'c')
这样就可用将$a赋值数组索引为0的元素， $b赋值数组索引为1的元素....
此外，list还可以空缺元素，如list(, , $c)，这样就只取到数组索引为2的元素
从PHP5.4开始，可以使用[]代替array()
将一个数组赋值给另一个数组，会连同数组内置指针位置也赋值，但两者独立

##### 相关函数
`count ( $var, $mode = COUNT_NORMAL )`：计算数组中元素个数或对象中属性的个数。函数别名sizeof
`array_key_exists($key, $arr)`：判断数组中是否有该键，一般使用isset($arr[$key]) 判断，因为性能更好，但当这儿键的值是null的时候，`array_key_exists` 返回true，而isset 返回false
`in_array($needle, $arr, $strict=FALSE)`：区分大小写，判断$needle是否在数组$arr中，若$strict为TRUE，则判断类型相同
`array_count_values ( $arr )`：返回一个关联数组，键为$arr中出现的值，值为每个值在$arr中出现的次数。（注意：如果数组的元素不是int或string则会抛出一个`E_WARNING`）

each ( $arr )：取出数组内置指针指向的当前元素构造成一个新的数组：索引0和'key'这个键的值为该元素的key，索引1和'value'这个键的值是该元素的value。而后数组指针后移一位，如果到达数组结尾，该函数返回false，数组指针停留在最后一个元素。
reset( $arr )：重置数组指针到第一个元素的位置，并返回其值。
end ( $arr )：将数组指针移到最后一个元素，并返回其值。
current ( $arr )：返回数组指针指向数组当前元素其值，但数组指针指向不变。当数组指针已经超出数组末端，返回false。函数别名pos
next ( $arr )：将数组指针前移一位后，返回当前元素其值。如果没有更多元素返回false
prev ( $arr )：将数组指针回移一位后，返回当前元素其值。

`array_push ( $arr , mixed $var... )`：数组尾端入栈多个元素
`array_pop ( $arr )`：将数组尾端一个元素弹出，数组为空则返回NULL（注：该操作也会reset数组指针）
`array_shift ( $arr )`：数组头一个元素弹出，数组为空则返回NULL
`array_unshift ( $arr, $var, ... )`：数组头插入多个元素
range ( mixed $start , mixed $limit, number $step = 1 )：创建从start到limit步进step的数组，常用数字和字符
`array_slice ($arr, $offset, $len)`：截取从$offset位置开始，长为$len的子数组，$offset若为负表示倒数，若$len为负，表示不要结尾的$len个元素
`array_splice ($arr, $offset, $len)`：和上面相反，去掉上面截取的部分，接合起来组成新shu'zu
`array_merge_recursive ( $arr, ... )`：递归合并一个或多个数组
`array_combine($arr_key, $arr_val)`：合并两个数组来创建一个新数组，其中的一个数组元素为键名，另一个数组元素为键值
`array_keys ($array, mixed $search_value = null, $strict = false ]] )`：返回数组的所有键（数字和字符串）组成数组。如果指定`$search_value`，则返回指定值的所有键，默认使用`==`做比较，strict为true 时，使用`===`
`array_values($array)`：返回数组所有值，组成数组。
`array_flip($arr)`：交换数组中的键和值，如果键类型不对，将出现一个警告，并且有问题的键／值对将不会出现在结果里。如果同一个值出现多次，则最后一个键名将作为它的值，其它键会被丢弃。

`array_reverse ( $arr, $preserve_keys = false )`：返回一个反序数组（对于关联数组总是保持关联的）。`preserve_keys`若为false，则数字键也会保持
`array_unique ($arr)`：数组去重后，返回新数组（每个值只保留第一个遇到的键名，按字符串比较）
`sort ( $arr, $sort_flags = SORT_REGULAR )`：将元素升序排列，返回成功与否。`sort_flags`可以是`SORT_REGULAR`（不改变类型比较）、`SORT_NUMERIC`（作为数字比较）、`SORT_STRING`（作为字符串比较）、`SORT_NATURAL`（已自然顺序进行字符串排序）。降序用rsort
`ksort ( $arr, $sort_flags = SORT_REGULAR )`：保持键值关联，对键排序。降序用krsort
`asort (  $arr, $sort_flags = SORT_REGULAR )`：保持键值关联，对值排序。降序用 arsort
`usort (  $arr , callable $cmp_function )`：可以自定义比较函数（使用函数名的字符串作为第二个参数，返回一个整数，如果两个元素比较结果=0，则它们在数组中的顺序未定；如果使用类的静态函数做比较函数，可以用`array("ClassName", "static_func_name")`做 第二个参数）。另外对应还有 uksort、 uasort
shuffle ( $arr )：随机打乱一个数组，返回成功与否

`array_walk ( $arr , callable $funcname, $userdata = NULL )`：用函数funcname作用于数组的每个元素，该函数以每个元素的值、键，以及$userdata作为参数，注意，如果想要对数组进行修改，函数的第一个参数需要使用引用（使用&在变量前）
`array_map`
`array_reduce`
`array_filter ( input, callback )`：通过callback指定的函数名（字符串），依次对input数组的每个值传给该函数，然后就回调函数返回true的成员组成数组返回（键名保留）。若未指定callback，就直接用数组元素进行判断。

`extract ( $arr , $extract_type = EXTR_OVERWRITE , $prefix = NULL )`：将数组的元素导入符号表中，成为变量，其中，元素的键作为变量名，元素的值作为变量的值。`extract_type`指定冲突的处理方法，`EXTR_OVERWRITE`（冲突覆盖）、`EXTR_SKIP`（冲突忽略）、`EXTR_PREFIX_SAME`（冲突加前缀prefix）、`EXTR_PREFIX_ALL`（统一加前缀prefix）、`EXTR_PREFIX_INVALID`（仅在非法变量名前加前缀prefix）、`EXTR_IF_EXISTS`（仅导入冲突，并覆盖）、`EXTR_PREFIX_IF_EXISTS`（仅导入冲突，并加前缀prefix）、`EXTR_REFS`（将变量作为引用提取数组中的值，该项可以和前面使用OR联用）。加上前缀prefix后会带上一个下划线。
<http://php.net/manual/zh/book.array.php>
<http://justcoding.iteye.com/blog/1181962/>


#### object

#### NULL
未被赋值或已被unset的变量

#### resource
特定的内置函数（如数据库函数）返回resource类型的变量，代表外部资源，这种变量无法直接操作，是一个标识资源的句柄


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


