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

if [ $# -ne 2 ]
then
        echo "The following arguments are required: buildtype (master, devel, etc.), distro (centos6, centos7, ubuntu14)"
        exit 1
fi

buildtype=$1
distro=$2
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
	run_packaging_script_centos "ophidia-terminal-rpm.sh"
	run_packaging_script_centos "ophidia-analytics-framework-rpm.sh"
	run_packaging_script_centos "ophidia-primitives-rpm.sh"
	run_packaging_script_centos "ophidia-server-rpm.sh"

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
		run_packaging_script_debian "ophidia-terminal-deb.sh"
		run_packaging_script_debian "ophidia-analytics-framework-deb.sh"
		run_packaging_script_debian "ophidia-primitives-deb.sh"
		run_packaging_script_debian "ophidia-server-deb.sh"

		#Move new DEBS
		mv ${pkg_path}/debbuild/*.deb /usr/local/ophidia/pkg
		rm -rf ${pkg_path}/debbuild
	fi
fi

rm -rf ${pkg_path}/sources
rm -rf /usr/local/ophidia/share

