if exists("b:current_syntax")
  finish
endif

syntax match Invalid /^.*$/
syntax match Value /\([ \t]\+[^ \t]\+\)*[ \t]*$/
syntax match Key /^[ \t]*[^ \t]\+/
syntax match Comment /^#.*$/

highlight Invalid ctermfg=Red
highlight Value ctermfg=LightGreen
highlight Key ctermfg=LightBlue
highlight Comment ctermfg=DarkGray

let b:current_syntax="key_value_pairs"
