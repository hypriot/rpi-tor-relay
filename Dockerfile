# Original version by Jess Frazelle
# see https://blog.jessfraz.com/post/running-a-tor-relay-with-docker/
#
# run a tor relay in a container
#
# Bridge relay:
#	docker run -d \
#		--restart always \
#		-v /etc/localtime:/etc/localtime \
#		-p 9001:9001 \
# 		--name tor-relay \
# 		hypriot/rpi-tor-relay -f /etc/tor/torrc.bridge
#
# Exit relay:
# 	docker run -d \
#		--restart always \
#		-v /etc/localtime:/etc/localtime \
#		-p 9001:9001 \
# 		--name tor-relay \
# 		hypriot/rpi-tor-relay -f /etc/tor/torrc.exit
#
# FROM alpine:latest
# MAINTAINER Jessica Frazelle <jess@docker.com>
FROM hypriot/rpi-alpine-scratch
MAINTAINER Dieter Reuter <dieter@hypriot.com>

## Note: Tor is only in testing repo -> http://pkgs.alpinelinux.org/packages?package=emacs&repo=all&arch=x86_64
RUN apk update && apk add \
	tor \
	--update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
	&& rm -rf /var/cache/apk/*

# default port to used for incoming Tor connections
# can be changed by changing 'ORPort' in torrc
EXPOSE 9001

# copy in our torrc files
COPY torrc.bridge /etc/tor/torrc.bridge
COPY torrc.exit /etc/tor/torrc.exit

# make sure files are owned by tor user
RUN chown -R tor /etc/tor

USER tor

ENTRYPOINT [ "tor" ]
