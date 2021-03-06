#!/bin/bash

#
#    Ophidia CI
#    Copyright (C) 2012-2017 CMCC Foundation
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

pkg_name="ophidia-analytics-framework"
repo_name="ophidia-analytics-framework"

source ${pkg_path}/scripts/functions.sh

build $1 ${pkg_path} ${repo_name} "--prefix=/usr/local/ophidia/oph-cluster/oph-analytics-framework --with-web-server-path=/var/www/html/ophidia --with-web-server-url=http://127.0.0.1/ophidia --enable-parallel-netcdf --with-netcdf-path=/usr/local/ophidia/extra --enable-cfitsio"

mkdir -p /usr/local/ophidia/share/oph-analytics-framework
cp -f LICENSE NOTICE.md /usr/local/ophidia/share/oph-analytics-framework
mkdir -p /usr/local/ophidia/oph-cluster/oph-analytics-framework/log

#Remove unnecessary dirs
rm -rf /usr/local/ophidia/oph-cluster/oph-analytics-framework/include

mkdir -p ${pkg_path}/${pkg_name}_${version}-${release}_amd64/DEBIAN

copy_control ${pkg_path} ${pkg_name} ${version} ${release} ${control_path}

cp -r --parents /usr/local/ophidia/oph-cluster/oph-analytics-framework ${pkg_path}/${pkg_name}_${version}-${release}_amd64
cp -r --parents /usr/local/ophidia/share/oph-analytics-framework ${pkg_path}/${pkg_name}_${version}-${release}_amd64
cp -r --parents /var/www/html/ophidia/operators_xml ${pkg_path}/${pkg_name}_${version}-${release}_amd64
cp -r --parents /var/www/html/ophidia/img ${pkg_path}/${pkg_name}_${version}-${release}_amd64
dpkg-deb --build ${pkg_path}/${pkg_name}_${version}-${release}_amd64 ${pkg_path}/debbuild/${pkg_name}_${version}-${release}_amd64.deb

rm -rf ${pkg_path}/sources/$1/${repo_name}
rm -rf /usr/local/ophidia/oph-cluster/oph-analytics-framework
rm -rf /usr/local/ophidia/share/oph-analytics-framework
rm -rf /var/www/html/ophidia/{operators_xml,img}
rm -rf ${pkg_path}/${pkg_name}_${version}-${release}_amd64

