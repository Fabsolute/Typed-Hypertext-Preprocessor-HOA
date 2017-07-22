%skip   space         \s

// Scalars.
%token  true          (?i)true
%token  false         (?i)false
%token  null          (?i)null
%token thp            <\?php
%token use            (?i)use
%token namespace      (?i)namespace
%token comment_char    //(.*)

// Logical operators
%token  not           (?i)not\b
%token  and           (?i)and\b
%token  or            (?i)or\b
%token  xor           (?i)xor\b

// Value
%token  string        ("|')(.*?)(?<!\\)\1
%token  float         \d+\.\d+
%token  integer       \d+
%token  parenthesis_  \(
%token _parenthesis   \)
%token  bracket_      \[
%token _bracket       \]
%token brace_          {
%token _brace          }
%token  comma          ,
%token semicolon       ;
%token colon           :
%token  dot           \.
%token backslash      \\
%token dollar         \$

%token equals =

%token plus \+
%token minus -
%token times \*
%token divide /

%token less_then <
%token greater_then >

%token identifier    (?i)[a-zA-Z_][a-zA-Z0-9_]*

#expression:
    logical_operation_primary()

logical_operation_primary:
    logical_operation_secondary()
    ( ( ::or:: #or | ::xor:: #xor ) logical_operation_primary() )?

logical_operation_secondary:
    operation()
    ( ::and:: #and logical_operation_secondary() )?

operation:
    operand() ( <identifier> logical_operation_primary() #operation )?

operand:
    ::parenthesis_:: logical_operation_primary() ::_parenthesis::
  | value()

value:
    ::not:: logical_operation_primary() #not
  | <true> | <false> | <null> | <float> | <integer> | <string>
  | array_declaration()
  | object_declaration()
  | constant()
  | chain()
  | string_join()

chain:
    ( variable() | function_call() )
    ( ( array_access() | object_access() ) #variable_access )*

constant:
    <identifier>

#variable:
    ::dollar:: <identifier>

#array_access:
    ::bracket_:: value() ::_bracket::

#equality:
    variable() ::equals:: (
        static_class_access()
        | expression()
    )

#string_join:
    value() ( ( ::dot:: value() ) * )?

object_access:
    ::minus:: ::less_then:: ( <identifier> #attribute_access | function_call() #method_access )

namespace_identifier:
    <identifier> ( ( ::backslash:: <identifier> ) * )?

#array_declaration:
    ::bracket_:: ( value() ( ::comma:: value() )* )? ::_bracket::

#object_declaration:
    ::brace_:: ( pair() ( ::comma:: pair() )* )? ::_brace::

#pair:
    ( variable() | <string> ) ::colon:: value()

#function_call:
    <identifier> ::parenthesis_::
    ( logical_operation_primary() ( ::comma:: logical_operation_primary() )* ) ?
    ::_parenthesis::

#use:
    ::use:: namespace_identifier()

#static_class_access:
    <identifier> ::colon:: ::colon:: ( <identifier> | function_call() )

#command:
    (
        use()
        | equality()
        | static_class_access()
        | logical_operation_primary()
    ) ::semicolon::

comment:
    ::comment_char::

command_or_comment:
    ( comment() | command() )

#code:
    command_or_comment() ( command_or_comment() * )?

#thp:
    <thp> code()