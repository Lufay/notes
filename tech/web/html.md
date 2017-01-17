# HTML
## 标签tag 与元素
HTML 标签是由尖括号包围的关键词，比如 `<html>`
HTML 标签通常是成对出现的，比如 `<b>` 和 `</b>`
标签对中的第一个标签是开始标签，第二个标签是结束标签
一对标签表示一个元素，元素的内容是开始标签与结束标签之间的内容
空元素在开始标签中进行关闭，如 `<br />`
标签可以拥有属性，属性总是以"名称/值"对的形式出现，比如：name="value"，属性值一般使用双引号，除非值内容本身含有双引号，则使用单引号
属性总是在 HTML 元素的开始标签中规定

## 常见标签
+ `<html>` 元素定义了整个 HTML 文档
+ `<head>` 元素定义了 HTML 文档的头部
    - 样式 `<style>` 可以指定块级元素的样式
        属性 type（text/css）：块级元素可以用“元素名#name或id”来标识，属性用键值对放在{}中
+ `<body>` 元素定义了 HTML 文档的主体
    属性 bgcolor背景色，background指定背景图片的URL地址

+ 标题（Heading） `<h1>` - `<h6>` 
    属性 align 对齐方式（center）
+ 段落 `<p>`
+ 区块 `<div>` 用于组织其他元素的容器（块级元素）
    属性 id或class来标记（前者是唯一标识，后者是一个元素组）
+ 行内分块 `<span>`（内联元素）
    属性 id或class来标记（前者是唯一标识，后者是一个元素组）
+ 表格 `<table>`
    属性 border 边框宽度，cellspacing 单元格边距，bgcolor表格背景色，background表格边距图片URL
    - `<caption>`指定表格的标题
    - `<thead>`指定表格的表头
    - `<tbody>`指定表格的表体
    - `<tfoot>`指定表格的表尾
    - `<tr>`定义表格的行
            - `<th>`定义表头
                    属性 colspan 指定跨列单元格的跨度，rowspan 指定跨行单元格的跨度
            - `<td>`定义表格单元格，单元格内可以包含文本、图片、列表、表单，表格等
                    属性 bgcolor表格背景色，background表格边距图片URL，align对齐方式（left、right）
            在一些浏览器中，如果某个单元格是空的（没有内容），浏览器可能无法显示出这个单元格的边框。为了避免这种情况，在空单元格中添加一个空格占位符（&nbsp;），就可以将边框显示出来。
    - `<col>`按列指定一些属性，如align
+ 列表
    - 无序列表 `<ul>`
        属性 type（disc/circle/square）
    - 有序列表 `<ol>`
        属性 type（A、a、I、 i）
    - 列表项 `<li>`
    - 定义列表 `<dl>`
    - 定义列表项 `<dt>` 项定义 `<dd>`
+ 表单 `<form>`
    属性action指定一个当表单被确认时，转发处理的目标文件，也可以是邮件目标（如：MAILTO:someone@qq.com）
    属性method（get：附加到URL尾、post：单独的消息发送）转发方式
    属性enctype（text/plain）
    - `<input>`
        属性：type（文本框text、密码框password、单选radio、复选checkbox、按钮button、确认提交键submit）
        name（标识）
        value（值）
        checked（checked）单选或复选的默认选项
        size 输入框的宽度
        maxlength 可输入的最大字符数
    - `<select>` 下拉列表
        `<optgroup>` 列表选项组，属性label
            `<option>` 列表选项，属性value，selected（selected）默认选择
    - `<fieldset>` 带标题边框域，内可含`<input>`
        `<legend>`指定域标题
+ `<textarea>`
    属性 rows 行数，cols 列数
+ 链接 `<a>`
    属性 href 指定链接的地址，target 被链接的文档如何打开
    属性 name 用于将该处设为命名锚，用于作为长文档内的跳转目标：
    如：`<a name="tips">`基本的注意事项 - 有用的提示`</a>`——创建命名锚
            `<a href="#tips">`有用的提示`</a>`——页内跳转到命名锚
            `<a href="http://www.w3school.com.cn/html/html_links.asp#tips">`有用的提示`</a>`——外部跳转到命名锚
    假如浏览器找不到已定义的命名锚，那么就会定位到文档的顶端。不会有错误发生。
图像 `<img />`
    属性 src 图片的URL地址，width、height显示宽高，alt为当图片找不到时，显示的替代文本，align指定图片和文字的对齐方式（bottom下对齐，middle，top顶对齐，left，right），border边框宽度，usemap指定使用映射的name
+ 画布 `<canvas>`，通过js绘图（位图）
+ 伸缩矢量图 `<svg>`
+ 映射 `<map>`
    属性 name、id标记
    - `<area>`定义一个图像的子区域
            属性 shape 子区域形状，coords子区域位置描述，href子区域超链接，alt子区域的替换文本
+ 换行 `<br />`
+ 水平线 `<hr />`

+ 注释 `<!-- This is a comment -->`

*注意*
默认情况下，HTML 会自动地在块级元素前后添加一个额外的空行，比如段落、标题、列表、表格元素前后
当显示页面时，浏览器会移除源代码中多余的空格和空行。所有连续的空格或空行都会被算作一个空格。

`<table>`标签就算没写`<tbody>`标签也会自动默认该标签是其唯一一个子标签。
```
<table>
    <thead>
        <tr>
            <th>
    <tbody>
        <tr>
            <td>
    <tfoot>
        <tr>
            <td>
```
注意：`<thead>` 标签仅得到所有主流浏览器的部分支持。

