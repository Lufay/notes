# gitgutter
## 安装
用pathogen.vim：
```
git clone git://github.com/airblade/vim-gitgutter.git ~/.vim/bundle/vim-gitgutter
```

## 使用
标记的更新时间取决于vim 的updatetime，默认是4000（4秒）
建议设置`set updatetime=100`

可以通过`[c` 和`]c` 快速跳转到上一个/下一个标记块的首行

可以在visual 和 operator-pending 模式下
`ic` 选中当前标记块的全部行
`ac` 选中当前标记块的全部行以及后面的空行

`<leader>hp`：preview，预览这一块的diff
`<leader>hs`：stage，git add
`<leader>hu`：undo，git checkout

### 设置
#### 整体启动
`:GitGutterEnable`(default)
`:GitGutterDisable`
`:GitGutterToggle `

#### 标记启动
`:GitGutterSignsEnable`(default)
`:GitGutterSignsDisable`
`:GitGutterSignsToggle`

#### 高亮启动
`:GitGutterLineHighlightsEnable`
`:GitGutterLineHighlightsDisable`(default)
`:GitGutterLineHighlightsToggle`
