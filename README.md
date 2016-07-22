# Ophidia CI

### Description

The Ophidia Continuous Integration comprises the scripts used to test, build and create the Ophidia packages.

### Requirements

In order to run the scripts you need the complete environment configured. Please see [http://ophidia.cmcc.it/documentation/admin/install/preliminarysteps.html](http://ophidia.cmcc.it/documentation/admin/install/preliminarysteps.html). Additionally you need the git command line an the following command line tools: 

* Codestyle:
  * indent 
* Functional:
  * openssl 
* Packaging: 
  * dpkg-deb, in the case of Debian/Ubuntu distributions
  * rpmbuild*, in the case of CentOS distros
* Unittest:
  * gcov
  * lcov
  * gcovr

Before running the scripts execute the following commands:

```
$ mkdir /usr/local/ophidia
$ chown ophidia:ophidia /usr/local/ophidia
$ mkdir /var/www/html/ophidia
$ chown ophidia:ophidia /var/www/html/ophidia
```

### How to run

To build the packages, run the following command inside the *packaging* sub-folder specifying the branch or tag of the repos (master, devel, etc.) and the Linux distribution (centos6, centos7 or ubuntu14):

```
$ ./main.sh master centos7
```

Packages will be placed in */usr/local/ophidia/pkg*.
