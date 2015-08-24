# CDH5
##NOTE: identical copy from Rich Haase <rdhaase@gmail.com> richhaase/cdh5-hadoop image, which builds on Ubuntu:12.04
##      Adding this temporarily until an Ubuntu:14.04 version exists upstream
FROM lab41/oracle-jdk7
MAINTAINER Kyle F "kylef@lab41.org"
ENV REFRESHED_AT 2015-07-29

# CDH5 Repositories
RUN cd /tmp && \
    wget http://archive.cloudera.com/cdh5/one-click-install/precise/amd64/cdh5-repository_1.0_all.deb && \
    dpkg -i cdh5-repository_1.0_all.deb
RUN wget -q http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key -O - | apt-key add -
RUN wget -q http://archive.cloudera.com/gplextras5/ubuntu/precise/amd64/gplextras/cloudera.list -O /etc/apt/sources.list.d/gplextras.list
RUN apt-get update

# Hadoop core packages
RUN apt-get install -yqq hadoop-yarn-resourcemanager hadoop-0.20-mapreduce-jobtracker \
    hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode hadoop-yarn-nodemanager \
    hadoop-0.20-mapreduce-tasktracker hadoop-hdfs-datanode hadoop-mapreduce \
    hadoop-mapreduce-historyserver hadoop-yarn-proxyserver hadoop-client

# Hadoop ecosystem packages
#
# HBase
RUN apt-get install -yqq hbase

# Hive
RUN apt-get install -yqq hive

# Oozie
RUN apt-get install -yqq oozie oozie-client

# Pig
RUN apt-get install -yqq pig pig-udf-datafu

# Spark
RUN apt-get install -yqq spark-core spark-master spark-worker spark-history-server spark-python

# Hue
RUN apt-get install -yqq hue hue-plugins
