# build off base
FROM lab41/spark-base
MAINTAINER Kyle F <kylef@lab41.org>
ENV REFRESHED_AT 2015-07-29

# install mesos
ENV MESOS_VERSION 0.27.2-2.0.15.ubuntu1404
RUN echo "deb http://repos.mesosphere.io/ubuntu/ trusty main" > /etc/apt/sources.list.d/mesosphere.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
RUN apt-get --assume-yes update
RUN apt-get --assume-yes install mesos=${MESOS_VERSION}

# configure mesos library location
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so
ENV MESOS_NATIVE_LIBRARY /usr/local/lib/libmesos.so

# update workdir
WORKDIR /ipython

# ensure >= glibc 2.16 and latest libstdc/pyzmq for mesos v0.22.1
ADD config/dpkg/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
RUN for f in $(find /etc/apt/sources.list* -type f); do \
        echo "updating $f..."; \
        sed -i "s/precise/trusty/g" $f; \
    done && \
    apt-get update && \
    apt-get upgrade --assume-yes libc6 libstdc++6
RUN pip install --upgrade pyzmq

# update spark libraries latest standalone install
RUN curl http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | tar -xz -C /usr/local/ && \
    cd /usr/local && rm spark && ln -s spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark && \
    rm -f /usr/local/spark && \
    rm /usr/bin/spark-shell && \
    ln --symbolic /usr/local/spark/bin/spark-shell /usr/bin/spark-shell
ENV SPARK_HOME /usr/local/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

# add runit services
ADD config/service /etc/service

# configure PAM for user auth
RUN apt-get update --assume-yes
RUN apt-get --assume-yes build-dep pam

#Rebuild and install libpam with --disable-audit option
RUN apt-get install --assume-yes libpam-modules
RUN export CONFIGURE_OPTS=--disable-audit && \
    cd /root && \
    apt-get -b source pam && \
    dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb

# install new bootstrap file (creates CONTAINER_USER)
ADD config/bootstrap/bootstrap.sh /bootstrap.sh

# setup notebook configuration
ADD config/jupyter/jupyter-start.sh /jupyter-start.sh
ADD config/jupyter/jupyter_notebook_config.py /jupyter_notebook_config.py
RUN chmod a+x /jupyter-start.sh

# expose the IPython notebook port
EXPOSE 8888

# add data volume
VOLUME ["/data"]
