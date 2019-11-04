FROM maven:3.6-jdk-11
COPY ./ /code
ENV PATH="/code/apache-jmeter-5.1.1/bin:${PATH}"
WORKDIR /code
CMD ["./entrypoint.sh","build-simulation-existing.jmx", "container5.properties"]
