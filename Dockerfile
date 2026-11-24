FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG QDK_VER=2.5.3

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    binutils \
    bzip2 \
    ca-certificates \
    coreutils \
    curl \
    fakeroot \
    file \
    gawk \
    gzip \
    imagemagick \
    libglib2.0-0 \
    rsync \
    sed \
    tar \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    mkdir -p /tmp/qdk_setup; \
    wget -q "https://github.com/qnap-dev/QDK/releases/download/v${QDK_VER}/qdk_${QDK_VER}_amd64.deb" -O /tmp/qdk_setup/qdk.deb; \
    dpkg-deb -x /tmp/qdk_setup/qdk.deb /; \
    rm -rf /tmp/qdk_setup; \
    if [ -f /usr/share/QDK/bin/qbuild ]; then \
        ln -sf /usr/share/QDK/bin/qbuild /usr/local/bin/qbuild; \
        ln -sf /usr/share/QDK/bin/qpkg_dump /usr/local/bin/qpkg_dump 2>/dev/null || true; \
    fi

ENV PATH="/usr/share/QDK/bin:${PATH}"

RUN qbuild --version && rsync --version | head -n 1

WORKDIR /workspace

ENTRYPOINT ["qbuild"]
CMD ["--help"]
