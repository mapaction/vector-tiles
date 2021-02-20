FROM postgres:13.2

ENV POSTGRES_USER admin
ENV POSTGRES_PASSWORD 'password123'
ENV POSTGRES_DB osm

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip postgis postgresql-13-postgis-3 \
    && rm -rf /var/lib/apt/lists/*


# COPY FILES INTO CONTAINER
# RUN shp2pgsql TO LOAD SHP FILES INTO DB


EXPOSE 5432
CMD ["postgres"]


