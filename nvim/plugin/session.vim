" Utilities for handling vim sessions
" Maintainer: Daniel Tellier <telldanieljames@gmail.com>

if exists('g:loaded_session') || &cp
  finish
endif
let g:loaded_session = 1

command! -nargs=0 MkSession
  \ lua require('plugins.session').mkSession(<f-args>)
command! -nargs=0 Grep
  \ lua require('plugins.session').srcSession(<f-args>)
