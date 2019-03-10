# Minimalistic Dockerized Bitcoin Core instance
This docker image is based on Alpine Linux and has only 40 MB.

You need to specify where to store bitcoin block data and who owns it.
For that purpose you may want to edit Volume section and specify
`host_uid` and `host_gid`. Those values by default should belong to the current user and can be displayed using command `id -u` and `id -g`
Build process can take a while and happens only for the first time unless specified explicitly.

## Usage

### Set up docker on Linux
Install docker and run the docker service.
You may add current user to the docker group:
```
$ sudo gpasswd -a <user> docker
```
then relogin and enable and start docker
```
$ sudo systemctl enable docker
$ sudo systemctl start docker
```
### Run bitcoin core sevice
```
$ docker-compose up
```
Optionally run in the background by specifying option `-d`.
If you want to rebuild the image explicitly add `--build`.

## Security considerations
RPC credentials are hardcoded into Dockerfile and RPC interface is closed and accessible only from inside docker container.
You can change it if you wish, open it to external IP in ENTRYPOINT specification in Dockerfile (see bitcoind --help). RPC ports can be then mapped to the host machine in docker-compose.yml file. Make sure not to map RPC port (by default 8332) outside local machine unless you know what you are doing. This means prepend use `"127.0.0.1:<rpcport>:<rpcport>` in Dockerfile.
