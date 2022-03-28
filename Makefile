# SPDX-License-Identifier: 0BSD

frsh: frsh.l frsh.y
	lex frsh.l
	yacc -d frsh.y
	cc lex.yy.c y.tab.c -o frsh

clean:
	@rm -f frsh
	@rm -f lex.yy.c
	@rm -f y.tab.c
	@rm -f y.tab.h
	@echo cleaned

.PHONY: clean
