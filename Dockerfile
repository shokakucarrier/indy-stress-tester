FROM quay.io/openshift/origin-jenkins-agent-base:v4.0

ENV TZ=UTC \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
	JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk

#USER root

ARG MAVEN_VERSION=3.3.9
ARG	PME_VERSION=4.2

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Install Maven
COPY CentOS-Base.repo /etc/yum.repos.d/

RUN INSTALL_PKGS="java-1.8.0-openjdk-devel.x86_64 python3 python3-pip python-virtualenv" && \
    curl http://mirror.centos.org/centos-7/7/os/x86_64/RPM-GPG-KEY-CentOS-7 -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    DISABLES="--disablerepo=rhel-server-extras --disablerepo=rhel-server --disablerepo=rhel-fast-datapath --disablerepo=rhel-server-optional --disablerepo=rhel-server-ose --disablerepo=rhel-server-rhscl" && \
    yum $DISABLES -y update && \
    yum $DISABLES install -y $INSTALL_PKGS && \
    rpm -V java-1.8.0-openjdk-devel.x86_64 && \
    yum clean all -y && \
    mkdir -p $HOME/.m2 

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

ADD pki/* /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust extract

RUN	sed -i 's/jdk.tls.disabledAlgorithms=SSLv3/jdk.tls.disabledAlgorithms=EC,ECDHE,ECDH,SSLv3/g' $JAVA_HOME/jre/lib/security/java.security

# NCL-4067: remove useless download progress with batch mode (-B)
RUN curl -SL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share

RUN mkdir -p /usr/share/pme && chmod ugo+x /usr/share/pme
RUN curl -SLo  /usr/share/pme/pme.jar https://repo.maven.apache.org/maven2/org/commonjava/maven/ext/pom-manipulation-cli/$PME_VERSION/pom-manipulation-cli-$PME_VERSION.jar

RUN mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven

RUN sed -i 's|${CLASSWORLDS_LAUNCHER} "$@"|${CLASSWORLDS_LAUNCHER} -B "$@"|g' /usr/share/maven/bin/mvn

RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN echo "export M2_HOME=/usr/share/maven" >> /etc/profile

RUN chgrp -R 0 /usr/share/maven && \
    chmod -R g=u /usr/share/maven


# ---------------------------------------------------------------
# END BASE IMAGE SETUP
# ---------------------------------------------------------------

COPY entrypoint.sh start.sh jmeter-prometheus-plugin-0.6.0-SNAPSHOT.jar CentOS-Base.repo /src/
COPY inputs /src/inputs
COPY tests /src/tests
ADD http://mirrors.tuna.tsinghua.edu.cn/apache//jmeter/binaries/apache-jmeter-5.2.1.tgz /src
RUN tar -xzvf /src/apache-jmeter-5.2.1.tgz -C /src/ && mv /src/jmeter-prometheus-plugin-0.6.0-SNAPSHOT.jar /src/apache-jmeter-5.2.1/lib/ext/ && chmod -R 777 /src
ENV PATH="/src/apache-jmeter-5.2.1/bin:${PATH}"
RUN DISABLES="--disablerepo=rhel-server-extras --disablerepo=rhel-server --disablerepo=rhel-fast-datapath --disablerepo=rhel-server-optional --disablerepo=rhel-server-ose --disablerepo=rhel-server-rhscl" && \
    yum $DISABLES install -y nmap-ncat epel-release libxml2-devel libxslt-devel python3-devel gcc mysql-connector-java postgresql-jdbc koji python-isodate python-pymongo skopeo&& \
    yum $DISABLES install -y http://data-perf.eng.pek2.redhat.com/rpms/rhel7/noarch/perfcharts-0.6.1-1.el7.noarch.rpm && \
    yum clean all -y && \
    pip3 install wheel && pip3 install --upgrade setuptools &&\
    pip3 install bzt j2cli[yaml]
EXPOSE 9270
WORKDIR /src