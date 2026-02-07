FROM traefik:v3.6.1

LABEL org.opencontainers.image.title="portfolio-traefik" \
      org.opencontainers.image.authors="decybell"

COPY traefik.yml /etc/traefik/traefik.yml
COPY dynamic/ /etc/traefik/dynamic/
COPY certs/ /certs/

EXPOSE 80 443 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]
