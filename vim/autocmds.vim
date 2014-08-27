" ----------------------------------------
" Auto Commands
" ----------------------------------------

if has("autocmd")
  augroup MyAutoCommands
    " Clear the auto command group so we don't define it multiple times
    " Idea from http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
    autocmd!
    " No formatting on o key newlines
    autocmd BufNewFile,BufEnter * set formatoptions-=o

    " No more complaining about untitled documents
    autocmd FocusLost silent! :wa

    " When editing a file, always jump to the last cursor position.
    " This must be after the uncompress commands.
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line ("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

    " Fix trailing whitespace in my most used programming langauges
    " autocmd BufWritePre *.py,*.coffee,*.rb,*.erb,*.md,*.scss,*.vim,Cakefile
    "       \ silent! :StripTrailingWhiteSpace

    autocmd BufNewFile,BufRead *.vim set filetype=vim
    autocmd BufNewFile,BufRead .ipythonrc set filetype=python
    

    " set python files properly
    autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab
    autocmd FileType jinja set tabstop=2|set shiftwidth=2|set expandtab

    " Help mode bindings
    " <enter> to follow tag, <bs> to go back, and q to quit.
    " From http://ctoomey.com/posts/an-incremental-approach-to-vim/
    autocmd filetype help nnoremap <buffer><cr> <c-]>
    autocmd filetype help nnoremap <buffer><bs> <c-T>
    autocmd filetype help nnoremap <buffer>q :q<CR>

    " Fix accidental indentation in html files
    " from http://morearty.com/blog/2013/01/22/fixing-vims-indenting-of-html-files/
    autocmd FileType html setlocal indentkeys-=*<Return>

    " automatically format xml files with xmllint
    autocmd FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"
    " au FileType json exe ":silent 1,$!python -mjson.tool"

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78

    autocmd TabEnter * normal "<Esc>"
    " Leave the return key alone when in command line windows, since it's used
    " to run commands there.
    autocmd! CmdwinEnter * :unmap <cr>
    autocmd! CmdwinLeave * :call MapCR()
  augroup END
endif
