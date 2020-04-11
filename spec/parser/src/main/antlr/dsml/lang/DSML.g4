grammar DSML;

@header {
package dsml.lang;
}

/* PARSER RULES */

file
    : expression* EOF
    ;

expression
    : property
    | specification
    ;

specification
    : ID ID ':' specifier
    ;

specifier
    : FQID
    | ID
    | specList
    | specObj
    ;

specList
    : '[' ( specifier ( ',' specifier )* )? ']'
    ;

specObj
    : '{' expression* '}'
    ;

// property rules are adapted from JSON

propObj
   : '{' property* '}'
   ;

property
   : ID '=' propValue
   ;

propList
   : '[' ( propValue (',' propValue )* )? ']'
   ;

propValue
   : FQID
   | ID
   | STRING
   | MLSTRING
   | NUMBER
   | BOOLEAN
   | propObj
   | propList
   ;


/* LEXER RULES */

FQID
    : ID ( '.' ID )+
    ;

ID
    : [_a-zA-Z] [_a-zA-Z0-9]*
    ;

BOOLEAN
    : 'true'
    | 'false'
    ;

STRING
    : '"' (ESC | SAFECODEPOINT)* '"'
    ;

MLSTRING
    : '"""' (ESC | SAFECODEPOINT | ENDL)* '"""'
    ;

fragment ESC
    : '\\' (["\\/bfnrt] | UNICODE)
    ;

fragment UNICODE
    : 'u' HEX HEX HEX HEX
    ;

fragment HEX
    : [0-9a-fA-F]
    ;

fragment SAFECODEPOINT
    : ~ ["\\\u0000-\u001F]
    ;

NUMBER
    : '-'? INT ('.' [0-9] +)? EXP?
    ;

fragment INT
    : '0' | [1-9] [0-9]*
    ;

fragment EXP
    : [Ee] [-+]? INT
    ;

WS              : [ \t]+        -> channel(HIDDEN);
ENDL            : [\r\n]+       -> channel(HIDDEN);
BLOCK_COMMENT   : '/*' .*? '*/' -> channel(HIDDEN);
LINE_COMMENT    : '//' ~[\r\n]* -> channel(HIDDEN);
