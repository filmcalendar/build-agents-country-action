FROM node:16-alpine

ARG GIT_PASSWORD

RUN set -x && \
    apk add --no-cache git bash jq curl

WORKDIR /app

# install agents
COPY package.json .npmrc /app/
RUN yarn --production --frozen-lockfile --no-audit
COPY .bin/fc-agent.js* /app/

# install entrypoint
RUN yarn add -D tweetsodium
COPY entrypoint.sh github-encrypt.js /app/
RUN chmod +x /app/entrypoint.sh && \
    chmod +x /app/github-encrypt.js && \
    mkdir -p /app/data

ENV PATH="/app:${PATH}"

ENTRYPOINT [ "entrypoint.sh" ]
