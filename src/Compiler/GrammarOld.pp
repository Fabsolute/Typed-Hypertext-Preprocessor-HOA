%skip space \s

// Scalars
%token true true
%token false false
%token null null
%token thp <\?php

// Values
%token string ("|')(.*?)(?<!\\)\1
%token float \d+\.\d+
%token integer \d+

%token parenthesis_ \(
%token _parenthesis \)

%token bracket_ \[
%token _bracket \]

%token brace_ {
%token _brace }

%token colon :
%token comma ,
%token semicolon ;
%token question_mark \?
%token dot \.

%token equals =

%token plus \+
%token minus -
%token times *
%token divide /

%token less_then <
%token greater_then >

%token  identifier    [^\s\(\)\[\],\.]+

value:
    ::not:: logical_operation_primary() #not
  | <true> | <false> | <null> | <float> | <integer> | <string>
  | array_declaration() | object_declaration() | chain()

variable:
    <identifier>

string:
    <string>

number:
    <integer> | <float>

#array_declaration:
    ::bracket_:: ( value() (::comma:: value() ) * ) ? ::_bracket::

#object_declaration:
    ::brace_:: ( pair() (::comma:: pair() )* ) ? ::_brace::

#pair:
    ( string() | variable() ) ::colon:: value()

#thp:
   <thp> function_call()
