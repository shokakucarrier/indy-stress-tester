FROM quay.io/openshift/origin-jenkins-agent-base:v4.0

ENV TZ=UTC \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
	JAVA_HOME=/usr/lib/jvm/java-11-openjdk

#USER root

ARG MAVEN_VERSION=3.6.3
ARG	PME_VERSION=4.2

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Install Maven
COPY CentOS-Base.repo /etc/yum.repos.d/

RUN INSTALL_PKGS="java-11-openjdk-devel java-1.8.0-openjdk-devel python3 python3-pip python-virtualenv" && \
    curl http://mirror.centos.org/centos-7/7/os/x86_64/RPM-GPG-KEY-CentOS-7 -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    DISABLES="--disablerepo=rhel-server-extras --disablerepo=rhel-server --disablerepo=rhel-fast-datapath --disablerepo=rhel-server-optional --disablerepo=rhel-server-ose --disablerepo=rhel-server-rhscl" && \
    yum $DISABLES -y update && \
    yum $DISABLES install -y $INSTALL_PKGS && \
    yum clean all -y && \
    mkdir -p $HOME/.m2 

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

ADD pki/* /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust extract

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

