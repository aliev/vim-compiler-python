command! -bang -nargs=* -complete=customlist,python#django#complete_managment_commands Django
      \ call python#django#admin_command(<bang>0, <q-args>)
