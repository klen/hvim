hvim, Haskell in VIM
==========================

This plugin allow you create haskell code in vim very easily.


Requirements
------------

- VIM >= 7.0 with python support
- ghc_ -- for code run and checking
- hacktags_ -- for auto creation tags
- hoogle_ -- for hoogle search


Installation
------------

- Just copy the plugin folders into your `~/.vim` directory.

.. note:: Alternatively, if you are using pathogen_, clone the plugin into your ``bundle`` folder.


Settings
--------

To change this settings, edit your `~/.vimrc` file. Default values: ::

    " Python interpreter
    let g:ghc = 'ghc'

    " Hoogle command
    let g:hoogle = 'pydoc'

    " Hasktags command
    let g:hasktags = 'pydoc'

    " Open cwindow if compilation ends with errors
    let g:MakeCWindow = 1

    " Place error signs
    let g:MakeErrorSigns = 1


Keys
----

<Leader>r -- Run code
K -- Show ghc :info
<Leader>t -- Show ghc :type
<Leader>it -- Insert ghc type
<Leader>sh -- Search in hoogle
<Leader>i -- Load file in ghci


Bug tracker
-----------

If you have any suggestions, bug reports or
annoyances please report them to the issue tracker
at https://github.com/klen/hvim/issues


Contributing
------------

Development of hvim happens at github: https://github.com/klen/hvim


Contributors
-------------

* klen_ (Kirill Klenov)


License
-------

Licensed under a `GNU lesser general public license`_.


.. _GNU lesser general public license: http://www.gnu.org/copyleft/lesser.html
.. _klen: http://klen.github.com/
.. _pathogen: https://github.com/tpope/vim-pathogen
.. _plugin-helpers: https://github.com/klen/plugin-helpers
.. _ghc: http://www.haskell.org/ghc/
.. _hasktags: http://www.haskell.org/haskellwiki/Hasktags#Haskell_tag_generators
.. _hoogle: http://www.haskell.org/hoogle/
