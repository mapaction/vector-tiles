FROM postgres:13.2

ENV POSTGRES_USER admin
ENV POSTGRES_PASSWORD 'password123'
ENV POSTGRES_DB osm

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip postgis postgresql-13-postgis-3 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

EXPOSE 5432
CMD ["postgres"]


