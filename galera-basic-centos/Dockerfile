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
    rm -r /var/lib/mysql && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql.0 /var/lib/mysql && \
    chmod g+w -R /var/lib/mysql

COPY my.cnf /etc/mysql/my.cnf
COPY entrypoint.sh /entrypoint.sh

RUN chmod 755 /entrypoint.sh
COPY server.cnf /etc/my.cnf.d/server.cnf
RUN chown -R mysql.0 /var/lib/mysql && \
    chmod g+w -R /var/lib/mysql

VOLUME ["/var/lib/mysql"]

USER 27

ENTRYPOINT ["/entrypoint.sh"]
