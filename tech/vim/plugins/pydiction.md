# Pydiction

## 安装和配置
```
git clone https://github.com/rkulla/pydiction.git ~/.vim/bundle/pydiction
```

在.vimrc 中自行配置：
```
filetype plugin on
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'
```

## 使用
输入部分内容，按TAB 键给出列表
ctrl+y: 补全选中项
Esc or ctrl+e: 关闭列表
其他：补全选中项，并输入对应键
