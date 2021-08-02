ARG IMAGE=intersystemsdc/iris-community:2021.1.0.205.0-zpm
FROM $IMAGE

USER root
## add git
RUN apt update && apt-get -y install git && \
    apt install python3 python3-pip -y

# Make python available in cmd
RUN export PATH=${PATH}:/usr/bin/python3
RUN /bin/bash -c "source ~/.bashrc"

WORKDIR /opt/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild
USER ${ISC_PACKAGE_MGRUSER}

#COPY  Installer.cls .
COPY  src src
COPY  python python
COPY module.xml module.xml
COPY iris.script iris.script

RUN iris start IRIS \
	&& iris session IRIS < iris.script \
    && iris stop IRIS quietly
