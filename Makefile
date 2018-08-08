QUERY_SETS=trec12 trec12-news trec45 trec45-news nyt
QLOGS_SETS=mq
QUERIES=$(addsuffix -t.tsv,$(QUERY_SETS))
QUERIES+=$(addsuffix -d.tsv,$(QUERY_SETS))
QUERIES+=$(addsuffix -n.tsv,$(QUERY_SETS))
QUERY_PATHS=$(addprefix queries/,$(QUERIES))
QRELS=$(addsuffix .tsv,$(QUERY_SETS))
QRELS_PATHS=$(addprefix qrels/,$(QRELS))
QLOGS=$(addsuffix .tsv,$(QLOGS_SETS))
QLOGS_PATHS=$(addprefix qlogs/,$(QLOGS))

all:$(QRELS_PATHS) $(QUERY_PATHS) $(QLOGS_PATHS)
	

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
	grep -v ^672 queries/trec45-t.tsv > queries/trec45-t.tsv.tmp; mv queries/trec45-t.tsv.tmp queries/trec45-t.tsv
	grep -v ^672 queries/trec45-d.tsv > queries/trec45-d.tsv.tmp; mv queries/trec45-d.tsv.tmp queries/trec45-d.tsv
	grep -v ^672 queries/trec45-n.tsv > queries/trec45-n.tsv.tmp; mv queries/trec45-n.tsv.tmp queries/trec45-n.tsv

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
# qlogs
#
qlogs/mq.tsv: contrib/qlogs/mq
	mkdir -p qlogs
	iconv -c contrib/qlogs/mq/07-million-query-topics.1-10000 | sed "s/[^:]*://g"  > qlogs/mq.tsv
	iconv -c contrib/qlogs/mq/08.million-query-topics.10001-20000 | sed "s/[^:]*://g" >> qlogs/mq.tsv
	iconv -c contrib/qlogs/mq/09.mq.topics.20001-60000 | sed "s/[^:]*://g" >> qlogs/mq.tsv

#
# support
#
src/extractQueries/extractQueries:
	make -C src/extractQueries/

contrib/queries/trec12:
	make -C contrib/queries

contrib/qlogs/mq:
	make -C contrib/qlogs

contrib/qrels/trec12:
	make -C contrib/qrels

clean:
	rm -Rf queries qrels qlogs
	make -C contrib/queries clean
	make -C contrib/qlogs clean
	make -C contrib/qrels clean
	make -C src/extractQueries clean