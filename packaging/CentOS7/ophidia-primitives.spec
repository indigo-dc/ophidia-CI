Name:         ophidia-primitives
Version:      **VERSION**
Release:      **RELEASE**%{?dist}
Summary:      Ophidia Primitives

Group:        Ophidia
License:      GPLv3
BuildRoot:    %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
Prefix:       /usr/local
Requires:     zlib, gsl >= 1.13, libmatheval >= 1.1.11

%description
Ophidia libraries implementing array-based primitives to be plugged into IO servers. 

%files
%defattr(-,root,root,-)
/usr/local/ophidia/oph-cluster/oph-primitives
/usr/local/ophidia/share/oph-primitives
