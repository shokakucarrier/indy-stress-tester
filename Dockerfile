FROM maven:3.6-jdk-11
COPY ./ /code
ADD http://mirrors.tuna.tsinghua.edu.cn/apache//jmeter/binaries/apache-jmeter-5.2.zip /code
RUN apt update && apt install unzip && unzip /code/apache-jmeter-5.2.zip -d /code && rm -f /code/apache-jmeter-5.2.zip
RUN chmod -R 777 /code
ENV PATH="/code/apache-jmeter-5.2/bin:${PATH}"
WORKDIR /code
CMD ["./entrypoint.sh","build-simulation-existing.jmx", "container5.properties"]