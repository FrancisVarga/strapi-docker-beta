FROM ubuntu:bionic

EXPOSE 1337

LABEL maintainer="Luca Perret <perret.luca@gmail.com>" \
      org.label-schema.vendor="Strapi" \
      org.label-schema.name="Strapi Docker image" \
      org.label-schema.description="Strapi containerized" \
      org.label-schema.url="https://strapi.io" \
      org.label-schema.vcs-url="https://github.com/strapi/strapi-docker" \
      org.label-schema.version=latest \
      org.label-schema.schema-version="1.0"

WORKDIR /usr/src/api

RUN apt-get update && apt-get install -yqq curl gnupg
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
      echo 'deb https://deb.nodesource.com/node_10.x bionic main' > /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get -yqq install nodejs && apt-get remove -yqq curl gnupg && rm -rf /var/lib/apt/lists/*

RUN npm install -g strapi@beta --unsafe-perm=true --allow-root && npm cache clean --force

COPY strapi.sh healthcheck.js ./
RUN chmod +x ./strapi.sh

HEALTHCHECK --interval=15s --timeout=5s --start-period=30s \
      CMD node /usr/src/api/healthcheck.js

CMD ["./strapi.sh"]
