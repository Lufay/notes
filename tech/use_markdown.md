段落
前后要有一个以上的空行（包括只含空白符的行）

标题
类 Atx 形式
# 第一级：一篇文章的大标题
## 第二级：章标题
### 第三级：节标题
#### 第四级：节内子标题
##### 第五级
###### 第六级

> 引用
> line1
>
> line2

当中间包含空行时，必须每行使用 >
如果是一个段落，则只在第一行使用 > 即可，如：
> 引用
line 1
line2

引用支持嵌套，引用块内也可以使用其他格式


+ 无序列表+
列表换行可以顶格
+ 无序列表+

    列表包含段落，则需要缩进（1个制表或4个空格）

+ 无序列表+
    + 嵌套无序列表

分割线*
***

- 无序列表-
- 无序列表-
- 无序列表-

分割线_
___

1. 有序列表
    > 嵌入列表的引用使用缩进
1. 有序列表
2\. 这不是列表项，而是单纯的字符，使用 \ 转义
3. 有序列表
    1. 嵌套有序列表
    1. 嵌套有序列表

强调：
和分割线相同，使用 * 和 _ ，使用其包围文字：
斜体：*em*
粗体：__strong__

~~删除线：~~

    这段文字加个框（缩进1个制表或者4个空格）

代码：
行内 use the `printf()` function.
段：
```lang
int main() {
    return 0;
}
```
lang可以写程序语言，也可以缺省

链接：
[链接文字](http://example.com/ "Title")
Title 可省，url可以使用本地路径
[链接文字][id]
[id]: http://example.com/ "Title"
Title 可以使用单引号、双引号、圆括号，可以写到链接下一行
url 可以用尖括号包起来
id 可以有字母、数字、空白、标点，不区分大小写，如果缺省，则等同链接文字
链接位置和链接定义可以分离在文件中
<http://example.com/>
<addr@example.com>
快速链接

图片：
![Alt text](/path/to/img.jpg "Option title")
Alt text 是图片的替代地址，可省
![Alt text][id]
[id]: url/to/image "Optional title attribute"

表格：
|header1|header2|header3|header4|
|---------|:-----------|----------:|:---:|
|v1|v2|v3|v4|
冒号 : 在哪一端表示那端对齐，在两端表示居中对齐，没有默认居左
分隔 thead 和 tbody 的 - 每列至少三个

目录：
[TOC]

标签分类：
Tags: Markdown

注脚1[^keyword]
注脚2[^footnote]
[^keyword]: 这是注脚1的文本

[^footnote]: 这是注脚2的文本

注脚位置和注脚定义可以分离在文件中
注脚定义之间要空行

Todo list:
- [ ] something1
    - [ ] something1.1
    - [ ] something1.2
    - [x] something1.3


公式、图标：
Rmd
R 语言
兼容LaTeX
WizNote:
支持Mathjax 公式、[流程图](http://adrai.github.io/flowchart.js/)、[时序图](http://bramp.github.io/js-sequence-diagrams/)、甘特图

编写工具：
Windows: MarkdownPad
Linux: ReText
Mac: Mou, MacDown
在线: [Cmd](https://www.zybuluo.com/mdeditor), [Dillinger](http://dillinger.io), 简书, StackEdit

格式转换：
使用Pandoc




