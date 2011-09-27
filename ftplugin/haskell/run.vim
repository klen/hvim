if helpers#SafeVar("b:did_run", 1) || !helpers#CheckProgramm('runghc')
    finish
endif

" DESC: Save and run haskell code
fun! RunHaskel() "{{{
    if &modifiable && &modified | write | endif	
    call helpers#ShowPreviewCmd(g:runghc . ' ' . expand('%:p'))
endfunction "}}}

" Map keys
nnoremap <silent> <buffer> <leader>r :call RunHaskel()<CR>
