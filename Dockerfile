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
COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh && \
    mkdir -p /app/data

ENV PATH="/app:${PATH}"

ENTRYPOINT [ "entrypoint.sh" ]
