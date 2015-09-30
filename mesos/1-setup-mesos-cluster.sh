#!/bin/bash

# install mesosphere on masters
fab --parallel \
    --roles=masters \
      install_mesosphere

# install mesos on slaves
fab --parallel \
    --roles=slaves \
      install_mesos

# configure zookeeper on all
fab --parallel \
    --roles=masters,slaves \
      configure_zookeeper

# configure and start masters
fab --parallel \
    --roles=masters \
      configure_and_start_masters

# configure and start slaves
fab --parallel \
    --roles=slaves \
      configure_and_start_slaves

# load docker images
fab --parallel \
    --roles=slaves \
      pull_docker_images
