#!/bin/bash

############################################################
# default variables
############################################################
# image naming scheme (prefix/label)
__image_base=lab41/spark-base
__image_master=lab41/spark-master
__image_worker=lab41/spark-worker
__image_client=lab41/spark-client-ipython
__dockerfile_dir=$(pwd)/dockerfiles

# networking
__ipchain=DOCKERSPARK
__iptables_ports=2122,4040,7077,8080,8081,8100:65535
__hostname=$(hostname --fqdn)

# container-specific
__host_dir_ipython_notebook=$(pwd)/runtime/ipython


############################################################
# helper functions
############################################################

# build function
# NOTE: requires Dockerfiles in shared directory that follows naming scheme: prefix/label.dockerfile
function build_docker_image() {
  local __image=$1
  docker build  -f ${__dockerfile_dir}/${__image}.dockerfile \
                -t $__image .
}
