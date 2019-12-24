# Group 13- CS 532- Project 1 
# Somil Gupta - Sahil Sharma
# Author- Somil Gupta
# The script runs the spark job for inverted index 
# Assumptions:  
# 1. Script is being run in the same folder as the clone of the project on local machine. 
# 2. Name of the files and folders are as per the git given for assignment. 

# Builds using sbt, creates output directory and submits the spark job and adds to rocks db. 
# Input switches argument:
#  -l Optional. Location of the default user workspace at Hadoop where Project1 was added, e.g. /user/somilgupta. This is because sudo access moves the current directory to /. Not required if spark does not require sudo access.
#  -d Optional. Custom name for database RocksDB. Default is "invertedPairs.db".
sudoFlag=
location=
dbName="invertedPairs.db"
# process switches
while getopts "l:d:" opt; do
    case $opt in
    l) location="$OPTARG" # Handle -l if present
      sudoFlag=1
       echo "You have opted for sudo spark submit. Location of the user workspace: $location";;
    d) dbName="$OPTARG";; # Handle -d if present
    \?) printf "Usage: %s: [-l project location] [-d db name] \n" $0
          exit 2;; # Incorrect switch
    esac
done
 echo "Name of the db to store kv pairs: $dbName"

# Edit location to have / at the end.
if [ ! -z $location ] && [[ "${location: -1}" != "/" ]]; then location="$location/"; fi
# Build the scala package.

sbt package
if ! $($HADOOP_HOME/bin/hdfs dfs -test -d ${location}Project1/invertedIndexOutput)
then $HADOOP_HOME/bin/hdfs dfs -mkdir ${location}Project1/invertedIndexOutput
fi

$HADOOP_HOME/bin/hdfs dfs -rm -R -f ${location}Project1/invertedIndexOutput/output
# To allow spark job to add file when run as root. 
$HADOOP_HOME/bin/hdfs dfs -chmod 777 ${location}Project1/invertedIndexOutput
if [ -z $sudoFlag ]
then
spark-submit   --class "IndexInverter"   --master local[4]   target/scala-2.11/mini-google-group-13_2.11-1.0.jar Project1
spark-submit  add_KV_to_rocksdb.py ${location}Project1 ${dbName}
else 
sudo spark-submit   --class "IndexInverter"   --master local[4]   target/scala-2.11/mini-google-group-13_2.11-1.0.jar ${location}Project1
sudo spark-submit  add_KV_to_rocksdb.py ${location}Project1 ${dbName}
fi

exit 0

