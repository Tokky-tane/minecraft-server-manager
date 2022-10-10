#!/bin/sh

usage() {
  echo "Usage: $0 -v <version>"
}

while getopts 'v:' OPT; do
  case $OPT in
    v)
      VERSION="$OPTARG"
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

if [ -z "$VERSION" ]; then
  usage
  exit 1
fi

sudo apt-get -qqy update &&
  sudo apt-get -qqy install curl unzip

new_server_path="${HOME}/bedrock-server-${VERSION}"

curl -sL \
  -o "/tmp/bedrock-server-${VERSION}.zip" \
  "https://minecraft.azureedge.net/bin-linux/bedrock-server-${VERSION}.zip" &&
  unzip "/tmp/bedrock-server-${VERSION}.zip" -d "${new_server_path}"

cd minecraft-server &&
  cp -r \
    allowlist.json \
    permissions.json \
    server.properties \
    whitelist.json \
    worlds \
    "${new_server_path}" &&
  cd .. &&
  mv minecraft-server "minecraft-server-prev-${VERSION}" &&
  tar czf "minecraft-server-prev-${VERSION}.tar.gz" "minecraft-server-prev-${VERSION}" &&
  mv "${new_server_path}" minecraft-server
