FROM centos:centos7
MAINTAINER adfinis-sygroup.ch <info@adfinis-sygroup.ch>
LABEL io.k8s.description="MariaDB is a multi-user, multi-threaded SQL database server" \
      io.k8s.display-name="MariaDB 10.1" \
      io.openshift.expose-services="3306:mysql" \
      io.openshift.tags="database,mysql,mariadb10,rh-mariadb10"
EXPOSE 3306/tcp


COPY mariadb.repo /etc/yum.repos.d/mariadb.repo
RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
    yum install -y \
      epel-release && \
    yum install -y \
      MariaDB-client \
      MariaDB-server \
      galera \
      which \
      socat \
      percona-xtrabackup && \
    yum clean all && \
    rm -rf /var/lib/mysql && \
    mkdir -p /var/lib/mysql && \
    chown mysql:root /var/lib/mysql && \
    chmod g+w /var/lib/mysql


RUN mkdir /init

COPY init/*sh /init/
COPY init/*cnf /init/
COPY init/peer-finder /init/

RUN chmod 755 /init/*sh && chmod 755 /init/peer-finder

COPY init/server.cnf /etc/my.cnf.d/server.cnf
RUN mkdir -p /etc/mysql && chown 27.0 /etc/mysql
VOLUME ["/var/lib/mysql"]

USER 27

ENTRYPOINT ["/init/entrypoint.sh"]
