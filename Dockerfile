FROM nginx:latest
COPY config/default.conf /etc/nginx/conf.d
CMD ["nginx", "-g", "daemon off;"]

