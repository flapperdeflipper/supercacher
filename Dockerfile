FROM public.ecr.aws/nginx/nginx-unprivileged:1.25.3

USER root
COPY --link ./config/nginx.conf /etc/nginx/nginx.conf
COPY --link ./config/cache.conf /etc/nginx/cache.conf
COPY --link ./config/services /etc/nginx/services

RUN mkdir -p \
    /var/lib/nginx/pypi \
    /var/lib/nginx/npm \
    /var/lib/nginx/apt \
    /var/lib/nginx/proxy \
 \
 && chown -R nginx:nginx /var/lib/nginx \
 && nginx -t \
 && rm -rf /tmp/*

WORKDIR /var/lib/nginx
USER nginx
EXPOSE 8080 8081 8082 8083
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
STOPSIGNAL SIGQUIT
