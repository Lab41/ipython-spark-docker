#!/bin/bash

set -e

# set user environment variables
export USER=$(whoami)
export HOME=/home/$USER

# create jupyter configuration
sudo rm -rf $HOME/.jupyter
jupyter notebook --generate-config
cp -f /jupyter_notebook_config.py $HOME/.jupyter/

# customize logo
sudo cp -f /ipython/profile_default/static/base/images/logo.png /usr/local/lib/python2.7/dist-packages/notebook/static/base/images/logo.png

# start notebook
PYSPARK_DRIVER_PYTHON=ipython PYSPARK_DRIVER_PYTHON_OPTS=notebook $SPARK_HOME/bin/pyspark --master $SPARK_MASTER $SPARK_WORKER_CONFIG
