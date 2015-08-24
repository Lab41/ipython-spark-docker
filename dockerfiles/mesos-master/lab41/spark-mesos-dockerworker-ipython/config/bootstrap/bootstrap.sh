#!/bin/bash

# setup container user
#   - replace 1000 with user/group id
#   - setup home directory
if [ -n "$CONTAINER_USER" ]; then
  export uid=1000 gid=1000 && \
  mkdir -p /home/${CONTAINER_USER} && \
  echo "${CONTAINER_USER}:x:${uid}:${gid}:${CONTAINER_USER^},,,:/home/${CONTAINER_USER}:/bin/bash" >> /etc/passwd && \
  echo "${CONTAINER_USER}:x:${uid}:" >> /etc/group && \
  echo "${CONTAINER_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${CONTAINER_USER} && \
  chmod 0440 /etc/sudoers.d/${CONTAINER_USER} && \
  chown ${uid}:${gid} -R /home/${CONTAINER_USER} && \
  chown ${uid}:${gid} -R /ipython
fi

# runsvdir-start clears environment variables
# initially export all variables (later reimport within /run file)
export > /env.bash

# start service
runsvdir-start
