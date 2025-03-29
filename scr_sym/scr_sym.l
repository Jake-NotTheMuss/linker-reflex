/* VERIFIED, all states/rules match SCR_SYM lexer states/rules exactly */

%option prefix = "sproc_"
/* these are the options used by linker */
%option caseless
%option noyywrap
%option reentrant

/* not used by linker, but needed here */
%option main

STRING \"([^\n\\\"]|\\[^\n])*\"
COMMENT "//"[^\n]*
IDENTIFIER [_A-Za-z][_A-Za-z0-9]*

%s DEFAULT BLOCK_COMMENT DOCBLOCK
%s CURLY_GROUP PAREN_GROUP CURLY_GROUP_BLOCK_COMMENT

%{
#define YY_USER_ACTION /* empty */
%}

%%

\n

<BLOCK_COMMENT>{
"*/"
.
}

<CURLY_GROUP_BLOCK_COMMENT>{
"*/"
.
}

<DOCBLOCK>{
"@/"
.
}

<CURLY_GROUP>{
"/*"
{COMMENT}
"}"
"{"
.
}

<PAREN_GROUP>{
{COMMENT}
")"
"("
.
}

<DEFAULT>{
[ \t\r]+
"//"[\t\n\r ]*todo[ \t\n\r\:][^\n]*
"//"[\t\n\r ]*hack[ \t\n\r\:][^\n]*
"//"[\t\n\r ]*undone[ \t\n\r\:][^\n]*
"//"[\t\n\r ]*fixme[ \t\n\r\:][^\n]*
{COMMENT} /* single-line comment */
"/*"
"/@"
{STRING}
\&{STRING}
#{STRING}
"{"
"}"
"("
")"
"["
"]"
"||"
"&&"
"|"
"^"
"&"
"=="
"!="
"<"
">"
"<="
">="
"<<"
">>"
"+"
"-"
"*"
"/"
"%"
"!"
"~"
"$"
0x[0-9A-Fa-f]+
[0-9]+
([0-9]*\.)?[0-9]+[Ee][\+\-]?[0-9]+|[0-9]*\.[0-9]+
","
"."
"?"
":"
"="
";"
"->"
"class"
"function"
"var"
"return"
"wait"
"thread"
"undefined"
"self"
"mission"
"level"
"game"
"anim"
"if"
"else"
"do"
"while"
"for"
"foreach"
"in"
"new"
"++"
"--"
"|="
"^="
"&="
"<<="
">>="
"+="
"-="
"*="
"/="
"%="
".size"
"#using_animtree"
"#animtree"
"#using"
"#namespace"
"#precache"
"::"
"waittill"
"waittillmatch"
"waittillframeend"
"switch"
"case"
"default"
"break"
"continue"
"false"
"true"
"notify"
"endon"
"assert"
"assertmsg"
"constructor"
"destructor"
"autoexec"
"private"
"native"
"const"
"..."
"/#"
"#/"
"isdefined"
"vectorscale"
"gettime"
"waitrealtime"
"profilestart"
"profilestop"
{IDENTIFIER}
{IDENTIFIER}(\\{IDENTIFIER})+
}

%%
