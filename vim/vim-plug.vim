" ----------------------------------------
" Vim-Plug
" ----------------------------------------


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

""" Navigation
" Plug 'ZoomWin'
" This fork is required due to remapping ; to :
" Plug 'christoomey/vim-space'
Plug 'kien/ctrlp.vim'
Plug 'JazzCore/ctrlp-cmatcher'

""" UI Additions
Plug 'nathanaelkane/vim-indent-guides'
Plug 'bling/vim-airline'
" Plug 'scrooloose/nerdtree'
Plug 'Rykka/colorv.vim'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-startify'
" Plug 'mbbill/undotree'
" Plug 'jszakmeister/vim-togglecursor'

""" Color schemes
Plug 'nanotech/jellybeans.vim'
Plug 'w0ng/vim-hybrid'
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'jnurmine/Zenburn'
Plug 'morhetz/gruvbox'
Plug 'zeis/vim-kolor'
Plug 'tpope/vim-vividchalk'
Plug 'aroberts/colorbundle.vim'

""" Commands
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'

if executable('ag')
  Plug 'epmatsw/ag.vim'
elseif executable('ack')
  Plug 'mileszs/ack.vim'
endif

" Plug 'milkypostman/vim-togglelist'
Plug 'tpope/vim-abolish'
" Plug 'scratch.vim'
" Plug 'mattn/emmet-vim'
" Plug 'mutewinter/GIFL'
Plug 'AndrewRadev/switch.vim'
" Plug 'tpope/vim-eunuch'
" Plug 'itspriddle/vim-marked'
Plug 'mutewinter/UnconditionalPaste'
Plug 'HelpClose'
Plug 'mattn/gist-vim'
Plug 'nelstrom/vim-visual-star-search'
Plug 'sk1418/Join'
" Plug 'SirVer/ultisnips'
Plug 'g3orge/vim-voogle'
" Plug 'benmills/vimux'
" Plug 'jgdavey/vim-turbux'
" Plug 'ecomba/vim-ruby-refactoring'
" Plug 'christoomey/vim-tmux-navigator'

""" Automatic Helpers
Plug 'IndexedSearch'
Plug 'xolox/vim-session'
" Plug 'Raimondi/delimitMate'
Plug 'scrooloose/syntastic'
" Plug 'ervandew/supertab'
Plug 'Valloric/MatchTagAlways'
" Plug 'Valloric/YouCompleteMe'
" Plug 'kballenegger/vim-autoreadwatch'

""" Language Additions
""    Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
Plug 'thoughtbot/vim-rspec'
""    JavaScript
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'leshill/vim-json'
""    HTML
Plug 'nono/vim-handlebars'
Plug 'othree/html5.vim'
Plug 'indenthtml.vim'
""    TomDoc
Plug 'mutewinter/tomdoc.vim'
Plug 'jc00ke/vim-tomdoc'
""    Other Languages
Plug 'derekwyatt/vim-scala'
Plug 'indentpython.vim'
Plug 'msanders/cocoa.vim'
Plug 'mutewinter/taskpaper.vim'
Plug 'mutewinter/nginx.vim'
Plug 'timcharper/textile.vim'
Plug 'hail2u/vim-css3-syntax'
" Plug 'mutewinter/vim-tmux'
Plug 'plasticboy/vim-markdown'
Plug 'groenewege/vim-less'
Plug 'wavded/vim-stylus'
Plug 'tpope/vim-cucumber'
Plug 'chrisbra/csv.vim'
Plug 'mitsuhiko/vim-jinja'
Plug 'keith/swift.vim'
""" MatchIt
" Plug 'matchit.zip'
" Plug 'kana/vim-textobj-user'
" Plug 'nelstrom/vim-textobj-rubyblock'
" Libraries
Plug 'L9'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'mattn/webapi-vim'
Plug 'xolox/vim-misc'

" Ensime
Plug 'ensime/ensime-vim'

call plug#end()

