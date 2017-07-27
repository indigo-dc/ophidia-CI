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

if [ $# -ne 4 ]
then
        echo "The following arguments are required: buildtype, distribution, path of rpm generator, path of specs"
        exit 1
fi

dist=$2
pkg_path=$3
spec_path=$4

pkg_name="ophidia-terminal"
repo_name="ophidia-terminal"

source ${pkg_path}/scripts/functions.sh

build $1 ${pkg_path} ${repo_name} "--prefix=/usr/local/ophidia/oph-terminal"

mkdir -p /usr/local/ophidia/share/oph-terminal
cp -f LICENSE NOTICE.md /usr/local/ophidia/share/oph-terminal

#Remove unnecessary dirs
rm -rf /usr/local/ophidia/oph-terminal/include

copy_spec ${pkg_path} ${pkg_name} ${version} ${release} ${dist} ${spec_path}

mkdir ${pkg_path}/rpmbuild/BUILDROOT/${pkg_name}-${version}-${release}.${dist}.x86_64
cp -r --parents /usr/local/ophidia/oph-terminal ${pkg_path}/rpmbuild/BUILDROOT/${pkg_name}-${version}-${release}.${dist}.x86_64
cp -r --parents /usr/local/ophidia/share/oph-terminal ${pkg_path}/rpmbuild/BUILDROOT/${pkg_name}-${version}-${release}.${dist}.x86_64
rpmbuild --define "_topdir ${pkg_path}/rpmbuild" -bb -vv ${pkg_path}/rpmbuild/SPECS/${pkg_name}-${version}-${release}.${dist}.x86_64.spec

rm -rf ${pkg_path}/sources/$1/${repo_name}
rm -rf /usr/local/ophidia/oph-terminal
rm -rf /usr/local/ophidia/share/oph-terminal

