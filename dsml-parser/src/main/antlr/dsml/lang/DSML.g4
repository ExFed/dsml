grammar DSML;

@header {
package dsml.lang;
}

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
    : 'namespace' ID '{' specEntry* '}'
    ;

specDecl
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
    : '{' specEntry* '}'
    ;

// metadata rules are adapted from JSON

metaObj
   : '{' metaPair* '}'
   ;

metaPair
   : ID '=' metaValue
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

FQID
    : ( '/' ID )+
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
