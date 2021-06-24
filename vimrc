" Needed by pthogen
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
syntax on
filetype on

" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backupdir=/tmp
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
" if has('mouse')
"   set mouse=a
" endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=0
  autocmd FileType text setlocal wrapmargin=0
  " set textwidth=0
  " set wrapmargin=0

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set wildmode=longest,list,full
set wildmenu
"noremap <S-F5> :.! date +"\%Y-\%m-\%d" <CR>okalavan:
noremap <S-F6> :s/\(^20[0-9][0-9]-[0-9][0-9]-[0-9][0-9] \)\(.*[^ ]\)\( *$\)/\t\2/
noremap <S-F5> o<C-R>=strftime("%Y-%m-%d")<cr><cr>kalavan:<cr><esc>kA
"noremap <C-O> r+a[MN]<esc>
noremap <C-O> :s/^\([ \t]*\)-/\1+\[MN\]/<cr>:nohl<cr>



""""""""""""""" PYTHON IDE COMES HERE """""""""""""""""""""""""""
" http://sontek.net/blog/detail/turning-vim-into-a-modern-python-ide#basic-editing-and-debugging
" Folding lines:
set foldmethod=indent
set foldlevel=99

execute pathogen#infect()

" gundo history
map <leader>g :GundoToggle<CR>

filetype plugin indent on    " enable loading indent file for filetype
" Optionaly tell pyflakes not to use quickfix
" let g:pyflakes_use_quickfix = 0

" pep8 let's you browse your code for warnings
let g:pep8_map='<leader>8'

" Completion using SuperTab plugin
set completeopt=menuone,longest,preview
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"


" enable NerdTree
map <leader>N :NERDTreeToggle<CR>

" RopeVim
	" Jump to definition
map <leader>j :RopeGotoDefinition<CR>
	" rename
map <leader>r :RopeRename<CR>

" search for something in your project
nmap <leader>/ <Esc>:Ack!

""""""""""""" XMLEDIT FTPLUGIN """""""""""""""""""""""""""""""""""""""""""""""""
let xml_use_xhtml = 1
let xml_tag_syntax_prefixes = 'html\|xml\|xsl\|docbk\|twiki'

""""""""""""" MARKDOWN PREVIEW """""""""""""""""""""""""""""""""""""""""""""""""
let vim_markdown_preview_github=1
let vim_markdown_preview_toggle=2
let vim_markdown_preview_temp_file=0
""""""""""""" Vim-plug """""""""""""""""""""""""""""""""""""""""""""""""""""""""
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()

