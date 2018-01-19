" Credit github.com/mutewinter/dot_vim

" All of the plugins are installed with vim-plug from this file.
source ~/.vim/vim-plug.vim

" Automatically detect file types. (must turn on after vim-plug)
filetype plugin indent on

" Platform (Windows, Mac, etc.) configuration.
source ~/.vim/platforms.vim

" All of the Vim configuration.
source ~/.vim/config.vim

" New commands
source ~/.vim/commands.vim

" All hotkeys, not dependant on plugins, are mapped here.
source ~/.vim/mappings.vim

" Plugin-specific configuration.
source ~/.vim/plugin_config.vim

" Small custom functions.
source ~/.vim/functions.vim

" Auto commands.
source ~/.vim/autocmds.vim
