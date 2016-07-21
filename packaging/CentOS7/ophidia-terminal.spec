Name:         ophidia-terminal  
Version:      **VERSION**
Release:      **RELEASE**%{?dist}
Summary:      Ophidia Terminal
 
Group:        Ophidia
License:      GPLv3
BuildRoot:    %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
Prefix:       /usr/local
Requires:     epel-release >= 7, jansson >= 2.4, graphviz >= 2.26.0, gtk2 >= 2.24.23, libxml2 >= 2.9, libcurl >= 7.29, openssl >= 1.0.1e, readline >= 6.0
 
%description
Ophidia terminal, an advanced CLI to send requests and workflows to the Ophidia server.
 
%files
%defattr(-,root,root,-)
/usr/local/ophidia/oph-terminal/bin/oph_term
/usr/local/ophidia/share/oph-terminal
 
%post
ln -sf /usr/local/ophidia/oph-terminal/bin/oph_term /usr/bin/oph_term
 
%postun
if [ "$1" = "0" ]; then
       rm -f /usr/bin/oph_term
fi
