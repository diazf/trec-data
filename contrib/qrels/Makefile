all: trec12 trec45 nyt msmarco msmarco-docs
	
trec12: 
	mkdir trec12
	cd trec12; curl -O https://trec.nist.gov/data/qrels_eng/qrels.51-100.disk1.disk2.parts1-5.tar.gz; tar xzf qrels.51-100.disk1.disk2.parts1-5.tar.gz; gunzip *.gz; rm -f *.tar
	cd trec12; curl -O https://trec.nist.gov/data/qrels_eng/qrels.101-150.disk1.disk2.parts1-5.tar.gz; tar xzf qrels.101-150.disk1.disk2.parts1-5.tar.gz; gunzip *.gz; rm -f *.tar
	cd trec12; curl -O https://trec.nist.gov/data/qrels_eng/qrels.151-200.201-250.disks1-3.all.tar.gz; tar xzf qrels.151-200.201-250.disks1-3.all.tar.gz; gunzip *.gz; rm -f *.tar *interactive*

trec45: 
	mkdir trec45
	cd trec45; curl -O https://trec.nist.gov/data/robust/qrels.robust2004.txt

nyt:
	mkdir nyt
	cd nyt; curl -O https://trec.nist.gov/data/core/qrels.txt

msmarco:
	mkdir msmarco
	cd msmarco; curl -O https://msmarco.blob.core.windows.net/msmarcoranking/qrels.train.tsv
	cd msmarco; curl -O https://msmarco.blob.core.windows.net/msmarcoranking/qrels.dev.tsv

msmarco-docs:
	mkdir msmarco-docs
	curl -s https://msmarco.blob.core.windows.net/msmarcoranking/msmarco-doctrain-qrels.tsv.gz | gunzip > msmarco-docs/msmarco-doctrain-qrels.tsv
	curl -s https://msmarco.blob.core.windows.net/msmarcoranking/msmarco-docdev-qrels.tsv.gz | gunzip > msmarco-docs/msmarco-docdev-qrels.tsv

clean:
	rm -Rf trec12 trec45 nyt msmarco msmarco-docs
