#!/usr/bin/env python3

import sys

# 1. read valid qids from top1000 document
qids=set()
with open(sys.argv[1],"r") as fp:
    for line in fp:
        qid = line.strip().split()[0]
        qids.add(qid)
    fp.close()

# 2. filter by valid qids
with open(sys.argv[2],"r") as fp:
    for line in fp:
        qid = line.strip().split()[0]
        if (qid in qids):
            print(line.strip())
    fp.close()
