FROM adoptopenjdk/openjdk11:x86_64-debianslim-jre-11.0.6_10
MAINTAINER ats.team__@__axway.com

# ADD ./docker_files $workdir

RUN ["java", "-version"]
RUN ["echo", "Initial empty container version"]

# Currently do not expose port
# EXPOSE 8089

ENV ENTRYPOINT_SCRIPT="echo \"Message from empty ATS container\""
CMD ["bash", "-c", "$ENTRYPOINT_SCRIPT"]

