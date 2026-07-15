FROM emscripten/emsdk:3.1.64@sha256:8847dad4171ebc8a53d9ae5cda86a2546ef5b2e68834c14dc1ba2b2962e125cc

# MySQL's release tarballs contain generated parsers; the signed Git tag does
# not. Keep the generator in the build image so the pinned source is enough.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       bison \
       libssl-dev \
    && rm -rf /var/lib/apt/lists/*
