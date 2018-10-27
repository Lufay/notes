execute pathogen#infect()
syntax on		" syntax highlight
"set nocompatible	" remove compatible to vi to avoid some limitation of early version
"set nobackup		" overwrite file without backup
"set backupcopy=yes	" set backup to overwrite
set helplang=cn		" set help info language
set autochdir		"自动切换当前目录为当前文件所在的目录
filetype plugin indent on	" equivalent to 3 line cmd:
							" filetype on			" detect filetype
							" filetype plugin on	" load filetype plugin
							" filetype indent on	" indent for some filetype

set nu				" set number of line
set ruler			" show the current row and column
set cursorline		" highlight current line
set cuc				" highlight current column
set tabstop=4		" set tab length to 4
set softtabstop=4	" set backspace to delete 4 space
set shiftwidth=4	" set << and >> command move width to 4
"set autoindent		" let next line align to the current line
set smartindent		" smart to indent when open a new line
set cin			" support C/C++ indent
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s	"设置C/C++语言的具体缩进方式
set pastetoggle=<F9>	"按F9键就可以切换自动缩进（为避免自动缩进在粘贴代码时造成的混乱
set shiftround

"set smarttab		" press backspace to delete space with width of tabstop
"set expandtab		" set tab to space with width of tabstop, short as et
"au FileType make set noet
set backspace=indent,eol,start  " make that backspace key work the way it should
set scrolloff=3		" keep 3 lines when scrolling

set ignorecase smartcase	" case-insensitive when searching, except that there are uppercase letter in the pattern, short as ic
set incsearch		" show the searching result when input the pattern
set hlsearch		" highlight the content when find it
set showmatch		" blink to the matches when entering parentheses
set matchtime=1		" tenths of a second to show the matching parenthesis

set enc=utf8	" not suit for win
set fenc=utf8
set tenc=utf8	" not suit for win
set fencs=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

set list listchars=tab:▸\ ,eol:¬,	" ,trail:·,extends:>,precedes:<
"hi TabSOL ctermbg=yellow guibg=yellow
"match TabSOL \t
hi WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {<CR>}<Esc>O
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
"inoremap } <c-r>=CloseBracket()<CR>
"inoremap " <c-r>=QuoteDelim('"')<CR>
"inoremap ' <c-r>=QuoteDelim("'")<CR>

function ClosePair(char)
	if getline('.')[col('.')-1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endf

function CloseBracket()
	if match(getline(line('.')+1),'\s*}') < 0
		return "\<CR>}"
	else
		return "\<Esc>j0f}a"
	endif
endf

function QuoteDelim(char)
	let line = getline('.')
	let col = col('.')
	if line[col - 2] == "\\"
		" Inserting a quoted quotation mark into the string
		return a:char
	elseif line[col - 1] == a:char
		" Escaping out of the string
		return "\<Right>"
	else
		" Starting a string
		return a:char.a:char."\<Esc>i"
	endif
endf

" 映射全选+复制 ctrl+a
map <C-A> ggVGY
map! <C-A> <Esc>ggVGY
" format all
map <F10> gg=G
" 选中状态下 Ctrl+c 复制到剪贴板
vmap <C-c> "+y
"去空行
nnoremap <F12> :g/^\s*$/d<CR>
"make 运行
:set makeprg=g++\ -Wall\ \ %
set autowrite	"自动保存

map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "! ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!java %<"
    elseif &filetype == 'sh'
        :!./%
    endif
endfunc

map <F8> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc



"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.[ch],*.cpp,*.sh,*.java,*.py,*.php exec ":call SetTitle()"
"定义函数SetTitle，自动插入文件头
func SetTitle()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1,"\#!/bin/bash")
        call append(line("."), "\#############################################")
        call append(line(".")+1, "\# File Name: ".expand("%"))
        call append(line(".")+2, "\# Version: 0.0.0")
        call append(line(".")+3, "\# Author: Lufay")
        call append(line(".")+4, "\# Date: ".strftime("%c"))
        call append(line(".")+5, "\# Description: ")
        call append(line(".")+6, "\#############################################")
        call append(line(".")+7, "")
    elseif &filetype == 'python'
        call setline(1,"\#!/usr/bin/env python")
        call append(line("."), "\# -*- coding: utf-8 -*-")
        call append(line(".")+1 , "'''module")
        call append(line(".")+2, " @filename: ".expand("%"))
        call append(line(".")+3, " @version: 0.0.0")
        call append(line(".")+4, " @author: Lufay")
        call append(line(".")+5, " @date: ".strftime("%c"))
        call append(line(".")+6, " @description: ")
        call append(line(".")+7, "'''")
        call append(line(".")+8, "")
    else
        call setline(1, "/**")
        call append(line("."),   " * Copyright(C), Company Inc.")
        call append(line(".")+1, " * File Name: ".expand("%"))
        call append(line(".")+2, " * @version: 0.0.0")
        call append(line(".")+3, " * @author: Lufay")
        call append(line(".")+4, " * @date: ".strftime("%c"))
        call append(line(".")+5, " * @description: ")
        call append(line(".")+6, " */")
        call append(line(".")+7, "")
    endif
    if &filetype == 'cpp'
        call append(line(".")+8, "#include<iostream>")
        call append(line(".")+9, "using namespace std;")
        call append(line(".")+10, "")
	elseif &filetype == 'c'
        call append(line(".")+8, "#include<stdio.h>")
        call append(line(".")+9, "")
	elseif &filetype == 'python'
        call append(line(".")+9, "import sys")
        call append(line(".")+10, "")
    endif
    "新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunc

set foldenable		" begin to fold
set foldmethod=syntax	" set fold method to syntax, foldmethod short as fdm, another:manual(self define),indent,expr,diff(zc for no diff code),marker
au filetype python set foldmethod=indent
set foldcolumn=0	" set the range of fold
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
			" can use space to open or close fold
			" zi: enable or disable fold
			" zo: open fold in current scope(zO:zo for all)
			" zc: fold to close in current scope(zC:zc for all)
			" zr: open fold from outside
			" zm: fold to close from inside
"au BufWinLeave * mkview
"au BufWinEnter * silent loadview

"set laststatus=2
"set statusline=%F%m%r%h%w/[POS=%l,%v][%p%%]/ / / /Encoding:/ %{(&fenc==/"/")?&enc:&fenc}%{(&bomb?/"[BOM]/":/"/")}/ / / /%{??? strftime(/"%Y-%m-%d/ -/ %H:%M/")}
"hi StatusLine guifg=SlateBlue guibg=Yellow	" set status line
"hi StatusLineNC guifg=Gray guibg=White

" ====================custom highlight===================================
" BufNewFile for edit a non-existed file
" BufRead for read a existed file
"au BufRead,BufNewFile *.idl hi service guifg=white guibg=red ctermfg=yellow ctermbg=black
"au BufRead,BufNewFile *.idl syn match service /\zsservice \ze/
"
"au BufRead,BufNewFile test_*.cpp hi TEST_F guifg=white guibg=red ctermfg=green ctermbg=black
"au BufRead,BufNewFile test_*.cpp syn match TEST_F /\zsTEST_F\ze/

" ====================plugins===================================
"autocmd vimenter * NERDTree
map <leader>d :NERDTreeToggle<CR>	" leader key default \
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeIgnore=['\.pyc','\~$','\.swp']
let NERDTreeWinSize=20

map <leader>t :TagbarToggle<CR>	" leader key default \
let g:tagbar_width=70

""let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
"let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
"map <leader>G :YcmCompleter GoTo<CR>
