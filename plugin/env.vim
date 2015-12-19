" Detect Django settings
if !exists('$DJANGO_SETTINGS_MODULE')
  let s:django_project_name = split($PWD, '/')[-1]
  let s:django_settings_file = printf("%s/settings.py", s:django_project_name)
  let s:django_settings_module = printf("%s.settings", s:django_project_name)

  if filereadable(expand(s:django_settings_file))
    let $DJANGO_SETTINGS_MODULE=s:django_settings_module
  endif
endif

" Disable Python warnings
if !exists('$PYTHONWARNINGS')
  let $PYTHONWARNINGS="ignore"
endif

if !exists('$PYTHONPATH')
  let $PYTHONPATH=$PWD
endif

if has('python')
py << EOF
import os
import os.path, sys
import vim

if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
    python_version = os.listdir(project_base_dir + '/lib')[0]

    site_packages = os.path.join(project_base_dir, 'lib', python_version, 'site-packages')
    current_directory = os.getcwd()

    sys.path.insert(1, site_packages)
    sys.path.insert(1, current_directory)
EOF
endif

