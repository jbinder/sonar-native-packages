#!/bin/sh

# Requires:
#   app-arch/dpkg

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VER=$1
sonarName="sonar"
isMainVersionHigherThan3=$(str=$(printf "%s >= %s" $(echo ${VER} | cut -f1 -d".") 4); echo $str | bc)
if [ ${isMainVersionHigherThan3} -eq 1 ]; then
  sonarName="sonarqube"
fi
 
echo "Building DEB package"
rm -v deb/*.zip || true
cp distfiles/${sonarName}-${VER}.zip deb/
cd deb/
./build.sh ${VER}
cd ..

echo "Building DEB repository"
cp -v deb/sonar.deb repo/deb/binary/${sonarName}_${VER}_all.deb
cd repo/deb/
dpkg-scanpackages binary /dev/null | gzip -9c > binary/Packages.gz
cd ../../
