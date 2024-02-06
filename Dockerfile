ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

WORKDIR /home/irisowner/irisbuild

USER root
RUN apt update && apt-get -y install git

USER ${ISC_PACKAGE_MGRUSER}

ARG TESTS=0
ARG MODULE="demo-coffeemaker"
ARG NAMESPACE="IRISAPP"

ENV PYTHON_PATH=/usr/irissys/bin/

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
    iris merge IRIS merge.cpf && \
	iris session IRIS < iris.script && \
    # ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
