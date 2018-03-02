FROM centos:centos7
MAINTAINER adfinis-sygroup.ch <info@adfinis-sygroup.ch>
LABEL io.k8s.description="MariaDB is a multi-user, multi-threaded SQL database server" \
      io.k8s.display-name="MariaDB 10.1" \
      io.openshift.expose-services="3306:mysql" \
      io.openshift.tags="database,mysql,mariadb10,rh-mariadb10"
EXPOSE 3306/tcp

COPY root/etc/yum.repos.d/mariadb.repo /etc/yum.repos.d/

RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
    yum install -y \
      epel-release && \
    yum install -y \
      MariaDB-client \
      MariaDB-server \
      galera \
      which \
      socat \
      percona-xtrabackup \
      bind-utils \
      policycoreutils && \
    yum clean all
RUN echo '!include /etc/config/my_extra.cnf' >> /etc/my.cnf

COPY root /
RUN /usr/libexec/container-setup.sh

VOLUME ["/var/lib/mysql"]
USER 27:27
ENTRYPOINT ["/usr/bin/container-entrypoint.sh"]
