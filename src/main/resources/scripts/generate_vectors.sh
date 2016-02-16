#!/bin/bash
tags=( gov2-701 gov2-751 gov2-801 )
files=( 701-750.txt 751-800.txt 801-850.txt )

#TODO Fill out
GOV2_INDEX=
TWITTER_INDEX=

pids=()
for i in "${!tags[@]}"; do
  tag=${tags[$i]}
  file=${files[$i]}
  printf "Generating vectors for collection %s \n" "$tag"
  ./target/appassembler/bin/SearchWebCollection -collection GOV2 -index $GOV2_INDEX -topics src/main/resources/topics-and-qrels/topics.$file -output $tag.run -bm25 -dump -featureFile $tag.vector -qrels src/main/resources/topics-and-qrels/qrels.$file -hits 1000 > $tag.debug 2>&1 &
  pids+=("$!")
  ./target/appassembler/bin/FeatureExtractor -index $GOV2_INDEX -qrel src/main/resources/topics-and-qrels/qrels.$file -topic src/main/resources/topics-and-qrels/topics.$file -out $tag.training -collection gov2 > $tag.debug 2>&1 &
  pids+=("$!")
done

./target/appassembler/bin/FeatureExtractor -index $TWITTER_INDEX -qrel src/main/resources/topics-and-qrels/qrels.microblog2011.txt -topic src/main/resources/topics-and-qrels/topics.microblog2011.txt -out twitter.training -collection twitter -extractors src/main/resources/featureExtractors/defaultTwitterExtractor.txt > twitter.debug 2>&1 &
pids+=("$!")

./target/appassembler/bin/SearchTweets -index $TWITTER_INDEX -topics src/main/resources/topics-and-qrels/topics.microblog2011.txt -output twitter.run  -hits 1000 -inmem -bm25 -dump -featureFile twitter.vector  -extractors src/main/resources/featureExtractors/defaultTwitterExtractor.txt -qrels src/main/resources/topics-and-qrels/qrels.microblog2011.txt -collection GOV2 > twitter.debug 2>&1 &
pids+=("$!")

for pid in "${pids}"; do
  wait $pid
done
