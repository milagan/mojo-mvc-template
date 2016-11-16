FROM perl:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libsqlite3-dev \
    libzmq3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN cpanm Mojolicious \
    && cpanm Mojolicious::Plugin::OpenAPI \
    && cpanm DBI \ 
    && cpanm DBD::SQLite \
    && cpanm ZMQ::LibZMQ3 \
    && cpanm MojoX::Log::Log4perl \
    && rm -fr ./cpanm /root/.cpanm /usr/src/perl /tmp/*

COPY . /app

WORKDIR /app

RUN chmod a+x docker-entrypoint.sh

EXPOSE 80/tcp

CMD ["./docker-entrypoint.sh"]
