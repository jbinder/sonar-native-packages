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
  sonarFile=sonar-${VER}.zip
  if [ ! -e "${sonarFile}" ]; then
    rm -v sonar-*.zip || true
    wget  http://dist.sonar.codehaus.org/sonar-${VER}.zip
  fi
  popd
}


VER=$1
fetch_sources

./build-deb.sh $1
./build-rpm.sh $1
