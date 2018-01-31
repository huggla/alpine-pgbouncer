FROM alpine:3.7

RUN \
#apk --no-cache add libevent libssl1.0 \
 apk --no-cache add --virtual build-dependencies make libevent-dev openssl-dev gcc libc-dev  \
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
 && chown pgbouncer /var/run/pgbouncer \
# && pip install --upgrade pip \
# && pip install jinja2 \
# && mkdir -p /templates \
# && cd /tmp \
 && rm -rf /tmp/pgbouncer* \
# && rm -f /etc/pgbouncer/pgbouncer.ini \
 && apk del build-dependencies

#COPY ./templates/* /templates/

#RUN chown -R pgbouncer /etc/pgbouncer && chown -R pgbouncer /templates
RUN chown -R pgbouncer /etc/pgbouncer


#COPY ./bin/start.sh /start.sh
#COPY ./bin/generate_config.py /generate_config.py

USER pgbouncer

#VOLUME /etc/pgbouncer

#EXPOSE 6432

CMD ["pgbouncer", "/etc/pgbouncer/pgbouncer.ini"] 
