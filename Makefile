QUERY_SETS=trec12 trec12-news trec45 trec45-news nyt
SPLIT_QUERY_SETS=msmarco msmarco-docs
QLOGS_SETS=mq aol

QUERIES=$(addsuffix -t.tsv,$(QUERY_SETS))
QUERIES+=$(addsuffix -d.tsv,$(QUERY_SETS))
QUERIES+=$(addsuffix -n.tsv,$(QUERY_SETS))
QUERIES+=$(addsuffix train-t.tsv,$(SPLIT_QUERY_SETS))
QUERIES+=$(addsuffix dev-t.tsv,$(SPLIT_QUERY_SETS))

QUERY_PATHS=$(addprefix queries/,$(QUERIES))

QRELS=$(addsuffix .tsv,$(QUERY_SETS))
QRELS+=$(addsuffix -train.tsv,$(SPLIT_QUERY_SETS))
QRELS+=$(addsuffix -dev.tsv,$(SPLIT_QUERY_SETS))
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
# msmarco
#
queries/msmarco-%.tsv: contrib/queries/msmarco 
	mkdir -p queries
	cat contrib/queries/msmarco/queries.train.tsv | iconv -c > queries/msmarco-train-t.tsv
	./src/scripts/msmarco-qid-filter.py contrib/queries/msmarco/top1000.dev.tsv contrib/queries/msmarco/queries.dev.tsv | iconv -c > queries/msmarco-dev-t.tsv

qrels/msmarco-%.tsv: contrib/qrels/msmarco contrib/queries/msmarco
	mkdir -p qrels
	cp contrib/qrels/msmarco/qrels.train.tsv qrels/msmarco-train.tsv
	./src/scripts/msmarco-qid-filter.py contrib/queries/msmarco/top1000.dev.tsv contrib/qrels/msmarco/qrels.dev.tsv > qrels/msmarco-dev.tsv

#
# msmarco-docs
#
queries/msmarco-docs-%.tsv: contrib/queries/msmarco-docs
	mkdir -p queries
	cat contrib/queries/msmarco-docs/msmarco-doctrain-queries.tsv | iconv -c > queries/msmarco-docs-train-t.tsv
	cat contrib/queries/msmarco-docs/msmarco-docdev-queries.tsv | iconv -c > queries/msmarco-docs-dev-t.tsv

qrels/msmarco-docs-%.tsv: contrib/qrels/msmarco-docs
	mkdir -p qrels
	cp contrib/qrels/msmarco-docs/msmarco-doctrain-qrels.tsv qrels/msmarco-docs-train.tsv
	cp contrib/qrels/msmarco-docs/msmarco-docdev-qrels.tsv qrels/msmarco-docs-dev.tsv

#
# qlogs
#
qlogs/mq.tsv: contrib/qlogs/mq
	mkdir -p qlogs
	iconv -c contrib/qlogs/mq/07-million-query-topics.1-10000 | sed "s/[^:]*://g"  > qlogs/mq.tsv
	iconv -c contrib/qlogs/mq/08.million-query-topics.10001-20000 | sed "s/[^:]*://g" >> qlogs/mq.tsv
	iconv -c contrib/qlogs/mq/09.mq.topics.20001-60000 | sed "s/[^:]*://g" >> qlogs/mq.tsv

qlogs/aol.tsv: contrib/qlogs/aol src/qlogProcessor/qlogProcessor
	mkdir -p qlogs
	cat contrib/qlogs/aol/AOL-user-ct-collection/user-ct-test-collection-01.txt | src/qlogProcessor/qlogProcessor -S misc/stopwords.txt | sort |uniq > qlogs/aol-01.tsv 
	cat contrib/qlogs/aol/AOL-user-ct-collection/user-ct-test-collection-02.txt | src/qlogProcessor/qlogProcessor -S misc/stopwords.txt | sort |uniq > qlogs/aol-02.tsv 
	cat contrib/qlogs/aol/AOL-user-ct-collection/user-ct-test-collection-03.txt | src/qlogProcessor/qlogProcessor -S misc/stopwords.txt | sort |uniq > qlogs/aol-03.tsv 
	cat contrib/qlogs/aol/AOL-user-ct-collection/user-ct-test-collection-04.txt | src/qlogProcessor/qlogProcessor -S misc/stopwords.txt | sort |uniq > qlogs/aol-04.tsv 
	cat contrib/qlogs/aol/AOL-user-ct-collection/user-ct-test-collection-05.txt | src/qlogProcessor/qlogProcessor -S misc/stopwords.txt | sort |uniq > qlogs/aol-05.tsv  
	cat contrib/qlogs/aol/AOL-user-ct-collection/user-ct-test-collection-06.txt | src/qlogProcessor/qlogProcessor -S misc/stopwords.txt | sort |uniq > qlogs/aol-06.tsv  
	cat contrib/qlogs/aol/AOL-user-ct-collection/user-ct-test-collection-07.txt | src/qlogProcessor/qlogProcessor -S misc/stopwords.txt | sort |uniq > qlogs/aol-07.tsv  
	cat contrib/qlogs/aol/AOL-user-ct-collection/user-ct-test-collection-08.txt | src/qlogProcessor/qlogProcessor -S misc/stopwords.txt | sort |uniq > qlogs/aol-08.tsv  
	cat contrib/qlogs/aol/AOL-user-ct-collection/user-ct-test-collection-09.txt | src/qlogProcessor/qlogProcessor -S misc/stopwords.txt | sort |uniq > qlogs/aol-09.tsv  
	cat contrib/qlogs/aol/AOL-user-ct-collection/user-ct-test-collection-10.txt | src/qlogProcessor/qlogProcessor -S misc/stopwords.txt | sort |uniq > qlogs/aol-10.tsv   
	sort qlogs/aol-*.tsv  | uniq  > qlogs/aol.tsv
	rm -f qlogs/aol-*.tsv


#
# support
#
src/extractQueries/extractQueries:
	make -C src/extractQueries/

src/qlogProcessor/qlogProcessor:
	make -C src/qlogProcessor/

contrib/queries/trec12:
	make -C contrib/queries

contrib/queries/msmarco:
	make -C contrib/queries

contrib/queries/msmarco-docs:
	make -C contrib/queries

contrib/qlogs/mq:
	make -C contrib/qlogs

contrib/qrels/trec12:
	make -C contrib/qrels

contrib/qrels/msmarco:
	make -C contrib/qrels

contrib/qrels/msmarco-docs:
	make -C contrib/qrels

clean:
	rm -Rf queries qrels qlogs
	make -C contrib/queries clean
	make -C contrib/qlogs clean
	make -C contrib/qrels clean
	make -C src/extractQueries clean
	make -C src/qlogProcessor clean