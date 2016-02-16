#!/bin/bash
tags=( gov2-701 gov2-751 gov2-801 twitter )
model_tags=( CA MART lambdaMART RandForest )
files=( 701-750.txt 751-800.txt 801-850.txt microblog2011.txt )
pids=()

# Must export anseriniDir
if [ -z $ANSERINI_DIR ]; then
  echo "Must set ANSERINI_DIR"
  exit 1
fi 

# First we should clean the folders
rm ./scores/*
rm ./reranks/*
rm ./results/*

for i in "${!tags[@]}"; do
  collection=${tags[$i]}
  file=${files[$i]}
  echo "Evaluating $collection"
  for j in "${!model_tags[@]}"; do
    model=${model_tags[$j]}
    echo "Model $model"
    ./eval.sh $ANSERINI_DIR/target/appassembler/bin/RankLibScore ./models/$collection-$model.model ./vectors/$collection.vector $collection-$model $ANSERINI_DIR/src/main/resources/topics-and-qrels/qrels.$file 0.999 > results/"$collection-$model.result" 2>&1  &
    pids+=("$!")
  done
done

for pid in $pids; do
  wait $pid
done
