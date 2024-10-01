if !exists("main_syntax")
  " quit when a syntax file was already loaded.
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = "tape"
elseif exists("b:current_syntax") && b:current_syntax == "tape"
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn keyword tapeCommentTodo TODO FIX XXX TBD contained
syn region tapeStringD start=+"+ skip=+\\\\\|\\"+ end=+"\|$+

syn match tapeLineComment "#.*" contains=@Spell,tapeCommentTodo

syn match tapeKeyCombo "Ctrl[+Alt]?[+Shift]?+[a-zA-Z]"

syn keyword tapeKeys Left Right Up Down Backspace Enter Tab Space
syn keyword tapeSpecial Screenshot Copy Paste
syn keyword tapeReserved Output Require Set Type Sleep Source Env

if main_syntax == "tape"
  syn sync fromstart
  syn sync maxlines=100

  syn sync ccomment tapeLineComment
endif

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi def link tapeLineComment Comment
hi def link tapeCommentTodo Todo
hi def link tapeStringD String

hi def link tapeKeyCombo Label

hi def link tapeKeys Repeat
hi def link tapeSpecial Special
hi def link tapeReserved Keyword

let b:current_syntax = "tape"

if main_syntax == 'tape'
  unlet main_syntax
endif

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8
