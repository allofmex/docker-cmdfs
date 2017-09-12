#!/bin/bash
echo "Create build script that will be run in termporary gcc container"
BUILD_SCRIPT="run_build.sh"
echo "#!/bin/bash" > $BUILD_SCRIPT
echo "apt-get update" >> $BUILD_SCRIPT
echo "apt-get install -y libfuse-dev nano checkinstall" >> $BUILD_SCRIPT
echo "mkdir /working" >> $BUILD_SCRIPT
echo "cd /working" >> $BUILD_SCRIPT
echo "git clone https://github.com/mikeswain/cmdfs.git" >> $BUILD_SCRIPT
echo "cd /working/cmdfs" >> $BUILD_SCRIPT
echo "./configure" >> $BUILD_SCRIPT
echo "make" >> $BUILD_SCRIPT
echo "checkinstall --fstrans=no --pakdir=/results/ --install=no \
-y -D make install" >> $BUILD_SCRIPT

chmod a+x run_build.sh
mkdir -p temp_result
rm temp_result/*
echo "Start gcc container to build cmdfs from source"
docker run --rm -it -v $PWD/temp_result:/results -v $PWD/run_build.sh:/run_build.sh gcc bash -c "./run_build.sh"
PACKAGEFILE=$(ls temp_result/)
mv temp_result/$PACKAGEFILE cmdfs-latest.deb
rmdir temp_result
rm $BUILD_SCRIPT
echo "Build finished, if there where no errors, you should have a cmdfs-latest.deb file now!"
