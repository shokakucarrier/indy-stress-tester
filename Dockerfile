FROM maven:3.6-jdk-11
RUN mkdir /code
ADD http://mirrors.tuna.tsinghua.edu.cn/apache//jmeter/binaries/apache-jmeter-5.2.zip /code
RUN apt update && apt install unzip && unzip /code/apache-jmeter-5.2.zip -d /code && rm -f /code/apache-jmeter-5.2.zip
ADD jmeter-prometheus-plugin-0.6.0-SNAPSHOT.jar /code/apache-jmeter-5.2/lib/ext/
COPY ./ /code
RUN chmod -R 777 /code
ENV PATH="/code/apache-jmeter-5.2/bin:${PATH}"
WORKDIR /code
CMD ["./entrypoint.sh","build-simulation-existing.jmx", "container5.properties"]
#CMD ["./entrypoint.sh","build-simulation-existing.jmx", "5", "localhost", "8080"]