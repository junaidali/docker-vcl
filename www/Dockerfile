FROM centos:7
LABEL maintainer="Junaid Ali <alisyed8@iit.edu>"
RUN yum install epel-release -y && yum update -y && yum install -y \
	httpd \
	mod_ssl \
	php \
	php-ldap \
	php-mysql \
	php-pear-CAS \
	php-pecl-xdebug \
	php-xml \
	php-xmlrpc \
	tcpdump \
	&& yum clean all \
	&& rm -rf /var/cache/yum
COPY etc/php.d/xdebug.ini /etc/php.d/xdebug.ini
COPY web /var/www/html/vcl
WORKDIR /var/www/html/vcl/.ht-inc
RUN ["chmod", "+x", "genkeys.sh"]
COPY conf.php /var/www/html/vcl/.ht-inc/
RUN ["chown", "-R", "apache", "/var/www/html/vcl/.ht-inc/maintenance"]
RUN ["chown", "-R", "apache", "/var/www/html/vcl/.ht-inc/cryptkey"]
EXPOSE 80
EXPOSE 443
COPY etc/php.ini /etc/php.ini

COPY docker-entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/supervisor.d/httpd.conf /etc/supervisor.d/httpd.conf
COPY wait-for-it.sh /wait-for-it.sh
RUN ["chmod", "+x", "/wait-for-it.sh"]

WORKDIR /var/www/html/vcl
# enable mounting of vcl source code for development
VOLUME [ "/var/www/html/vcl" ]
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
