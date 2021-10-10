FROM ubuntu:latest

EXPOSE 28444
EXPOSE 28555
EXPOSE 28447

ENV FLORA_ROOT=/root/.flora/mainnet
ENV keys="generate"
ENV harvester="false"
ENV farmer="false"
ENV plots_dir="/plots"
ENV farmer_address="null"
ENV farmer_port="null"
ENV testnet="false"
ENV TZ="UTC"
ENV FLORA_CHECKOUT="dc0c498c811c394a339ccb35fbec330ccdb4b9c4"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y bc curl lsb-release python3 tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3-dev python3.8-venv python3.8-distutils python-is-python3 vim tzdata && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

ARG BRANCH=main

RUN echo "cloning ${BRANCH}" && \
    git clone --branch ${BRANCH} https://github.com/Flora-Network/flora-blockchain.git && \
    cd flora-blockchain && \
    git checkout ${FLORA_CHECKOUT} && \
    git submodule update --init mozilla-ca && \
    chmod +x install.sh && \
    /usr/bin/sh ./install.sh

ENV PATH=/flora-blockchain/venv/bin:$PATH
WORKDIR /flora-blockchain

COPY docker-start.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["docker-start.sh"]