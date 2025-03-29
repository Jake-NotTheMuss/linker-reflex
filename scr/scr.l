/* VERIFIED, all states/rules match SCR lexer states/rules exactly */

/* these are the options used by linker */
%option caseless
%option noyywrap
%option reentrant

/* not used by linker, but needed here */
%option main

STRING \"([^\n\\\"]|\\[^\n])*\"
IDENTIFIER [_A-Za-z][_A-Za-z0-9]*

%s DEFAULT BLOCK_COMMENT DEVBLOCK DOCBLOCK

%%

\n

<BLOCK_COMMENT>{
"*/"
.
}

<DEVBLOCK>{
"//"[^\n]*
"#/"
.
}

<DOCBLOCK>{
"@/"
.
}

<DEFAULT>{
[ \t\r]+ /* white space */
"//"[\t\n\r ]*todo[ \t\n\r\:][^\n]*
"//"[\t\n\r ]*hack[ \t\n\r\:][^\n]*
"//"[\t\n\r ]*undone[ \t\n\r\:][^\n]*
"//"[\t\n\r ]*fixme[ \t\n\r\:][^\n]*
"//"[^\n]* /* single-line comment */
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
"==="
"!="
"!=="
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
"world"
"classes"
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
"__function__"
{IDENTIFIER}
{IDENTIFIER}(\\{IDENTIFIER})+
.
}


%%
