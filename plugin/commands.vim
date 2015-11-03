
command! -bang -nargs=* -complete=customlist,python#django#complete#managmentcommands Django
      \ call python#django#admin#command(<bang>0, <q-args>)
