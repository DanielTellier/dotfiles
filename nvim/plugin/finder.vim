" Finds certain types of definitions in various programming languages
" Maintainer: Daniel Tellier <telldanieljames@gmail.com>

if exists('g:loaded_finder') || &cp
  finish
endif
let g:loaded_finder = 1

command! -nargs=1 FindCDef
  \ lua require('plugins.finder').findCDef(<f-args>)
command! -nargs=+ -complete=file Grep
  \ lua require('plugins.finder').grepExt(<f-args>)
