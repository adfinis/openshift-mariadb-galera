# Technical details

## build
- When building the image, the script `/usr/libexec/container-setup.sh` gets called
- This script creates data & config dirs, and set their permissions


## run
- When running the image, the script `/usr/bin/container-entrypoint.sh` acts as container entrypoint
- The entrypoint first checks if its in an OpenShift/Kubernetes enviroment by checking the ENV-varible `POD_NAMESPACE`
  - if `POD_NAMESPACE` is set, the entrypoint runs the command `/usr/bin/peer-finder` which looks up other nodes. `peer-finder` then calls the script `/usr/share/container-scripts/mysql/configure-galera.sh` which creates an galera-config at `/etc/my.cnf.d/galera.cnf`
- Then the entrypoint checks if the directory `/var/lib/mysql/mysql` exists. If not it assumes that mysql needs to be set up, so it calls the script `/usr/share/container-scripts/mysql/configure-mysql.sh`
  - This script creates an fist time mysql config which sets up users, tables and so on
- After that, the entrypoint calls mysqld with correct flags to run mysqld


## readinessProbe
- ther readinessProbe lives in `/usr/share/container-scripts/mysql/readiness-probe.sh` if the script exits 0, the container is ready, other error codes are inerpreted as notReady


## peer-finder
- `peer-finder` is a go binary which find all pods from a service. The source can be found here:
https://github.com/kubernetes/contrib/blob/master/pets/peer-finder/
- it can be compiled like this:
```
go get -v
CGO_ENABLED=0 go build -a -installsuffix cgo --ldflags '-w' ./peer-finder.go
```
