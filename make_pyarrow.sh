#!/usr/bin/env /bin/sh

ARG ARROW_VERSION=3.0.0
ARG ARROW_SHA1=c1fed962cddfab1966a0e03461376ebb28cf17d3
ARG ARROW_BUILD_TYPE=release

ENV ARROW_HOME=/usr/local 
ENV PARQUET_HOME=/usr/local

#Download and build apache-arrow

RUN mkdir /root/arrow \
    && wget -q https://github.com/apache/arrow/archive/apache-arrow-${ARROW_VERSION}.tar.gz -O /tmp/apache-arrow.tar.gz \
    && echo "${ARROW_SHA1} *apache-arrow.tar.gz" | sha1sum /tmp/apache-arrow.tar.gz \
    && tar -xvf /tmp/apache-arrow.tar.gz -C /root/arrow --strip-components 1 \
    && mkdir -p /root/arrow/cpp/build \
    && cd /root/arrow/cpp/build \
    && cmake -DCMAKE_BUILD_TYPE=$ARROW_BUILD_TYPE \
        -DOPENSSL_ROOT_DIR=/usr/local/ssl \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_INSTALL_PREFIX=$ARROW_HOME \
        -DARROW_WITH_BZ2=ON \
        -DARROW_WITH_ZLIB=ON \
        -DARROW_WITH_ZSTD=ON \
        -DARROW_WITH_LZ4=ON \
        -DARROW_WITH_SNAPPY=ON \
        -DARROW_PARQUET=ON \
        -DARROW_PYTHON=ON \
	-DARROW_DATASET=ON \
        -DARROW_PLASMA=ON \
        -DARROW_BUILD_TESTS=OFF \
        .. \
    && make -j$(nproc) \
    && make install \
    && cd /root/arrow/python \
    && python3 setup.py build_ext --build-type=$ARROW_BUILD_TYPE --with-parquet \
    && python3 setup.py install 
