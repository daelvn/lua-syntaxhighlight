local lpeg = require('lpeg')
-- Copyright 2015-2019 Jason Schindler. See License.txt.
-- Fish (http://fishshell.com/) script LPeg lexer.

local lexer = require('syntaxhighlight.textadept.lexer')
local token, word_match = lexer.token, lexer.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local lex = lexer.new('fish')

-- Whitespace.
lex:add_rule('whitespace', token(lexer.WHITESPACE, lexer.space^1))

-- Keywords.
lex:add_rule('keyword', token(lexer.KEYWORD, word_match[[
  alias and begin bg bind block break breakpoint builtin case cd command
  commandline complete contains continue count dirh dirs echo else emit end eval
  exec exit fg fish fish_config fishd fish_indent fish_pager fish_prompt
  fish_right_prompt fish_update_completions for funced funcsave function
  functions help history if in isatty jobs math mimedb nextd not open or popd
  prevd psub pushd pwd random read return set set_color source status switch
  test trap type ulimit umask vared while
]]))

-- Identifiers.
lex:add_rule('identifier', token(lexer.IDENTIFIER, lexer.word))

-- Variables.
lex:add_rule('variable', token(lexer.VARIABLE,
                               '$' * (lexer.word +
                                      lexer.delimited_range('{}', true, true))))

-- Strings.
local sq_str = lexer.delimited_range("'", false, true)
local dq_str = lexer.delimited_range('"')
lex:add_rule('string', token(lexer.STRING, sq_str + dq_str))

-- Shebang.
lex:add_rule('shebang', token('shebang', '#!/' * lexer.nonnewline^0))
lex:add_style('shebang', lexer.STYLE_LABEL)

-- Comments.
lex:add_rule('comment', token(lexer.COMMENT, '#' * lexer.nonnewline^0))

-- Numbers.
lex:add_rule('number', token(lexer.NUMBER, lexer.float + lexer.integer))

-- Operators.
lex:add_rule('operator', token(lexer.OPERATOR, S('=!<>+-/*^&|~.,:;?()[]{}')))

-- Fold points.
lex:add_fold_point(lexer.KEYWORD, 'begin', 'end')
lex:add_fold_point(lexer.KEYWORD, 'for', 'end')
lex:add_fold_point(lexer.KEYWORD, 'function', 'end')
lex:add_fold_point(lexer.KEYWORD, 'if', 'end')
lex:add_fold_point(lexer.KEYWORD, 'switch', 'end')
lex:add_fold_point(lexer.KEYWORD, 'while', 'end')

return lex
