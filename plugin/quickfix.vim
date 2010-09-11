" QuickFix window customizations and make functions

if exists("loaded_quickfix")
    finish
endif
let loaded_quickfix = 1

" ---------------------------------
" Externally-accessible functions
" ---------------------------------
" Pylint
function! Pylint()
    if !executable("pylint")
        return
    endif
    let makeprg = 'pylint -f parseable %'
    let errorformat = '%f:%l: [%t%n%.%#] %m'
    call s:RunMake({'makeprg': makeprg, 'errorformat': errorformat})
    call s:ShowErrors()
endfunction

" Python doctests
function! Doctest()
    let makeprg = 'python -m doctest %'
    let errorformat = 'File "%f"\, line %l%.%#'
    call s:RunMake({'makeprg': makeprg, 'errorformat': errorformat})
    call s:ShowErrors()
endfunction

" Cucumber
function! Cucumber()
    let makeprg = 'cucumber --strict --format progress'
    let errorformat = ''
    call s:RunMake({'makeprg': makeprg, 'errorformat': errorformat})
    call s:ShowErrors()
endfunction

" Status line indicator
" If b:errors is undefined, return an empty string.
" If there are errors, return [N errors], otherwise return [OK]
function! QuickFixStatusLine()
    if !exists("b:errors")
        return ''
    elseif s:HaveErrors()
        let err_count = len(b:errors)
        return '['.err_count.' errors]'
    else
        return '[OK]'
    endif
endfunction

" ---------------------------------
" Internal functions
" ---------------------------------
" Generic make function
function! s:RunMake(options)
    let &makeprg = a:options['makeprg']
    let &errorformat = a:options['errorformat']
    silent make
    let b:errors = s:ActualErrors()
endfunction

" Return a list of errors that have a line number
function! s:ActualErrors()
    let b:errors = getqflist()
    return filter(copy(b:errors), 'v:val["lnum"] !=# 0')
endfunction

" Return true if there are errors to display
function! s:HaveErrors()
    return !empty(s:ActualErrors())
endfunction

" Display the current buffer's errors in the Quickfix window,
" and add sign markers on each error line
:sign define fixme text=>> texthl=todo
function! s:ShowErrors()
    cclose
    execute "sign unplace *"
    " Only proceed if there are some errors to display
    if s:HaveErrors()
        copen
        wincmd k
        let l:fname = expand("%:p")
        let l:type = 'fixme'
        let l:id = 1
        for l:item in b:errors
            let l:lnum = item['lnum']
            let l:exec = printf('sign place %d line=%d name=%s file=%s',
                                \ l:id, l:lnum, l:type, l:fname)
            execute l:exec
            let l:id = l:id + 1
        endfor
    endif
    redraw!
endfunction

" Close the Quickfix window if it's the only thing open
autocmd BufEnter * call s:MyLastWindow()
function! s:MyLastWindow()
    " if the window is quickfix go on
    if &buftype=="quickfix"
        " if this window is last on screen quit without warning
        if winbufnr(2) == -1
            quit!
        endif
    endif
endfunction

