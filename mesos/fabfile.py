# Steps from, "How To Configure a Production-Ready Mesosphere Cluster on Ubuntu 14.04," - Sep 25, 2014
# https://www.digitalocean.com/community/tutorials/how-to-configure-a-production-ready-mesosphere-cluster-on-ubuntu-14-04

from fabric.api import run, env, execute, task
from fabric.context_managers import shell_env
import math


# list master and slave hosts
env.roledefs = {
    'masters': ['ip-address-master1', 'ip-address-master2', 'ip-address-master2'],
    'slaves': ['ip-address-slave1', 'ip-address-slave2', 'ip-address-slave3']
}

# docker on mesos
mesos_containerizers = "mesos,docker"
docker_images = ['lab41/spark-mesos-dockerworker-ipython']


def configure_packages():
    run('sudo sh -c "echo \'nameserver 8.8.8.8\' >> /etc/resolvconf/resolv.conf.d/base"')
    run('sudo resolvconf -u')
    run(' DISTRO=$(lsb_release -is | tr \'[:upper:]\' \'[:lower:]\'); \
          CODENAME=$(lsb_release -cs); \
          sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF; \
          echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list')


def install_mesos():
    execute(configure_packages)
    run(' sudo apt-get update && \
          sudo apt-get install --yes mesos')


def install_mesosphere():
    execute(configure_packages)
    run(' sudo apt-get update && \
          sudo apt-get install --yes mesosphere')


def configure_zookeeper():
    host_str = ""
    for index,host in enumerate(env.roledefs['masters']):
        host_str += "{}:2181,".format(host)
    host_str = host_str[:-1]

    run('sudo sed -i "s|^zk.*|zk://{}/mesos|g" /etc/mesos/zk'.format(host_str))

def configure_zookeeper_masters():
    host_id = env.roledefs['masters'].index(env.host)
    run('sudo sh -c "echo \'{}\' > /etc/zookeeper/conf/myid"'.format(host_id))
    for index,host in enumerate(env.roledefs['masters']):
        run('sudo sh -c "echo \'server.{}={}:2888:3888\' >> /etc/zookeeper/conf/zoo.cfg"'.format(index, host))


def configure_quorum():
    run('sudo sh -c "echo \'{}\' > /etc/mesos-master/quorum"'.format(len(env.roledefs['masters'])/2 + 1))


def configure_mesos_ip():
    run('sudo sh -c "echo \'{}\' > /etc/mesos-master/ip"'.format(env.host))
    run('sudo sh -c "echo \'{}\' > /etc/mesos-master/hostname"'.format(env.host))


def configure_marathon():
    run('sudo mkdir -p /etc/marathon/conf')
    run('sudo cp /etc/mesos-master/hostname /etc/marathon/conf')
    run('sudo cp /etc/mesos/zk /etc/marathon/conf/master')
    run('sudo cp /etc/marathon/conf/master /etc/marathon/conf/zk')
    run('sudo sed -i "s|mesos|marathon|g" /etc/marathon/conf/zk')


def start_masters():
    run('echo manual | sudo tee /etc/init/mesos-slave.override')
    run('sudo stop mesos-slave; sudo restart zookeeper')
    run('sudo start mesos-master')
    run('sudo start marathon')


def start_slaves():
    run('echo manual | sudo tee /etc/init/zookeeper.override')
    run('echo manual | sudo tee /etc/init/mesos-master.override')
    run('echo {} | sudo tee /etc/mesos-slave/ip'.format(env.host))
    run('sudo cp /etc/mesos-slave/ip /etc/mesos-slave/hostname')
    run('sudo sh -c "echo \'{}\' > /etc/mesos-slave/containerizers"'.format(mesos_containerizers))
    run('sudo sh -c "echo \'5mins\' > /etc/mesos-slave/executor_registration_timeout"')
    run('sudo stop zookeeper; sudo stop mesos-master; sudo start mesos-slave')


def docker_pull_containers():
    for image in docker_images:
        run('docker pull {}'.format(image))


def configure_and_start_masters():
    execute(configure_zookeeper_masters)
    execute(configure_quorum)
    execute(configure_mesos_ip)
    execute(configure_marathon)
    execute(start_masters)


def configure_and_start_slaves():
    execute(start_slaves)

def pull_docker_images():
    execute(docker_pull_containers)

def docker_restart():
    run('sudo service docker restart')
