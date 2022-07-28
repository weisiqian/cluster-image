#!/bin/bash
prefix=$registry/$repo
buildDir=.build-image
mkdir -p $buildDir
cp -rf applications/$app/$version/* $buildDir/
# shellcheck disable=SC2164
cd $buildDir
filename=Kubefile
if  [ -f Dockerfile ]; then
  filename=Dockerfile
fi
[ -f init.sh  ] && sh init.sh $arch
sudo sealos build -t $prefix/$app:$version-$arch --platform linux/$arch -f $filename  .
if [ $? != 0 ]; then
   echo "====build app image failed!===="
   exit 1
fi

sudo sealos login $registry -u $username -p $password
sudo sealos push $prefix/$app:$version-$arch
if [ $? != 0 ]; then
   echo "====push app image failed!===="
   exit 1
fi
