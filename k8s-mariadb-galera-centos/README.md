# Technical details

## build
- When building the image, the script `/usr/libexec/container-setup.sh` gets
  called
- This script creates data / config directories and sets their permissions
  accordingly

## run
- When running the image, the script `/usr/bin/container-entrypoint.sh` acts as
  a container entrypoint
- The entrypoint first checks if it's in an OpenShift / Kubernetes environment
  by inspecting the ENV variable `POD_NAMESPACE`
  - If `POD_NAMESPACE` is set, the entrypoint runs the command 
    `/usr/bin/peer-finder` which looks for other nodes. `peer-finder` then
    calls the script `/usr/share/container-scripts/mysql/configure-galera.sh`
    which creates a galera-config at `/etc/my.cnf.d/galera.cnf`
- Next, the entrypoint checks if the directory `/var/lib/mysql/mysql` exists. 
  If not, it assumes that mysql needs to be set up, thus it calls the script
  `/usr/share/container-scripts/mysql/configure-mysql.sh`
  - This script creates a fist time mysql config which sets up users, tables,
    etc. 
- After that, the entrypoint calls `mysqld` with correct flags to run mysqld


## readinessProbe
- The readinessProbe lives in
  `/usr/share/container-scripts/mysql/readiness-probe.sh`, if the script exits
  with 0, the container is ready, other error codes are interpreted as
  `notReady`


## peer-finder
- `peer-finder` is a go binary which finds all pods of a service. The source
   can be found here:
   https://github.com/kubernetes/contrib/tree/master/peer-finder
- It can be compiled like this:
```bash
$ go get -v
$ CGO_ENABLED=0 go build -a -installsuffix cgo --ldflags '-w' ./peer-finder.go
```
