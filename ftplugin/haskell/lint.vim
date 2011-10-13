" DESC: Set scriptname
let g:scriptname = expand("<sfile>:t")

" OPTION: g:hvim_lint -- bool. Load hvim lint
call helpers#SafeVar("g:hvim_lint", 1)

" OPTION: g:hvim_lint_write -- bool. Make code every save
call helpers#SafeVar("g:hvim_lint_write", 1)

" DESC: Disable script loading
if helpers#SafeVar("b:lint", 1) || !helpers#CheckProgramm("ghc") || g:hvim_lint == 0
    finish
endif

" DESC: Signs definition
sign define E text=EE texthl=Error
sign define W text=WW texthl=Todo
sign define C text=CC texthl=Comment

execute "setlocal makeprg=" . g:ghc . '\ -e\ :q\ %'
setlocal errorformat=
                    \%-Z\ %#,
                    \%W%f:%l:%c:\ Warning:\ %m,
                    \%E%f:%l:%c:\ %m,
                    \%E%>%f:%l:%c:,
                    \%+C\ \ %#%m,
                    \%W%>%f:%l:%c:,
                    \%+C\ \ %#%tarning:\ %m,

" DESC: Set commands
command! -buffer HsLint :call helpers#Lint("silent make")

" DESC: Set autocommands
if g:hvim_lint_write
    au BufWritePost <buffer> call helpers#Lint("silent make")
endif
