" Vim syntax file
" Language:	Haskell
" Maintainer:	John Williams <jrw@pobox.com>
" Last Change:	2001 Sep 02
" Thanks to Ryan Crumley for suggestions and John Meacham for
" pointing out bugs.
"
" Options-assign a value to these variables to turn the option on:
"
" hs_highlight_delimiters - Highlight delimiter characters--users
"			    with a light-colored background will
"			    probably want to turn this on.
" hs_highlight_boolean - Treat True and False as keywords.
" hs_highlight_types - Treat names of primitive types as keywords.
" hs_highlight_more_types - Treat names of other common types as keywords.
" hs_highlight_debug - Highlight names of debugging functions.

" Remove any old syntax stuff hanging around
if version < 600
  syn clear
elseif exists("b:current_syntax")
  finish
endif

" (Qualified) identifiers (no default highlighting)
syn match ConId "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=\<[A-Z][a-zA-Z0-9_']*\>"
syn match VarId "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=\<[a-z][a-zA-Z0-9_']*\>"

" Infix operators--most punctuation characters and any (qualified) identifier
" enclosed in `backquotes`. An operator starting with : is a constructor,
" others are variables (e.g. functions).
syn match hsVarSym "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[-!#$%&\*\+/<=>\?@\\^|~.][-!#$%&\*\+/<=>\?@\\^|~:.]*"
syn match hsConSym "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=:[-!#$%&\*\+./<=>\?@\\^|~:]*"
syn match hsVarSym "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[a-z][a-zA-Z0-9_']*`"
syn match hsConSym "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[A-Z][a-zA-Z0-9_']*`"

" Reserved symbols--cannot be overloaded.
syn match hsDelimiter  "(\|)\|\[\|\]\|,\|;\|_\|{\|}"

" Strings and constants
syn match   hsSpecialChar	contained "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&\\abfnrtv]\|^[A-Z^_\[\\\]]\)"
syn match   hsSpecialChar	contained "\\\(NUL\|SOH\|STX\|ETX\|EOT\|ENQ\|ACK\|BEL\|BS\|HT\|LF\|VT\|FF\|CR\|SO\|SI\|DLE\|DC1\|DC2\|DC3\|DC4\|NAK\|SYN\|ETB\|CAN\|EM\|SUB\|ESC\|FS\|GS\|RS\|US\|SP\|DEL\)"
syn match   hsSpecialCharError	contained "\\&\|'''\+"
syn region  hsString		start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=hsSpecialChar
syn match   hsCharacter		"[^a-zA-Z0-9_']'\([^\\]\|\\[^']\+\|\\'\)'"lc=1 contains=hsSpecialChar,hsSpecialCharError
syn match   hsCharacter		"^'\([^\\]\|\\[^']\+\|\\'\)'" contains=hsSpecialChar,hsSpecialCharError
syn match   hsNumber		"\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>"
syn match   hsFloat		"\<[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>"

" Keyword definitions. These must be patters instead of keywords
" because otherwise they would match as keywords at the start of a
" "literate" comment (see lhs.vim).
syn match hsModule		"\<module\>"
syn match hsImport		"\<import\>.*"he=s+6 contains=hsImportMod
syn match hsImportMod		contained "\<\(as\|qualified\|hiding\)\>"
syn match hsInfix		"\<\(infix\|infixl\|infixr\)\>"
syn match hsStructure		"\<\(class\|data\|deriving\|instance\|default\|where\)\>"
syn match hsTypedef		"\<\(type\|newtype\)\>"
syn match hsStatement		"\<\(do\|case\|of\|let\|in\)\>"
syn match hsConditional		"\<\(if\|then\|else\)\>"

" Not real keywords, but close.
if exists("hs_highlight_boolean")
  " Boolean constants from the standard prelude.
  syn match hsBoolean "\<\(True\|False\)\>"
endif
if exists("hs_highlight_types")
  " Primitive types from the standard prelude and libraries.
  syn match hsType "\<\(Int\|Integer\|Char\|Bool\|Float\|Double\|IO\|Void\|Addr\|Array\|String\)\>"
