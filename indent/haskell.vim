if helpers#SafeVar('b:did_indent', 1)
    finish
endif

setlocal autoindent
setlocal indentexpr=GetHaskellIndent(v:lnum)
setlocal indentkeys=!^F,o,O,=where,0<Bar>

setlocal expandtab
setlocal softtabstop=4
setlocal shiftwidth=4


fun! GetHaskellIndent(lnum)

    let n0 = a:lnum
    let n1 = a:lnum - 1
    let l0 = getline(n0)
    let l1 = getline(n1)

    " NB: l0 may have trailing characters.  For example: iloveyou<Left><Return>
  let at_new_line_p = (col('.') - 1) == matchend(l0, '^\s*')
  if at_new_line_p
    " Case: 'class' statement
    "   class Monad m where<*>
    "   ##<|>
    if l1 =~# '\v^\s*<class>.*<where>'
      return indent(n1) + &l:shiftwidth
    endif

    " Case: 'instance' statement
    "   instance Eq Foo where<*>
    "   ##<|>
    if l1 =~# '\v^\s*<instance>.*<where>'
      return indent(n1) + &l:shiftwidth
    endif

    " Case: 'do' notation (1)
    "   f a b = do<*>
    "   ##<|>
    if l1 =~# '\v^\s*.{-}<do>\s*(--.*)?$'
      return indent(n1) + &l:shiftwidth
    endif

    " Case: 'do' notation (2)
    "   f a b = do g a<*>
    "   ###########<|>
    let xs = matchlist(l1, '\v^(\s*.{-}<do>\s*)\S')
    if xs != []
      return len(xs[1])
    endif

    " Case: Function definition (1)
    "   f a b =<*>
    "   ##<|>
    if l1 =~# '\v^\s*<\S.*\s+\=\s*(--.*)?$'
      return indent(n1) + &l:shiftwidth
    endif

    " Case: Function definition (2)
    "   f a b = g a >>=<*>
    "   ########<|>
    let R = '\v^(.{-}\s+\=\s+)\S.{-}[^A-Za-z0-9_"'')}\]]\s*(--.*)?$'
    let xs = matchlist(l1, R)
    if xs != []
      return len(xs[1])
    endif

    " Case: 'where' clause (2)
    "   foo = bar . baz
    "   ##where<*>
    "   ####<|>
    if l1 =~# '\v^\s*<where>\s*(--.*)?$'
      return indent(n1) + &l:shiftwidth
    endif

    " Otherwise: Keep the previous indentation level.
    return -1
  else
    " Case: 'where' clause (1)
    "   foo = bar . baz
    "   ##where<*><|>
    if l0 =~# '\v^\s*<where>'
      return indent(prevnonblank(n1)) + &l:shiftwidth
    endif

    " Case: Guards (1)
    "   f a b
    "   ##|<*><|>
    if l0 =~# '\v^\s*\|'
      let np = prevnonblank(n1)
      let after_guard_p = (getline(np) =~# '\v^\s*\|')
      return indent(np) + (after_guard_p ? 0 : &l:shiftwidth)
    endif


    " Otherwise: Keep the previous indentation level.
    return -1
  endif
endfunction
