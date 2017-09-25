#!/usr/bin/env bash
#we need to know our own path (for later)
MY_PATH="`dirname \"$0\"`"
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"

#cmdfs cache size in MB
CACHE=10000
#cmdfs cache dir
CACHE_DIR="/c"
mkdir -p $CACHE_DIR
chmod a+w $CACHE_DIR

set -x

# SIGTERM-handler to umount on container exit
term_handler() {
  echo "umount cmdfs mount"
  umount -f /hostTarget/photos_landscape
  umount -f /hostTarget/photos_all
  exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; term_handler' SIGINT
trap 'kill ${!}; term_handler' SIGTERM
trap 'kill ${!}; term_handler' SIGQUIT

mkdir -p /hostTarget/photos_all /hostTarget/photos_landscape
echo "mount cmdfs"
#cmdfs /hostSource /hostTarget -s -o extension="JPG;PNG",hide-empty-dirs
#cmdfs /hostSource /hostTarget -s -o "command=convert - -resize 1920x1080 -,extension=jpg;gif;png,cache-dir=$CACHE_DIR"
#cmdfs /hostSource /hostTarget -s -o "allow_other,command=convert - -resize 1920x1080 -,mime-re=image/*,cache-dir=$CACHE_DIR,monitor,cache-size=500"

#-s important, single threaded. If not used, cmdfs crashes after a while
cmdfs /hostSource /hostTarget/photos_all -s -o "extension=jpg;jpeg;gif;png,monitor,command=$MY_PATH/img_filter.sh,cache-dir=$CACHE_DIR,cache-size=$CACHE,allow_other"
cmdfs /hostTarget/photos_all /hostTarget/photos_landscape -s \
  -o "cache-dir=/tmp,cache-entries=2,exclude-re=.*[#][L][5-9].*,extension=jpg;jpeg;gif;png,hide-empty-dirs,command=$MY_PATH/img_filter_land.sh,allow_other"

# wait forever (to keep container running)
while true
do
  tail -f /dev/null & wait ${!}
done
