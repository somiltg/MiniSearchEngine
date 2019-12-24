# Script to add Key-Value pairs to rocksdb by instantiating Spark rdd on HDFS
# @author Sahil Sharma
# @group Mini project - CS 532- Group 13.

# import statements
import pyspark
from pyspark import SparkContext, SparkConf
import rocksdb
import sys

db = rocksdb.DB(str(sys.argv[2]), rocksdb.Options(create_if_missing=True))
try:
    sc = SparkContext.getOrCreate()
    # Creating a db for loading inverted key-value pairs using rocksdb
    # loading the inverted output into spark rdd
    # taking location of output file from user
    path_to_file = str(sys.argv[1])+"/invertedIndexOutput/output"
    rdd = sc.textFile(path_to_file)
    # mapping key value pairs from the rdd
    Inverted_pairs = rdd.map(lambda x: (x.split(",")[0], x.split("List("))[1])
    keys = Inverted_pairs.keys()
    values = Inverted_pairs.values()
    # converting them into python lists
    keys = keys.collect()
    values = values.collect()

    for key, value in zip(keys, values):
        # cleaning the data before putting it in
        # cleaning key
        key = key[1:-1]
        # cleaning values
        value = value[:-2]
        db.put(key.encode(), value.encode())

except:
    print("Unexpected error:", sys.exc_info()[0])
    raise

#Closing the db gracefully, required in the case of rocksdb
finally:
    db.close()
