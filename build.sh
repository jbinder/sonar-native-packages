#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi


fetch_sources()
{
  mkdir -p distfiles
  pushd distfiles
  
  sonarName="sonar"
  isMainVersionHigherThan3=$(str=$(printf "%s >= %s" $(echo ${VER} | cut -f1 -d".") 4); echo $str | bc)
  if [ ${isMainVersionHigherThan3} -eq 1 ]; then
    sonarName="sonarqube"
  fi
  sonarFile=${sonarName}-${VER}.zip
  if [ ! -e "${sonarFile}" ]; then
    rm -v sonar-*.zip || true
    wget  http://dist.sonar.codehaus.org/${sonarFile}
  fi
  popd
}


VER=$1
PROVISIONING_SCRIPT=$2
fetch_sources

./build-deb.sh $1 ${PROVISIONING_SCRIPT}
./build-rpm.sh $1 ${PROVISIONING_SCRIPT}
