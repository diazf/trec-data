all:mq
	

mq:
	mkdir mq
	curl -s https://trec.nist.gov/data/million.query/07/07-million-query-topics.1-10000.gz | gunzip > mq/07-million-query-topics.1-10000
	curl -s https://trec.nist.gov/data/million.query/08/08.million-query-topics.10001-20000.gz | gunzip > mq/08.million-query-topics.10001-20000
	curl -s https://trec.nist.gov/data/million.query/09/09.mq.topics.20001-60000.gz | gunzip > mq/09.mq.topics.20001-60000

clean:
	rm -Rf mq