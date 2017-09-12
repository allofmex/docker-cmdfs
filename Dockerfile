# VERSION 0.0.1
FROM ubuntu:latest
MAINTAINER allofmex

RUN apt-get update && apt-get install -y libfuse-dev imagemagick nano
ADD cmdfs-latest.deb /tmp/cmdfs.deb
RUN dpkg -i /tmp/cmdfs.deb
ADD ./config-example /etc/cmdfs
CMD ["./etc/cmdfs/run.sh"]

