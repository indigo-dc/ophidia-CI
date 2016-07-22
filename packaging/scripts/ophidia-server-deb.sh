#!/bin/bash

#
#    Ophidia CI
#    Copyright (C) 2012-2016 CMCC Foundation
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

if [ $# -ne 3 ]
then
        echo "The following arguments are required: buildtype, path of package generator, path of control file"
        exit 1
fi

pkg_path=$2
control_path=$3

pkg_name="ophidia-server"
repo_name="ophidia-server"

source ${pkg_path}/scripts/functions.sh

build $1 ${pkg_path} ${repo_name} "--prefix=/usr/local/ophidia/oph-server --with-framework-path=/usr/local/ophidia/oph-cluster/oph-analytics-framework --with-soapcpp2-path=/usr/local/ophidia/extra --enable-webaccess --with-web-server-path=/var/www/html/ophidia --with-web-server-url=http://127.0.0.1/ophidia --with-matheval-path=/usr/local/ophidia/extra" 

mkdir -p /usr/local/ophidia/share/oph-server
cp -f LICENSE NOTICE.md /usr/local/ophidia/share/oph-server
mkdir -p /usr/local/ophidia/oph-server/log
mkdir -p /usr/local/ophidia/oph-server/txt
mkdir -p /var/www/html/ophidia/sessions
cp -r authz /usr/local/ophidia/oph-server/
mkdir -p /usr/local/ophidia/oph-server/authz/sessions
mkdir -p /usr/local/ophidia/oph-server/etc/cert

#Remove unnecessary include dir
rm -rf /usr/local/ophidia/oph-server/include

#Copy configuration files
cp -r ${pkg_path}/common/oph-server/etc/* /usr/local/ophidia/oph-server/etc/

mkdir -p ${pkg_path}/${pkg_name}_${version}-${release}_amd64/DEBIAN

copy_control ${pkg_path} ${pkg_name} ${version} ${release} ${control_path}

cp -r --parents /usr/local/ophidia/oph-server ${pkg_path}/${pkg_name}_${version}-${release}_amd64
cp -r --parents /usr/local/ophidia/share/oph-server ${pkg_path}/${pkg_name}_${version}-${release}_amd64
cp -r --parents /var/www/html/ophidia/*.php ${pkg_path}/${pkg_name}_${version}-${release}_amd64
cp -r --parents /var/www/html/ophidia/*.css ${pkg_path}/${pkg_name}_${version}-${release}_amd64
cp -r --parents /var/www/html/ophidia/sessions ${pkg_path}/${pkg_name}_${version}-${release}_amd64

mkdir -p ${pkg_path}/${pkg_name}_${version}-${release}_amd64/usr/sbin
ln -sf /usr/local/ophidia/oph-server/bin/oph_server ${pkg_path}/${pkg_name}_${version}-${release}_amd64/usr/sbin/oph_server

dpkg-deb --build ${pkg_path}/${pkg_name}_${version}-${release}_amd64 ${pkg_path}/debbuild/${pkg_name}_${version}-${release}_amd64.deb 

rm -rf ${pkg_path}/sources/$1/${repo_name}
rm -rf /usr/local/ophidia/oph-server
rm -rf /usr/local/ophidia/share/oph-server
rm -rf /var/www/html/ophidia/{*.php,*.css,sessions}
rm -rf ${pkg_path}/${pkg_name}_${version}-${release}_amd64

