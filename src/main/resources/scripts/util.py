import csv
# Utilitiy methods for experiments

# bucket consumes an array of rows, an index indicating where the qid is, and a lambda key function that will be used to sort the bucket as well
# return an ay of sorted buckets by qid
def bucket(data, index, key, sort = True):
  last_qid = ""
  bucket = []
  buckets=[]
  for i in range(len(data)):
    row = data[i]
    qid = row[index]
    if qid != last_qid:
      # Process the last bucket
      last_qid = row[index]
      sorted_bucket = bucket
      if sort:
        sorted_bucket = sorted(bucket, key=key, reverse=True)
      buckets.append(sorted_bucket)
      bucket = []
    # we add our row into the bucket
    bucket.append(row)
  return buckets[1:]

def read_csv(file_path):
  csv_file = open(file_path, 'rb')
  reader = csv.reader(csv_file, delimiter = ' ')
  
  data = []
  for row in reader:
    data.append(row)

  return data
