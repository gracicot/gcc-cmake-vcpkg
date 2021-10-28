ARG GCC_VERSION=11.2
FROM gcc:${GCC_VERSION}

# We install perl for openssl build using vcpkg
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install \
	curl \
	ninja-build \
	unzip \
	zip \
	tar \
	make \
	perl \
	pkg-config \
	git

ENV VCPKG_FORCE_SYSTEM_BINARIES=1

RUN mkdir /opt/cmake && \
	curl -s "https://cmake.org/files/v3.21/cmake-3.21.1-linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /opt/cmake

ENV PATH="/opt/cmake/bin:/opt/vcpkg:${PATH}"

RUN mkdir /opt/vcpkg \
	&& curl -L -s "https://github.com/microsoft/vcpkg/tarball/025e564979cc01d0fbc5c920aa8a36635efb01bb" | tar --strip-components=1 -xz -C /opt/vcpkg \
	&& /opt/vcpkg/bootstrap-vcpkg.sh -disableMetrics -useSystemBinaries \
	&& /opt/vcpkg/vcpkg integrate install \
	&& /opt/vcpkg/vcpkg integrate bash

ENV VCPKG_ROOT="/opt/vcpkg"
