# Intentionally misconfigured for demo purposes.
FROM ubuntu:latest
ADD https://example.com/app.tar.gz /opt/app/
RUN apt-get update && apt-get install -y curl sudo
EXPOSE 22
USER root
CMD ["/opt/app/start.sh"]
