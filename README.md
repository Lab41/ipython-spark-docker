# ipython-spark-docker

Please see the accompanying blog post, <a href="http://lab41.github.io/blog/2015/04/13/ipython-on-spark-on-docker" target="_blank">Using Docker to Build an IPython-driven Spark Deployment</a>, for the technical details and motivation behind this project.  This repo provides [Docker](http://www.docker.io) containers to run:
  - [Spark](https://spark.apache.org) master and worker(s) on dedicated hosts
  - [IPython](http://ipython.org) user interface within a dedicated Spark client

## Architecture
Docker containers provide a portable and repeatable method for deploying the cluster:
<p align="center">
    <img src="architecture/architecture-draw.io.png" alt="hadoop-docker-client connections">
</p>

### CDH5 Tools and Libraries

<table>
  <tr>
    <td><a href="http://hadoop.apache.org/" target="_blank">HDFS</a></td>
    <td><a href="http://hbase.apache.org/" target="_blank">Hbase</a></td>
    <td><a href="https://hive.apache.org/" target="_blank">Hive</a></td>
    <td><a href="http://oozie.apache.org/" target="_blank">Oozie</a></td>
    <td><a href="http://pig.apache.org/" target="_blank">Pig</a></td>
    <td><a href="http://gethue.com/" target="_blank">Hue</a></td>
  </tr>
</table>


### Python Packages and Modules

<table>
    <tr>
      <td><a href="http://www.clips.ua.ac.be/pattern" target="_blank">Pattern</a></td>
      <td><a href="http://nltk.org" target="_blank">NLTK</a></td>
      <td><a href="http://pandas.pydata.org" target="_blank">Pandas</a></td>
      <td><a href="http://www.numpy.org" target="_blank">NumPy</a></td>
      <td><a href="http://scipy.org" target="_blank">SciPy</a></td>
      <td><a href="http://sympy.org" target="_blank">SymPy</a></td>
      <td><a href="http://stanford.edu/~mwaskom/software/seaborn/" target="_blank">Seaborn</a></td>
    </tr>
    <tr>
      <td><a href="http://cython.org" target="_blank">Cython</a></td>
      <td><a href="http://numba.pydata.org" target="_blank">Numba</a></td>
      <td><a href="http://biopython.org" target="_blank">Biopython</a></td>
      <td><a href="http://ipython.org/ipython-doc/dev/config/extensions/rmagic.html" target="_blank">Rmagic</a></td>
      <td><a href="http://zeromq.org/bindings:python" target="_blank">0MQ</a></td>
      <td><a href="http://matplotlib.org/" target="_blank">Matplotlib</a></td>
      <td><a href="http://scikit-learn.org/" target="_blank">Scikit-Learn</a></td>
    </tr>
    <tr>
      <td><a href="http://statsmodels.sourceforge.net/" target="_blank">Statsmodels</a></td>
      <td><a href="http://www.crummy.com/software/BeautifulSoup/" target="_blank">Beautiful Soup</a></td>
      <td><a href="https://networkx.github.io/" target="_blank">NetworkX</a></td>
      <td><a href="http://numba.pydata.org/" target="_blank">LLVM</a></td>
      <td><a href="http://bokeh.pydata.org/" target="_blank">Bokeh</a></td>
      <td><a href="https://github.com/wrobstory/vincent" target="_blank">Vincent</a></td>
      <td><a href="http://mdp-toolkit.sourceforge.net/" target="_blank">MDP</a></td>
    </tr>
</table>


## Usage

**Installation Prerequisites** - Prepare hosts and Docker environment:

  1. Build host nodes with
    - <a href="http://docs.docker.com/installation/ubuntulinux" target="_blank">Docker v1.5+</a>
    - <a href="http://packages.ubuntu.com/trusty/jq" target="_blank">jq JSON processor</a>
    - <a href="http://packages.ubuntu.com/trusty/iptables" target="_blank">iptables</a>
    <div>For example, on an Ubuntu host:</div>
    <pre><code>./0-prepare-host.sh</code></pre>
  2. Update the Hadoop configuration files in ```config/cdh5/<multiple-files>``` with the correct hostnames for your Hadoop cluster.  Use ```grep FIXME -R .``` to find hostnames to change.
  3. Generate new SSH keypair (```config/ssh/id_rsa``` and ```config/ssh/id_rsa.pub```), adding the public key to ```config/ssh/authorized_keys```.
  4. (optional) Update ```SPARK_WORKER_CONFIG``` environment variable for Spark-specific options such as executor cores.  Update the variable via a shell ```export``` command or by updating ```config/sv/spark-client-iython/ipython/run```.
  5. (optional) Comment out any unwanted packages in the base Dockerfile image ```dockerfiles/lab41/spark-base.dockerfile```.

**Building/Running** - Build each Docker image and run each on separate dedicated hosts:

1. <strong>Build all images</strong>: <pre><code>./1-build.sh</code></pre>
2. <strong>Deploy cluster nodes</strong>
  - Ensure each host has a Fully-Qualified-Domain-Name (i.e. master.domain.com; worker1.domain.com; ipython.domain.com)
  - Tip: Create a shared host image with pre-built containers and pass the below scripts as startup commands on each host type
3. <strong>Run master container on master host</strong>: <pre><code>./2-run-spark-master.sh</code></pre>
4. <strong>Run worker container(s) on worker host(s)</strong>: <pre><code>./3-run-spark-worker.sh spark://<spark-master-fqdn>:7077</code></pre>
5. <strong>Run client container on client host</strong>: <pre><code>./4-run-spark-client-ipython.sh spark://<spark-master-fqdn>:7077</code></pre>
