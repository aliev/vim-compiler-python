function! python#commands#django#django_admin(bang, args)
  " Keep old makeprg
  let l:_makeprg = &makeprg

  execute "compiler python"
  let &makeprg = "django-admin.py"
  execute printf("Dispatch%s _ %s", a:bang ? "!" : "", a:args)

  " Restore old makeprg
  let &makeprg = l:_makeprg
endfunction
