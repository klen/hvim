" DESC: Set scriptname
let g:scriptname = expand("<sfile>:t")

" OPTION: g:hvim_run -- bool. Load hvim run script
call helpers#SafeVar("g:hvim_run", 1)

" OPTION: g:hvim_run_key -- string. Key for run haskell code
call helpers#SafeVar("g:hvim_run_key", "<leader>r")

" DESC: Disable script loading
if helpers#SafeVar("b:did_run", 1) || !helpers#CheckProgramm("runghc") || g:hvim_run == 0
    finish
endif

" DESC: Save and run haskell code
fun! <SID>:RunHaskel() "{{{
    if &modifiable && &modified | write | endif	
    call helpers#ShowPreviewCmd(g:runghc . ' ' . expand("%:p"))
endfunction "}}}

" DESC: Set commands
command! -buffer HsRun call <SID>:RunHaskel()

" DESC: Set keys
exe "nnoremap <silent> <buffer> " g:hvim_run_key ":call <SID>:RunHaskel()<CR>"
