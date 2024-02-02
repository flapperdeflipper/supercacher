FROM public.ecr.aws/nginx/nginx-unprivileged:1.25.3

USER root
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./includes /etc/nginx/includes
RUN mkdir -p \
    /var/lib/nginx/pypi \
    /var/lib/nginx/npm \
    /var/lib/nginx/apt \
 \
 && chown -R nginx:nginx /var/lib/nginx \
 && echo > /etc/nginx/conf.d/default.conf \
 && nginx -t \
 && rm -rf /tmp/*

WORKDIR /var/lib/nginx
USER nginx
EXPOSE 8080 8081 8082
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
STOPSIGNAL SIGQUIT
