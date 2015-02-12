#!/bin/bash

# runsvdir-start clears environment variables
# initially export all variables (later reimport within /run file)
export > /env.bash

# start service
runsvdir-start
