# NERDTree
## 安装
用pathogen.vim：
```
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
```

## 使用
+ 启动vim 时启动，在.vimrc 中添加`autocmd vimenter * NERDTree`
+ 在已启动的vim 中打开窗口：`:NERDTreeToggle`
可以添加映射：`map <C-n> :NERDTreeToggle<CR>`
+ 当窗口只剩NERDTree，自动关闭vim：
```
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
```

### 常用的快捷键
o：如果是文件，打开文件并跳转；如果是目录，打开或收拢该目录；
go：打开文件或目录，但不跳转；
O：递归打开目录；
x：收拢父目录；
X：递归收拢该目录下的所有子目录（但该目录不收拢）；
i和s：可以水平分割(split)或纵向分割(vsplit)窗口打开文件，前面加g，表示打开不跳转；
r：递归刷新当前目录；
R：递归刷新根目录；
cd：设置当前目录为pwd
t：在新Tab页中打开，并跳到新Tab 页；
T：在新Tab页中打开，但不跳到新Tab 页；
p：到上层目录；
P：到根目录；
K和J：到同目录第一个节点和最后一个节点；
CC：选该目录为根节点
u和U：将当前根结点的父目录设为根节点，变成合拢 和 保持展开
I：切换是否显示隐藏文件；
m：显示文件系统菜单（添加、删除、移动操作）；
?：帮助；
q：关闭。
<http://www.cppblog.com/deane/articles/109378.html>

## 注意
+ 如果想要目录带git 标记，可以安装[nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)
+ 不支持多Tab 页显示目录，可以安装[vim-nerdtree-tabs](https://github.com/jistr/vim-nerdtree-tabs)

