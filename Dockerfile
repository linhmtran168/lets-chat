FROM node:0.12-slim
MAINTAINER SD Elements

RUN mkdir -p /usr/src/app
COPY . /usr/src/app

RUN set -x \
&&  apt-get update \
&&  apt-get install -y g++ gcc git make python --no-install-recommends

ENV LCB_DATABASE_URI=mongodb://mongo/letschat \
    LCB_HTTP_HOST=0.0.0.0 \
    LCB_HTTP_PORT=8080 \
    LCB_XMPP_ENABLE=true \
    LCB_XMPP_PORT=5222

WORKDIR /usr/src/app

RUN npm install --production \
&&  npm install lets-chat-ldap lets-chat-s3 \
&&  npm dedupe \
&&  npm cache clean \
&&  rm -rf /tmp/npm*

EXPOSE 8080 5222

VOLUME ["/usr/src/app/config", "/usr/src/app/uploads"]

CMD ["npm", "start"]
