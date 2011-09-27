if helpers#SafeVar("b:did_utils", 1) || !helpers#CheckProgramm('ghc')
    finish
endif

fun! <SID>:ShowGHCICmd(cmd, word) "{{{
    if a:word == '' | call helpers#ShowError('no name/symbol under cursor!') | return 0 | endif
    let output = system(g:ghc . ' -v0 --interactive ' . expand("%"), " :" . a:cmd . " " .  escape(a:word, " "))
    call helpers#ShowPreview(output)
endfunction "}}}


fun! <SID>:InsertType(word) "{{{
    if a:word == '' | call helpers#ShowError('no name/symbol under cursor!') | return 0 | endif
    let output = system(g:ghc . ' -v0 --interactive ' . expand("%"), ":type ". escape(a:word, " "))
    call append(line(".")-1, output )
endfunction "}}}


fun! <SID>:Hoogle(word) "{{{
    if !helpers#CheckProgramm('hoogle')
        helpers#ShowError('Hoogle must be installed for this command.')
        return 0
    endif
    let cmd = g:hoogle . " --info " . escape(a:word, " ")
    call helpers#ShowPreviewCmd(cmd)
endfunction "}}}


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


command! -nargs=+ Hoogle call <SID>:Hoogle("<args>")
command! -nargs=+ ShowInfo call <SID>:ShowGHCICmd("info", "<args>")

" nnoremap <silent> <buffer> K :call <SID>:ShowGHCICmd("info", expand("<cWORD>"))<CR>
nnoremap <silent> <buffer> K :call <SID>:ShowDoc()<CR>
nnoremap <silent> <buffer> <leader>t :call <SID>:ShowGHCICmd("type", expand("<cword>"))<CR>
nnoremap <silent> <buffer> <leader>sb :call <SID>:ShowGHCICmd("browse", expand("<cWORD>"))<CR>

nnoremap <silent> <buffer> <leader>it :call <SID>:InsertType(expand("<cword>"))<CR>
nnoremap <silent> <buffer> <leader>sh :call <SID>:Hoogle(expand("<cWORD>"))<CR>
nnoremap <silent> <buffer> <leader>i :!ghci %<CR>
