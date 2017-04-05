FROM alpine:latest

RUN apk --no-cache add c-ares libevent yaml python \
 && apk --no-cache add --virtual build-dependencies autoconf autoconf-doc automake c-ares-dev curl gcc libc-dev libevent-dev libtool make man openssl-dev pkgconfig py-pip sqlite-dev \
 && curl -o  /tmp/pgbouncer-1.7.2.tar.gz -L https://pgbouncer.github.io/downloads/files/1.7.2/pgbouncer-1.7.2.tar.gz \
 && cd /tmp \
 && tar xvfz /tmp/pgbouncer-1.7.2.tar.gz \
 && cd pgbouncer-1.7.2 \
 && ./configure --prefix=/usr \
 && make \
 && cp pgbouncer /usr/bin \
 && mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer \
 && cp etc/pgbouncer.ini /etc/pgbouncer/ \
 && cp etc/userlist.txt /etc/pgbouncer/ \
 && adduser -D -S pgbouncer \
 && chown pgbouncer /var/run/pgbouncer \
 && pip install --upgrade pip \
 && pip install jinja2 \
 && mkdir -p /templates \
 && cd /tmp \
 && rm -rf /tmp/pgbouncer* \
 && rm -f /etc/pgbouncer/pgbouncer.ini \
 && apk del build-dependencies

COPY ./templates/* /templates/

RUN chown -R pgbouncer /etc/pgbouncer && chown -R pgbouncer /templates

COPY ./bin/start.sh /start.sh
COPY ./bin/generate_config.py /generate_config.py

USER pgbouncer

VOLUME /etc/pgbouncer

EXPOSE 6432

CMD /start.sh
