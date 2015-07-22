#!/bin/bash

# import functions
source variables_and_helpers.sh


# set docker image
__image=$__image_master


# update repo and images
#git pull origin master && \
docker pull $__image # alternatively: ./1-build.sh


# get host DNS server (for internal resolution)
__dns=$(dns_detect)


# run container
echo "starting $__image..."
__container=$(docker run  -d \
                          --hostname="$__hostname" \
                          --dns=$__dns \
                          --volume=$__host_dir_hadoop_conf:/etc/hadoop/conf \
                          --volume=$__host_dir_hive_conf:/etc/hive/conf \
                            $__image)


# forward host ports to container
host_forward_multiple_ports_to_container $__container


# notify user
echo "Visit Spark master UI at http://$__hostname:8080"
