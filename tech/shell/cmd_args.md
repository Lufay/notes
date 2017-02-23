# 命令行参数

## 内置变量
`$#`：参数个数（不含命令本身）
`$0`：命令本身
`$1 $2 $3 ... ${10}`：依次各个参数
`$@`：表示`"$1" "$2" "$3" ...`
`$*`：表示`"$1 $2 $3 ..."`
配合shift n 命令，该命令表示跳过前n个参数后开始编号，比如shift 1后，原来`$2`的参数就变成了`$1`

附，其他内置变量
`$?`：上一个命令的返回值（一般0 表示正确，其他表示错误）
`$$`：当前shell 进程的pid
`$!`：最近一个后台进程的pid
`$_`：前一个命令的最后一个参数
`$-`：显示shell使用的当前选项

## 内置命令getopts（不支持长选项）
```
while getopts "a:bc" arg		# 冒号表示需要参数
do
    case $arg in
        a)
            echo $OPTARG		# 参数值在变量$OPTARG
        ;;
        b)
        ;;
        c)
        ;;
        ?)
            echo "unkown argument"
            exit 1
        ;;
    esac
done
```
1. 每次执行检查下一个命令行参数（变量$OPTIND记录了下一个要处理参数的索引，起始为1）
1. 如果是以 - 开头，就检查是否是列出option中的字符
	1. 如果是，就把该字符保存在第二个参数arg中，参数值保存在变量$OPTARG，返回0；
	1. 如果不是option列出的字符，arg就存入?，返回0；
1. 如果命令行中没有参数，或下一个参数不以 - 开头，就返回非0。

支持短格式option的连写，但不支持短格式option和参数值的连写

## 外部命令getopt（支持长选项）
```
TEMP=`getopt -o ab:c:: --long a-long,b-long:,c-long:: — $* 2>/dev/null`
eval set -- "$TEMP"
while :
do
    case "$1" in
        -a|--a-long)
            shift
        ;;
        -b|--b-long)
            echo $2
            shift 2
        ;;
        -c|--c-long)
            case "$2" in
                "")
                    each "no argument"
                ;;
                *)
                    echo "$2"
                ;;
            esac
            shift 2
        ;;
        --)
            shift
            break
        ;;
        *)
            echo "unkown argument"
            exit 1
        ;;
    esac
done
```
选项：
-o：用来指示短选项（连写）
--long：用来指示长选项（用逗号分隔）
-n：用来指示出错时的信息
--：表示escape后续的符号-，用以分割option和argument

两个冒号表示有一个可选参数（必须紧贴选项）
使用该命令会对argument进行规范化（可选参数给一个空串作为参数，option和argument用--分割），使用eval set命令，将它们重新放入位置变量中
成功解析返回0，解析失败返回其他值
