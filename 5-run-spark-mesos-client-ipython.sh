#!/bin/bash

# import functions
source variables_and_helpers.sh


# set worker
__spark_user=$1
if [ "$__spark_user" == "" ]; then
  echo "You must provide a user. Usage:"
  echo "$0 username mesos://ip:port"
  exit 1
fi


# set worker
__spark_master=$2
if [ "$__spark_master" == "" ]; then
  echo "You must provide a master. Usage:"
  echo "$0 username mesos://ip:port"
  exit 1
fi


# set docker image
__image=$__image_client_mesos


# update repo and images
git pull origin master && \
docker pull $__image # alternatively: ./1-build.sh


# get host DNS server (for internal resolution)
__dns=$(dns_detect)


# run container
echo "starting $__image..."
__container=$(docker run  -d \
                          --net="host" \
                          --env "SPARK_MASTER=$__spark_master" \
                          --env "CONTAINER_USER=$__spark_user" \
                          --volume=$__host_dir_hadoop_conf:/etc/hadoop/conf \
                          --volume=$__host_dir_hive_conf:/etc/hive/conf \
                          --volume=$__host_dir_ipython_notebook:/ipython \
                            $__image)


#TODO: determine how to forward ports instead of binding --net="host" above
# forward host ports to container
#host_forward_multiple_ports_to_container $__container


# notify user
echo "Visit IPython notebook at http://$__hostname:8888"
