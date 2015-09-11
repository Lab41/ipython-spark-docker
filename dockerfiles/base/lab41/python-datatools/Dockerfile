# hadoop client for Lab41's CHD5 cluster
FROM lab41/cdh5-hadoop
MAINTAINER Kyle F <kylef@lab41.org>
ENV REFRESHED_AT 2015-07-29

########################################################
# add ipython environment to existing CDH5
########################################################
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

#Utilities
RUN apt-get install --assume-yes vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common pkg-config

#Required by Python packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes build-essential python-dev python-pip liblapack-dev libatlas-dev gfortran libfreetype6 libfreetype6-dev libpng12-dev python-lxml libyaml-dev g++ libffi-dev

#0MQ
RUN cd /tmp && \
    wget http://download.zeromq.org/zeromq-4.0.3.tar.gz && \
    tar xvfz zeromq-4.0.3.tar.gz && \
    cd zeromq-4.0.3 && \
    ./configure && \
    make install && \
    ldconfig && \
    rm -rf /tmp/zeromq-4.0.3*

#Upgrade pip
RUN pip install -U setuptools
RUN pip install -U pip

#matplotlib needs latest distribute
RUN pip install -U distribute

#NumPy v1.7.1 is required for Numba
RUN pip install numpy==1.7.1

#Pandas
RUN pip install pandas

#Optional
RUN pip install cython
RUN pip install jinja2 pyzmq tornado
RUN pip install numexpr bottleneck scipy pygments
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

#Biopython
RUN pip install biopython

#Bokeh
RUN pip install requests bokeh

#Install R 3+
RUN echo 'deb http://cran.rstudio.com/bin/linux/ubuntu trusty/' > /etc/apt/sources.list.d/r.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN apt-get update && \
    apt-get install --assume-yes r-base r-base-core r-base-html r-recommended

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
    cd / && \
    rm -rf /tmp/mdp-toolkit
RUN easy_install MDP

#IPython (jsonschema needed for IPython)
RUN pip install ipython jsonschema jupyter
ENV IPYTHONDIR /ipython
RUN mkdir $IPYTHONDIR && \
    ipython profile create nbserver


# default to python interpreter
CMD ["python2.7"]
