# Cmdfs in docker

This is a docker implementation of [cmdfs fuse file system](https://github.com/mikeswain/cmdfs).

Usage examples:
- present a filtered subset of you photo collections to your electronic photo frame
- present only landscape oriented photos out of your full collection to the photo frame
- run automatic rsync backups of downscaled versions of your fullsize photos
- many more

### How to use

Download and extract all these files to a folder on your host.
Before we can use cmdfs we need to compile it from source. We will do this in a termporary gcc container to keep the host clean:

```sh
$ sudo su
# cd /pathToWhereYouExtracted
# ./build.sh
```

This should download, init and run the build process. If all went fine, you will have a cmdfs-latest.deb file in the work folder.

That's it, ready to go:
### Docker
```sh
# docker build -t cmdfs-image .
# docker run -d -v /HOSTFOTODIR:/hostSource:ro -v /HOSTFILTEREDFOTOSDIR:/hostTarget:shared --privileged cmdfs-image
```

### Or docker-compose
```sh
# docker-compose build
# docker-compose up -d
```
### Customization
If not specified, the container will use config in config-example. You may want to use your own filter settings. Just copy folder config-example to /HOSTPATHOFCMDFSFILES/config and add 
```sh
-v /HOSTPATHOFCMDFSFILES/config:/etc/cmdfs/
```
in docker run command or uncomment the correspondending line in docker-compose.yml if you use compose

For debugging:

```sh
# docker ps
```
To see if container is STATUS UP

```sh
# docker logs CONTAINERNAME
```
For more info about startup
