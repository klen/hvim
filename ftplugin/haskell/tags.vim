" DESC: Set scriptname
let g:scriptname = expand('<sfile>:t')

" OPTION: g:hvim_tags -- bool. Load hvim tags script
call helpers#SafeVar('g:hvim_tags', 1)

" OPTION: g:hvim_tags_write -- bool. Regenerate tags every save
call helpers#SafeVar('g:hvim_tags_write', 1)

" DESC: Disable script loading
if helpers#SafeVar("b:tags", 1) || !helpers#CheckProgramm('hasktags') || g:hvim_tags == 0
    finish
endif

" DESC: Update ctags file
fun! <SID>:HaskellCTags() "{{{
    echo system(g:hasktags . ' -cx ' . getcwd() . "/*.hs")
endfunction "}}}

" DESC: Fix tlist plugin
let Tlist_haskell_Ctags_Cmd = g:hasktags . ' -x -c -o -'
let Tlist_haskell_Ctags_Allowed_Flags = []
let tlist_haskell_settings     = 'haskell;m:module;d:data;t:type;c_a:c_a;fi:fi'

" DESC: Set commands
command! -buffer HsTags call <SID>:HaskellCTags()

" DESC: Set autocommands
if g:hvim_tags_write
    au BufWritePost <buffer> call s:CTags()
endif
