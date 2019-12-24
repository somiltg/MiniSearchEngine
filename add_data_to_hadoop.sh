# Group 13- CS 532- Project 1 
# Somil Gupta - Sahil Sharma
# Author- Somil Gupta
# The script unzips the project data and uploads the data to hdfs, along with id_URL_pairs.txt. 
# Assumptions: 
# 1. Hadoop and spark are setup. Set $HADOOP_HOME to hadoop location. 
# 2. Script is being run in the same folder as the clone of the project on local machine. 
# 3. Name of the files and folders are as per the git given for assignment. 

if [ -d Project1_data ] 
then echo "Project1_data already unzipped. Using the folder."
else unzip -a Project1_data.zip
fi
if ! $($HADOOP_HOME/bin/hdfs dfs -test -d Project1)
then $HADOOP_HOME/bin/hdfs dfs -mkdir Project1
fi
if $($HADOOP_HOME/bin/hdfs dfs -test -d Project1/Project1_data)
then 
	echo "Project1_data already uploaded to hdfs. Delete the folder at hdfs if you want to update."
else
	$HADOOP_HOME/bin/hdfs dfs -put  Project1_data Project1/
	echo "Project1_data successfully uploaded to hdfs."
fi
if ! $($HADOOP_HOME/bin/hdfs dfs -test -f 'Project1/id_URL_pairs.txt')
	then $HADOOP_HOME/bin/hdfs dfs -put id_URL_pairs.txt  Project1/
	echo "id_URL_pairs.txt successfully uploaded to hdfs."
	else echo "id_URL_pairs.txt already present in hdfs. Delete the file at hdfs if you want to update."
fi
rm -Rf Project1_data

 



