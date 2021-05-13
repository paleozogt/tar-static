FROM ubuntu:bionic as builder

RUN apt-get update && apt-get install -y \
        build-essential \
        curl \
        tar \
        upx \
  && rm -rf /var/lib/apt/lists/*

# cross-compiler and arch repo
ARG TRIPLET
RUN if [ $(gcc -dumpmachine) != "$TRIPLET" ]; then \
          apt-get update && apt-get install -y \
             g++-$TRIPLET \
       && rm -rf /var/lib/apt/lists/* \
; fi

ARG CFLAGS
ENV CFLAGS $CFLAGS
ADD . /build
WORKDIR /build
RUN ./build.sh $TRIPLET

######################################
FROM scratch as prod
COPY --from=builder /build/releases/tar /
ENTRYPOINT ["/tar"]
