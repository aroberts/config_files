if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.html.djt setfiletype htmldjango
  au! BufRead,BufNewFile *.plot setfiletype gnuplot
augroup END

