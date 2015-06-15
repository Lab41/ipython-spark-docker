# ipython-spark-docker

Please see the accompanying blog post, [Using Docker to Build an IPython-driven Spark Deployment](http://lab41.github.io/blog/2015/04/13/ipython-on-spark-on-docker), for the technical details and motivation behind this project.  This repo provides [Docker](http://www.docker.io) containers to run:

  - [Spark](https://spark.apache.org) master and worker(s) on dedicated hosts
  - [IPython](http://ipython.org) user interface within a dedicated Spark client

## Usage

####Installation and Deployment
Build each Docker image and run each on separate dedicated hosts

*Tip*: Build a common/shared host image with all necessary configurations and pre-built containers, which you can then use to deploy each node. When starting each node, you can pass the container run scripts as [User data](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) to initialize that container at boot time

---------------------------------

#### Clone [ipython-spark-docker](https://github.com/Lab41/ipython-spark-docker)

```
git clone https://github.com/Lab41/ipython-spark-docker.git
```

---------------------------------

####*Build and configure hosts*
  1. Install [Docker v1.5+](http://docs.docker.com/installation/ubuntulinux), [jq JSON processor](http://packages.ubuntu.com/trusty/jq), and [iptables](http://packages.ubuntu.com/trusty/iptables).

For example, on an Ubuntu host:

```
./0-prepare-host.sh
```

  2. Update the Hadoop configuration files in ```runtime/cdh5/<hadoop|hive>/<multiple-files>``` with the correct hostnames for your Hadoop cluster.  Use ```grep FIXME -R .``` to find hostnames to change.
  3. Generate new SSH keypair (```config/ssh/id_rsa``` and ```config/ssh/id_rsa.pub```), adding the public key to ```config/ssh/authorized_keys```.
  4. (optional) Update ```SPARK_WORKER_CONFIG``` environment variable for Spark-specific options such as executor cores.  Update the variable via a shell ```export``` command or by updating ```config/sv/spark-client-iython/ipython/run```.
  5. (optional) Comment out any unwanted packages in the base Dockerfile image ```dockerfiles/lab41/spark-base.dockerfile```.

---------------------------------

####*Get Docker images*:

Option A: If you prefer to pull from Docker Hub:

```
docker pull lab41/spark-master
docker pull lab41/spark-worker
docker pull lab41/spark-client-ipython
```

Option B: If you prefer to build from scratch yourself:

```
./1-build.sh
```

If you are creating common/shared host images, this would be the point to snapshot the host image for replication.

---------------------------------

####*Deploy cluster nodes*

Ensure each host has a Fully-Qualified-Domain-Name (i.e. master.domain.com; worker1.domain.com; ipython.domain.com) for the Spark nodes to properly associate

*Run the master container on the master host*:

```
./2-run-spark-master.sh
```

*Run worker container(s) on worker host(s)* (replace 'spark-master-fqdn' below):

```
./3-run-spark-worker.sh spark://spark-master-fqdn:7077
```

*Run the client container on the client host* (replace 'spark-master-fqdn' below):

```
./4-run-spark-client-ipython.sh spark://spark-master-fqdn:7077
```
