Name:         ophidia-analytics-framework
Version:      **VERSION**
Release:      **RELEASE**%{?dist}
Summary:      Ophidia Analytics Framework
 
Group:        Ophidia
License:      GPLv3
BuildRoot:    %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
Prefix:       /usr/local
Requires:     mpich, mpich-autoload, mysql-community-libs >= 5.6.22, libxml2 >= 2.7.6, openssl >= 1.0.1e, epel-release >= 6, jansson >= 2.6
AutoReqProv:  no

%description
Ophidia framework module with all analytics operators. Parallel NetCDF support enabled.

%files
%defattr(-,root,root,-)
/usr/local/ophidia/oph-cluster/oph-analytics-framework
/var/www/html/ophidia/operators_xml
/var/www/html/ophidia/img
/usr/local/ophidia/share/oph-analytics-framework
%dir /usr/local/ophidia/oph-cluster/oph-analytics-framework/log
