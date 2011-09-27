if helpers#SafeVar('b:did_options', 1)
    finish
endif

setlocal nowrap
setlocal number
setlocal foldlevelstart=99
setlocal foldlevel=99
setlocal foldmethod=indent

setlocal complete=""
setlocal complete+=.
setlocal complete+=k
setlocal complete+=b
setlocal completeopt-=preview
setlocal completeopt+=longest

setlocal include=^import\\s*\\(qualified\\)\\?\\s*
setlocal includeexpr=substitute(v:fname,'\\.','/','g').'.'
setlocal suffixesadd=hs,lhs,hsc
