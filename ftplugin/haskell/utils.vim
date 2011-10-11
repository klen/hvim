" DESC: Set scriptname
let g:scriptname = expand('<sfile>:t')

" OPTION: g:hvim_utils -- bool. Load hvim utils script
call helpers#SafeVar('g:hvim_utils', 1)

" OPTION: g:hvim_utils_type_key -- str. Key for show type
call helpers#SafeVar('g:hvim_utils_type_key', "'<leader>t'")

" OPTION: g:hvim_utils_browse_key -- str. Key for :browse
call helpers#SafeVar('g:hvim_utils_browse_key', "'<leader>t'")

" DESC: Disable script loading
if helpers#SafeVar("b:utils", 1) || !helpers#CheckProgramm('ghc') || g:hvim_utils == 0
    finish
endif

" DESC: Show output from ghci command
" ARGS: cmd -- str, command
"       word -- str, command param
fun! <SID>:ShowGHCICmd(cmd, word) "{{{
    if a:word == '' | call helpers#ShowError('no name/symbol under cursor!') | return 0 | endif
    let output = system(g:ghc . ' -v0 --interactive ' . expand("%"), " :" . a:cmd . " " .  escape(a:word, " "))
    call helpers#ShowPreview(output)
endfunction "}}}

" DESC: Insert ghci type
" ARGS: word -- str, word for type
fun! <SID>:InsertType(word) "{{{
    if a:word == '' | call helpers#ShowError('no name/symbol under cursor!') | return 0 | endif
    let output = system(g:ghc . ' -v0 --interactive ' . expand("%"), ":type ". escape(a:word, " "))
    call append(line(".")-1, output )
endfunction "}}}

" DESC: Search in hoogle
" ARGS: word -- str, word for search
fun! <SID>:Hoogle(word) "{{{
    if !helpers#CheckProgramm('hoogle')
        helpers#ShowError('Hoogle must be installed for this command.')
        return 0
    endif
    let cmd = g:hoogle . " --info " . escape(a:word, " ")
    call helpers#ShowPreviewCmd(cmd)
endfunction "}}}

" DESC: Show type and info
fun! <SID>:ShowDoc() "{{{
    let lnum = line(".")
    let col  = col(".")
    if has('syntax_items')
        if synIDattr(synID(l:lnum, 1, 1), "name") == "HsImport"
            call <SID>:ShowGHCICmd("browse", expand("<cWORD>"))
            return 1
        endif
        if  synIDattr(synID(l:lnum, l:col, 1), "name") == "HsStructure"
            return 0
        endif
    endif
    call <SID>:ShowGHCICmd("info", expand("<cword>"))
endfunction "}}}

" DESC: Set commands
command! -buffer -nargs=+ Hoogle call <SID>:Hoogle("<args>")
command! -buffer -nargs=+ ShowInfo call <SID>:ShowGHCICmd("info", "<args>")
command! -buffer HsType call <SID>:ShowGHCICmd("type", expand("<cword>"))
command! -buffer HsBrowse call <SID>:ShowGHCICmd("browse", expand("<cWORD>"))

" DESC: Set keys
exe "nnoremap <silent> <buffer> " g:hvim_utils_type_key ":HsType<CR>"
exe "nnoremap <silent> <buffer> " g:hvim_utils_browse_key ":HsBrowse<CR>"

nnoremap <silent> <buffer> K :call <SID>:ShowDoc()<CR>
nnoremap <silent> <buffer> <leader>it :call <SID>:InsertType(expand("<cword>"))<CR>
nnoremap <silent> <buffer> <leader>sh :call <SID>:Hoogle(expand("<cWORD>"))<CR>
nnoremap <silent> <buffer> <leader>i :!ghci %<CR>
