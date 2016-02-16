#!/bin/bash

if [ "$#" -lt 2 ]; then
  echo "Usage: anserini_path trec_eval"
  exit -1;
fi

export ANSERINI_DIR=$1 TREC_EVAL=$2
mkdir experiment
pushd experiment
mkdir models training_vectors vectors results reranks scores past_experiments debug

