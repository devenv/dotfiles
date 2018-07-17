au BufRead *.class call SetClassOptions()

function! SetClassOptions()
  setf stata
  silent %!~/bin/decompile_jar.sh %
  set readonly
  set ft=java
  silent normal gg=G
  set nomodified
endfunction
