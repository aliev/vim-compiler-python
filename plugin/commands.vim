function! DjangoRun(bang, args)
  " Keep old settings
  let l:_makeprg = &makeprg

  execute "compiler python"
  let &makeprg = "django-admin.py"
  execute printf("Dispatch%s _ %s", a:bang ? "!" : "", a:args)
  let &makeprg = l:_makeprg
endfunction

command! -bang -nargs=* -complete=customlist,python#django#complete#managmentcommands Django
      \ call DjangoRun(<bang>0, <q-args>)
