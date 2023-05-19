FROM httpd:alpine

ARG http_proxy
ARG https_proxy
ARG no_proxy

ENV user=mirror

RUN apk update                                               && \
    apk add --no-cache openjdk17-jre dcron nss supervisor bash && \
    addgroup -S $user                                        && \
    adduser -S $user -G $user                                && \
    mkdir -p /tmp/nvd                                        && \
    chown -R $user:$user /tmp/nvd                            && \
    chown -R $user:$user /usr/local/apache2/htdocs           && \
    rm -v /usr/local/apache2/htdocs/index.html

COPY /docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY /docker/bin/mirror.sh /usr/local/bin/mirror.sh
COPY /docker/crontab/mirror /etc/crontabs/mirror
COPY /docker/apache2/mirror.conf /usr/local/apache2/conf
COPY /target/nist-data-mirror.jar /usr/local/bin/

EXPOSE 80/tcp

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf", "-l", "/var/log/supervisord.log", "-j", "/var/run/supervisord.pid"]
