FROM traefik:v3.6.1
LABEL authors="decybell"

COPY traefik.yml /etc/traefik/traefik.yml
COPY dynamic/ /etc/traefik/dynamic/:ro
COPY certs /certs:ro

EXPOSE 80 443 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]