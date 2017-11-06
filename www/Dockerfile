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
	&& yum clean all \
	&& rm -rf /var/cache/yum
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
COPY etc/php.ini /etc/php.ini
WORKDIR /var/www/html/vcl
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]