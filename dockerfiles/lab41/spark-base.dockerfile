# hadoop client for Lab41's CHD5 cluster
FROM lab41/cdh5-hadoop
MAINTAINER Kyle F <kylef@lab41.org>


########################################################
# add ipython environment to existing CDH5
########################################################
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

#Runit
RUN apt-get install -y runit
CMD /usr/sbin/runsvdir-start

#SSHD
RUN apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd
RUN sed -i "s/session.*required.*pam_loginuid.so/#session    required     pam_loginuid.so/" /etc/pam.d/sshd
RUN sed -i "s/PermitRootLogin without-password/#PermitRootLogin without-password/" /etc/ssh/sshd_config

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common

#Required by Python packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential python-dev python-pip liblapack-dev libatlas-dev gfortran libfreetype6 libfreetype6-dev libpng12-dev python-lxml libyaml-dev g++ libffi-dev

#0MQ
RUN cd /tmp && \
    wget http://download.zeromq.org/zeromq-4.0.3.tar.gz && \
    tar xvfz zeromq-4.0.3.tar.gz && \
    cd zeromq-4.0.3 && \
    ./configure && \
    make install && \
    ldconfig

#Upgrade pip
RUN pip install -U setuptools
RUN pip install -U pip

#matplotlib needs latest distribute
RUN pip install -U distribute

#IPython
RUN pip install ipython
ENV IPYTHONDIR /ipython
RUN mkdir /ipython && \
    ipython profile create nbserver

#NumPy v1.7.1 is required for Numba
RUN pip install numpy==1.7.1

#Pandas
RUN pip install pandas

#Optional
RUN pip install cython
RUN pip install jinja2 pyzmq tornado
RUN pip install numexpr bottleneck scipy pygments
RUN apt-get install pkg-config
RUN pip install matplotlib
RUN pip install sympy pymc
RUN pip install patsy
RUN pip install statsmodels
RUN pip install beautifulsoup4 html5lib

#Pattern
RUN pip install --allow-external pattern

#NLTK
RUN pip install pyyaml nltk

#Networkx
RUN pip install networkx

#LLVM and Numba
RUN cd /tmp && \
    wget http://llvm.org/releases/3.6.1/llvm-3.6.1.src.tar.xz && \
    tar xvf llvm-3.6.1.src.tar.xz && \
    cd llvm-3.6.1.src && \
    ./configure --enable-optimized
RUN cd /tmp/llvm-3.6.1.src && \
    REQUIRES_RTTI=1 make install
RUN pip install enum34
RUN cd /tmp && \
    git clone https://github.com/numba/llvmlite && \
    cd llvmlite && \
    python setup.py install
RUN pip install numba

#Biopython
RUN pip install biopython

#Bokeh
RUN pip install requests bokeh

#Install R 3+
RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' > /etc/apt/sources.list.d/r.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get update && \
    apt-get install -y r-base r-base-core r-base-html r-recommended

#Rmagic
RUN pip install rpy2

# vincent
RUN pip install vincent

# seaborn statistical visualization
RUN pip install seaborn

# scikit-learn ML
RUN pip install scikit-learn

# mdp data processing
RUN cd /tmp; git clone https://github.com/mdp-toolkit/mdp-toolkit.git && \
    cd /tmp/mdp-toolkit; python setup.py install && \
    cd /; rm -rf /tmp/mdp-toolkit
RUN easy_install MDP

# jsonschema needed for IPython
RUN pip install jsonschema

########################################################
# configure for remote hadoop cluster
########################################################

# update hadoop env
ENV JAVA_HOME /opt/jdk/jdk1.7.0_67

# add custom shell env
ADD config/environment/bashrc.sh /.bashrc

# add remote cluster config
ADD config/cdh5/hadoop /etc/hadoop/conf
ADD config/cdh5/hive /etc/hive/conf

# enable data volume
VOLUME ["/data"]



########################################################
# configure for remote pyspark connection. modified from:
#   http://ramhiser.com/2015/02/01/configuring-ipython-notebook-support-for-pyspark
########################################################

# update spark libraries latest standalone install
RUN curl http://d3kbcqa49mib13.cloudfront.net/spark-1.2.0-bin-hadoop2.4.tgz | tar -xz -C /usr/local/ && \
    cd /usr/local && ln -s spark-1.2.0-bin-hadoop2.4 spark && \
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
