FROM adoptopenjdk/openjdk11:x86_64-debianslim-jre-11.0.10_9
LABEL maintainer="ats.team__@__axway.com"\
    product="Axway ATS Agent"\
    version="4.0.8-SNAPSHOT"

ARG USERNAME=atsuser
ARG WORKDIR=/home/$USERNAME
ARG AGENT_VERSION="4.0.8-SNAPSHOT"

USER root

# Install: official image binaries
RUN apt-get -y update && apt-get install -y unzip wget --no-install-recommends && rm -rf /var/lib/apt/lists/*
# debug version RUN apt-get -y update && apt-get install -y unzip wget nano mc --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Direct alternative: curl http://ftp.bg.debian.org/debian/pool/main/u/unzip/unzip_6.0-23+deb10u1_amd64.deb && apt install ...
# RUN apt-get update && apt-get -y install wget zip sudo unzip postgresql-client openjdk-8-jre-headless

ENV JAVA_HOME=/opt/java/openjdk AGENT_HOME=$WORKDIR/ AGENT_ZIP=ats-agent-standalone-all.zip
ENV LC_ALL='en_US.UTF-8' LANG='en_US.UTF-8' LANGUAGE='en_US.UTF-8'

# Create folders, which will contain ATS Agent installation and optimize security configuration
RUN mkdir -p ${AGENT_HOME} && chmod 770 -R ${AGENT_HOME} &&\
    useradd -d ${AGENT_HOME} -M -u 10001 -g 0 -s /usr/sbin/nologin $USERNAME &&\
    sed -i "/securerandom.source=/ s/=.*/=file:\/dev\/.\/urandom/g" $JAVA_HOME/conf/security/java.security &&\
    sed -i "/securerandom.strongAlgorithms=/ s/=.*/=NativePRNGNonBlocking:SUN/g" $JAVA_HOME/conf/security/java.security &&\
    sed -i "/crypto.policy=/ s/=.*/=unlimited/g" $JAVA_HOME/conf/security/java.security

# For local agent build:
#COPY resources/ats-agent-standalone-all*.zip ./$AGENT_ZIP
#RUN ls -la && unzip $AGENT_ZIP && rm $AGENT_ZIP && ls -la

COPY ./docker_files/config $WORKDIR/
COPY --chown=$USERNAME:0 ./docker_files/entrypoint.sh $WORKDIR/

#RUN cd $WORKDIR
RUN chmod +x $WORKDIR/config $WORKDIR/entrypoint.sh

RUN $WORKDIR/config
RUN chown -R $USERNAME /home/$USERNAME

USER $USERNAME
# TODO: include parsed agent version

EXPOSE 8089
# Optionally expose port range for copying files via agent

#RUN echo "Work dir before entrypoint: `pwd`"

ENTRYPOINT ["/bin/bash", "-c", "cd $AGENT_HOME && pwd && ./entrypoint.sh"]
