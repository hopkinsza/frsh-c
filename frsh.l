%{
#include <stdbool.h>
#include <stdio.h>

#include "y.tab.h"

/* in-place removal of underscores from a string */
void
rm_undsc(char *str)
{
	int u = 0;
	char *p = str;
	for (; *p != '\0'; p++) {
		if (*p == '_') {
			u++;
		} else {
			*(p-u) = *p;
		}
	}
	*(p-u) = '\0';
}
%}

dig	[0-9]
let	[a-zA-Z]
alnum	[a-zA-Z0-9_]

dec_digit	[0-9]
bin_digit	[0-1]
oct_digit	[0-7]
hex_digit	[0-9a-fA-F]
dec_digund	{dec_digit}|_
bin_digund	{bin_digit}|_
oct_digund	{oct_digit}|_
hex_digund	{hex_digit}|_

ident	[a-zA-Z_]{alnum}*

flolit	{intlit}"."{dig}+
strlit	\"{let}*\"

%%
 /*keywords */
var		return KW_VAR;

 /* literals */
true		yylval.Bool = true;  return BOOL;
false		yylval.Bool = false; return BOOL;

 /* numbers supported by strtol(3) */
"-"?0{dig}({dig}|_)*			{
	rm_undsc(yytext);
	yylval.Int = strtol(yytext, NULL, 0);
	return INT;
}
"-"?{dec_digit}({dec_digit}|_)+		{
	rm_undsc(yytext);
	yylval.Int = strtol(yytext, NULL, 0);
	return INT;
}
"-"?0x{hex_digit}({hex_digit}|_)+	{
	rm_undsc(yytext);
	yylval.Int = strtol(yytext, NULL, 0);
	return INT;
}

 /* binary and an alternative octal representation */
"-"?0b{bin_digit}+	{
	/* diff */
	bool neg;
	if (yytext[0] == '-') {
		neg = true;
	}
	return INT;
}
"-"?0o{oct_digit}+	{
	/* diff */
	return INT;
}


"-"?[0-9]+"."[0-9]+	return FLOAT;

 /* identifier */
{ident}		return IDENT;

 /* operators */
 /* "=="		return DEQ; */

[ \t]+		;
\\\n		;
\n|";"		return SEP;
.		return (int)yytext[0];
%%
