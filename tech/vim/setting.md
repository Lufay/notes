# Vim 配置

## 编码
+ encoding
vim 内部编码方式，包括缓冲区、菜单文本、消息文本，只有设置在.vimrc文件中才有效
+ termencoding
vim 所在终端的字符编码方式
+ fileencoding
当前文件的字符编码，保存文件也会保存为这种编码方式，因为fileencodings 的机制，只有在vim环境下手动设置才有效。
+ fileencodings
启动时会按所列编码方式逐一探测即将打开文件的字符编码方式，并将fileencoding 设置为最终探测到的字符编码
推荐序列：ucs-bom,utf-8,utf-16,cp936,gbk,gb18030,big5,gb2312,euc-jp,euc-kr,latin1

## 撤销持久化
set undofile " 当文件关闭后，保存undo操作，默认为.un~结尾的隐藏文件
set undodir=$HOME/.vim/undo  " 保存undofile的位置（默认原地保存）
set undolevels=1000  " 保存undo操作次数
set undoreload=10000  " 保存undo操作到文件的次数
