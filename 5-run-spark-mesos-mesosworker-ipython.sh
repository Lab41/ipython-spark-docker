#!/bin/bash

# import functions
source variables_and_helpers.sh


# set user
__spark_user=$1
if [ "$__spark_user" == "" ]; then
  echo "You must provide a user. Usage:"
  echo "$0 username mesos://ip:port hdfs://path/to/spark/binary"
  exit 1
fi


# set master
__spark_master=$2
if [ "$__spark_master" == "" ]; then
  echo "You must provide a master. Usage:"
  echo "$0 username mesos://ip:port hdfs://path/to/spark/binary"
  exit 1
fi


# set master
__spark_binary=$3
if [ "$__spark_binary" == "" ]; then
  echo "You must locate the spark binary. Usage:"
  echo "$0 username mesos://ip:port hdfs://path/to/spark/binary"
  exit 1
fi


# set docker image
__image=$__image_client_mesos_mesosworker


# update repo and images
#git pull origin master && \
docker pull $__image # alternatively: ./1-build.sh


# get host DNS server (for internal resolution)
__dns=$(dns_detect)


# run container
echo "starting $__image..."
__container=$(docker run  -d \
                          --net="host" \
                          --publish=8888:8888 \
                          --env "SPARK_MASTER=$__spark_master" \
                          --env "SPARK_BINARY=$__spark_binary" \
                          --env "SPARK_RAM_DRIVER=96G" \
                          --env "SPARK_RAM_WORKER=64G" \
                          --env "CONTAINER_USER=$__spark_user" \
                          --volume=$__host_dir_hadoop_conf:/etc/hadoop/conf \
                          --volume=$__host_dir_hive_conf:/etc/hive/conf \
                          --volume=$__host_dir_ipython_notebook:/ipython \
                          --volume=$__host_dir_data:/data \
                            $__image)


#TODO: determine how to forward ports instead of binding --net="host" above
# forward host ports to container
#host_forward_multiple_ports_to_container $__container


# notify user
echo "Visit IPython notebook at http://$__hostname:8888"
