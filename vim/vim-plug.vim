" ----------------------------------------
" Vim-Plug
" ----------------------------------------


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugs')

""" Navigation
Plug 'ctrlpvim/ctrlp.vim'
" Plug 'JazzCore/ctrlp-cmatcher'

""" UI Additions
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'scrooloose/nerdtree'
Plug 'Rykka/colorv.vim'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-startify'
" Plug 'mbbill/undotree'

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
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

if executable('ag')
  Plug 'rking/ag.vim'
elseif executable('ack')
  Plug 'mileszs/ack.vim'
endif

Plug 'tpope/vim-abolish'
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'handlebars.html'] }
" Plug 'mutewinter/GIFL' " wrap text in google-i'm-feeling-lucky search result
" Plug 'AndrewRadev/switch.vim'
Plug 'tpope/vim-eunuch' " shell commands/file manip in vim
Plug 'mutewinter/UnconditionalPaste'
Plug 'HelpClose'
Plug 'mattn/gist-vim'
Plug 'bronson/vim-visual-star-search'
Plug 'sk1418/Join'
" Plug 'SirVer/ultisnips'

""" Automatic Helpers
Plug 'henrik/vim-indexed-search'
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
" Plug 'Raimondi/delimitMate' " auto insert pair delimiters
Plug 'scrooloose/syntastic'
Plug 'Valloric/MatchTagAlways'
Plug 'Valloric/YouCompleteMe'

" check file on disk for changes more often
" Plug 'kballenegger/vim-autoreadwatch'

""" Language Additions
""    Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-rake', { 'for': 'ruby' }
Plug 'tpope/vim-bundler', { 'for': 'ruby' }
Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }
""    JavaScript
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'leshill/vim-json'
""    HTML
Plug 'nono/vim-handlebars'
Plug 'othree/html5.vim'
Plug 'indenthtml.vim'
""    Other Languages
Plug 'derekwyatt/vim-scala'
Plug 'indentpython.vim'
Plug 'blueyed/nginx.vim'
Plug 'timcharper/textile.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'plasticboy/vim-markdown'
Plug 'groenewege/vim-less'
Plug 'tpope/vim-cucumber'
Plug 'chrisbra/csv.vim'
Plug 'mitsuhiko/vim-jinja'
Plug 'keith/swift.vim'
" Libraries
Plug 'L9'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'mattn/webapi-vim'
" Plug 'xolox/vim-misc'

" Ensime
Plug 'ensime/ensime-vim'

call plug#end()

