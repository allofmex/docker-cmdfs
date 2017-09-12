# Cmdfs in docker
# WARNING: This instruction is not ready yet! We are waiting for some fixes in cmdfs project! (2017 Sep 12)
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
# cd /HOSTPATHOFCMDFSFILES
# ./build.sh
```

This should download, init and run the build process. If all went fine, you will have a cmdfs-latest.deb file in the work folder.

Prepare mount points where your filtered folder should appear:
```sh
# mkdir /HOSTFILTEREDFOTOSDIR
# chmod a+w /HOSTFILTEREDFOTOSDIR
```

Now we have cmdfs ready to be installed in a container:

### Docker
Build image and run container
```sh
# docker build -t cmdfs-image .

# docker run -d -v /HOSTFOTODIR:/hostSource:ro -v /HOSTFILTEREDFOTOSDIR:/hostTarget:shared --privileged cmdfs-image
```

### Or if you prefer docker-compose
```sh
# docker-compose build
# docker-compose up -d
```

In this case the container will use the example configuration in folder config-example. It's configured to:
- mount a folder photos_all in your HOSTFILTEREDFOTOSDIR, containing a downscaled version of all jpg,png,... files 
- a second folder photos_landscape which uses the first photos_all as input but presents only photos that have landscape aspect ratio (wider than high)

The mounts are getting exposed to host system. So you are able to use them in another container (see "Extra notes" below)

### Customization
If not specified, the container will use config in config-example. You may want to use your own filter settings. Just copy folder config-example to /HOSTPATHOFCMDFSFILES/config and add 
```sh
-v /HOSTPATHOFCMDFSFILES/config:/etc/cmdfs/
```
in docker run command or uncomment the correspondending line in docker-compose.yml if you use compose.
The container will call run.sh script at initialization. If you like to setup own mount, add or edit `cmdfs /hostSource /hostTarget/...` lines.
How to configure the `-o "..."` options see http://cmdfs.sourceforge.net/ or http://www.linux-magazine.com/Online/Features/Cmdfs

### Extra notes:
- We need `--privileged` setting to be able to mount within container
- This container is configured to expose the mounts back to host to use them again in other container or on host itself. To achieve this we have `:shared` at the volume mount. Without it would be visible only inside the container. 
- You need `allow_other` option in cmdfs (fuse) mount option. There may be better (more secure) options, but than you have to handle user/group settings if you want to access the mount from other container.
### Debugging:
To see if container is STATUS UP and to get container name:
```sh
# docker ps
```

For more info about startup:
```sh
# docker logs CONTAINERNAME
```

You can also add `/dev/log:/dev/log` to your container volume mounts to receive cmdfs syslog messages on host.
