# build off base
FROM lab41/spark-base
MAINTAINER Kyle F <kylef@lab41.org>

# add runit services
ADD config/sv/spark-master /etc/service
