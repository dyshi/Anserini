import csv
import sys

# Will take in the scored file and produce a ranked file
# will only output the top 10 docs for a qid
scored_file = open(sys.argv[1], 'rb')
reader = csv.reader(scored_file, delimiter = ' ')
scored_docs = []

for row in reader:
  scored_docs.append(row)

scored_docs = sorted(scored_docs, key=lambda(x) : x[0])
# divide into buckets
bucket = []
last_qid = ""
bucket_docs = []
for i in range(len(scored_docs)):
  row = scored_docs[i]
  # if we are now in a different bucket
  if row[0] != last_qid:
    last_qid = row[0]
    sorted_bucket = sorted(bucket, key=lambda(x) : float(x[4]), reverse=True)
    # Ensures only the first 10 are scored, we can relax this constraint
    for j in range(len(sorted_bucket)):
      sorted_bucket[j][3] = j +1
    bucket_docs.append(sorted_bucket)
    bucket= []

  # We append to this bucket
  bucket.append(row)

writer = csv.writer(open(sys.argv[2], 'w+'), delimiter=' ')
for bucket in bucket_docs:
  writer.writerows(bucket)
  
