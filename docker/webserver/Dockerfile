FROM alpine:3.21 AS build

RUN apk update && apk add nginx \
	&& rm -r /var/cache/apk /etc/nginx/http.d/default.conf \
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY site make_apps_*.sql /var/www/dogespace.nl/
COPY config /etc/nginx/http.d
COPY uacme /etc/uacme

FROM scratch

COPY --from=build / /
CMD nginx -g 'daemon off;'
