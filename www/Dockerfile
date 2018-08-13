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
	postfix \
	python-setuptools \
	tcpdump \
	which \
	&& yum clean all \
	&& rm -rf /var/cache/yum \
	&& easy_install supervisor

COPY etc/php.d/xdebug.ini /etc/php.d/xdebug.ini
COPY web /var/www/html
WORKDIR /var/www/html/.ht-inc
RUN ["chmod", "+x", "genkeys.sh"]
COPY conf.php /var/www/html/.ht-inc/
RUN ["chown", "-R", "apache", "/var/www/html/.ht-inc/maintenance"]
RUN ["chown", "-R", "apache", "/var/www/html/.ht-inc/cryptkey"]
EXPOSE 80
EXPOSE 443
COPY etc/php.ini /etc/php.ini

COPY docker-entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/supervisor.d/httpd.conf /etc/supervisor.d/httpd.conf
COPY wait-for-it.sh /wait-for-it.sh
RUN ["chmod", "+x", "/wait-for-it.sh"]

# setup postfix
COPY postfix-wrapper.sh /postfix-wrapper.sh
RUN ["chmod", "+x", "postfix-wrapper.sh"]
COPY etc/supervisor.d/postfix.conf /etc/supervisor.d/postfix.conf

WORKDIR /var/www/html
# enable mounting of vcl source code for development
VOLUME [ "/var/www/html" ]
ENTRYPOINT ["/wait-for-it.sh", "vcl-mysql:3306", "--", "/entrypoint.sh"]
CMD ["/wait-for-it.sh", "vcl-mysql:3306", "--", "/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
