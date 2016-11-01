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

if [ $# -lt 2 ]
then
        echo "The following arguments are required: buildtype (master, devel, etc.), distro (centos6, centos7, ubuntu14)"
		echo "The following arguments are optional: package (terminal, primitives, server or analytics-framework)"
        exit 1
fi

buildtype=$1
distro=$2
package=$3
pkg_path=$PWD

#Prepare environment
mkdir -p ${pkg_path}/sources/${buildtype}
mkdir -p /usr/local/ophidia/share
mkdir -p /usr/local/ophidia/pkg

case "${distro}" in
        centos6)
			dist='el6'
			spec_path="${pkg_path}/CentOS6"
            ;;         
        centos7)
			dist='el7.centos'
			spec_path="${pkg_path}/CentOS7"
            ;;         
        ubuntu14)
			dist='debian'
			spec_path="${pkg_path}/Ubuntu14"
            ;;         
        *)
            echo "Distro can be centos6, centos7 or ubunutu14"
            exit 1
esac

if [ ${dist} = 'el6' ] || [ ${dist} = 'el7.centos' ]
then
	# For centos linux setup rpmbuild paths
	mkdir -p ${pkg_path}/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}	

	function run_packaging_script_centos {

		if [ $# -ne 1 ]
		then
				echo "Packaging script missing"
				exit 1
		fi

		${pkg_path}/scripts/${1} ${buildtype} ${dist} ${pkg_path} ${spec_path}; if [[ $? != 0 ]]; then exit $?; fi
	}

	#Build RPMS
	if [ "${package}" == "terminal" ] || [ $# -eq 2 ]; then
		run_packaging_script_centos "ophidia-terminal-rpm.sh"
	fi
	if [ "${package}" == "analytics-framework" ] || [ $# -eq 2 ]; then
		run_packaging_script_centos "ophidia-analytics-framework-rpm.sh"
	fi
	if [ "${package}" == "primitives" ] || [ $# -eq 2 ]; then
		run_packaging_script_centos "ophidia-primitives-rpm.sh"
	fi
	if [ "${package}" == "server" ] || [ $# -eq 2 ]; then
		run_packaging_script_centos "ophidia-server-rpm.sh"
	fi

	#Move new RPMS
	mv ${pkg_path}/rpmbuild/RPMS/x86_64/*.rpm /usr/local/ophidia/pkg
	rm -rf ${pkg_path}/rpmbuild

else 

	if [ ${dist} = 'debian' ]
	then
		mkdir -p ${pkg_path}/debbuild	

		function run_packaging_script_debian {

			if [ $# -ne 1 ]
			then
					echo "Packaging script missing"
					exit 1
			fi

			${pkg_path}/scripts/${1} ${buildtype} ${pkg_path} ${spec_path}; if [[ $? != 0 ]]; then exit $?; fi
		}

		#Build DEBS
		if [ "${package}" == "terminal" ] || [ $# -eq 2 ]; then
			run_packaging_script_debian "ophidia-terminal-deb.sh"
		fi
		if [ "${package}" == "analytics-framework" ] || [ $# -eq 2 ]; then
			run_packaging_script_debian "ophidia-analytics-framework-deb.sh"
		fi
		if [ "${package}" == "primitives" ] || [ $# -eq 2 ]; then
			run_packaging_script_debian "ophidia-primitives-deb.sh"
		fi
		if [ "${package}" == "server" ] || [ $# -eq 2 ]; then
			run_packaging_script_debian "ophidia-server-deb.sh"
		fi

		#Move new DEBS
		mv ${pkg_path}/debbuild/*.deb /usr/local/ophidia/pkg
		rm -rf ${pkg_path}/debbuild
	fi
fi

rm -rf ${pkg_path}/sources
rm -rf /usr/local/ophidia/share

