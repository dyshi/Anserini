#!/bin/bash
echo "Cleaning"
./clean_experiment.sh
echo "Restoring models, vectors, training_vectors from past_experiments/$1"
cp past_experiments/$1/models/* models/
cp past_experiments/$1/vectors/* vectors/
cp past_experiments/$1/training_vectors/* training_vectors/
