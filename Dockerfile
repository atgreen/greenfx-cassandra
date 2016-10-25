FROM centos:centos7

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm
ADD src/datastax.repo /etc/yum.repos.d/datastax.repo

RUN yum -y install wget tar supervisor sysstat sudo \
      which openssl hostname java-1.8.0-openjdk-headless dsc22 && \
    yum -y update && yum clean all

# Configure supervisord
ADD src/supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor

# Deploy startup script
ADD src/start.sh /usr/local/bin/start

# Necessary since cassandra is trying to override the system limitations
# See https://groups.google.com/forum/#!msg/docker-dev/8TM_jLGpRKU/dewIQhcs7oAJ
RUN rm -f /etc/security/limits.d/cassandra.conf

EXPOSE 7199 7000 7001 9160 9042
EXPOSE 22 8012 61621

# sorry
USER root
CMD start
