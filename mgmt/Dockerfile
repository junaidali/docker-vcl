FROM centos:7
LABEL maintainer="Junaid Ali <alisyed8@iit.edu>"

# install system dependencies for vcld
RUN yum update -y && yum install -y \
    bzip2 \
    e2fsprogs \
    e2fsprogs-devel \
    expat-devel \
    gcc \
    httpd-devel \
    krb5-devel \
    krb5-libs \
    libssl-dev \
    libuuid-devel \
    libxml2-devel \
    make \
    nmap \
    openssh-clients \
    openssl-devel \
    perl \
    perl-App-cpanminus \
    perl-Archive-Tar \
    perl-core \
    perl-CPAN \
    perl-Crypt-CBC \
    perl-Crypt-SSLeay \
    perl-Crypt-OpenSSL-RSA \
    perl-Data-Dumper \
    perl-DBD-MySQL \
    perl-DBI \
    perl-Digest-SHA1 \
    perl-IO-String \
    perl-JSON \
    perl-libwww-perl \
    perl-MailTools \
    perl-Net-Jabber \
    perl-Net-Netmask \
    perl-RPC-XML \
    perl-Text-CSV_XS \
    perl-Time-HiRes \
    perl-XML-LibXML \
    perl-XML-Simple \
    perl-YAML \
    postfix \
    python-setuptools \
    wget \
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
RUN ["cpanm", "CPAN", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Crypt::CBC", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Crypt::Rijndael", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "DBI", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Digest::SHA1", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Frontier::Client", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "LWP::Protocol::https", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Mail::Mailer", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Mo::builder", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Net::Netmask", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Net::SSH::Expect", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Object::InsideOut", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "RPC::XML", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Scalar::Util", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Shell", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Term::ANSIColor", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Text::CSV_XS", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "Time::HiRes", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "URI", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm", "YAML", "--notest", "--skip-installed", "--no-man-pages"]

# vmware vsphere perl sdk setup
RUN ["cpanm" , "Archive::Zip", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Class::Data::Inheritable", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Class::MethodMaker", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Compress::Raw::Zlib", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Compress::Zlib", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Convert::ASN1", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Crypt::OpenSSL::RSA", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Crypt::SSLeay", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Crypt::X509", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Data::Dump", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Data::Dumper", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Devel::StackTrace", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Exception::Class", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Fatal", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "HTML::Parser", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "IO::Compress::Base", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "IO::Socket::INET6", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "JSON::PP", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "LWP::Protocol::https", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "MIME::Base64", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Net::INET6Glue", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "SOAP::Lite", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "Socket6", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "URI", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "UUID", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "UUID::Random", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "version", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "XML::LibXML", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "XML::LibXML::Common", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "XML::NamespaceSupport", "--notest", "--skip-installed", "--no-man-pages"]
RUN ["cpanm" , "XML::SAX", "--notest", "--skip-installed", "--no-man-pages"]

ADD vsphere-perl-sdk/VMware-vSphere-Perl-SDK-6.5.0-4566394.x86_64.tar.gz /tmp/
WORKDIR /tmp/vmware-vsphere-cli-distrib/
RUN ["perl", "Makefile.PL"]
RUN ["make"]
RUN ["make", "install"]

# setup ssh client configuration
RUN ["echo", "UserKnownHostsFile /dev/null", ">>", "/etc/ssh/ssh_config"]
RUN ["echo", "StrictHostKeyChecking no", ">>", "/etc/ssh/ssh_config"]

# setup vcld configuration file and verify dependencies
RUN ["mkdir", "/etc/vcl/"]
COPY managementnode /usr/local/vcl
RUN ["cp", "/usr/local/vcl/etc/vcl/vcld.conf", "/etc/vcl/"]
RUN ["perl", "/usr/local/vcl/lib/VCL/utils.pm"]

# setup vcld startup scripts
COPY docker-entrypoint.sh /entrypoint.sh
COPY configure-vcl-db.pl /configure-vcl-db.pl
WORKDIR /
RUN ["chmod", "+x", "entrypoint.sh"]
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/supervisor.d/vcld.conf /etc/supervisor.d/vcld.conf
COPY wait-for-it.sh /wait-for-it.sh
RUN ["chmod", "+x", "wait-for-it.sh"]

# setup postfix
COPY postfix-wrapper.sh /postfix-wrapper.sh
RUN ["chmod", "+x", "postfix-wrapper.sh"]
COPY etc/supervisor.d/postfix.conf /etc/supervisor.d/postfix.conf

# enable mounting of vcl logs directory
VOLUME [ "/var/log/vcl" ]

WORKDIR /usr/local/vcl
ENTRYPOINT ["/wait-for-it.sh", "vcl-mysql:3306", "--", "/entrypoint.sh"]
CMD ["/wait-for-it.sh", "vcl-mysql:3306", "--", "/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]