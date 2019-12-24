# Miniature Search engine over spark
#### COMPSCI532_Project1 - Group 13

## Team members- 
1. Somil Gupta - somilgupta@umass.edu   
2. Sahil Sharma - sahilsharma@umass.edu

## Technologies used:
Following are the versions of the prerequisite technologies used for the project. 
1. Scala- 2.11 
2. Hadoop- 3.2.1
3. Spark- 2.4.4
4. sbt (for scala build) - 1.3.2
5. Rocks DB- 5.3.0 (install from https://github.com/twmht/python-rocksdb)
6. Flask- 1.1.1
7. bash - GNU 3.2.57
8. Python- 3.6.8

## Document Parsing Logic:
 Word can either be a number (with $, comma and decimal)- ended by a comma, or it can be a word that
   can be ended by an apostrophe. 
   
   Regex used : **(\$(?:[0-9]+[,.]?[0-9]+)+|\w+'?\w\*)**
   
   To understand the regex details, please click on https://regexr.com/4mjs6. 

## Project structure:

* add_data_to_hadoop.sh (uploads data to hadoop along with the index)
* run_spark_app.sh (runs the spark job for inverted index and dumps to rocks db.)
* get_inverted_file_from_hdfs.sh (Fetches output file to local system.)
* src\main\scala\
        - IndexInverter.scala (Scala job for index inversion)
* add_KV_to_rocksdb.py (Adds key-value to rocksDB store.)
* start_query_server.py (Initiate query server on flask.)
* build.sbt (Required for sbt builds.)

## Usage instructions:
#### Assumptions
1. Hadoop, spark, SBT and flask are setup. Set $HADOOP_HOME to hadoop location and $SPARK_HOME.
2. Scripts are being run in the same folder as the clone of the project on local machine. 
3. Name of the files and folders are as per the git given for assignment. 
4. Let 'project location' be the location of the project at Hadoop. 

#### Steps
1. **sh data_to_hadoop.sh**: This script would create a folder Project1 at the hadoop project location and transfer Project1_data to it, along with id_URL_pairs.txt. 
    - Checks for presence instead of overwriting. You may have to delete the file manually if you want to overwrite. 
2. **\[sudo\] sh run_spark_app.sh \[-l project location\] \[-d rocks DB name\]** : This script builds the InvertedIndex.scala file into a jar, submits spark job to invert indexes, stores the inverted indexes at Project1/invertedIndexOutput/output which is then retrieved by add_KV_to_rocksdb.py to dump to rocks db.
    - **\[-l project location\]** : Location of the default user workspace at Hadoop where Project1 was added. This is required to run in sudo mode if spark-submit runs on sudo on your machine. Default is the default location referenced via non-sudo HADOOP access (your user workspace).
    - **\[-d Rocks DB name\]**:  Custom name for the rocks DB database. Use the same name when invoking start_query_server.sh. Default is named as "invertedPairs.db"
3. **python3 start_query_server.py \[rocks db name\]**: Once the spark jobs are completed, run this script to invoke the flask HTTP server on your local machine. Open http://localhost:5900/search on your browser and query the engine with your keys.
    - The used HTTP protocol is get and so your request should be of the form http://localhost:5900/search?query={query_string}. 
    - By default, rocks db name is "invertedPairs.db", so you can go without this argument. 
 

## Evaluation
- For the purpose of inverted Index evaluation, we have uploaded the invertedIndexOutput in Project1_invertedOutput.zip. The evaluator can recreate this zip after running the project by using the command **sh get_inverted_file_from_hdfs.sh** which fetches the data from hdfs and zips the output. 
- We have also added result for the query outputs for the test plan provided, in the file results.txt. 

_______________________

# Instructor default

This repository is for Project 1. Each students are required to develop a mockup of the core functionality of a Web search engine. For more details, you may refer to the project website https://marcoserafini.github.io/teaching/systems-for-data-science/fall19/project1.html

In this repository, there are 1977 documents. Each of these documents are crawled from the internet, and named as the document id. The file id_URL_pairs.txt is the mapping of document id and its URL. Each line represent one document. Your search engine are required to return the URL of the document. 

For group information, please refer to the form here (https://docs.google.com/spreadsheets/d/1FZshWm0o7_WcKcdyc9sAkdbSnUWrlALn74COMBAkWzA/edit?usp=sharing). Please create a group in GitHub Classroom with the corresponding group name shown in the form above. 

A query test plan will be provided for you to check the correctness of your program soon. 

For submission, please include the inverted index, and all the code needed to run your program. 


