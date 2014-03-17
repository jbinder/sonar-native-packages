#!/bin/sh

# Requires:
#   app-arch/createrepo

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
 
echo "Building RPM package"
rm -v rpm/SOURCES/*.zip || true
cp -v distfiles/${sonarName}-${VER}.zip rpm/SOURCES/
rpm/build.sh ${VER}

echo "Building RPM repository"
cp -v rpm/RPMS/noarch/* repo/rpm/noarch/
cd repo
createrepo rpm -s sha
cd ../
