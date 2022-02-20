FROM ubuntu:20.04

RUN apt update

# Build and install cmake 3.22.2 from source
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes libssl-dev wget build-essential
WORKDIR /opt
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2.tar.gz
RUN tar xzf cmake-3.22.2.tar.gz
WORKDIR /opt/cmake-3.22.2
RUN ./configure
RUN make -j4
RUN make install

# Build libresect.so
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install --yes ninja-build git python3 libtool zlib1g-dev
WORKDIR /opt
RUN git clone https://github.com/borodust/libresect.git
WORKDIR /opt/libresect
RUN git checkout v1.0.0-rc1
RUN git submodule update --init --recursive
RUN ./build_clang.sh
RUN mkdir -p build/resect/
WORKDIR /opt/libresect/build/resect/
RUN /usr/local/bin/cmake -DCMAKE_BUILD_TYPE=Release ../../ && /usr/local/bin/cmake --build .
