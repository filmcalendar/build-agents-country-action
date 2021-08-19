#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

rm -rf .bin
rm -f package.json
rm -f .npmrc

agent_dir="../agents-${FC_COUNTRY}"

cp -r "$agent_dir/.bin" .
cp "$agent_dir/package.json" "$agent_dir/.npmrc" .
cp docker/entrypoint.sh .
cp src/github-encrypt.js .

docker build \
  --build-arg GIT_PASSWORD \
  --tag "local/filmcalendar/fc-agents-${FC_COUNTRY}:latest" \
    .

rm -rf .bin
rm package.json
rm .npmrc
rm entrypoint.sh
rm github-encrypt.js
