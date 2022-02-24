# pathogen
[TOC]

## 作用
原生安装插件，插件的各部分分散在不同的目录中（例如$VIM/plugin、$VIM/doc）这样修改和卸载就比较麻烦
pathogen让每个插件占有一个单独的目录
安装完pathogen之后，只需要在`~/.vim/`目录下新建一个目录`~/.vim/bundle/`，并将要安装的所有插件放在`~/.vim/bundle/`目录下即可以使用。如果要删除某个插件，只需要将`~/.vim/bundle/`目录下对应的插件目录删除即可。

## 安装及启用
从<https://github.com/tpope/vim-pathogen> 下载，pathogen插件只有一个单独的脚本pathogen.vim，所谓安装就是把它放在当前用户的`~/.vim/autoload`目录下即可（对应Windows是`$VIM/vimfiles/autoload`）。
```
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
```

当Vim启动时，会自动执行runtimepath(rtp)列表中所包含文件夹下的vim脚本，pathogen会在启动时把./vim/bundle下的文件夹中的插件按照一定顺序递归加载到rtp中，这样Vim启动时，通过pathogen管理的插件就生效了。有了pathogen之后，一般.vim文件夹下只有三个文件夹：autoload、bundle和doc

在vimrc文件中添加
```
filetype off
call pathogen#infect()  ' 或execute pathogen#infect()
```
注意：当运行pathogen命令时，文件格式检测必须关闭，先写命令filetype off，必须在诸如`filetype plugin indent on` 的filetype 命令之后之前（该问题仅仅发生在vim7.3.430及以前，在设置完pathogen后，再将filetype detection打开，新版本则不必）

## 使用
在$VIM/vimfiles目录下新建目录bundle，安装的插件放到这个目录下就可以了
对于支持git 安装和更新的插件，直接在bundle 目录下执行git clone 就安装成功了，在插件目录执行git pull 就更新成功了

很多插件还带有自己的说明文档（doc目录中），只要执行一下命令
```
:call pathogen#helptags()
```
pathogen就可以自动为bundle目录下所有的doc目录中的txt文件生成帮助文档标签。

### 使用中可能的问题
#### 与c.vim的兼容问题
只需要将此插件的c.vim文件（在plugin目录下）的69行：
```
let s:plugin_dir   = $VIM.'/vimfiles/'
```
改为：
```
let s:plugin_dir   = $VIM.'/vimfiles/bundle/cvim/'
```

#### vimball的方式发布的插件（.vba格式）
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
