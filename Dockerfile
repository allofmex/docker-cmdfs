# VERSION 0.0.1
FROM ubuntu:latest

MAINTAINER MEx

RUN apt-get update && apt-get install -y libfuse-dev imagemagick nano
#libfuse-dev
#https://github.com/mikeswain/cmdfs.git
ADD cmdfs-ng_0.5-1_amd64.deb /tmp/cmdfs.deb
RUN dpkg -i /tmp/cmdfs.deb
#RUN cd /dmdfs_src
#./configure &&\
#make &&\
#make install

#RUN mkdir /hostTarget
#RUN mkdir /hostTarget/photos_all /hostTarget/photos_landscape

#ADD run.sh /run.sh
#ADD img_filter.sh /usr/local/bin/img_filter.sh
#ADD img_filter_land.sh /usr/local/bin/img_filter_land.sh
#RUN mkdir -p /usr/local/bin/cmdfs/
ADD ./config-example /etc/cmdfs
CMD ["./etc/cmdfs/run.sh"]
#cmdfs /tmp /test -o extension="JPG;PNG"
#CMD bash

#CMD ["./run.sh"]
#CMD ["tail", "-f", "/dev/null"]
