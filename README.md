# :warning: This project is no longer being maintained :warning:

The code in this repository was created as a proof of concept back when
StatefulSets where still called PetSets and hasn't seen much love since. 

Feel free to use the bootstrap logic and image structure in your project, but
we're not going to implement any changes going forward.

If you find the code in this repository helpful, but want to use it under a
different license please get in contact with us.

# MariaDB Galera cluster on OpenShift


[![Travis](https://img.shields.io/travis/adfinis-sygroup/openshift-mariadb-galera.svg?style=flat-square)](https://travis-ci.org/adfinis-sygroup/openshift-mariadb-galera)
[![License](https://img.shields.io/github/license/adfinis-sygroup/openshift-mariadb-galera.svg?style=flat-square)](LICENSE)


## Requirements
- OpenShift Origin 1.3 or Enterprise 3.3 OR
- Kubernetes 1.3+


## General informations

### Environment variables and volumes

The image recognizes the following environment variables that you can set during
initialization by passing `-e VAR=VALUE` to the Docker run command.

|  Variable name         | Description                               |
| :--------------------- | ----------------------------------------- |
|  `MYSQL_USER`          | User name for MySQL account to be created |
|  `MYSQL_PASSWORD`      | Password for the user account             |
|  `MYSQL_DATABASE`      | Database name                             |
|  `MYSQL_ROOT_PASSWORD` | Password for the root user (optional)     |

You can also set the following mount points by passing the `-v /host:/container`
flag to Docker.

| Volume mount point       | Description          |
| :----------------------- | -------------------- |
|  `/var/lib/mysql`        | MySQL data directory |

**Notice: When mouting a directory from the host into the container,
ensure that the mounted directory has the appropriate permissions and
that the owner and group of the directory matches the user UID or name
which is running inside the container.**


## Usage in OpenShift

### Importing templates

Import the templates into OpenShift with the following commands:
```bash
$ oc create -f mariadb-galera-ephemeral-template.yml -n openshift
$ oc create -f mariadb-galera-persistent-template.yml -n openshift
```


### Creating a cluster with templates
- Navigate to the OpenShift web console
- Choose your project and click `add to Project`
- Choose one of the two mariadb-galera templates

If choosing the persistent template, make sure that the PV's are created in the
namespace of your project and match the `VOLUME_PV_NAME` and `VOLUME_CAPACITY`
parameters of the template.


### Manual cluster creation

- Create PV's as cluster admin:
```bash
$ oc create -f galera-pv-nfs.yml -n yourproject
```
- Then create the service and petset itself:
```bash
$ oc create -f galera.yml
```


### Manual cluster cleanup

```bash
$ oc delete petset mysql
$ oc delete svc galera
$ oc delete pod mysql-0 mysql-1 mysql-2
$ oc delete pv datadir-mysql-0 datadir-mysql-1 datadir-mysql-2
```


## Usage in Kubernetes

This image runs on kubernetes as well.

### Create cluster
```bash
$ kubectl create -f galera-pv-host.yml
$ kubectl create -f galera.yml
```

For Kubernetes v1.5 the API endpoints have changed you need to use the definition in `galera_k8s_v1.6.yml`.

```bash
$ kubectl create -f galera-pv-host.yml
$ kubectl create -f galera_k8s_v1.6.yml
```

### Cleanup cluster
```bash
$ kubectl delete petset mysql
$ kubectl delete svc galera
$ kubectl delete pod mysql-0 mysql-1 mysql-2
$ kubectl delete pv datadir-mysql-0 datadir-mysql-1 datadir-mysql-2
```


## Building
```bash
$ git clone https://github.com/adfinis-sygroup/openshift-mariadb-galera
$ cd k8s-mariadb-galera-centos
$ make
```
Technical informations how the image works in detail can be found
[here](k8s-mariadb-galera-centos/README.md)


## Contributions
Contributions are more than welcome! Please feel free to open new issues or
pull requests.


## License
GNU GENERAL PUBLIC LICENSE Version 3

See the [LICENSE](LICENSE) file.
