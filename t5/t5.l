/* VERIFIED, all states/rules match t5 lexer states/rules exactly */

%option noyywrap
%option reentrant

%option main

STRING \"([^\n\\\"]|\\[^\n])*\"
IDENTIFIER [_A-Za-z][_A-Za-z0-9]*
FLOAT ([0-9]*\.)?[0-9]+E[\+\-]?[0-9]+|[0-9]*\.[0-9]+

%s DEFAULT BLOCK_COMMENT

%%

\n

<BLOCK_COMMENT>{
"*/"
.
}

<DEFAULT>{
[ \t\r]+ /* white space */
"//"[^\n]* /* single-line comment */
"/*"
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
[0-9]+
{FLOAT}
","
"."
"?"
":"
"="
";"
"return"
"wait"
"thread"
"undefined"
"self"
"level"
"game"
"anim"
"if"
"else"
"while"
"for"
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
"#include"
"::"
"waittill"
"waittillmatch"
"waittillframeend"
"notify"
"switch"
"case"
"default"
"break"
"continue"
"endon"
"false"
"true"
"breakpoint"
"prof_begin"
"prof_end"
"/#"
"#/"
"$"
"breakon"
{IDENTIFIER}
({IDENTIFIER}\\)+{IDENTIFIER}
}

.


%%
