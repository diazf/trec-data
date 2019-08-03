all:mq aol
	

mq:
	mkdir mq
	curl -s https://trec.nist.gov/data/million.query/07/07-million-query-topics.1-10000.gz | gunzip > mq/07-million-query-topics.1-10000
	curl -s https://trec.nist.gov/data/million.query/08/08.million-query-topics.10001-20000.gz | gunzip > mq/08.million-query-topics.10001-20000
	curl -s https://trec.nist.gov/data/million.query/09/09.mq.topics.20001-60000.gz | gunzip > mq/09.mq.topics.20001-60000

aol:
	mkdir aol
	curl -s http://www.cim.mcgill.ca/~dudek/206/Logs/AOL-user-ct-collection/aol-data.tar.bz2 > aol/aol-data.tar.bz2
	cd aol
	bzcat aol-data.tar.bz2 | tar xf - 
	cd ..

clean:
	rm -Rf mq aol