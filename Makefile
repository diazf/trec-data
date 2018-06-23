QUERY_SETS=trec12 trec12-news trec45 trec45-news nyt
QUERIES=$(addsuffix -t.tsv,$(QUERY_SETS))
QUERIES+=$(addsuffix -d.tsv,$(QUERY_SETS))
QUERIES+=$(addsuffix -n.tsv,$(QUERY_SETS))
QUERY_PATHS=$(addprefix queries/,$(QUERIES))
QRELS=$(addsuffix .tsv,$(QUERY_SETS))
QRELS_PATHS=$(addprefix qrels/,$(QRELS))

all:$(QRELS_PATHS) $(QUERY_PATHS)
	

#
# trec12
#
queries/trec12-%.tsv: contrib/queries/trec12 src/extractQueries/extractQueries
	mkdir -p queries
	cat contrib/queries/trec12/* | src/extractQueries/extractQueries queries/trec12

qrels/trec12.tsv: contrib/qrels/trec12
	mkdir -p qrels
	cat contrib/qrels/trec12/* | awk '($$NF>0)' |sed "s/ /	/g" > qrels/trec12.tsv

qrels/trec12-news.tsv:qrels/trec12.tsv
	egrep "AP|WSJ|Z" qrels/trec12.tsv > qrels/trec12-news.tsv

#
# trec45 (aka robust04)
#
queries/trec45-%.tsv: contrib/queries/trec45 src/extractQueries/extractQueries
	mkdir -p queries
	cat contrib/queries/trec45/* | src/extractQueries/extractQueries queries/trec45

qrels/trec45.tsv: contrib/qrels/trec45
	mkdir -p qrels
	cat contrib/qrels/trec45/* | awk '($$NF>0)' |sed "s/ /	/g" > qrels/trec45.tsv

qrels/trec45-news.tsv:qrels/trec45.tsv
	egrep "FBIS|FT|LA" qrels/trec45.tsv > qrels/trec45-news.tsv

#
# nyt (aka core2017)
#
queries/nyt-%.tsv: contrib/queries/nyt src/extractQueries/extractQueries
	mkdir -p queries
	cat contrib/queries/nyt/* | src/extractQueries/extractQueries queries/nyt

qrels/nyt.tsv: contrib/qrels/nyt
	mkdir -p qrels
	cat contrib/qrels/nyt/* | awk '($$NF>0)' |sed "s/ /	/g" > qrels/nyt.tsv


#
# support
#
src/extractQueries/extractQueries:
	make -C src/extractQueries/

contrib/queries/trec12:
	make -C contrib/queries

contrib/qrels/trec12:
	make -C contrib/qrels

clean:
	rm -Rf queries qrels
	make -C contrib/queries clean
	make -C contrib/qrels clean
	make -C src/extractQueries clean