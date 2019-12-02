FROM maven:3.6-jdk-11
COPY ./ /src
ADD http://mirrors.tuna.tsinghua.edu.cn/apache//jmeter/binaries/apache-jmeter-5.2.1.tgz /src
RUN tar -xzvf /src/apache-jmeter-5.2.1.tgz -C /src/ && mv /src/jmeter-prometheus-plugin-0.6.0-SNAPSHOT.jar /src/apache-jmeter-5.2.1/lib/ext/
RUN chmod -R 777 /src
ENV PATH="/src/apache-jmeter-5.2.1/bin:${PATH}"
EXPOSE 9270
WORKDIR /src
CMD ["./entrypoint.sh","build-simulation-existing.jmx", "container5.properties"]
#CMD ["./entrypoint.sh","build-simulation-existing.jmx", "5", "localhost", "8080"]