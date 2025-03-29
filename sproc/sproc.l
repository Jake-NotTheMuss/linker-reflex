/* VERIFIED, all states/rules match SRPOC lexer states/rules exactly */

/* these are the options used by linker */
%option batch never-interactive
%option caseless
%option noyywrap noinput nounput
%option yylineno
%option reentrant

%option main

STRING \"([^\n\\\"]|\\[^\n])*\"

%s DEFAULT

%{
#define YY_USER_ACTION /* empty */
%}

%%

<DEFAULT>{
"#if"
"#elif"
[A-Za-z_][A-Za-z_0-9]*
[0-9]+
{STRING}
"&&"
"||"
"!"
"=="
"!="
">"
">="
"<"
"<="
"("
")"
\n
.
}

%%
