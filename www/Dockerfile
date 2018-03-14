FROM centos:7
LABEL maintainer="Junaid Ali <alisyed8@iit.edu>"
RUN yum install epel-release -y && yum update -y && yum install -y \
	httpd \
	mod_ssl \
	php \
	php-ldap \
	php-mysql \
	php-pecl-xdebug \
	php-xml \
	php-xmlrpc \
	tcpdump \
	&& yum clean all \
	&& rm -rf /var/cache/yum
COPY etc/php.d/xdebug.ini /etc/php.d/xdebug.ini
COPY web /var/www/html/vcl
COPY secrets.php /var/www/html/vcl/.ht-inc/
WORKDIR /var/www/html/vcl/.ht-inc
RUN ["chmod", "+x", "genkeys.sh"]
RUN ["./genkeys.sh"]
COPY conf.php /var/www/html/vcl/.ht-inc/
RUN ["chown", "-R", "apache", "/var/www/html/vcl/.ht-inc/maintenance"]
RUN ["chown", "-R", "apache", "/var/www/html/vcl/.ht-inc/cryptkey"]
EXPOSE 80
EXPOSE 443
WORKDIR /var/www/html/vcl
# enable mounting of vcl source code for development
VOLUME [ "/var/www/html/vcl" ]
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
