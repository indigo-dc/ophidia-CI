Name:         ophidia-server 
Version:      **VERSION**
Release:      **RELEASE**%{?dist}
Summary:      Ophidia Server
 
Group:        Ophidia
License:      GPLv3
BuildRoot:    %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
Prefix:       /usr/local
Requires:     mysql-community-libs >= 5.6.22, libxml2 >= 2.7.6, libcurl >= 7.19.7, openssl >= 1.0.1e, libssh2 >= 1.4.2, epel-release >= 6, jansson >= 2.6
AutoReqProv:  no
 
%description
Ophidia server, a service responsible for managing client requests and workflows of Ophidia operators.

%files
%defattr(-,root,root,-)
/usr/local/ophidia/oph-server
/var/www/html/ophidia/env.php
/var/www/html/ophidia/header.php
/var/www/html/ophidia/index.php
/var/www/html/ophidia/sessions.php
/var/www/html/ophidia/tailer.php
/var/www/html/ophidia/style.css
/usr/local/ophidia/share/oph-server
%dir /var/www/html/ophidia/sessions
%dir /usr/local/ophidia/oph-server/log
%dir /usr/local/ophidia/oph-server/txt

%post
ln -sf /usr/local/ophidia/oph-server/bin/oph_server /usr/sbin/oph_server

%postun
if [ "$1" = "0" ]; then
	rm -f /usr/sbin/oph_server
fi 
