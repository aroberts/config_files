" ----------------------------------------
" Mappings
" ----------------------------------------

" Set leader
" Note: This line MUST come before any <leader> mappings
let mapleader=" "
let maplocalleader=" "

" ---------------
" Regular Mappings
" ---------------

" Yank entire buffer with gy
nnoremap gy :%y+<cr>

" Select entire buffer
nnoremap vy ggVG

" Make Y behave like other capital commands.
" Hat-tip http://vimbits.com/bits/11
nnoremap Y y$

" Jump to beginning and end of lines easier. From http://vimbits.com/bits/16
noremap H ^
noremap L $

" Create newlines without entering insert mode
nnoremap go o<Esc>k
nnoremap gO O<Esc>j

" remap U to <C-r> for easier redo
" from http://vimbits.com/bits/356
nnoremap U <C-r>

" Swap implementations of ` and ' jump to markers
" By default, ' jumps to the marked line, ` jumps to the marked line and
" column, so swap them
" nnoremap ' `
" nnoremap ` '

" ---------------
" Window Movement
" ---------------

" Here's a visual guide for moving between window splits.
"   4 Window Splits
"   --------
"   g1 | g2
"   ---|----
"   g3 | g4
"   -------
"
"   6 Window Splits
"   -------------
"   g1 | gt | g2
"   ---|----|----
"   g3 | gb | g4
"   -------------
nnoremap <silent> gh :wincmd h<CR>
nnoremap <silent> gj :wincmd j<CR>
nnoremap <silent> gk :wincmd k<CR>
nnoremap <silent> gl :wincmd l<CR>
" Upper left window
" nnoremap <silent> g1 :wincmd t<CR>
" Upper right window
" nnoremap <silent> g2 :wincmd b<Bar>:wincmd k<CR>
" Lower left window
" nnoremap <silent> g3 :wincmd t<Bar>:wincmd j<CR>
" Lower right window
" nnoremap <silent> g4 :wincmd b<CR>

" Top Middle
" nnoremap <silent> gt g2<Bar>:wincmd h<CR>
" Bottom Middle
" nnoremap <silent> gb g3<Bar>:wincmd l<CR>

" Previous Window
" nnoremap <silent> gp :wincmd p<CR>
" Equal Size Windows
" nnoremap <silent> g= :wincmd =<CR>
" Swap Windows
" nnoremap <silent> gx :wincmd x<CR>

" ---------------
" Modifer Mappings
" ---------------

" Make line completion easier.
inoremap <C-l> <C-x><C-l>

" Easier Scrolling (think j/k with left hand)
" All variations are mapped for now until I get used to one
nnoremap <C-j> 15gjzz
nnoremap <C-k> 15gkzz
vnoremap <C-j> 15gjzz
vnoremap <C-k> 15gkzz

" ---------------
" Insert Mode Mappings
" ---------------

" Let's make escape better, together.
" inoremap jk <Esc>
" inoremap JK <Esc>
" inoremap Jk <Esc>
" inoremap jK <Esc>

" ---------------
" Leader Mappings
" ---------------

" Clear search
noremap <silent><leader>/ :nohls<CR>

" Highlight search word under cursor without jumping to next
nnoremap <leader>h *<C-O>

" Toggle spelling mode with ,s
" nnoremap <silent> <leader>s :set spell!<CR>

" Begin to edit any file in .vim directory
" nnoremap <leader>v :e ~/.vim/

" Underline the current line with '-'
nnoremap <silent> <leader>ul :t.\|s/./-/\|:nohls<cr>

" Underline the current line with '='
nnoremap <silent> <leader>uul :t.\|s/./=/\|:nohls<cr>

" Surround the commented line with lines.
"
" Example:
"          # Test 123
"          becomes
"          # --------
"          # Test 123
"          # --------
nnoremap <silent> <leader>cul :normal "lyy"lpwv$r-^"lyyk"lP<cr>

" Format the entire file
nnoremap <leader>fef mx=ggG='x

" Format a json file with Python's built in json.tool.
" from https://github.com/spf13/spf13-vim/blob/3.0/.vimrc#L390
nnoremap <leader>jt <Esc>:%!underscore print<CR><Esc>:set filetype=json<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Split window vertically or horizontally *and* switch to the new split!
nnoremap <silent> <leader>hs :split<Bar>:wincmd j<CR>
nnoremap <silent> <leader>vs :vsplit<Bar>:wincmd l<CR>

" Close the current window
nnoremap <silent> <leader>sc :close<CR>
" ---------------
" Typo Fixes
" ---------------

noremap <F1> <Esc>
inoremap <F1> <Esc>
" cnoremap w' w<CR>

" Don't use Ex mode, use Q for formatting
map Q gq

" Removes doc lookup mapping because it's easy to fat finger and never useful.
" nnoremap K k
" vnoremap K k

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: ,e
map <leader>e :e <C-R>=expand("%:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: ,t
map <leader>t :tabe <C-R>=expand("%:h") . "/" <CR>

" Opens a write command with the path of the currently edited file filled in
" Normal mode: ,w
map <leader>w :w <C-R>=expand("%:h") . "/" <CR>

" Rename the current file with Fugitive
" (TODO: make it work in non-git projects)
" Normal mode: ,r
map <leader>r :Gmove <C-R>=expand("%:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" add a blank line below cursor
nnoremap cl o<Esc>^Dk

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Press ^F from insert mode to insert the current file name
imap <C-F> <C-R>=expand("%")<CR>

