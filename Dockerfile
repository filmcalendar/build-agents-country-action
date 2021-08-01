FROM mhart/alpine-node:16

ARG GIT_PASSWORD

RUN set -x && \
    apk add --no-cache git bash

WORKDIR /app
COPY package.json .npmrc /app/
RUN yarn --production --no-audit

COPY .bin/fc-agent.js /app/fc-agent.js
COPY .bin/fc-agent.js.map /app/fc-agent.js.map
COPY fc-agents-init.sh /app/
RUN chmod +x /app/fc-agents-init.sh && \
    npm link && \
    mkdir -p /app/data

ENV PATH="/app:${PATH}"

ENTRYPOINT [ "fc-agents-init.sh" ]
