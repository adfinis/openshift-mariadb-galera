# MariaDB Galera cluster on OpenShift

## Requirements
- OpenShift Origin 1.3 or Enterprise 3.3

## Creating new cluster

- Create PV's as cluster admin:
```
oc create -f galera-pv-nfs.yml -n yourproject
```
- Then create the service and petset itself:
```
oc create -f galera.yml
```

## Cleaning up

```
oc delete petset mysql
oc delete svc galera
oc delete pod mysql-0 mysql-1 mysql-2
oc delete pv datadir-mysql-0 datadir-mysql-1 datadir-mysql-2
```
