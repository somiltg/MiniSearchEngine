# Group 13- CS 532- Project 1 
# Somil Gupta - Sahil Sharma
# Author- Somil Gupta
# The script fetches the result of the spark job from hdfs, stores the result in zipped form for uploading to git. 
# Assumptions: 
# 1. Hadoop and spark are setup. Set $HADOOP_HOME to hadoop location. 
# 2. Script is being run in the same folder as the clone of the project on local machine. 
# 3. Name of the files and folders are as per the git given for assignment. 

# Argument for this script is the name of the folder where output was dumped by spark job in hdfs. Its printed in the spark job output. 

if [ -f Project1_invertedOutput.zip ] 
then rm Project1_invertedOutput.zip
fi
if $($HADOOP_HOME/bin/hdfs dfs -test -d Project1/invertedIndexOutput/output)
then 
	$HADOOP_HOME/bin/hdfs dfs -get Project1/invertedIndexOutput/output
	mv output Project1_invertedOutput
	zip -r Project1_invertedOutput.zip Project1_invertedOutput
        rm -R Project1_invertedOutput
        echo "Successfully fetched and zipped the inverted index output."
	exit 0
else 
	echo "The given location Project1/invertedIndexOutput/output does not exist."
	exit 1
fi 



 




