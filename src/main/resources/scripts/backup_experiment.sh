#!/bin/bash
echo "Copying models, reranks, scores, vectors, results, training_vectors into $1"

mkdir $1
cp -r models $1/
cp -r scores $1/
cp -r reranks $1/
cp -r results $1/
cp -r vectors $1/
cp -r training_vectors $1/
