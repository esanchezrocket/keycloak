FROM adoptopenjdk:8u252-b09-jre-hotspot-bionic

ENV KEYCLOAK_VERSION 11.0.2
ENV JDBC_POSTGRES_VERSION 42.2.5
ENV JDBC_MYSQL_VERSION 8.0.19
ENV JDBC_MARIADB_VERSION 2.5.4
ENV JDBC_MSSQL_VERSION 7.4.1.jre11

ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
ENV JBOSS_HOME /opt/jboss/keycloak
ENV LANG en_US.UTF-8

ARG GIT_REPO
ARG GIT_BRANCH
ARG KEYCLOAK_DIST=https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz

USER root

RUN apt-get update -y && apt-get install -y gzip hostname libc6 openjdk-11-jre-headless openssl tar gettext-base && apt-get clean all

ADD tools /opt/jboss/tools
RUN /opt/jboss/tools/build-keycloak.sh

COPY ./master_export_20201130_01.json /config-files/oauth2-demo-realm-config.json
COPY ./custom-entrypoint.sh /config-files/custom-entrypoint.sh

RUN chmod 777 /config-files
RUN chmod +x /config-files/custom-entrypoint.sh

USER 1000

EXPOSE 8080
EXPOSE 8443

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]
