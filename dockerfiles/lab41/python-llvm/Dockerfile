# hadoop client for Lab41's CHD5 cluster
FROM lab41/python-datatools
MAINTAINER Kyle F <kylef@lab41.org>


########################################################
# add LLVM and Numba to base python
########################################################
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


# default to python interpreter
CMD ["python2.7"]
