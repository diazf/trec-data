%{
	FILE *fpTitle=NULL;
	FILE *fpDescription=NULL;
	FILE *fpNarrative=NULL;
	FILE *currentFP = NULL;
	int qid=-1;
%}

%x NUMBER TITLE DESCRIPTION NARRATIVE
%%

<*>"<num>" {
	if (currentFP!=NULL) fprintf(currentFP,"\n");
	currentFP = NULL;
	BEGIN NUMBER;
}
<NUMBER>"Number:" |
<NUMBER>"\n" |
<NUMBER>[^0-9] {}
<NUMBER>[0-9]+ { qid = atoi(yytext);}

<*>"<title>" {
	if (currentFP!=NULL) fprintf(currentFP,"\n");
	currentFP = fpTitle;
	fprintf(currentFP,"%d\t",qid);
	BEGIN TITLE;
}
<TITLE>"Topic:" {}
<TITLE>[\n\t \r]+ {fprintf(fpTitle," ");}
<TITLE>. {fprintf(fpTitle,"%s",yytext);}

<*>"<desc>" {
	if (currentFP!=NULL) fprintf(currentFP,"\n");
	currentFP = fpDescription;
	fprintf(currentFP,"%d\t",qid);
	BEGIN DESCRIPTION;
}
<DESCRIPTION>"Description:" {}
<DESCRIPTION>[\n\t \r]+ {fprintf(fpDescription," ");}
<DESCRIPTION>. {fprintf(fpDescription,"%s",yytext);}

<*>"<narr>" {
	if (currentFP!=NULL) fprintf(currentFP,"\n");
	currentFP = fpNarrative;
	fprintf(currentFP,"%d\t",qid);
	BEGIN NARRATIVE;
}
<NARRATIVE>"Narrative:" {}
<NARRATIVE>[\n\t \r]+ {fprintf(fpNarrative," ");}
<NARRATIVE>. {fprintf(fpNarrative,"%s",yytext);}

<*>"<"[^>]+">" {BEGIN INITIAL;}

"\n" |
.    { 	}

%%

int
main( int argc, char **argv ){
	char buffer[10000];
	sprintf(buffer,"%s-t.tsv",argv[1]);
	fpTitle = fopen(buffer,"w");
	sprintf(buffer,"%s-d.tsv",argv[1]);
	fpDescription = fopen(buffer,"w");
	sprintf(buffer,"%s-n.tsv",argv[1]);
	fpNarrative = fopen(buffer,"w");
	yyin = stdin;
	yylex();
	if (currentFP!=NULL) fprintf(currentFP,"\n");
	fclose(fpTitle);
	fclose(fpDescription);
	fclose(fpNarrative);
}
