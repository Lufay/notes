# emmet

## 安装
用pathogen.vim：
```
git clone https://github.com/mattn/emmet-vim.git ~/.vim/bundle/emmet-vim
```

## 使用
### 语法
#### html 骨架
`html:5`

#### 类似CSS 选择器
1. E 代表HTML标签。
2. E#id 代表id属性。
3. E.class 代表class属性，如果缺少了E，则默认是div
4. E[attr=foo] 代表某一个特定属性。
5. E{foo} 代表标签包含的内容是foo。
6. E>N 代表N是E的子元素。
7. E+N 代表N是E的同级元素。
8. E^N 代表N是E的上级元素。
9. E*N 代表E 重复N 次，其中E 中可以包含$ ，每个$ 表示一位数字，用以重复自动编号
可以使用() 标识优先级

### 代码生成
在写完上述语法后，使用`ctrl+y+,`来生成html 代码（不用跳出输入模式）

## 配置
### 仅对html/css 生效
```
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
```

### 修改触发键
`let g:user_emmet_leader_key='<C-Z>'`
但最后的逗号不能改


