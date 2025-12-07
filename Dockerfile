FROM caddy:2.9-alpine

COPY ./public /srv
RUN ls -al /srv
COPY ./CaddyFile /etc/caddy/Caddyfile
