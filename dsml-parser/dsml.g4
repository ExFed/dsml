grammar dsml;

/* PARSER RULES */

dsml_spec
    : spec_entry+
    ;

spec_entry
    : namespace
    | meta_pair
    | spec_decl
    ;

namespace
    : IDENTIFIER ( '/' IDENTIFIER )* '{' spec_entry* '}'
    ;

spec_decl
    : SPEC_TYPE IDENTIFIER ':' specifier
    ;

specifier
    : IDENTIFIER
    | spec_array
    | spec_obj
    ;

spec_array
    : '[' specifier ( ',' specifier? )* ']'
    | '[' ']'
    ;

spec_obj
    : '{' spec_entry* '}'
    ;

// metadata rules (adapted from JSON)

meta_obj
   : '{' meta_pair* '}'
   ;

meta_pair
   : IDENTIFIER '=' meta_value
   ;

meta_array
   : '[' meta_value (',' meta_value)* ']'
   | '[' ']'
   ;

meta_value
   : STRING
   | NUMBER
   | BOOLEAN
   | meta_obj
   | meta_array
   ;


/* LEXER RULES */

SPEC_TYPE
    : IDENTIFIER
    ;

IDENTIFIER
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
