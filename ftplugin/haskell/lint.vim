if helpers#SafeVar("b:did_lint", 1) || !helpers#CheckProgramm('ghc')
    finish
endif

sign define E text=EE texthl=Error
sign define W text=WW texthl=Todo
sign define C text=CC texthl=Comment

execute 'setlocal makeprg=' . g:ghc . '\ -e\ :q\ %'
setlocal errorformat=
                    \%-Z\ %#,
                    \%W%f:%l:%c:\ Warning:\ %m,
                    \%E%f:%l:%c:\ %m,
                    \%E%>%f:%l:%c:,
                    \%+C\ \ %#%m,
                    \%W%>%f:%l:%c:,
                    \%+C\ \ %#%tarning:\ %m,

au BufWritePost <buffer> call helpers#Lint('silent make')
