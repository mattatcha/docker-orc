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

WORKDIR /root/
RUN git clone https://github.com/apache/orc.git -b master --depth 1

WORKDIR /root/orc/build
RUN cmake .. -DCMAKE_BUILD_TYPE=RELEASE && \
      make package

RUN tar xzf ORC-*-SNAPSHOT-Linux.tar.gz -C /tmp

FROM openjdk:8

COPY --from=builder /tmp/ORC-*-SNAPSHOT-Linux /opt/orc

RUN for i in /opt/orc/share/*.jar; do file="${i##*/}"; echo '#!/bin/bash\nexec java -jar' "$i" \"\$@\" > /opt/orc/bin/"${file%%-[[:digit:]]*}"; done
RUN chmod -R +x /opt/orc/bin/*
ENV PATH="/opt/orc/bin:${PATH}"
