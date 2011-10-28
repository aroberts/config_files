" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup
set nowritebackup
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set exrc       " project-specific .vimrc files

" Hide pyc files by default
let g:netrw_list_hide = "^.*.pyc"

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
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
  autocmd FileType text setlocal textwidth=78

  " automatically format xml files with xmllint
  au FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" if has("folding")
"   set foldenable
"   set foldmethod=syntax
"   set foldlevel=1
"   set foldnestmax=2
"   set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '
"
"   " automatically open folds at the starting cursor position
"   " autocmd BufReadPost .foldo!
" endif

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

hi MatchParen ctermbg=0 ctermfg=3

" Always display the status line
set laststatus=2

" Hide search highlighting
map ,nh :nohls <CR>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: ,e
map ,e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: ,t
map ,t :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Duplicates the current tab
" Normal mode: Ctrl+T
map <C-T> :tabe <C-R>=expand("%:p") <CR> <CR>

" Edits the previously edited file
" Normal mode: gb
map gb <C-^>

" Put
" Insert mode: Ctrl+V
imap <C-V> <C-R>"

" Command to resolve the conflicted state of the current file
command! Resolve :!svn resolved %

" Command to restart autotest
command! Atres :!autotest_ctl -INT

" Command to stop autotest
command! Atstop :!autotest_ctl

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Use dark colors
if !has("gui_running")
  " set bg=dark
endif

" Ruby color mappings
highlight link rubySymbol rubyString

" Adds a blank line after the current line
nmap cl o<Esc>^Dk

" Maps autocomplete to tab
imap <Tab> <C-N>

" Duplicate a selection
" Visual mode: D
vmap D y'>p

" For Haml
au! BufRead,BufNewFile *.haml         setfiletype haml

" No Help, please
nmap <F1> <Esc>

" Press ^F from insert mode to insert the current file name
imap <C-F> <C-R>=expand("%")<CR>

" Edit routes
command! Rroutes :e config/routes.rb
command! RTroutes :tabe config/routes.rb

" Local config
if filereadable(".vimrc.local")
  source .vimrc.local
endif

" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

