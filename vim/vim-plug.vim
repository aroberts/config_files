" ----------------------------------------
" Vim-Plug
" ----------------------------------------

call plug#begin('~/.vim/plugs')

""" Navigation
Plug 'ctrlpvim/ctrlp.vim'
" Plug 'JazzCore/ctrlp-cmatcher'

""" UI Additions
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'scrooloose/nerdtree'
" Plug 'Rykka/colorv.vim' # broken- https://github.com/gu-fan/colorv.vim/issues/32
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

if executable('yarn')
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install()}}
endif

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
" Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'handlebars.html'] }
Plug 'tpope/vim-eunuch' " shell commands/file manip in vim
Plug 'inkarkat/vim-UnconditionalPaste'
Plug 'vim-scripts/HelpClose'
" Plug 'mattn/gist-vim'
Plug 'bronson/vim-visual-star-search'
Plug 'sk1418/Join'
" Plug 'SirVer/ultisnips'

""" Automatic Helpers
Plug 'henrik/vim-indexed-search'
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
" Plug 'Raimondi/delimitMate' " auto insert pair delimiters
Plug 'vim-syntastic/syntastic'
if has('python3') | Plug 'Valloric/MatchTagAlways' | endif
" Plug 'Valloric/YouCompleteMe'

" check file on disk for changes more often
" Plug 'kballenegger/vim-autoreadwatch'

""" Language Additions
""    Ruby
" Plug 'vim-ruby/vim-ruby'
" Plug 'tpope/vim-haml'
" Plug 'tpope/vim-rails', { 'for': 'ruby' }
" Plug 'tpope/vim-rake', { 'for': 'ruby' }
" Plug 'tpope/vim-bundler', { 'for': 'ruby' }
" Plug 'thoughtbot/vim-rspec', { 'for': 'ruby' }
""    JavaScript
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'leshill/vim-json'
""    HTML
Plug 'nono/vim-handlebars'
Plug 'othree/html5.vim'
Plug 'vim-scripts/indenthtml.vim'
""    Other Languages
Plug 'derekwyatt/vim-scala'
Plug 'vim-scripts/indentpython.vim'
Plug 'blueyed/nginx.vim'
Plug 'timcharper/textile.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'plasticboy/vim-markdown'
Plug 'groenewege/vim-less'
" Plug 'tpope/vim-cucumber'
Plug 'chrisbra/csv.vim'
" Plug 'mitsuhiko/vim-jinja'
Plug 'keith/swift.vim'
" Libraries
Plug 'vim-scripts/L9'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'mattn/webapi-vim'
" Plug 'xolox/vim-misc'

Plug 'edkolev/tmuxline.vim'

call plug#end()

