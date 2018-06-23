extractQueries:extractQueries.l Makefile
	flex --8bit -F extractQueries.l
	gcc -O3 -o extractQueries lex.yy.c -ll
	rm -f lex.yy.c

clean:
	rm -f lex.yy.c extractQueries