FROM alpine
MAINTAINER Scott Dickson <scottfoesho at gmail dot com>

# Install packages
RUN apk update
RUN apk add --no-cache perl \
		perl-io-socket-ssl \
		perl-libwww \
		perl-json \
		perl-xml-simple \
		perl-xml-writer \
		perl-datetime \
		perl-clone \
		perl-db_file \
		perl-module-build-tiny \
		perl-lwp-protocol-https \
		perl-xml-sax \
		darkhttpd \
		tzdata \
		git

# Install unpackaged perl modules - search on https://www.cpan.org/
RUN apk add --no-cache build-base \
		perl-dev \
		perl-app-cpanminus \
		gcc
RUN cpanm "HTML::TableExtract"
RUN cpanm "Furl"

# Clone xml_tv repo
RUN git clone https://github.com/markcs/xml_tv /xml_tv

# Add local files
COPY root/ /

# Clean up build packages
RUN apk del build-base \
		perl-dev \
		perl-app-cpanminus \
		gcc

# Clean up files
RUN rm -rf /tmp/*

# Add s6 overlay - https://github.com/just-containers/s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

EXPOSE 80
VOLUME /srv/http /cache

ENTRYPOINT ["/init"]
