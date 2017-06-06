FROM openjdk:8

LABEL maintainer jjeffcaii@outlook.com

ENV \
JAVA_LIBRARY_PATH="/usr/local/lib/hadoop" \
HBASE_HOME="/usr/local/lib/hbase" \
HADOOP_CONF_DIR="/etc/hadoop" \
HBASE_CLASSPATH="/etc/hadoop" \
HBASE_MANAGES_ZK="false"

WORKDIR $HBASE_HOME

# add native hadoop lib
ARG HADOOP_MAJOR_VERSION="2.5"
COPY ./native/${HADOOP_MAJOR_VERSION} ${JAVA_LIBRARY_PATH}

ARG APACHE_MIRROR="http://mirrors.ustc.edu.cn/apache"

# set versions
ARG HBASE_MAJOR_VERSION="1.2"
ARG HBASE_MINOR_VERSION="5"

RUN \
curl -o /tmp/hbase.tar.gz  ${APACHE_MIRROR}/hbase/${HBASE_MAJOR_VERSION}.${HBASE_MINOR_VERSION}/hbase-${HBASE_MAJOR_VERSION}.${HBASE_MINOR_VERSION}-bin.tar.gz && \
tar xvzf /tmp/hbase.tar.gz -C . && \
mv hbase-${HBASE_MAJOR_VERSION}.${HBASE_MINOR_VERSION}/* . && \
rm -rf hbase-${HBASE_MAJOR_VERSION}.${HBASE_MINOR_VERSION} && \
rm -rf docs bin/*.cmd conf/*.cmd *.txt && \
rm -rf /tmp/*

ARG PHOENIX_VERSION="4.10.0"

RUN \
curl -o /tmp/phoenix.tar.gz ${APACHE_MIRROR}/apache/phoenix/apache-phoenix-${PHOENIX_VERSION}-HBase-${HBASE_MAJOR_VERSION}/bin/apache-phoenix-${PHOENIX_VERSION}-HBase-${HBASE_MAJOR_VERSION}-bin.tar.gz && \
tar xvzf /tmp/phoenix.tar.gz -C /tmp && \
rm -f /tmp/phoenix.tar.gz && \
mv /tmp/*phoenix* /tmp/phoenix && \
mv /tmp/phoenix/*-server.jar lib && \
rm -rf /tmp/*

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY etc conf

VOLUME [ "/etc/hadoop" ]

ENTRYPOINT [ "entrypoint" ]
