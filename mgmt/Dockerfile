FROM centos:7
LABEL maintainer="Junaid Ali <alisyed8@iit.edu>"

# install system dependencies for vcld
RUN yum update -y && yum install -y \
    e2fsprogs \
    e2fsprogs-devel \
    expat-devel \
    gcc \
    httpd-devel \
    krb5-devel \
    krb5-libs \
    libxml2-devel \
    libuuid-devel \
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
    perl-XML-LibXML \
    perl-XML-Simple \
    perl-YAML \
    python-setuptools \
    which \
    xmlsec1-openssl \
	&& yum clean all \
	&& rm -rf /var/cache/yum \
    && easy_install supervisor

# install cpanm
WORKDIR /usr/local/bin
RUN ["curl", "-L", "https://cpanmin.us", "-o", "cpanm"]
RUN ["chmod", "+x", "cpanm"]

# install perl dependencies for vcld
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

# setup vcld configuration file
RUN ["mkdir", "/etc/vcl/"]
COPY managementnode /usr/local/vcl
RUN ["cp", "/usr/local/vcl/etc/vcl/vcld.conf", "/etc/vcl/"]

# setup ssh client configuration
RUN ["echo", "UserKnownHostsFile /dev/null", ">>", "/etc/ssh/ssh_config"]
RUN ["echo", "StrictHostKeyChecking no", ">>", "/etc/ssh/ssh_config"]
RUN ["perl", "/usr/local/vcl/lib/VCL/utils.pm"]

# vmware vsphere perl sdk setup
RUN ["cpanm", "Crypt::SSLeay", "--notest", "--skip-installed"]
RUN ["cpanm", "IO::Compress::Base", "--notest", "--skip-installed"]
RUN ["cpanm", "Compress::Zlib", "--notest", "--skip-installed"]
RUN ["cpanm", "Compress::Raw::Zlib", "--notest", "--skip-installed"]
RUN ["cpanm", "Archive::Zip", "--notest", "--skip-installed"]
RUN ["cpanm", "Data::Dumper", "--notest", "--skip-installed"]
RUN ["cpanm", "XML::LibXML", "--notest", "--skip-installed"]
RUN ["cpanm", "LWP::Protocol::https", "--notest", "--skip-installed"]
RUN ["cpanm", "XML::LibXML::Common", "--notest", "--skip-installed"]
RUN ["cpanm", "XML::NamespaceSupport", "--notest", "--skip-installed"]
RUN ["cpanm", "XML::SAX", "--notest", "--skip-installed"]
RUN ["cpanm", "Data::Dump", "--notest", "--skip-installed"]
RUN ["cpanm", "URI", "--notest", "--skip-installed"]
RUN ["cpanm", "UUID", "--notest", "--skip-installed"]
RUN ["cpanm", "SOAP::Lite", "--notest", "--skip-installed"]
RUN ["cpanm", "HTML::Parser", "--notest", "--skip-installed"]
RUN ["cpanm", "version", "--notest", "--skip-installed"]
RUN ["cpanm", "Fatal", "--notest", "--skip-installed"]
RUN ["cpanm", "Class::MethodMaker", "--notest", "--skip-installed"]
RUN ["cpanm", "JSON::PP", "--notest", "--skip-installed"]
RUN ["cpanm", "Devel::StackTrace", "--notest", "--skip-installed"]
RUN ["cpanm", "Class::Data::Inheritable", "--notest", "--skip-installed"]
RUN ["cpanm", "Convert::ASN1", "--notest", "--skip-installed"]
RUN ["cpanm", "Crypt::OpenSSL::RSA", "--notest", "--skip-installed"]
RUN ["cpanm", "Crypt::X509", "--notest", "--skip-installed"]
RUN ["cpanm", "Exception::Class", "--notest", "--skip-installed"]
RUN ["cpanm", "MIME::Base64", "--notest", "--skip-installed"]
RUN ["cpanm", "UUID::Random", "--notest", "--skip-installed"]
RUN ["cpanm", "Socket6", "--notest", "--skip-installed"]
RUN ["cpanm", "IO::Socket::INET6", "--notest", "--skip-installed"]
RUN ["cpanm", "Net::INET6Glue", "--notest", "--skip-installed"]

ADD vsphere-perl-sdk/VMware-vSphere-Perl-SDK-6.5.0-4566394.x86_64.tar.gz /tmp/
RUN ["/tmp/vmware-vsphere-cli-distrib/vmware-install.pl", "-d", "EULA_AGREED=yes"]

# enable mounting of vcl logs directory
VOLUME [ "/var/log/vcl" ]

# setup vcld startup scripts
COPY docker-entrypoint.sh /entrypoint.sh
COPY configure-vcl-db.pl /configure-vcl-db.pl
WORKDIR /
RUN ["chmod", "+x", "entrypoint.sh"]
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/supervisor.d/vcld.conf /etc/supervisor.d/vcld.conf
COPY wait-for-it.sh /wait-for-it.sh
RUN ["chmod", "+x", "wait-for-it.sh"]

WORKDIR /usr/local/vcl
ENTRYPOINT ["/wait-for-it.sh", "db:3306", "--", "/entrypoint.sh"]
CMD ["/wait-for-it.sh", "db:3306", "--", "/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]