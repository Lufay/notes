# pathogen

当Vim启动时，会自动执行runtimepath(rtp)列表中所包含文件夹下的vim脚本，pathogen会在启动时把./vim/bundle下的文件夹中的插件按照一定顺序递归加载到rtp中，这样Vim启动时，通过pathogen管理的插件就生效了。有了pathogen之后，一般.vim文件夹下只有三个文件夹：autoload、bundle和doc

下载 pathogen.vim，将其放到$VIM/vimfiles/autoload目录下
在vimrc文件中添加
```
filetype off
call pathogen#infect()
```
注意：当运行pathogen命令时，文件格式检测必须关闭，先写命令filetype off（该问题仅仅发生在vim7.3.430及以前，在设置完pathogen后，再将filetype detection打开，新版本则不必）

在$VIM/vimfiles目录下新建目录bundle，安装的插件就都放到这个目录下
很多插件还带有自己的说明文档（doc目录中），只要执行一下命令
```
:call pathogen#helptags()
```
pathogen就可以自动为bundle目录下所有的doc目录中的txt文件生成帮助文档标签。

与c.vim的兼容问题：
只需要将此插件的c.vim文件（在plugin目录下）的69行：
```
let s:plugin_dir   = $VIM.'/vimfiles/'
```
改为：
```
let s:plugin_dir   = $VIM.'/vimfiles/bundle/cvim/'
```

vimball的方式发布的插件（.vba格式）：
如果按照常规的安装方式，即用Vim打开vba文件，然后执行命令：
```
:so %
```
那么，插件的文件还是被解压到vimfiles目录下，而非bundle目录，可以执行：
```
:edit name.vba
:!mkdir $VIM\vimfiles\bundle\name
:UseVimball $VIM\vimfiles\bundle\name
```
可以将name插件解压到指定的目录而且自动执行了helptags命令
