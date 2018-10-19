FROM mysql:5.6
LABEL maintainer="Junaid Ali <alisyed8@iit.edu>"

# Add VCL Database
ENV MYSQL_DATABASE vcl

# Copy VCL Initialization Data
COPY ./data/vcl.sql /docker-entrypoint-initdb.d/