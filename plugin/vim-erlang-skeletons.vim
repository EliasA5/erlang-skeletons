if has('python')
    let s:pyfile = 'pyfile '
elseif has('python3')
    let s:pyfile = 'py3file '
else
    echo "Error: Required vim compiled with +python or +python3"
    finish
endif

let s:pyfile_command = s:pyfile . resolve(expand('<sfile>:p:h:h')) . '/plugin/load_template.py'

let s:plugin_dir = expand('<sfile>:p:h')
if !exists("g:erl_tpl_dir")
    let g:erl_tpl_dir=s:plugin_dir . "/templates"
endif

if !exists("g:erl_author")
    let g:erl_author=$USER
endif

if !exists("g:erl_company")
    let g:erl_company=g:erl_author
endif

if !exists("g:erl_replace_buffer")
    let g:erl_replace_buffer=0
endif

function! LoadTemplate(tpl_file)
    execute s:pyfile_command
endfunction

command! -nargs=0 EQCStatem      call LoadTemplate("eqc_statem")
command! -nargs=0 ErlServer      call LoadTemplate("gen_server")
command! -nargs=0 ErlFsm         call LoadTemplate("gen_fsm")
command! -nargs=0 ErlStatem      call LoadTemplate("gen_statem")
command! -nargs=0 ErlSupervisor  call LoadTemplate("supervisor")
command! -nargs=0 ErlEvent       call LoadTemplate("gen_event")
command! -nargs=0 ErlApplication call LoadTemplate("application")
command! -nargs=0 ErlCTSuite     call LoadTemplate("commontest")
command! -nargs=1 ErlTemplate    call LoadTemplate(<args>)

