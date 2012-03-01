augroup filetypedetect
    au BufNewFile,BufRead *.wiki setf Wikipedia

    " Set indentation for various file types
    autocmd BufRead,BufNewFile *.gemspec,*.rb,*.erb,Rakefile set shiftwidth=2|set tabstop=2
    autocmd BufRead,BufNewFile *.css,*.html,*.js,*.webtest set shiftwidth=2|set tabstop=2
    autocmd BufRead,BufNewFile *.feature set shiftwidth=2|set tabstop=2|set expandtab
    autocmd BufRead,BufNewFile *.yml,*.yaml set shiftwidth=2|set tabstop=2|set expandtab
    autocmd BufRead,BufNewFile *.php set shiftwidth=2|set tabstop=2|set expandtab
    autocmd BufRead,BufNewFile *.py set shiftwidth=4|set tabstop=4
    autocmd BufRead,BufNewFile *.py,*.rb match Underlined '\%80v.*'
    autocmd FileType ruby set shiftwidth=2|set tabstop=2

    " Set syntax highlighting for various file types
    autocmd BufRead,BufNewFile *.wiki,*.wikia.*,*.wikipedia.org* set filetype=Wikipedia
    autocmd BufRead,BufNewFile *.info,*.module,*.install set filetype=php
    autocmd BufRead,BufNewFile *.liquid set filetype=liquid
    autocmd BufRead,BufNewFile Gemfile set filetype=ruby
    autocmd BufRead,BufNewFile *.json set filetype=javascript
    autocmd BufRead,BufNewFile *.less set filetype=css
    autocmd BufRead,BufNewFile *.t2t set filetype=txt2tags
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd BufRead,BufNewFile *.wsgi set filetype=python

    " Set wrapping for various file types
    autocmd BufRead,BufNewFile *.txt,*.rst,*.markdown set textwidth=80
augroup END

