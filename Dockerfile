FROM alpine:3.7

RUN apk --no-cache add --virtual build-dependencies make libevent-dev openssl-dev gcc libc-dev  \
 && wget -O /tmp/pgbouncer-1.8.1.tar.gz https://pgbouncer.github.io/downloads/files/1.8.1/pgbouncer-1.8.1.tar.gz \
 && cd /tmp \
 && tar xvfz /tmp/pgbouncer-1.8.1.tar.gz \
 && cd pgbouncer-1.8.1 \
 && ./configure --prefix=/usr/local --with-libevent=libevent-prefix \
 && make \
 && cp pgbouncer /usr/bin \
 && mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer \
 && cp etc/pgbouncer.ini /etc/pgbouncer/ \
 && cp etc/userlist.txt /etc/pgbouncer/ \
 && adduser -D -S pgbouncer \
 && chown -R pgbouncer /etc/pgbouncer /var/run/pgbouncer /var/log/pgbouncer \
 && rm -rf /tmp/pgbouncer* \
 && apk del build-dependencies

USER pgbouncer

CMD ["pgbouncer", "/etc/pgbouncer/pgbouncer.ini"] 
