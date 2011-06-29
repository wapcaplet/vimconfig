" ------------------
" INTERFACE PREFS
" ------------------

filetype off " So filetype will be refreshed for pathogen
call pathogen#runtime_append_all_bundles()

" Allow 256 colors and set color scheme
set t_Co=256
colo mustang
" Run :so colors/demo.vim in an empty buffer for color

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
"set cursorline

" Ignore non-text files
set wildignore=*.pyc,*.exe,*.pyo

" Set leader character
let mapleader = ","

" Allow hidden buffers
set hidden

" Reduce key mapping timeout
set timeout
set timeoutlen=300
set ttimeoutlen=300

" Don't add two spaces after periods when joining
set nojoinspaces

" No backup or swap files
set nobackup
set nowritebackup
set noswapfile

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
set autoindent

" vim-indent-guides config
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 0
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_indent_levels = 10
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=236

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
map <F1> :execute 'NERDTreeToggle %:p:h'<CR>
map <F2> :execute 'TlistToggle'<CR>
" Custom commands
command! Pylint :call Pylint()
command! Doctest :call Doctest()
" Ctrl-J/K to scroll up and down in normal mode
nmap <C-J> <C-E>
nmap <C-K> <C-Y>
" Ctrl-h/j/k/l to switch windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" Ctrl-z to undo all edits made since going into insert mode
inoremap <C-z> <C-o>u
inoremap <C-r> <C-o><C-r>
" Shortcuts for FuzzyFinder
map <leader>f :FufFile<CR>
map <leader>b :FufBuffer<CR>
map <leader>l :FufLine<CR>
"let g:fuf_keyOpenSplit = '<C-s>'
"let g:fuf_keyOpenVsplit = '<C-v>'
"let g:fuf_keyOpenTabpage = '<C-t>'
"let g:fuf_keyPrevMode = '<C-n>'
"let g:fuf_keyNextMode = '<C-m>'
"let g:fuf_keyPrevPattern = '<C-h>'
"let g:fuf_keyNextPattern = '<C-l>'
" Buffer navigation
map <leader>n :bprevious<CR>
map <leader>m :bnext<CR>
map <leader>d :BD<CR>


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

call SetArrowKeysAsTextShifters()

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

    " Set indentation for various file types
    autocmd BufRead,BufNewFile *.gemspec,*.rb,*.erb,Rakefile set shiftwidth=2|set tabstop=2
    autocmd BufRead,BufNewFile *.css,*.html,*.js set shiftwidth=2|set tabstop=2
    autocmd BufRead,BufNewFile *.feature set shiftwidth=2|set tabstop=2|set expandtab
    autocmd BufRead,BufNewFile *.yml,*.yaml set shiftwidth=2|set tabstop=2|set expandtab
    autocmd BufRead,BufNewFile *.php set shiftwidth=2|set tabstop=2|set expandtab
    autocmd BufRead,BufNewFile *.py set shiftwidth=4|set tabstop=4
    autocmd BufRead,BufNewFile *.py,*.rb match Underlined '\%80v.*'
    autocmd FileType ruby set shiftwidth=2|set tabstop=2

    " Set syntax highlighting for various file types
    autocmd BufRead,BufNewFile *.wiki,*.wikia.*,*.wikipedia.org* set filetype=Wikipedia
    autocmd BufRead,BufNewFile *.info,*.module set filetype=php
    autocmd BufRead,BufNewFile *.liquid set filetype=liquid
    autocmd BufRead,BufNewFile Gemfile set filetype=ruby
    autocmd BufRead,BufNewFile *.json set filetype=javascript
    autocmd BufRead,BufNewFile *.less set filetype=css
    autocmd BufRead,BufNewFile *.t2t set filetype=txt2tags
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd BufRead,BufNewFile *.wsgi set filetype=python

    " Set wrapping for various file types
    autocmd BufRead,BufNewFile *.txt,*.rst set textwidth=80

    " Start at top of file when editing git/bzr commit messages
    autocmd BufRead,BufNewFile COMMIT_EDITMSG,bzr_log.* call cursor(1, 0)
    autocmd BufRead,BufNewFile COMMIT_EDITMSG,bzr_log.* set textwidth=72

    " Automatically insert shebang for shell scripts, and make them executable
    autocmd BufWritePost *.sh :silent !chmod +x <afile>
    " Load template for new files
    autocmd BufNewFile * call LoadTemplate()
    " Strip trailing whitespace on save
    autocmd BufWritePre * :call <SID>StripTrailingWhitespace()

    " Highlight the status line depending on insert mode
    autocmd InsertEnter * call InsertStatuslineColor(v:insertmode)
    autocmd InsertLeave * hi statusline ctermbg=148

    " Enable compilers for ruby and python
    autocmd FileType ruby compiler ruby
    "autocmd FileType python compiler pylint

    " Disable syntastic for some file types
    autocmd FileType python SyntasticDisable python
    autocmd FileType cucumber SyntasticDisable cucumber
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

