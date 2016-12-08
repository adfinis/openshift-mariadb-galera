# Copyright 2016 All rights reserved.

FROM centos:centos7
MAINTAINER adfinis-sygroup.ch <info@adfinis-sygroup.ch>

RUN yum update -y && yum install -y wget && yum clean all

ADD on-start.sh /
ADD my-galera.cnf /
# See ../peer-finder for source
RUN wget -qO /peer-finder https://storage.googleapis.com/kubernetes-release/pets/peer-finder
ADD install.sh /
RUN chmod -c 755 /install.sh /on-start.sh /peer-finder

ENTRYPOINT ["/install.sh"]
