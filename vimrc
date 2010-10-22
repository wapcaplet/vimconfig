" ------------------
" INTERFACE PREFS
" ------------------

" Allow 256 colors and set color scheme
set t_Co=256
colo mustang
" Default the statusline to green when entering Vim
" (Overrides color defined in colorscheme)
hi statusline cterm=bold ctermbg=148 ctermfg=black

" Show line numbers and current command while typing
set number
set showcmd

" Highlight first match while typing search phrase
set hlsearch
set incsearch
" Highlight the current line
set cursorline

" Ignore non-text files
set wildignore=*.pyc,*.exe,*.pyo

" Set leader character
let mapleader = ","

" Allow hidden buffers
set hidden

" Reduce key mapping timeout
set timeout
set timeoutlen=200
set ttimeoutlen=200

" Don't add two spaces after periods when joining
set nojoinspaces

" ------------------
" PLUGIN SETTINGS
" ------------------
"
" Show error window when syntastic detects errors
let g:syntastic_auto_loc_list=1
let g:syntastic_enable_signs=1

" Swap tab and shift-tab for SuperTab, since the defaults seem
" to work in reverse (forward is backward, backward is forward)
"let g:SuperTabMappingForward = "<s-tab>"
"let g:SuperTabMappingBackward = "<tab>"

" Tell Pydiction where to find files
let g:pydiction_location = "$HOME/.vim/vimfiles/complete-dict"
" Turn on extra highlighting for python
let python_highlight_all = 1

" Browser for Haskell plugin
let g:haddock_browser = "/usr/bin/opera"

" ------------------
" INDENTATION
" ------------------

" Default indentation options
set shiftwidth=4
set tabstop=4
set expandtab
set smarttab
set backspace=indent,eol,start

" Enable filetype-based indentation
filetype on
filetype indent on
filetype plugin on

" Display >... in place of tab characters
set list
set listchars=tab:>.,trail:.,nbsp:.


" ------------------
" KEY BINDINGS
" ------------------

" Put those function keys to use
map <F1> :execute 'NERDTreeToggle'<CR>
map <F2> :execute 'TlistToggle'<CR>
" Custom commands
command! Pylint :call Pylint()
command! Doctest :call Doctest()
" Ctrl-J/K to scroll up and down in normal mode
nmap <C-J> <C-E>
nmap <C-K> <C-Y>
" Ctrl-h/j/k/l to move cursor in insert mode
inoremap <C-h> <C-o>h
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-l> <C-o>l
" Ctrl-z to undo all edits made since going into insert mode
inoremap <C-z> <C-o>u
inoremap <C-r> <C-o><C-r>
" Shortcuts for FuzzyFinder
map <leader>f :FufFile<CR>
map <leader>b :FufBuffer<CR>
map <leader>l :FufLine<CR>
map <leader>n :bprevious<CR>
map <leader>m :bnext<CR>


" ------------------
" ARROW KEYS
" ------------------
function! DelEmptyLineAbove()
    if line(".") == 1
        return
    endif
    let l:line = getline(line(".") - 1)
    if l:line =~ '^\s*$'
        let l:colsave = col(".")
        .-1d
        silent normal! <C-y>
        call cursor(line("."), l:colsave)
    endif
endfunction

function! AddEmptyLineAbove()
    let l:scrolloffsave = &scrolloff
    " Avoid jerky scrolling with ^E at top of window
    set scrolloff=0
    call append(line(".") - 1, "")
    if winline() != winheight(0)
        silent normal! <C-e>
    endif
    let &scrolloff = l:scrolloffsave
endfunction

function! DelEmptyLineBelow()
    if line(".") == line("$")
        return
    endif
    let l:line = getline(line(".") + 1)
    if l:line =~ '^\s*$'
        let l:colsave = col(".")
        .+1d
        ''
        call cursor(line("."), l:colsave)
    endif
endfunction

function! AddEmptyLineBelow()
    call append(line("."), "")
endfunction

