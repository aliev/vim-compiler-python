function! python#django#admin#command(bang, args)
  " Keep old settings
  let l:_makeprg = &makeprg

  execute "compiler python"
  let &makeprg = "django-admin.py"
  execute printf("Dispatch%s _ %s", a:bang ? "!" : "", a:args)
  let &makeprg = l:_makeprg
endfunction
