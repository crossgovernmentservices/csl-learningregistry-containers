FROM ubuntu:14.04
MAINTAINER Chris Morandi <c.morandi@kainos.com>

RUN apt-get update && apt-get install -y wget curl
RUN wget https://github.com/jwilder/dockerize/releases/download/v0.1.0/dockerize-linux-amd64-v0.1.0.tar.gz
RUN tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.1.0.tar.gz
