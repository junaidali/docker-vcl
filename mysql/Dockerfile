FROM mysql:5.6
LABEL maintainer="Junaid Ali <alisyed8@iit.edu>"

# Enable SSL
RUN ["mkdir", "/etc/certs"]
COPY etc/certs/ca.pem /etc/certs/ca.pem
COPY etc/certs/server-cert.pem /etc/certs/server-cert.pem
COPY etc/certs/server-key.pem /etc/certs/server-key.pem
COPY etc/certs/client-cert.pem /etc/certs/client-cert.pem
COPY etc/certs/client-key.pem /etc/certs/client-key.pem
RUN ["chown", "-R", "mysql:mysql", "/etc/certs"]

COPY etc/my.cnf /etc/mysql/my.cnf

# Copy VCL Initialization Data
COPY data/vcl.sql /docker-entrypoint-initdb.d/