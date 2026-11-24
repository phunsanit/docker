# builder_qnap_qdk

Docker build image for QNAP QDK (`qbuild`) on Ubuntu 22.04 with `rsync` and packaging utilities pre-installed.

## Upstream Reference

- QNAP QDK repository: [https://github.com/qnap-dev/QDK](https://github.com/qnap-dev/QDK)

## Why `rsync` Is Installed

`qbuild` uses `/usr/bin/rsync` internally when copying package payload files (such as architecture binaries and shared files) into its data package staging directory. Installing `rsync` ensures file synchronization succeeds during QPKG builds instead of silently dropping payload files.

## Included Tools

- Base OS: `ubuntu:22.04`
- QNAP QDK (`qbuild`, default `QDK_VER=2.5.3` from [https://github.com/qnap-dev/QDK](https://github.com/qnap-dev/QDK))
- File sync & archive tools: `rsync`, `tar`, `gzip`, `bzip2`, `xz-utils`, `file`, `gawk`, `sed`, `coreutils`, `binutils`
- Image & packaging helpers: `imagemagick`, `fakeroot`, `libglib2.0-0`, `curl`, `wget`, `ca-certificates`

## Build Image

From `/Users/common/Docker/builder_qnap_qdk`:

    docker build --platform linux/amd64 -t qnap_qdk_builder:latest .

Rebuild without layer cache:

    docker build --no-cache --platform linux/amd64 --build-arg QDK_VER=2.5.3 -t qnap_qdk_builder:latest .

## Usage

Run `qbuild` (default entrypoint):

    docker run --rm --platform linux/amd64 -v /path/to/qpkg/project:/workspace -w /workspace qnap_qdk_builder:latest --build-arch arm_64 --build-dir /workspace/build

Verify installed tools (`qbuild` and `rsync`):

    docker run --rm --entrypoint bash --platform linux/amd64 qnap_qdk_builder:latest -c 'qbuild --version && command -v rsync && rsync --version | head -n 1'
