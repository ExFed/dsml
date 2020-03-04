grammar DSML;

@header {
package dsml.lang;
}

/* PARSER RULES */

file
    : expression* EOF
    ;

expression
    : namespace
    | property
    | specification
    ;

namespace
    : 'namespace' (QID | ID) '{' expression* '}'
    ;

specification
    : ID ID ':' specifier
    ;

specifier
    : FQID
    | QID
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
   | QID
   | ID
   | STRING
   | NUMBER
   | BOOLEAN
   | propObj
   | propList
   ;


/* LEXER RULES */

FQID
    : ( '/' ID )+
    ;

QID
    : ID FQID
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

WS
    : [ \t\n\r] + -> skip
    ;

BLOCK_COMMENT
    :   '/*' .*? '*/' -> skip
    ;

LINE_COMMENT
    :   '//' ~[\r\n]* -> skip
    ;
