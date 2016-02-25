FROM ubuntu:12.04
MAINTAINER Chris Morandi <c.morandi@kainos.com>

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install flex dctrl-tools libsctp-dev ed zlib1g-dev
RUN apt-get -y install libxslt1-dev automake make ruby libtool g++
RUN apt-get -y install zip libcap2-bin
RUN apt-get -y install git-core curl rake swig vim


RUN adduser couchdb
RUN echo couchdb:couchdb | chpasswd
RUN adduser couchdb sudo
RUN echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir /opt/couchdb && chown couchdb:couchdb /opt/couchdb
USER couchdb
WORKDIR /home/couchdb/ 
RUN git clone git://github.com/jimklo/build-couchdb 
WORKDIR /home/couchdb/build-couchdb
RUN git submodule init
RUN git submodule update
RUN rake install=/opt/couchdb/1.2.2 git="git://github.com/apache/couchdb tags/1.2.2" plugins="git://github.com/iriscouch/browserid_couchdb origin/master,git://github.com/couchbase/geocouch origin/couchdb1.2.x"


WORKDIR  /opt/couchdb/
RUN ln -s ./1.2.2 current
ADD env.sh /opt/couchdb/1.2.2/env.sh
ADD couchdb /opt/couchdb/current/etc/init.d/couchdb
USER root
RUN chmod +x /opt/couchdb/current/etc/init.d/couchdb
ADD local.ini /opt/couchdb/current/etc/couchdb/local.ini
ADD browserid.ini /opt/couchdb/current/etc/couchdb/default.d/browserid.ini
RUN chown -R couchdb:couchdb /opt/couchdb/

RUN ln -s /opt/couchdb/current/etc/init.d/couchdb /etc/init.d/couchdb
RUN ln -s /opt/couchdb/current/etc/logrotate.d/couchdb /etc/logrotate.d/couchdb
RUN update-rc.d couchdb defaults
EXPOSE 5984

#CMD service couchdb start
