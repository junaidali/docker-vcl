FROM centos:7
LABEL maintainer="Junaid Ali <alisyed8@iit.edu>"
RUN yum update -y && yum install -y \
	httpd \
	mod_ssl \
	php \
	php-ldap \
	php-mysql \
	php-xml \
	php-xmlrpc \
	python-setuptools \
	which \	
	&& yum clean all \
	&& rm -rf /var/cache/yum \
	&& easy_install supervisor

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
ENTRYPOINT ["/wait-for-it.sh", "vcl-mysql:3306", "--", "/entrypoint.sh"]
CMD ["/wait-for-it.sh", "vcl-mysql:3306", "--", "/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]