#!/bin/bash
tags=( gov2-701 gov2-751 gov2-801 twitter )
model_tags=( MART CA lambdaMART RandForest )
model_indices=( 0 4 6 8 )
pids=()
./clean_experiment.sh

for collection in "${tags[@]}" ; do
  printf "training models for collection: %s\n" "$collection"
  for i in "${!model_tags[@]}"; do
    printf "Model: %s \n" "${model_tags[$i]}"
    tag=${model_tags[$i]}
    echo " java -jar rankLib.jar -train training_vectors/$collection.training -ranker ${model_indices[$i]}  -save models/$collection-$tag.model > debug/$collection-$tag.debug 2>&1 &"
    java -jar rankLib.jar -train training_vectors/$collection.training -ranker ${model_indices[$i]}  -save models/$collection-$tag.model > debug/$collection-$tag.debug 2>&1 &  
    pids+=("$!")
  done
done

for pid in "${pids}"; do
  wait $pid
done
