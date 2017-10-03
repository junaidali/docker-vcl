FROM centos:7
LABEL maintainer="Junaid Ali <alisyed8@iit.edu>"
RUN yum update -y \
    && yum install -y openssh-clients perl expat-devel gcc krb5-devel krb5-libs libxml2-devel make nmap openssl-devel perl-Archive-Tar perl-CPAN perl-Crypt-CBC perl-Crypt-OpenSSL-RSA perl-Crypt-Rijndael perl-DBD-MySQL perl-DBI     perl-Digest-SHA1 perl-IO-String perl-JSON perl-MailTools perl-Net-Jabber perl-Net-Netmask perl-Net-SSH-Expect perl-RPC-XML perl-Text-CSV_XS perl-Time-HiRes perl-XML-Simple perl-YAML xmlsec1-openssl \
	&& yum clean all \
	&& rm -rf /var/cache/yum

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

COPY managementnode /usr/local/vcl
COPY vcld.conf /etc/vcl/
RUN ["echo", "UserKnownHostsFile /dev/null", ">>", "/etc/ssh/ssh_config"]
RUN ["echo", "StrictHostKeyChecking no", ">>", "/etc/ssh/ssh_config"]
RUN ["perl", "/usr/local/vcl/lib/VCL/utils.pm"]

WORKDIR /usr/local/vcl
VOLUME [ "/var/log/vcl" ]

CMD ["/usr/local/vcl/bin/vcld", "-v -conf=/etc/vcl/vcld.conf"]