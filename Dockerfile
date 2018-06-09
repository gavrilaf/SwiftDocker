FROM swift:latest

#ADD . /app
#WORKDIR /app

#RUN swift package resolve
#RUN swift build --configuration release

#ENTRYPOINT .build/release/SwiftDocker

ADD . /app
WORKDIR /app

RUN swift package resolve
RUN swift build --configuration release

COPY pkg-swift-deps.sh /usr/bin/pkg-swift-deps
RUN chmod +x /usr/bin/pkg-swift-deps
RUN pkg-swift-deps .build/release/SwiftDocker

FROM busybox:glibc

COPY --from=0 app/swift_libs.tar.gz /tmp/swift_libs.tar.gz
COPY --from=0 app/.build/release/SwiftDocker /usr/bin/

RUN tar -xzvf /tmp/swift_libs.tar.gz && \
    rm -rf /tmp/*

CMD ["SwiftDocker"]