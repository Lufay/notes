# Vim 插件总结
[TOC]

## 插件简述
### 插件管理
Vundle：插件管理，为了解决自动搜索及下载插件而存在的

[pathogen](https://github.com/tpope/vim-pathogen.git)：插件管理，为了解决安装的插件文件分散到多个目录不好管理而存在的（一个插件包往往具备多种功能，每个文件根据Vim的路径约定会放置到不同的目录下，通用插件放到plugin下，语法高亮插件放到syntax下，自动加载插件放到autoload下，文件类型插件放到ftplugin下，编码格式插件的放到indent下；无论是你想要安装新插件，还是想删除旧插件，都非常麻烦，你不得不在每个文件夹下找相关的vim文件）

### 文件浏览
netrw.vim：已内置，文件浏览器，当打开的文件不是普通文件而是目录时启用，移动光标到指定行，回车即可打开该文件, -返回上级目录，c切换当前目录到正在浏览的目录，d创建目录，D删除目录或文件, i切换显示方式，R重命名，s改变排序方式

[nerdtree](https://github.com/scrooloose/nerdtree.git)：树形文件浏览器

### 窗口
QuickFix：内置

WinManager：整合页面窗口

Powerline：状态栏

### 查找
[ctrlp](https://github.com/ctrlpvim/ctrlp.vim.git)：模糊查找

Grep

ack：全局查找，用perl编写

Command-T：基于Ruby和C扩展实现的快速文件浏览的插件（需要vim支持ruby扩展）

MiniBufExplorer：编辑文件较多时联用其他插件会卡

[ctags](https://sourceforge.net/projects/ctags/?source=typ_redirect)：符号收集和定位

Cscope：强化ctags

taglist：符号表

[tagbar](https://github.com/majutsushi/tagbar.git)：符号表，更适合面向对象

grep.vim：工程内查找和替换

[easymotion](https://github.com/easymotion/vim-easymotion.git): 跳转

### 辅助工具
echofunc：函数调用时，提示函数声明

VisualMark：使书签可见

ShowMarks

marks browser

[indentLine](https://github.com/Yggdroot/indentLine.git)：显示代码缩进（实体）

[vim-indent-guides](https://github.com/nathanaelkane/vim-indent-guides.git)：显示缩进（高亮）

[javascript-indent](https://github.com/vim-scripts/JavaScript-Indent.git)：js缩进

[maksimr/vim-jsbeautify](https://github.com/maksimr/vim-jsbeautify.git)：js/html/css代码格式化

tabular：快速对齐

EnhancedCommentify：块注释

NerdCommenter：块注释

tComment：同上

DoxygenToolkit.vim：文档注释

[gundo](https://github.com/sjl/gundo.vim.git)：支持分支的 undo

### 静态代码检查
[Syntastic](https://github.com/scrooloose/syntastic.git)：语法检查，实际上这个插件只是个接口，背后的语法检查是交给各个语言自己的检查器, 外界的语法检测器必须在$PATH中，也可以使用软链接（Ruby 实际使用ruby -c命令，JavaScript 使用 jshint，jslint 等）

[JSHint](https://github.com/jshint/jshint.git)：静态代码检查

[JsLint](https://github.com/douglascrockford/JSLint.git)：js语法检查

[vim-flake8](https://github.com/nvie/vim-flake8.git)：python语法及代码风格检查

### 代码补全
neocomplete.vim

neocomplcache.vim

new-omni-completion：代码补全

[YouCompleteMe](https://github.com/Valloric/YouCompleteMe.git)：基于clang引擎通过语义检查为C/C++/Objective-C进行代码补全，集成clang_complete、AutoComplPop、Supertab、neocomplcache、Syntastic。集成Jedi引擎完成Python的代码补全。通过OmniSharp完成C#的补全。通过 Gocode and Godef完成Go的补全。通过 Tern完成js的补全。通过eclim完成Java和ruby的补全。其他语言使用 vim内置的omnifunc补全。

eclim：eclipse的代码提示

SuperTab：简化补全快捷键

[vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors.git)：多光标同步编辑

jedi-vim：python提示，需要--enable-pythoninterp 的配置和安装jedi

pydiction：python补全

python_ifold：python代码折叠

c.vim：c语言插件

cpp.vim

stl.vim

[Auto Pairs](https://github.com/jiangmiao/auto-pairs.git)：自动补全和删除括号（支持三引号）

[surround.vim](https://github.com/tpope/vim-surround.git)

matchit：vim自带，默认不安装，通过 :help matchit-install查看

[MatchTagAlways](https://github.com/Valloric/MatchTagAlways.git)

[Emmet-vim](https://github.com/mattn/emmet-vim.git)：zencoding

[tern_for_vim](https://github.com/ternjs/tern_for_vim.git)：js的定义、调用快速跳转和自动补全

### 高亮和颜色
[vim-javascript](https://github.com/pangloss/vim-javascript.git)：js 缩进和语法高亮

[vim-javascript-syntax](https://github.com/jelera/vim-javascript-syntax.git)：js语法高亮

[javascript-libraries-syntax.vim](https://github.com/othree/javascript-libraries-syntax.vim.git)：js相关库的语法高亮插件

[TagHighlight](https://github.com/vim-scripts/TagHighlight.git)：自定义类型高亮

Molokai：配色方案

solarized：配色方案

### 代码片段
snipMate：代码片段

[xptemplate](https://github.com/drmingdrmer/xptemplate.git)：同上，更复杂，更强大

ultisnip：同上
******

## 安装
Linux安装到~/.vim/下
Windows安装到$VIM/vimfiles下
vim的插件查找路径次序可以通过:set rtp查看（runtimepath）
