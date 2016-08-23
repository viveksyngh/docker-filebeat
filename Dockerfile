# Setting up the base image
FROM ubuntu:14.04

# Set the file maintainer
MAINTAINER Vivek Singh <vivek@happay.in>

# Setting up envoirment varibale
ENV FILEBEAT_VERSION=1.2.3 \
    FILEBEAT_SHA1=3fde7f5f5ea837140965a193bbb387c131c16d9c



# Installing wget
# RUN apt-get install apt-transport-https
RUN apt-get update
# RUN apt-get build-dep wget wget http://ftp.gnu.org/gnu/wget/wget-1.16.tar.gz
# RUN tar -xvf wget-1.16.tar.gz
# RUN cd wget-1.16/
# RUN ./configure --with-ssl=openssl --prefix=/opt/wget
# RUN make
# RUN make install
# RUN ln -s /opt/wget /usr/bin/wget
RUN apt-get -y install wget

# Creating Beats source list
RUN echo "deb http://packages.elastic.co/beats/apt stable main" |  \
    tee -a /etc/apt/sources.list.d/beats.list

# Adding GPG key 
RUN wget -qO - http://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

# Intalling filebeat
RUN apt-get update
RUN apt-get install filebeat

# Copy filebeat configuration file
COPY filebeat.yml /filebeat.yml

# Replacing default configuration with our configuration
RUN cp -f /filebeat.yml /etc/filebeat/filebeat.yml

# Copy logstash certificate file
RUN mkdir -p /etc/pki/tls/certs
COPY logstash-forwarder.crt /logstash-forwarder.crt
RUN cp /logstash-forwarder.crt /etc/pki/tls/certs/

# Mounting log folder to container 
RUN mkdir /logvol
VOLUME /var/log:/logvol

# Mounting debug log folder or application
RUN mkdir /debugvol
VOLUME /home/vivek/repos/happay_v2/logs:/debugvol

# Copy entrypoint file 
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Starting filebeat service
# RUN service filebeat restart
