FROM centos:7
LABEL maintainer="Junaid Ali <alisyed8@iit.edu>"
RUN yum update -y && yum install -y \
    expat-devel \
    gcc \
    krb5-devel \
    krb5-libs \
    libxml2-devel \
    make \
    nmap \
    openssh-clients \
    openssl-devel \
    perl \
    perl-Archive-Tar \
    perl-CPAN \
    perl-Crypt-CBC \
    perl-Crypt-OpenSSL-RSA \
    perl-Crypt-Rijndael \
    perl-DBD-MySQL \
    perl-DBI \
    perl-Digest-SHA1 \
    perl-IO-String \
    perl-JSON \
    perl-MailTools \
    perl-Net-Jabber \
    perl-Net-Netmask \
    perl-Net-SSH-Expect \
    perl-RPC-XML \
    perl-Text-CSV_XS \
    perl-Time-HiRes \
    perl-XML-Simple \
    perl-YAML \
    python-setuptools \
    xmlsec1-openssl \
	&& yum clean all \
	&& rm -rf /var/cache/yum \
    && easy_install supervisor

WORKDIR /usr/local/bin
RUN ["curl", "-L", "https://cpanmin.us", "-o", "cpanm"]
RUN ["chmod", "+x", "cpanm"]

RUN ["cpanm", "CPAN", "--notest", "--skip-installed"]
RUN ["cpanm", "DBI", "--notest", "--skip-installed"]
RUN ["cpanm", "Digest::SHA1", "--notest", "--skip-installed"]
RUN ["cpanm", "Frontier::Client", "--notest", "--skip-installed"]
RUN ["cpanm", "LWP::Protocol::https", "--notest", "--skip-installed"]
RUN ["cpanm", "Mail::Mailer", "--notest", "--skip-installed"]
RUN ["cpanm", "Mo::builder", "--notest", "--skip-installed"]
RUN ["cpanm", "Net::Netmask", "--notest", "--skip-installed"]
RUN ["cpanm", "Net::SSH::Expect", "--notest", "--skip-installed"]
RUN ["cpanm", "Object::InsideOut", "--notest", "--skip-installed"]
RUN ["cpanm", "RPC::XML", "--notest", "--skip-installed"]
RUN ["cpanm", "Scalar::Util", "--notest", "--skip-installed"]
RUN ["cpanm", "Term::ANSIColor", "--notest", "--skip-installed"]
RUN ["cpanm", "Time::HiRes", "--notest", "--skip-installed"]
RUN ["cpanm", "URI", "--notest", "--skip-installed"]
RUN ["cpanm", "YAML", "--notest", "--skip-installed"]

RUN ["mkdir", "/etc/vcl/"]
COPY managementnode /usr/local/vcl
RUN ["cp", "/usr/local/vcl/etc/vcl/vcld.conf", "/etc/vcl/"]
RUN ["echo", "UserKnownHostsFile /dev/null", ">>", "/etc/ssh/ssh_config"]
RUN ["echo", "StrictHostKeyChecking no", ">>", "/etc/ssh/ssh_config"]
RUN ["perl", "/usr/local/vcl/lib/VCL/utils.pm"]

VOLUME [ "/var/log/vcl" ]
COPY docker-entrypoint.sh /entrypoint.sh
WORKDIR /
RUN ["chmod", "+x", "entrypoint.sh"]
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/supervisor.d/vcld.conf /etc/supervisor.d/vcld.conf
WORKDIR /usr/local/vcl
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]