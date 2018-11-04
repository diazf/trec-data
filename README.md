trec-data
=========

A simple package to download and standardize [TREC](https://trec.nist.gov) experiment data.  It generates or includes,

* standardized title, description, and narrative queries
* qrels for the full corpus and popular "news-only" subsets
* standard stopword list (indri)

The build process will download and process qrels from NIST servers for the following datasets,

* trec12: topics 51-200 associated with _all_ documents on [Tipster Disks 1 and 2](https://catalog.ldc.upenn.edu/LDC93T3A).
* trec12-news: topics 51-200 associated with _only news_ documents on [Tipster Disks 1 and 2](https://catalog.ldc.upenn.edu/LDC93T3A).  This only includes the AP, WSJ, and Ziff-Davis documents in the qrels.
* trec45: the [Robust 2004](https://trec.nist.gov/data/robust/04.guidelines.html) topics associated with  documents on [TREC Disks 4 and 5](https://trec.nist.gov/data/qa/T8_QAdata/disks4_5.html) _except_ the Congressional Record.
* trec45-news: the [Robust 2004](https://trec.nist.gov/data/robust/04.guidelines.html) topics associated with _only news_ documents on [TREC Disks 4 and 5](https://trec.nist.gov/data/qa/T8_QAdata/disks4_5.html).  This only includes the FBIS, FT, and LA Times documents in the qrels.
* nyt: the [Common Core 2017](https://trec.nist.gov/data/core2017.html) topics associated with _all_ documents in the [New York Times Annotated Corpus](https://catalog.ldc.upenn.edu/ldc2008t19).
* msmarco: the topics associated with documents in the [MS MARCO dataset](http://www.msmarco.org/).

For each set of queries (i.e. trec12, trec45, and nyt), we generate title, description, and narrative queries.  The MS Marco dataset only has title queries.


## Datasets

```
qrels/     relevance judgements for test collections
queries/   queries for tests collections
qlogs/     queries with no associated relevance judgments
misc/      miscellaneous data for experiments
```

## Building the Dataset

```
make
```

## Dependencies

* [make](https://www.gnu.org/software/make/)
* [curl](https://curl.haxx.se/)
* [flex](https://github.com/westes/flex)

## Related

* [trec_eval](https://github.com/usnistgov/trec_eval)

## Citation

```
@online{diaz:trec-data,
author = {Diaz, Fernando},
title = {trec-data},
year = {2018},
url = {https://github.com/diazf/trec-data}
}
```

