FROM jodogne/orthanc-plugins:1.12.7
RUN apt-get update && apt-get install -y ca-certificates && update-ca-certificates