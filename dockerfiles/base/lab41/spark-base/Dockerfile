# hadoop client for Lab41's CHD5 cluster
FROM lab41/python-llvm
MAINTAINER Kyle F <kylef@lab41.org>
ENV REFRESHED_AT 2015-07-29

########################################################
# add base services
########################################################
RUN apt-get update

#Runit
RUN apt-get install --assume-yes runit
CMD /usr/sbin/runsvdir-start

#SSHD
RUN apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd
RUN sed -i "s/session.*required.*pam_loginuid.so/#session    required     pam_loginuid.so/" /etc/pam.d/sshd
RUN sed -i "s/PermitRootLogin without-password/#PermitRootLogin without-password/" /etc/ssh/sshd_config


########################################################
# configure for remote hadoop cluster
########################################################

# update hadoop env
ENV JAVA_HOME /opt/jdk/jdk1.7.0_67

# add custom shell env
ADD config/environment/bashrc.sh /.bashrc

# enable data volumes, including CDH5 conf directories
VOLUME ["/data", "/etc/hadoop/conf", "/etc/hive/conf"]



########################################################
# configure for remote pyspark connection. modified from:
#   http://ramhiser.com/2015/02/01/configuring-ipython-notebook-support-for-pyspark
########################################################

# set spark version
ENV SPARK_VERSION 1.6.0
ENV HADOOP_VERSION 2.4

# update spark libraries latest standalone install
RUN curl http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | tar -xz -C /usr/local/ && \
    cd /usr/local && ln -s spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark && \
    rm /usr/bin/spark-shell && \
    ln --symbolic /usr/local/spark/bin/spark-shell /usr/bin/spark-shell


# spark environment
# NOTE: spark defaults to submit using 'python2.7'
#         update args to match binary installed on spark nodes
ENV SPARK_HOME /usr/local/spark
ENV PATH $PATH:$SPARK_HOME/bin
ENV PYSPARK_PYTHON python
WORKDIR $SPARK_HOME


# setup SSH for spark master-client communications
# NOTE: normally considered poor docker form, but in this case
#       spark master and workers communicate via SSH
ENV SPARK_SSH_PORT 2122
ENV SPARK_SSH_OPTS -o StrictHostKeyChecking=no -p $SPARK_SSH_PORT
ADD config/ssh /root/.ssh


# alternatively, generate and distribute ssh keys using:
#ADD config/ssh/config /root/.ssh/config
#RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
#    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 0600 /root/.ssh/config && \
    chmod 0400 /root/.ssh/id_rsa && \
    chown root:root -R /root/.ssh && \
    sed  -i "/^[^#]*UsePAM/ s/.*/#&/" /etc/ssh/sshd_config && \
    sed  -i "/^[^#]*Port/ s/.*/#&/" /etc/ssh/sshd_config && \
    echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "Port $SPARK_SSH_PORT" >> /etc/ssh/sshd_config


# default to bootstrap, leaving each container to implement separate runsvdir file(s)
ADD config/bootstrap/bootstrap.sh /bootstrap.sh
CMD ["/bootstrap.sh"]
