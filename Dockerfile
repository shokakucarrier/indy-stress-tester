FROM maven:3.6-jdk-11
USER 1000:1000
COPY --chown=1000:1000 ./ /code
ENV PATH="/code/apache-jmeter-5.1.1/bin:${PATH}"
WORKDIR /code
CMD ["./entrypoint.sh","build-simulation-existing.jmx", "container5.properties"]
