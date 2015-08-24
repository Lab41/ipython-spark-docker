#!/bin/bash

# fail on errors
set -e


# import functions
source variables_and_helpers.sh


# build images
build_docker_image "base"         $__image_upstream_oracle
build_docker_image "base"         $__image_upstream_cdh5
build_docker_image "base"         $__image_upstream_python
build_docker_image "base"         $__image_upstream_llvm
build_docker_image "base"         $__image_base
build_docker_image "standalone"   $__image_master
build_docker_image "standalone"   $__image_worker
build_docker_image "standalone"   $__image_client_standalone
build_docker_image "mesos-master" $__image_client_mesos_base
build_docker_image "mesos-master" $__image_client_mesos_mesosworker
build_docker_image "mesos-master" $__image_client_mesos_dockerworker
