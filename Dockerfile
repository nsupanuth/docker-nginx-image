FROM centos:8

RUN yum -y update && yum clean all

RUN yum install -y tar bzip2 zip unzip nc telnet rsync

ENV NGINX_VERSION=1.15.8

# install nginx as a small test vehicle
RUN yum install -y gcc pcre-devel zlib-devel make && yum clean -y all

RUN curl -OL http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz\
  && tar -C /tmp -xzf nginx-${NGINX_VERSION}.tar.gz \
  && rm nginx-${NGINX_VERSION}.tar.gz

RUN cd /tmp/nginx-${NGINX_VERSION} \
  && ./configure \
  && make \
  && make install

RUN chmod -R g+w /usr/local/nginx \
  && sed -i 's/ 80;/ 8080;/g' /usr/local/nginx/conf/nginx.conf

# expose nginx port
EXPOSE 8080

# run nginx in no-daemon mode
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

