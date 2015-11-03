
command! -bang -nargs=* -complete=customlist,python#django#complete#managmentcommands Django
      \ call python#django#admin#run(<bang>0, <q-args>)