endif
if exists("hs_highlight_more_types")
  " Types from the standard prelude libraries.
  syn match hsType "\<\(Maybe\|Either\|Ratio\|Complex\|Ordering\|IOError\|IOResult\|ExitCode\)\>"
  syn match hsMaybe    "\<Nothing\>"
  syn match hsExitCode "\<\(ExitSuccess\)\>"
  syn match hsOrdering "\<\(GT\|LT\|EQ\)\>"
endif
if exists("hs_highlight_debug")
  " Debugging functions from the standard prelude.
  syn match hsDebug "\<\(undefined\|error\|trace\)\>"
endif


" Comments
syn match   hsLineComment      "---*\([^-!#$%&*+./<=>?@\^|~].*\)\?$"
"syn match   hsLineComment      "--.*"
syn region  hsBlockComment     start="{-"  end="-}" contains=hsBlockComment
syn region  hsPragma           start="{-#" end="#-}"

" Literate comments--any line not starting with '>' is a comment.
if exists("b:hs_literate_comments")
  syn region  hsLiterateComment   start="^" end="^>"
endif

if !exists("hs_minlines")
  let hs_minlines = 50
endif
exec "syn sync lines=" . hs_minlines

if version >= 508 || !exists("did_hs_syntax_inits")
  if version < 508
    let did_hs_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  hi link hsModule			  hsStructure
  hi link hsImport			  Include
  hi link hsImportMod			  hsImport
  hi link hsInfix			  PreProc
  hi link hsStructure			  Structure
  hi link hsStatement			  Statement
  hi link hsConditional			  Conditional
  hi link hsSpecialChar			  SpecialChar
  hi link hsTypedef			  Typedef
  hi link hsVarSym			  hsOperator
  hi link hsConSym			  hsOperator
  hi link hsOperator			  Operator
  if exists("hs_highlight_delimiters")
    " Some people find this highlighting distracting.
    hi link hsDelimiter			  Delimiter
  endif
  hi link hsSpecialCharError		  Error
  hi link hsString			  String
  hi link hsCharacter			  Character
  hi link hsNumber			  Number
  hi link hsFloat			  Float
  hi link hsConditional			  Conditional
  hi link hsLiterateComment		  hsComment
  hi link hsBlockComment		  hsComment
  hi link hsLineComment			  hsComment
  hi link hsComment			  Comment
  hi link hsPragma			  SpecialComment
  hi link hsBoolean			  Boolean
  hi link hsType			  Type
  hi link hsMaybe			  hsEnumConst
  hi link hsOrdering			  hsEnumConst
  hi link hsEnumConst			  Constant
  hi link hsDebug			  Debug

  delcommand HiLink
endif

"if version < 600
"    syn include @cppTop <sfile>:p:h/c.vim
"else
"    syn include @cppTop syntax/c.vim
"endif
"
"syn region cppLine start="^#"rs=s-1 end="$" contains=@cPreProcGroup keepend

syn region cppError     display start="^\s*#"                                            end="$"
syn region cppDirective display start="^\s*#\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$"
syn region cppDirective display start="^\s*#\s*\(else\|endif\)\>"                        end="$"
if !exists("cpp_no_if0")
    syn region cppComment                  start="^\s*#\s*if\s\+0\+\>"                            end=".\|$"                                contains=cppCommentInside
    syn region cppCommentInside  contained start="0"                                              end="^\s*#\s*\(endif\>\|else\>\|elif\>\)" contains=cppCommentInside2
    syn region cppCommentInside2 contained start="^\s*#\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*#\s*endif\>"                     contains=cppCommentInside2
endif
syn match  cppInclude   display                 "^\s*#\s*include\>\s*["<]"                                                          contains=cppIncluded
syn region cppIncluded  display contained start=+"+                                                        skip=+\\\\\|\\"+ end=+"+
syn match  cppIncluded  display contained       "<[^>]*>"
syn region cppDirective                   start="^\s*#\s*\(define\|undef\)\>"                              skip="\\$"       end="$"
syn region cppDirective                   start="^\s*#\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$"       end="$"

hi link cppInclude        PreCondit
hi link cppIncluded       String
hi link cppDirective      PreCondit
hi link cppCommentInside  cppComment
hi link cppCommentInside2 cppComment
hi link cppComment        Comment
hi link cppError          Error

let b:current_syntax = "haskell"

" Options for vi: ts=8 sw=2 sts=2 nowrap noexpandtab ft=vim
