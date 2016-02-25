FROM ubuntu:14.04
MAINTAINER Chris Morandi <c.morandi@kainos.com>

ADD precise.list /etc/apt/sources.list.d/precise.list
ADD 99precise /etc/apt/apt.conf.d/99precise
RUN apt-get update && apt-get upgrade -y

RUN apt-get -y install flex dctrl-tools libsctp-dev ed zlib1g-dev
RUN apt-get -y install libxslt1-dev automake make ruby libtool g++
RUN apt-get -y install zip libcap2-bin
RUN apt-get -y install python-dev python-setuptools python-virtualenv
RUN apt-get -y install -t precise libyajl1
RUN apt-get -y install nginx git-core curl rake swig vim

RUN adduser learnreg
RUN echo learnreg:learnreg | chpasswd
RUN adduser learnreg sudo
RUN echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD gnupg/ /home/learnreg/.gnupg/
RUN chown -R learnreg:learnreg /home/learnreg/.gnupg/
USER learnreg
WORKDIR /home/learnreg
RUN git clone git://github.com/LearningRegistry/LearningRegistry
WORKDIR /home/learnreg/LearningRegistry
WORKDIR /home/learnreg
RUN virtualenv ~/virtualenv/lr

RUN virtualenv --no-site-packages env
RUN . env/bin/activate &&  pip install uwsgi && pip install six==1.10.0 &&  pip install -e ./LearningRegistry/LR
USER root
ADD ./lrconfigdir/learningregistry.conf /home/learnreg/LearningRegistry/config/learningregistry.conf
ADD ./lrconfigdir/learningregistry.conf  /etc/nginx/sites-available/
ADD ./lrconfigdir/learningregistry_cgi /home/learnreg/LearningRegistry/etc/nginx/learningregistry_cgi/
RUN rm /etc/nginx/sites-enabled/default && ln -s /etc/nginx/sites-available/learningregistry.conf  /etc/nginx/sites-enabled/learningregistry.conf && cp -r /home/learnreg/LearningRegistry/etc/nginx/conf.d/* /etc/nginx/conf.d/ && cp -r /home/learnreg/LearningRegistry/etc/nginx/learningregistry_cgi /etc/nginx/learningregistry_cgi
USER learnreg
ADD ./lrconfigdir/development.ini /home/learnreg/LearningRegistry/LR/development.ini
EXPOSE 80
CMD sudo service nginx restart && cd /home/learnreg/LearningRegistry/LR && . ../../env/bin/activate && uwsgi --ini-paste ./development.ini -H ../../env 

