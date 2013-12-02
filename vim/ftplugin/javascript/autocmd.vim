" Additions for javascript filetype

if exists("g:loaded_javascript_autocmds")
  finish
endif

let g:loaded_javascript_autocmds = 1
autocmd Filetype javascript setlocal tabstop=2 softtabstop=2 expandtab


