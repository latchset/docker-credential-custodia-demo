# Demo container for docker-credential-custodia

## Build and run the container

Requires a local Docker daemon and golang.

```
$ sudo dnf install docker golang
$ make dockerrun
...
sudo docker run \
    --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/bin/docker:/bin/docker \
    --name dcc_demo_container \
    dcc_demo:latest
2016-09-19 15:08:53 - custodia                         - Custodia debug logger enabled
2016-09-19 15:08:53 - custodia                         - Custodia audit log: /var/log/custodia/audit.log
2016-09-19 15:08:53 - custodia                         - Config file <_io.TextIOWrapper name='/etc/custodia/custodia.conf' mode='r' encoding='ANSI_X3.4-1968'> loaded
2016-09-19 15:08:53 - server                           - Serving on Unix socket /var/run/custodia/custodia.sock
```

## Run docker-credential-custodia

```
$ make dockerexec
# echo '{"ServerURL": "http://localhost:5000", "Username": "user", "Secret": "password"}' | docker-credential-custodia store
# docker-credential-custodia list
{"http://localhost:5000":""}
# echo http://localhost:5000 | docker-credential-custodia get
{"ServerURL":"","Username":"user","Secret":"password"}
```
