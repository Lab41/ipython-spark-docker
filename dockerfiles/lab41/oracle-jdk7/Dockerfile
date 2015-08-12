# JDK7
##NOTE: identical copy from Rich Haase <rdhaase@gmail.com> richhaase/oracle-jdk7 image, which builds on Ubuntu:12.04
##      Adding this temporarily until an Ubuntu:14.04 version exists upstream
FROM ubuntu:trusty
MAINTAINER Kyle F "kylef@lab41.org"
ENV REFRESHED_AT 2015-07-29

# Install wget
RUN apt-get update
RUN apt-get install --assume-yes wget

# Install Oracle JDK
RUN mkdir /opt/jdk && \
    wget --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-linux-x64.tar.gz && \
    tar -zxf jdk-7u67-linux-x64.tar.gz -C /opt/jdk && \
    rm jdk-7u67-linux-x64.tar.gz

# configure java(c)
RUN update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.7.0_67/bin/java 100
RUN update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.7.0_67/bin/javac 100
