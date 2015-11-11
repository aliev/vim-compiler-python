function! python#commands#python#run(bang, args)
  " Keep old makeprg
  let l:_makeprg = &makeprg

  execute "compiler python"
  let &makeprg = "python"
  execute printf("Dispatch%s _ %s", a:bang ? "!" : "", a:args)

  " Restore old makeprg
  let &makeprg = l:_makeprg
endfunction
