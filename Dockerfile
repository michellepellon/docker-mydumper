FROM alpine:3.19.0

LABEL maintainer="Michelle Pellon <mgracepellon@gmail.com>"

ENV PACKAGES="mysql-client=10.11.5-r3 bash=5.2.21-r0" \
    LIB_PACKAGES="glib-dev=2.78.3-r0 mariadb-dev=10.11.5-r3 zlib-dev=1.3-r2 pcre-dev=8.45-r3 openssl-dev=3.1.4-r2" \
    BUILD_PACKAGES="cmake=3.27.8-r0 build-base=0.5-r3 git=2.43.0-r0" \
    BUILD_PATH="/opt/mydumper-src/" \
    MYDUMPER_VERSION="v0.15.1-3"

RUN apk --no-cache add \
        $PACKAGES \
        $BUILD_PACKAGES \
        $LIB_PACKAGES

RUN git clone https://github.com/mydumper/mydumper.git $BUILD_PATH

WORKDIR $BUILD_PATH

RUN git checkout $MYDUMPER_VERSION

COPY CMakeLists.txt /opt/mydumper-src/CMakeLists.txt

RUN cmake . && \
    make && \
    mv ./mydumper /usr/bin/. && \
    mv ./myloader /usr/bin/. && \
    cd / && rm -rf $BUILD_PATH && \
    apk del cmake build-base git && \
    rm -f /usr/lib/*.a && \
    (rm "/tmp/"* 2>/dev/null || true) && \
    (rm -rf /var/cache/apk/* 2>/dev/null || true)

# Compilation outputs both mydumper and myloader binaries.
CMD [ "bash", "-c", "echo 'This Docker image contains both mydumper and myloader binaries. Run the container by invoking either mydumper or myloader as first argument.'" ]
