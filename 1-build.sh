#!/bin/bash

# fail on errors
set -e


# import functions
source variables_and_helpers.sh


# build images
build_docker_image $__image_base
build_docker_image $__image_master
build_docker_image $__image_worker
build_docker_image $__image_client
