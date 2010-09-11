" Vim syntax file
" Language:     Literate Haskell with surrounding TeX markup
" Maintainer:   Ian Lynagh <igloo@earth.li>
" Last Change:  2002 Jan 25
" Version:      1.0

" Known bugs:
" * Gaps and nested comments spread over sections (or in the case of
"   gaps even birdtracks) go wrong

"
if version < 600
    syn clear
elseif exists("b:current_syntax")
    finish
endif

" Heuristic
"   If any of the first s:num_lines lines
"       look like a TeX comment
"       look like the start of a LaTeX document
"   or all of the first s:num_lines lines
"       are blank
"   then this probably has TeX style markup.
"
" Note that for a new file the latter will always hold.
let s:num_lines = 20
let s:tex = 0 " 0 means all lines blank
              " 1 means TeX line seen
              " 2 means only other lines seen
let s:loop = 1
while s:tex != 1 && s:loop <= s:num_lines
    let s:line = getline(s:loop)
    if s:line =~# '^\s*\(%\|\\documentclass\)'
        let s:tex = 1
    elseif s:line !~# '^\s*$'
        let s:tex = 2
    endif
    let s:loop = s:loop + 1
endwhile

if s:tex == 1 || s:tex == 0
    " Load the TeX stuff to do the top level highlighting
    if version < 600
        so <sfile>:p:h/tex.vim
    else
        runtime! syntax/tex.vim
        unlet b:current_syntax
    endif
else
    " At the top level everything is neither Haskell nor TeX
    syn match NotHaskellNorTeX /.*/
endif

" Clean up
unlet s:tex
unlet s:loop
unlet s:line
unlet s:num_lines

" Load the Haskell highlighting stuff into the haskellTop cluster
if version < 600
    syn include @haskellTop <sfile>:p:h/haskell.vim
else
    syn include @haskellTop syntax/haskell.vim
endif

" Use Haskell highlighting in the Haskell sections
syn region lhsLine  matchgroup=NotHaskellNorTeX
    \ start="^>"                 end="$"                contains=@haskellTop
syn region lhsBlock matchgroup=NotHaskellNorTeX
    \ start="^\\begin{p\?x\?code}\s*$" end="^\\end{p\?x\?code}\s*$" contains=@haskellTop
" Stuff that is neither Haskell nor TeX is shown as a comment
highlight link NotHaskellNorTeX Comment

" Set format options so code gets an automatic > leader
setlocal comments=:>
setlocal formatoptions=tcqro
