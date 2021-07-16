FROM alpine
LABEL maintainer="Robert Jürgens <blechritter@me.com>"
WORKDIR /root
ENV LOG_FILE=${LOG_DIR}/app.log
COPY install.sh ./
COPY install-py.sh ./
ENV MPLLOCALFREETYPE=1
RUN ./install.sh
COPY pip.conf /etc/.
RUN ./install-py.sh
EXPOSE 8888
CMD ["/usr/bin/jupyter","lab","--ip=0.0.0.0","--allow-root","--LabApp.password='sha1:b131ee8c3209:de079ff5e0d8d4fa1c7dfe40672bfcf2ac894fb9'"]