" Arrow key remapping: Up/Dn = move line up/dn; Left/Right = indent/unindent
function! SetArrowKeysAsTextShifters()
    map <silent> <Left> <<
    map <silent> <Right> >>
    noremap <silent> <Up> :call DelEmptyLineAbove()<CR>
    noremap <silent> <Down>  :call AddEmptyLineAbove()<CR>
    noremap <silent> <C-Up> :call DelEmptyLineBelow()<CR>
    noremap <silent> <C-Down> :call AddEmptyLineBelow()<CR>
    imap <silent> <Left> <C-D>
    imap <silent> <Right> <C-T>
    inoremap <silent> <Up> <Esc>:call DelEmptyLineAbove()<CR>a
    inoremap <silent> <Down> <Esc>:call AddEmptyLineAbove()<CR>a
    inoremap <silent> <C-Up> <Esc>:call DelEmptyLineBelow()<CR>a
    inoremap <silent> <C-Down> <Esc>:call AddEmptyLineBelow()<CR>a
endfunction

" call SetArrowKeysAsTextShifters()

" ------------------
" TEMPLATES
" ------------------

" Ctrl-p to jump to %...% placeholder and replace
"nnoremap <C-p> /%\u.\{-1,}%<CR>c/%/e<CR>
"inoremap <C-p> <ESC>/%\u.\{-1,}%<CR>c/%/e<CR>

function! LoadTemplate()
    silent! 0r ~/.vim/skel/template.%:e
    syn match Todo "%\u\+%" containedIn=ALL
endfunction

" ------------------
" AUTOCOMMANDS
" ------------------

augroup vimrc_autocmds
    " Clear autocommands so they aren't duplicated
    autocmd!
    " Automatically re-load .vimrc when it's saved
    autocmd BufWritePost .vimrc source %
    " Set indentation for different kinds of files
    autocmd BufRead,BufNewFile *.rb,*.erb,*.html set shiftwidth=2|set tabstop=2
    autocmd BufRead,BufNewFile *.feature set shiftwidth=2|set tabstop=2|set expandtab
    autocmd BufRead,BufNewFile *.py set shiftwidth=4|set tabstop=4
    autocmd BufRead,BufNewFile *.py,*.rb match Underlined '\%80v.*'
    " Set syntax highlighting for Wikipedia/Wikia source
    autocmd BufRead,BufNewFile *.wiki,*.wikia.*,*.wikipedia.org* setfiletype Wikipedia
    " Syntax highlighting for Drupal modules
    autocmd BufRead,BufNewFile *.info,*.module set filetype=php
    " Syntax highlighting for Gemfile
    autocmd BufRead,BufNewFile Gemfile set filetype=ruby
    " Automatically insert shebang for shell scripts, and make them executable
    autocmd BufWritePost *.sh :silent !chmod +x <afile>
    " Load template for new files
    autocmd BufNewFile * call LoadTemplate()
    " Strip trailing whitespace on save
    autocmd BufWritePre * :call <SID>StripTrailingWhitespace()
    " Highlight the status line depending on insert mode
    autocmd InsertEnter * call InsertStatuslineColor(v:insertmode)
    autocmd InsertLeave * hi statusline ctermbg=148
    " Add txt2tags syntax highlighting
    autocmd BufNewFile,BufRead *.t2t set ft=txt2tags
    " Enable compilers for ruby and python
    autocmd FileType ruby compiler ruby
    "autocmd FileType python compiler pylint
    autocmd FileType python SyntasticDisable python
    autocmd FileType cucumber SyntasticDisable cucumber
    " Highlight .less files as .css
    autocmd BufRead,BufNewFile *.less setfiletype css
augroup END

" Run cucumber to see if there are any undefined steps,
" and write the step templates to a new buffer
function! Cucumber()
    new
    let filename = expand('%:p')
    exec 'read !cucumber --format progress --strict '.filename.' | grep "^\(Given\|When\|Then\)"'
endfunction

function! <SID>StripTrailingWhitespace()
    " Save current cursor position
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction

