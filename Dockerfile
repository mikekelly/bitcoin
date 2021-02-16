FROM debian:bullseye-slim

ENV BITCOIN_VERSION=0.21.0

RUN apt-get update -y && apt-get install -y curl gnupg wget
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
RUN apt-get install -y libevent-dev libboost-system-dev libboost-filesystem-dev libboost-test-dev libboost-thread-dev libsqlite3-dev libdb-dev libdb++-dev

COPY ./ /root/src
WORKDIR /root/src

RUN ./autogen.sh
RUN ./configure --with-incompatible-bdb
RUN make -C src bitcoind bitcoin-cli
RUN make install

RUN mkdir /root/.bitcoin
WORKDIR /root/.bitcoin

RUN bitcoind -version | grep "Bitcoin Core version v${BITCOIN_VERSION}"
CMD ["bitcoind"]
