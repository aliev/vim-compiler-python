function! DjangoComplete(prefix, line, ...)
python << EOF
from django.core import management
from django.conf import settings

prefix = vim.eval('a:prefix')
commands = list(management.get_commands())

if prefix:
    commands = [command for command in commands if command.startswith(prefix)]

vim.command('return '+str(commands))
EOF
endfunction

function! DjangoRun(bang, args)
  " Keep old settings
  let l:_makeprg = &makeprg

  execute "compiler python"
  let &makeprg = "django-admin.py"
  execute printf("Dispatch%s _ %s", a:bang ? "!" : "", a:args)
  let &makeprg = l:_makeprg
endfunction

command! -bang -nargs=* -complete=customlist,DjangoComplete  Django
      \ call DjangoRun(<bang>0, <q-args>)
