FROM klakegg/hugo:0.101.0-onbuild AS hugo

FROM caddy:2.9-alpine

COPY --from=hugo /target /usr/share/caddy
COPY ./CaddyFile /etc/caddy/Caddyfile
