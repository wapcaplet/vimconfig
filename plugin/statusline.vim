" Status line customizations
if exists("loaded_statusline")
  finish
endif
let loaded_statusline = 1

" ------------------
" STATUS LINE
" ------------------

" Always show status line
set laststatus=2

" Status line items
set statusline=%f                 " Filename
set statusline+=\ %#error#%m%*    " Modified?
set statusline+=%r                " Read-only?
set statusline+=%y                " File type
set statusline+=\ \(%L\ lines\)   " Total lines
set statusline+=%=                " Separator
set statusline+=%l\,%c            " Line# and column
" Display a warning if &et is wrong, or we have mixed-indenting
set statusline+=\ %#error#%{StatuslineTabWarning()}%*
" Show syntax errors on save
set statusline+=%#error#%{SyntasticStatuslineFlag()}%*
" Show Quickfix error count
set statusline+=%#todo#%{QuickFixStatusLine()}%*

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

" Tab character warnings
"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

" Highlight the status line with a color depending on the insert mode
function! InsertStatuslineColor(mode)
    if a:mode == 'i'
        hi statusline ctermbg=117
    elseif a:mode == 'r'
        hi statusline ctermbg=117
    else
        hi statusline ctermbg=117
    endif
endfunction

