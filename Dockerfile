## -*- docker-image-name: "actian/vectortest" -*-

FROM centos:7
# Docker file for Actian Vector Community Edition
LABEL com.actian.vendor="Actian Corporation" \
      description="Actian Vector Testing image"

# Pull dependencies
RUN yum install -y libaio util-linux-ng sudo net-tools iproute nmap-ncat openssh-server which

ADD startup.sh /usr/local/bin/startup.sh

# This Dockerfile will work with any community linux version that follows this naming convention
ENV VECTOR_ARCHIVE actian-vector-*-community-linux-x86_64*
ENV II_SYSTEM /VectorVW

# Pull in Vector saveset
ADD ${VECTOR_ARCHIVE}.tgz .

# Install Vector
RUN cd $VECTOR_ARCHIVE && ./install.sh -express $II_SYSTEM VW -noad -nodemo && hostname > /tmp/hostname.build
ADD java.sh /etc/profile.d/java.sh
ADD ema_check_vector.sh /VectorVW/ingres/iiema/plugins/ema_check_vector
ADD vectorEMA.jar /VectorVW/ingres/iiema/plugins/vectorEMA.jar
ADD vectorh.conf /VectorVW/ingres/iiema/data/vectorh.conf

# fixup the installation with container specific stuff
RUN 	ssh-keygen -A && \
	cp $II_SYSTEM/ingres/.ingVWsh /etc/profile.d/vectorVW.sh && \
	chown -R actian $II_SYSTEM/ingres/iiema && \
	chmod ugo+rx $II_SYSTEM/ingres/iiema/plugins/ema_check_vector && \
	source /etc/profile.d/vectorVW.sh && \
	sed -i -e "s,`cat /tmp/hostname.build`,localhost,g" -e '/ingstart.*rmcmd/d' -e '/ingstart.*mgmtsvr/d' $II_SYSTEM/ingres/files/config.dat && \
	ingsetenv II_HOSTNAME localhost && \
	ln -s $II_SYSTEM/ingres/utility/dockerctl /usr/local/bin/dockerctl

EXPOSE 22 27832 27839

# TEMPORARY until we get "secrets" working
RUN echo actian | passwd --stdin actian
RUN su - actian -c 'ingstart && echo "alter user actian with password =actian;commit;\\p\\g" | sql -s iidbdb'

ENTRYPOINT ["sh", "startup.sh"]
