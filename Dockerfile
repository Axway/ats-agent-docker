FROM adoptopenjdk/openjdk11:x86_64-debianslim-jre-11.0.8_10
LABEL maintainer="ats.team__@__axway.com"\
      product="Axway ATS Agent"

ARG USERNAME=atsuser
ARG WORKDIR=/home/$USERNAME

USER root

RUN apt-get -y update && apt-get install -y unzip wget --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Direct alternative: curl http://ftp.bg.debian.org/debian/pool/main/u/unzip/unzip_6.0-23+deb10u1_amd64.deb && apt install ...
# RUN apt-get update && apt-get -y install wget zip sudo unzip postgresql-client openjdk-8-jre-headless

ENV AGENT_HOME=$WORKDIR/
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
ENV AGENT_ZIP=ats-agent-standalone-all.zip

# Create folders, which will contain ATS Agent installation
RUN mkdir -p ${AGENT_HOME} && chmod 770 -R ${AGENT_HOME} &&\
    useradd -d ${AGENT_HOME} -M -u 10001 -g 0 -s /usr/sbin/nologin $USERNAME

# For local agent build:
#COPY resources/ats-agent-standalone-all*.zip ./$AGENT_ZIP
#RUN ls -la && unzip $AGENT_ZIP && rm $AGENT_ZIP && ls -la

COPY ./docker_files/config $WORKDIR/
COPY --chown=$USERNAME:0 ./docker_files/entrypoint.sh $WORKDIR/

#RUN cd $WORKDIR
RUN chmod +x $WORKDIR/config
RUN chmod +x $WORKDIR/entrypoint.sh

RUN $WORKDIR/config
RUN chown -R $USERNAME /home/$USERNAME

USER $USERNAME
# TODO: include parsed agent version

EXPOSE 8089
# Optionally expose port range for copying files via agent

#RUN echo "Work dir before entrypoint: `pwd`"

ENTRYPOINT ["/bin/bash", "-c", "cd $AGENT_HOME && pwd && ./entrypoint.sh"]
