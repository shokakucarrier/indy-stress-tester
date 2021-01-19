FROM quay.io/kaine/maven-openshift-agen-base:latest

COPY ./ /src
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