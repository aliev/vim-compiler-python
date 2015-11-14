command! -bang -nargs=* -complete=customlist,python#complete#django#django_admin Django
      \ call python#commands#django#django_admin(<bang>0, <q-args>)
