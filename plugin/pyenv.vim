if !exists('$PYTHONWARNINGS')
  let $PYTHONWARNINGS="ignore"
endif

if !exists('$PYTHONPATH')
  let $PYTHONPATH=$PWD
endif

if !exists('$DJANGO_SETTINGS_MODULE')
  let s:django_project_name = split($PWD, '/')[-1]
  let s:django_settings_file = printf("%s/settings.py", s:django_project_name)
  let s:django_settings_module = printf("%s.settings", s:django_project_name)

  if filereadable(expand(s:django_settings_file))
    let $DJANGO_SETTINGS_MODULE=s:django_settings_module
  endif
endif

