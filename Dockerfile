FROM ubuntu:18.04

# defining user root
USER root

# OS update
# Add nginx and sigsci repos
# Install packages
# Install SigSci agent and native nginx module
RUN apt-get update && apt-get install -y gnupg2
RUN apt-get install -y apt-transport-https wget
RUN wget -qO - http://nginx.org/packages/keys/nginx_signing.key | apt-key add -
RUN wget -qO - https://apt.signalsciences.net/release/gpgkey | apt-key add -
RUN echo "deb https://apt.signalsciences.net/release/ubuntu/ bionic main" > /etc/apt/sources.list.d/sigsci-release.list
RUN echo "deb http://nginx.org/packages/ubuntu/ bionic nginx" > /etc/apt/sources.list.d/nginx.list
RUN apt-get update
RUN apt-get install -y nginx=1.16.0* wget apt-transport-https curl ; curl -slL https://apt.signalsciences.net/gpg.key | apt-key add -; apt-get update; apt-get install -y sigsci-agent nginx-module-sigsci-nxo=1.16.0*; apt-get clean

WORKDIR /app
ADD . /app
RUN chmod +x start.sh

#Edit nginx.conf to load SigSci nginx module
RUN sed -i '1iload_module /etc/nginx/modules/ngx_http_sigsci_module.so;' /etc/nginx/nginx.conf 
RUN sed -i '1iload_module /etc/nginx/modules/ndk_http_module.so;' /etc/nginx/nginx.conf

# copy sigsci agent conf file
RUN mkdir /etc/sigsci
COPY agent.conf /etc/sigsci/agent.conf

# Expose ports
EXPOSE 80

# Start sigsci agent and nginx
ENTRYPOINT ["./start.sh"]
