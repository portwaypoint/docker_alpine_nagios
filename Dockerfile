FROM alpine:3.4 

MAINTAINER richardj@bsquare.com 
ENV VERSION 0.4 
# Run-time Dependencies 

RUN apk upgrade --update
#ENV RUNTIME_PKGS="sudo nagios nagios-plugins busybox rsync perl gd zlib libpng jpeg freetype mysql perl-plack findutils" 
ENV RUNTIME_PKGS="nagios nagios-plugins busybox" 
ENV BUILDTIME_PKGS="alpine-sdk curl" 

# Run-time dependencies 
RUN 	apk --no-cache add $RUNTIME_PKGS && \
    	apk --no-cache add --virtual .bdeps $BUILDTIME_PKGS && \
    	curl https://mathias-kettner.de/download/mk-livestatus-1.2.8p11.tar.gz | tar xvz && \
    	(cd mk-livestatus-1.2.8p11 && ./configure && make && make install ) && \
    	rm -rf mk-livestatus-1.2.8p11 && \ 
	apk del .bdeps 
ADD start_nagios.sh /bin

##Adding dependancies for Livestatus over TCP
RUN apk add socat
RUN apk add nano
#RUN apk add netcat-openbsd
RUN mkdir -p /var/lib/nagios/rw
RUN chmod 777 /var/lib/nagios/rw
ADD nagios.cfg /etc/nagios/nagios.cfg

ADD custom_configs /etc/nagios/custom_configs


RUN chown -R nagios /usr/local/lib/mk-livestatus/
USER nagios 


CMD /bin/start_nagios.sh

# socat -d -d TCP-LISTEN:30000,fork UNIX-CLIENT:/var/lib/nagios/rw/live

