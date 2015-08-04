#
# Nginx, with Python and j2cli to evaluate Jinja2 templates.
#
# Config based off h5bp
# See https://github.com/h5bp/server-configs-nginx
#

FROM nginx

RUN apt-get update && \
    apt-get install -y python-setuptools && \
    easy_install j2cli && \
    apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/*

COPY ./h5bp /etc/nginx/h5bp

# Templates for nginx config files
COPY /templates /templates
COPY ./docker-entrypoint.sh /

EXPOSE 80 443
CMD ["nginx"]
ENTRYPOINT ["/docker-entrypoint.sh"]
