if helpers#SafeVar("b:did_tags", 1) || !helpers#CheckProgramm('hasktags')
    finish
endif

" DESC: Update ctags file
fun! s:CTags()
  echo system(g:hasktags . ' -cx ' . getcwd() . "/*.hs")
endfunction

let Tlist_haskell_Ctags_Cmd = g:hasktags . ' -x -c -o -'
let Tlist_haskell_Ctags_Allowed_Flags = []
let tlist_haskell_settings     = 'haskell;m:module;d:data;t:type;c_a:c_a;fi:fi'

au BufWritePost <buffer> call s:CTags()
