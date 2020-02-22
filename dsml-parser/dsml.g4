grammar dsml;

/* PARSER RULES */

dsmlSpec
    : specEntry+
    ;

specEntry
    : namespace
    | metaPair
    | specDecl
    ;

namespace
    : 'namespace' SCOPED_ID '{' specEntry* '}'
    ;

specDecl
    : SPEC_TYPE SCOPED_ID ':' specifier
    ;

specifier
    : GLOBAL_ID
    | SCOPED_ID
    | specList
    | specObj
    ;

specList
    : '[' ( specifier ( ',' specifier )* )? ']'
    ;

specObj
    : '{' specEntry* '}'
    ;

// metadata rules are adapted from JSON

metaObj
   : '{' metaPair* '}'
   ;

metaPair
   : SCOPED_ID '=' metaValue
   ;

metaList
   : '[' ( metaValue (',' metaValue? )* )? ']'
   ;

metaValue
   : STRING
   | NUMBER
   | BOOLEAN
   | metaObj
   | metaList
   ;


/* LEXER RULES */

SPEC_TYPE
    : GLOBAL_ID
    | SCOPED_ID
    ;

GLOBAL_ID
    : '/' SCOPED_ID
    ;

SCOPED_ID
    : NAME ( '/' NAME )*
    ;

fragment NAME
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

// no leading zeros

fragment EXP
    : [Ee] [+\-]? INT
    ;

// \- since - means "range" inside [...]

WS
    : [ \t\n\r] + -> skip
    ;

BLOCK_COMMENT
    :   '/*' .*? '*/' -> skip
    ;

LINE_COMMENT
    :   '//' ~[\r\n]* -> skip
    ;
