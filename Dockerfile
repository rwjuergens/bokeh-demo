FROM alpine:latest
LABEL maintainer="Robert Jürgens <blechritter@me.com>"
WORKDIR /root
ENV LOG_FILE=${LOG_DIR}/app.log
COPY install_sorted.sh ./
# COPY pip.conf /etc/.
COPY myPips.sh ./
ENV MPLLOCALFREETYPE=1
RUN ./install_sorted.sh
# Now build apache-arrow
ARG ARROW_VERSION=5.0.0
# ARG ARROW_SHA1=c1fed962cddfab1966a0e03461376ebb28cf17d3
ARG ARROW_SHA1=f131330dd28fab9313a42ee1f3db766577726600
ARG ARROW_BUILD_TYPE=release

ENV ARROW_HOME=/usr/local 
ENV PARQUET_HOME=/usr/local

#Download and build apache-arrow

RUN mkdir /root/arrow \
    # && wget -q https://github.com/apache/arrow/archive/apache-arrow-${ARROW_VERSION}.tar.gz -O /tmp/apache-arrow.tar.gz \
    && wget -q https://downloads.apache.org/arrow/arrow-${ARROW_VERSION}/apache-arrow-${ARROW_VERSION}.tar.gz -O /tmp/apache-arrow.tar.gz \
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
    && python3 setup.py build_ext --build-type=${ARROW_BUILD_TYPE} --with-parquet --with-dataset  \
    && python3 setup.py install 
# now install all the other Python libraries
RUN ./myPips.sh
EXPOSE 8888
CMD ["/usr/bin/jupyter","lab","--ip=0.0.0.0","--port=8888","--allow-root","--no-browser","--ServerApp.password=sha1:056ece862e9d:1a177ee8724504a1b74f2b735dd2600604afef13"]

