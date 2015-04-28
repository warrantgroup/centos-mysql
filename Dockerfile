FROM warrantgroup/centos:7
MAINTAINER Andy Roberts <andy.roberts@warrant-group.com>

# Install packages
RUN yum --setopt=tsflags=nodocs -y install \
	http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm \
	pwgen

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL configuration
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

# Add MySQL scripts
ADD import.sh /import.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Exposed ENV
ENV MYSQL_USER admin
ENV MYSQL_PASS **Random**

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 22, 3306

CMD ["/run.sh"]
