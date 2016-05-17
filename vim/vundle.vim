" ----------------------------------------
" Vundle
" ----------------------------------------

set nocompatible " be iMproved
filetype off     " required!

if !isdirectory(expand('~/.vim/bundle/vundle/.git'))
    !git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/vundle
endif

set runtimepath+=~/.vim/bundle/vundle/

call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/vundle'

" ---------------
" Plugin Plugins
" ---------------

""" Navigation
" Plugin 'ZoomWin'
" This fork is required due to remapping ; to :
" Plugin 'christoomey/vim-space'
Plugin 'kien/ctrlp.vim'
Plugin 'JazzCore/ctrlp-cmatcher'

""" UI Additions
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'bling/vim-airline'
" Plugin 'scrooloose/nerdtree'
Plugin 'Rykka/colorv.vim'
Plugin 'mhinz/vim-signify'
Plugin 'mhinz/vim-startify'
" Plugin 'mbbill/undotree'
" Plugin 'jszakmeister/vim-togglecursor'

""" Color schemes
Plugin 'nanotech/jellybeans.vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'tomasr/molokai'
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'
Plugin 'morhetz/gruvbox'
Plugin 'zeis/vim-kolor'
Plugin 'tpope/vim-vividchalk'
Plugin 'aroberts/colorbundle.vim'

""" Commands
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'godlygeek/tabular'

if executable('ag')
  Plugin 'epmatsw/ag.vim'
elseif executable('ack')
  Plugin 'mileszs/ack.vim'
endif

" Plugin 'milkypostman/vim-togglelist'
Plugin 'tpope/vim-abolish'
" Plugin 'scratch.vim'
" Plugin 'mattn/emmet-vim'
" Plugin 'mutewinter/GIFL'
Plugin 'AndrewRadev/switch.vim'
" Plugin 'tpope/vim-eunuch'
" Plugin 'itspriddle/vim-marked'
Plugin 'mutewinter/UnconditionalPaste'
Plugin 'HelpClose'
Plugin 'mattn/gist-vim'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'sk1418/Join'
" Plugin 'SirVer/ultisnips'
Plugin 'g3orge/vim-voogle'
" Plugin 'benmills/vimux'
" Plugin 'jgdavey/vim-turbux'
" Plugin 'ecomba/vim-ruby-refactoring'
" Plugin 'christoomey/vim-tmux-navigator'

""" Automatic Helpers
Plugin 'IndexedSearch'
Plugin 'xolox/vim-session'
" Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/syntastic'
" Plugin 'ervandew/supertab'
Plugin 'Valloric/MatchTagAlways'
" Plugin 'Valloric/YouCompleteMe'
" Plugin 'kballenegger/vim-autoreadwatch'

""" Language Additions
""    Ruby
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-bundler'
Plugin 'thoughtbot/vim-rspec'
""    JavaScript
Plugin 'pangloss/vim-javascript'
Plugin 'kchmck/vim-coffee-script'
Plugin 'leshill/vim-json'
""    HTML
Plugin 'nono/vim-handlebars'
Plugin 'othree/html5.vim'
Plugin 'indenthtml.vim'
""    TomDoc
Plugin 'mutewinter/tomdoc.vim'
Plugin 'jc00ke/vim-tomdoc'
""    Other Languages
Plugin 'derekwyatt/vim-scala'
Plugin 'indentpython.vim'
Plugin 'msanders/cocoa.vim'
Plugin 'mutewinter/taskpaper.vim'
Plugin 'mutewinter/nginx.vim'
Plugin 'timcharper/textile.vim'
Plugin 'hail2u/vim-css3-syntax'
" Plugin 'mutewinter/vim-tmux'
Plugin 'plasticboy/vim-markdown'
Plugin 'groenewege/vim-less'
Plugin 'wavded/vim-stylus'
Plugin 'tpope/vim-cucumber'
Plugin 'chrisbra/csv.vim'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'keith/swift.vim'
""" MatchIt
" Plugin 'matchit.zip'
" Plugin 'kana/vim-textobj-user'
" Plugin 'nelstrom/vim-textobj-rubyblock'
" Libraries
Plugin 'L9'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-speeddating'
Plugin 'mattn/webapi-vim'
Plugin 'xolox/vim-misc'

" Ensime
Plugin 'ensime/ensime-vim'

call vundle#end()
filetype plugin indent on

