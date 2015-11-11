function! python#commands#django#admin_command(bang, args)
  " Keep old makeprg
  let l:_makeprg = &makeprg

  execute "compiler python"
  let &makeprg = "django-admin.py"
  execute printf("Dispatch%s _ %s", a:bang ? "!" : "", a:args)

  " Restore old makeprg
  let &makeprg = l:_makeprg
endfunction

function! python#commands#django#complete_managment_commands(prefix, line, ...)
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
