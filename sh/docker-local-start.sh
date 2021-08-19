#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

docker run -i \
  --env FC_COUNTRY="${FC_COUNTRY}" \
  --env GIT_PASSWORD="${GIT_PASSWORD}" \
  --env GIT_USER_EMAIL="${GIT_USER_EMAIL}" \
  --env GIT_USER="${GIT_USER}" \
  --env WEBSHARE_API_KEY="${WEBSHARE_API_KEY}" \
  --name "agents-${FC_COUNTRY}" \
  --rm \
    "local/filmcalendar/fc-agents-${FC_COUNTRY}:latest"
