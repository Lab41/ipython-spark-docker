#!/bin/bash

############################################################
# default variables
############################################################
# image naming scheme (prefix/label)
__image_upstream_oracle=lab41/oracle-jdk7
__image_upstream_cdh5=lab41/cdh5-hadoop
__image_upstream_python=lab41/python-datatools
__image_upstream_llvm=lab41/python-llvm
__image_base=lab41/spark-base
__image_master=lab41/spark-master
__image_worker=lab41/spark-worker
__image_client_standalone=lab41/spark-client-ipython
__image_client_mesos_base=lab41/spark-mesos-base
__image_client_mesos_mesosworker=lab41/spark-mesos-mesosworker-ipython
__image_client_mesos_dockerworker=lab41/spark-mesos-dockerworker-ipython
__dockerfile_dir=$(pwd)/dockerfiles

# networking
__ipchain=DOCKERSPARK
__iptables_ports=2122,4040,7077,8080,8081,8100:65535
__hostname=$(hostname --fqdn)

# container-specific
__host_dir_data=/data
__host_dir_ipython_notebook=$(pwd)/runtime/ipython
__host_dir_hadoop_conf=$(pwd)/runtime/cdh5/hadoop/conf
__host_dir_hive_conf=$(pwd)/runtime/cdh5/hive/conf


############################################################
# helper functions
############################################################

# build function
# NOTE: requires Dockerfiles in shared directory that follows naming scheme: prefix/label.dockerfile
function build_docker_image() {
  local __stage=$1
  local __image=$2
  echo -e "\n\n ----- Building $__image ----- \n\n"
  pushd ${__dockerfile_dir}/${__stage}/${__image}
  docker build -t $__image .
  popd
}

# detect DNS server
function dns_detect() {
  local __dns=${__dns:=$(cat /etc/resolv.conf | grep -m 1 nameserver | cut -d' ' -f 2)}
  if [ "$__dns" == "127.0.1.1" ]; then
    __dns=$(nm-tool | grep DNS | sed 's/\s//g' | cut -d':' -f 2)
  fi
  echo "$__dns"
}


# get container's ip address
function container_get_ip() {
  local __container=$1
  local __ip=""
  __ip=$(sudo docker inspect $__container | jq --raw-output '.[].NetworkSettings.IPAddress')
  echo "$__ip"
}


# setup host->container port forwarding
function host_forward_multiple_ports_to_container() {
  local __container=$1
  local __ip=$(container_get_ip $__container)

  if [ "" == "$__ip" ]; then
    echo "ERROR: count not get ip for container $__container"
  else

    echo "forwarding all ports to container $__container at $__ip"

    # create chain (will fail if already exists)
    sudo /sbin/iptables -t nat -N $__ipchain

    # flush chain rules
    sudo /sbin/iptables -t nat -F $__ipchain
    for rule in $(sudo iptables -t nat --line-numbers -L PREROUTING | grep $__ipchain | grep ^[0-9] | awk '{ print $1 }' | tac); do sudo iptables -t nat -D PREROUTING $rule; done

    # NAT forward to new chain
    sudo /sbin/iptables -t nat -A PREROUTING -j $__ipchain

    # NAT forward host ports to container
    sudo /sbin/iptables -t nat -A $__ipchain -p tcp -d $__hostname --match multiport --dports $__iptables_ports -j DNAT --to-destination $__ip

  fi
}
