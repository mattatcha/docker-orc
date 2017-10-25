FROM openjdk:8 as builder

RUN apt-get update
RUN apt-get install -y \
  cmake \
  gcc \
  g++ \
  git \
  libsasl2-dev \
  libssl-dev \
  make \
  maven
  
WORKDIR /root
RUN git clone https://github.com/apache/orc.git -b master --depth 1
RUN cd orc/java && mvn package


FROM openjdk:8

COPY --from=builder /root/orc/build/java/tools/orc-tools-*-SNAPSHOT-uber.jar /opt/orc/
