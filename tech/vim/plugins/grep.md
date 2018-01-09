# grep.vim
[参考](http://www.vim.org/scripts/script.php?script_id=311)
[TOC]

## 前置条件
系统必须有 grep, fgrep, egrep, agrep, find 和 xargs 这些命令工具。

## 安装和配置
把 grep.vim 这个文件放到$HOME/.vim/plugin 或 $HOME/vimfiles/plugin 或 $VIM/vimfiles/plugin 目录中。

前置条件中的这些命令工具如果无法通过PATH 环境变量找到的话，可以在.vimrc 中自行配置：
```
:let Grep_Path = 'd:\tools\grep.exe'
:let Fgrep_Path = 'd:\tools\fgrep.exe'
:let Egrep_Path = 'd:\tools\egrep.exe'
:let Agrep_Path = 'd:\tools\agrep.exe'
:let Grep_Find_Path = 'd:\tools\find.exe'
:let Grep_Xargs_Path = 'd:\tools\xargs.exe'
```

默认的搜索目录是`*`，可以在.vimrc 中改动：
```
:let Grep_Default_Filelist = '*.c *.cpp *.asm'
```
空格分隔

默认的grep 选项是空，可以在.vimrc 中改动：
```
:let Grep_Default_Options = '-i'
```

其他配置：
默认跳过目录'RCS CVS SCCS'
```
:let Grep_Skip_Dirs = 'dir1 dir2 dir3'
```

默认跳过文件`'*~ *,v s.*'`
```
:let Grep_Skip_Files = '*.bak *~'
```

## 用法
该插件引入一些vim 命令：
```
:Grep          - 调用grep 命令
:GrepAdd       - Same as ":Grep" but adds the results to the current results 
:Rgrep         - Run recursive grep 
:RgrepAdd      - Same as ":Rgrep" but adds the results to the current results 
:GrepBuffer    - Search for a pattern on all open buffers 
:GrepBufferAdd - Same as ":GrepBuffer" but adds the results to the current results 
:Bgrep         - Same as :GrepBuffer 
:BgrepAdd      - Same as :GrepBufferAdd 
:GrepArgs      - Search for a pattern on all the Vim argument filenames (:args) 
:GrepArgsAdd   - Same as ":GrepArgs" but adds the results to the current results 

:Fgrep         - 调用fgrep 命令
:FgrepAdd      - Same as ":Fgrep" but adds the results to the current results 
:Rfgrep        - Run recursive fgrep 
:RfgrepAdd     - Same as ":Rfgrep" but adds the results to the current results 

:Egrep         - 调用egrep 命令
:EgrepAdd      - Same as ":Egrep" but adds the results to the current results 
:Regrep        - Run recursive egrep 
:RegrepAdd     - Same as ":Regrep" but adds the results to the current results 

:Agrep         - 调用agrep 命令
:AgrepAdd      - Same as ":Agrep" but adds the results to the current results 
:Ragrep        - Run recursive agrep 
:RagrepAdd     - Same as ":Ragrep" but adds the results to the current results 
```

### 命令格式
```
:Grep   [<grep_options>] [<search_pattern> [<file_name(s)>]]
:GrepArgs [<grep_options>] [<search_pattern>]
```
如果上述命令可选部分缺失，都会有提示

### 结果
结果将显示在quickfix 窗口中，该窗口并不总是开着，可以使用`:copen`命令进行打开
可以通过`:cnext``:cprev`进行移动，使用Enter 进行选择
可以使用`:colder``:cnewer`在多个grep 结果中进行跳转


### 其他
在外部命令被调用之前，都可以使用Esc 键进行取消

可以设置键映射：
```
nnoremap <silent> <F3> :Grep<CR>
```


