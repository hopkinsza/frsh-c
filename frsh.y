%{
#include <stdbool.h>
#include <stdio.h>

void
yyerror(const char *str)
{
	fprintf(stderr, "error: %s\n", str);
}

int
yywrap()
{
	return 1;
}

int
main()
{
	yyparse();
}
%}

%union
{
	bool Bool;
	long Int;
	double Float;
	char *String;
}

%token KW_VAR

%token <String> IDENT

%token <Bool> BOOL
%token <Int> INT
%token <Float> FLOAT

%token SEP

%%

commands:
	| commands command SEP
	;

command:
	| IDENT
	{
		printf("> ident\n");
	}
	| BOOL
	{
		printf("> bool: %d\n", $1);
	}
	| INT
	{
		printf("> int: %d\n", $1);
	}
	| FLOAT
	{
		printf("> float: %f\n", $1);
	}
	;

%%

/*
commands:
	| commands command SEP
	;

command:
	| declare
	| assign
	;

declare:
	KW_VAR IDENT
	{
		printf("> declared a var\n");
	}
	;

assign:
	IDENT '=' number
	{
		printf("> assigned\n");
	}
	;

number:
	INT
	| FLOAT
	;
*/
