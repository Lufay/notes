windows 下的vim

对应Linux 下的.vimrc 文件和 .vim 文件夹
在gvim 对应的是
+ 全局配置：vim 安装目录下的`_vimrc`文件和 vimfiles 文件夹
+ 用户配置：当前用户根目录下的`_vimrc`文件和 vimfiles 文件夹

## 工具栏
```vim
set guioptions+=T
set guioptions-=T
```
显、隐工具栏

```
amenu ToolBar
```
查看当前工具栏按钮，在各种模式下对应的指令
可以看到这里每个按钮都有一个编号

### 新增工具栏按钮
```
amenu icon=/path/to/pic 1.400 ToolBar.TabNew :tabnew<CR>
tmenu ToolBar.TabNew open a new tab
```
amenu 命令指定按钮对应的指令；tmenu 命令指定按钮的浮动文案
这里
+ icon 指定了按钮的图标，图标必须是18*18 像素的图片，如果是.bmp 文件，则可以缺省后缀；如果没指定icon，则默认去vimfiles/bitmaps 下找按钮名.bmp 文件。该命令也可以用在tmenu 上
+ 1.400 是按钮的位置编号
+ TabNew 是指定的按钮名

#### 关于图标
可以去网上download 一个图标按钮，然后用画图工具编辑，使用重新调整大小功能，调整成目标大小后，另存为bmp 文件
在非Windows 的系统上，图标格式为.xpm

### 添加工具栏分隔
```
amenu 1.xxx ToolBar.-sep8- <Nop>
```
这样就在指定位置添加一个分隔符

### 移除工具栏按钮
```
aunmenu ToolBar.TabNew
tunmenu ToolBar.TabNew
```
前者移除按钮，后者移除文案

### 内置的按钮
#### Make
由于Windows 系统上并没有make 命令，所以一般该按钮并没有作用
不过可以下载一个Windows 版的[gnumake](https://gnuwin32.sourceforge.net/packages/make.htm)
如果需要一个集成的gnu工具包，可以直接下载[MinGW](https://sourceforge.net/projects/mingw/)

不过，vim 中的`:make` 指令，并等价于`:!make`；同理`:python`或`:python3`也并不等价于`:!python`
因为前者是内置命令，受内置的参数指定；后者则是直接执行外部命令
比如`:make` 指令，实际执行的是`set makeprg` 配置的指令
而`:python`或`:python3` 也是受`set pythondll`或`set pythonthreedll`指定的动态库来决定解释器

此外，`:make`指令的所有输出都会被重定向到一个临时文件中