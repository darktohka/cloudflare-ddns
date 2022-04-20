FROM python:alpine

ENV SHELL /bin/sh
ENV LANG C.UTF-8

ENV PYTHONUNBUFFERED 1
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PIP_NO_CACHE_DIR 0
ENV HEALTHCHECK_URL https://hc-ping.com/ffffffff-ffff-ffff-ffff-ffffffffffff

COPY requirements.txt /srv
WORKDIR /srv

RUN \
# Create user
    addgroup -g 427 -S cloudflare \
    && adduser -u 427 -S cloudflare -G cloudflare \
# Upgrade system
    && apk add --no-cache iproute2 \
# Install Python dependencies
    && pip install --no-cache-dir --upgrade -r requirements.txt \
    && chown -R cloudflare:cloudflare . \
# Cleanup
    && rm -rf /tmp/* /var/cache/apk/*

COPY . /srv
USER cloudflare
ENTRYPOINT ["python", "cloudflare-ddns", "--update"]
