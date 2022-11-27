FROM devkitpro/devkitppc:20210726
ARG VERSION

ENV PATH="${PATH}:/opt/devkitpro/devkitPPC/bin"
ENV VERSION=${VERSION}

RUN apt-get update && apt-get install make

WORKDIR /build

ENTRYPOINT make VERSION=${VERSION}