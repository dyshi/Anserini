#!/bin/bash
if [ "$#" -lt 5 ];then
  echo "Usage: anseriniScorer model.path feature-vector.path tag qrel.path"
  exit -1;
fi

if [ -z $TREC_EVAL ]; then
  echo "Must set TREC_EVAL"
  exit 1
fi

# Feature files always have qrel qid ..... and should not be sorted
$1 -model $2 -featureFile $3 -output ./scores/$4.scores -qrels $5
sort ./scores/$4.scores -o ./scores/$4.scores
python rank.py ./scores/$4.scores ./reranks/$4.reranks 
sed -i -e 's/qid://g' ./reranks/$4.reranks
sed -i -e 's/docid://g' ./reranks/$4.reranks
$TREC_EVAL $5 reranks/$4.reranks
