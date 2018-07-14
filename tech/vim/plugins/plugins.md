# Vim 插件总结
[TOC]

## 插件简述
### 插件管理
Vundle：插件管理，为了解决自动搜索及下载插件而存在的

[pathogen](https://github.com/tpope/vim-pathogen.git)：插件管理，为了解决安装的插件文件分散到多个目录不好管理而存在的（一个插件包往往具备多种功能，每个文件根据Vim的路径约定会放置到不同的目录下，通用插件放到plugin下，语法高亮插件放到syntax下，自动加载插件放到autoload下，文件类型插件放到ftplugin下，编码格式插件的放到indent下；无论是你想要安装新插件，还是想删除旧插件，都非常麻烦，你不得不在每个文件夹下找相关的vim文件）

### 辅助视窗
+ MiniBufExplorer：buffer管理工具，但编辑文件较多时联用其他插件会卡
+ QuickFix：内置
+ WinManager：整合页面窗口
+ Powerline：状态栏

#### 文件浏览
netrw.vim：已内置，文件浏览器，当打开的文件不是普通文件而是目录时启用，移动光标到指定行，回车即可打开该文件, -返回上级目录，c切换当前目录到正在浏览的目录，d创建目录，D删除目录或文件, i切换显示方式，R重命名，s改变排序方式

[nerdtree](https://github.com/scrooloose/nerdtree.git)：树形文件浏览器

Command-T：基于Ruby和C扩展实现的快速文件浏览的插件（需要vim支持ruby扩展）

#### 查找
[ctrlp](https://github.com/ctrlpvim/ctrlp.vim.git)：模糊查找
[LeaderF](https://github.com/Yggdroot/LeaderF)：同上

[grep.vim](https://github.com/yegappan/grep)：工程内查找和替换

[EasyGrep](https://github.com/dkprice/vim-easygrep)：全局查找并替换

[ack](https://github.com/mileszs/ack.vim)：全局查找，用perl编写<https://github.com/beyondgrep/ack2>
或者使用ag

[ctags](https://sourceforge.net/projects/ctags/?source=typ_redirect)：符号收集和定位

Cscope：强化ctags

taglist：符号表

[tagbar](https://github.com/majutsushi/tagbar.git)：符号表，更适合面向对象

[easymotion](https://github.com/easymotion/vim-easymotion.git): 跳转

### 通用工具
+ [VisualMark](http://www.vim.org/scripts/script.php?script_id=1026)：使书签可见
安装：把下载下来的 visualmask.vim 放到 $HOME/.vim/plugin 目录下
使用：在普通模式下按 ctrl+F2 或者 mm 即可设置或取消高亮书签，按 F2 或 Shift+F2 进行下一个、上一个书签间跳转
问题：`E197: Cannot set language to "en_US"`
解决：将`exec ":lan mes en_US"` 这一行改为`exec ":lan mes en_US.utf8"` 或 `exec ":lan POSIX"`
如果觉得配色不好看，可以修改SignColor
+ [ShowMarks](http://www.vim.org/scripts/script.php?script_id=152)
前置：需要vim 编译支持sign 特性
安装：把下载下来的 showmarks.vim 放到 $HOME/.vim 目录下
问题：<https://easwy.com/blog/archives/advanced-vim-skills-advanced-move-method/>
+ marks browser

[YankRing](https://github.com/vim-scripts/YankRing.vim)：多剪贴板可视化

[gitgutter](https://github.com/airblade/vim-gitgutter)：显示git diff
[fugitive.vim](https://github.com/tpope/vim-fugitive)：git 工具集成

[gundo](https://github.com/sjl/gundo.vim.git)：支持分支的 undo
[undotree](https://github.com/mbbill/undotree)：同上，不依赖Python

[repeat](https://github.com/tpope/vim-repeat)：重复之前的操作

[vim-markdown](https://github.com/plasticboy/vim-markdown)：Markdown 语法高亮
[vim-instant-markdown](https://github.com/suan/vim-instant-markdown)：实时的Markdown 预览（需要node.js）
[python-vim-instant-markdown](https://github.com/isnowfy/python-vim-instant-markdown)：同上，需要python2支持，保存文件才能看到效果

[conqueTerm](https://code.google.com/archive/p/conque/)：在vim在模拟Terminal

[VimIM](https://vim.sourceforge.io/scripts/script.php?script_id=2506)：中文输入法
<https://github.com/vim-scripts/VimIM>
<https://github.com/vimim/vimim>


### 编码助手
[echofunc](https://github.com/mbbill/echofunc)：函数调用时，提示函数声明

#### 代码检查
[Syntastic](https://github.com/scrooloose/syntastic.git)：语法检查，实际上这个插件只是个接口，背后的语法检查是交给各个语言自己的检查器, 外界的语法检测器必须在$PATH中，也可以使用软链接（Ruby 实际使用ruby -c命令，JavaScript 使用 jshint，jslint 等）

[JSHint](https://github.com/jshint/jshint.git)：静态代码检查

[JsLint](https://github.com/douglascrockford/JSLint.git)：js语法检查

[vim-flake8](https://github.com/nvie/vim-flake8.git)：python语法及代码风格检查

#### 代码补全
[neocomplete.vim](https://github.com/Shougo/neocomplete.vim.git)：需要Vim 7.3.885+ with Lua enabled

neocomplcache.vim

new-omni-completion：代码补全

[YouCompleteMe](https://github.com/Valloric/YouCompleteMe.git)：基于clang引擎通过语义检查为C/C++/Objective-C进行代码补全，集成clang_complete、AutoComplPop、Supertab、neocomplcache、Syntastic。集成Jedi引擎完成Python的代码补全。通过OmniSharp完成C#的补全。通过 Gocode and Godef完成Go的补全。通过 Tern完成js的补全。通过eclim完成Java和ruby的补全。其他语言使用 vim内置的omnifunc补全。

eclim：结合eclipse的代码提示

jedi-vim：python提示，需要--enable-pythoninterp 的配置和安装jedi

pydiction：python补全

SuperTab：简化补全快捷键

#### 注释
EnhancedCommentify：块注释

NerdCommenter：块注释

tComment：同上

DoxygenToolkit.vim：文档注释

#### 自动配对
[Auto Pairs](https://github.com/jiangmiao/auto-pairs.git)：自动补全和删除括号（支持三引号）

[Rainbow Parentheses Improved](https://github.com/luochen1990/rainbow)：多彩括号

[surround.vim](https://github.com/tpope/vim-surround.git)

matchit：vim自带，默认不安装，通过 :help matchit-install查看

[MatchTag](https://github.com/gregsexton/MatchTag)
[MatchTagAlways](https://github.com/Valloric/MatchTagAlways.git)

#### 配色
[TagHighlight](https://github.com/vim-scripts/TagHighlight.git)：自定义类型高亮

[indentLine](https://github.com/Yggdroot/indentLine.git)：显示代码缩进（实体）

[vim-indent-guides](https://github.com/nathanaelkane/vim-indent-guides.git)：显示缩进（高亮）

[vim-javascript](https://github.com/pangloss/vim-javascript.git)：js 缩进和语法高亮

[vim-javascript-syntax](https://github.com/jelera/vim-javascript-syntax.git)：js语法高亮

[javascript-libraries-syntax.vim](https://github.com/othree/javascript-libraries-syntax.vim.git)：js相关库的语法高亮插件

python_ifold：python代码折叠

Molokai：配色方案

solarized：配色方案

#### 代码片段
snipMate：代码片段

[xptemplate](https://github.com/drmingdrmer/xptemplate.git)：同上，更复杂，更强大

ultisnip：同上

#### 快速编码
[vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors.git)：多光标同步编辑

[Emmet-vim](https://github.com/mattn/emmet-vim.git)：zencoding

#### 代码格式化
[maksimr/vim-jsbeautify](https://github.com/maksimr/vim-jsbeautify.git)：js/html/css代码格式化

[javascript-indent](https://github.com/vim-scripts/JavaScript-Indent.git)：js缩进

tabular：快速对齐

### 具体语言一体插件
c.vim：c语言插件

cpp.vim

stl.vim

<https://github.com/fatih/vim-go>
<https://github.com/derekwyatt/vim-scala>

[tern_for_vim](https://github.com/ternjs/tern_for_vim.git)：js的定义、调用快速跳转和自动补全

******

## 安装
Linux安装到~/.vim/下
Windows安装到$VIM/vimfiles下
vim的插件查找路径次序可以通过:set rtp查看（runtimepath）
