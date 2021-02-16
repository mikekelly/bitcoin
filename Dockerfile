FROM debian:bullseye-slim

ENV BITCOIN_VERSION=0.21.0
ENV BITCOIN_DATA=/home/bitcoin/.bitcoin

RUN useradd -r bitcoin
RUN apt-get update -y && apt-get install -y curl gnupg wget

# deps
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
RUN apt-get install -y libevent-dev libboost-system-dev libboost-filesystem-dev libboost-test-dev libboost-thread-dev libsqlite3-dev libdb-dev libdb++-dev

COPY ./ /home/bitcoin/src
WORKDIR /home/bitcoin/src

RUN ./autogen.sh
RUN ./configure --with-incompatible-bdb
RUN make -j"$(($(nproc)+1))" -C src bitcoind bitcoin-cli
RUN make -j"$(($(nproc)+1))" install

RUN bitcoind -version | grep "Bitcoin Core version v${BITCOIN_VERSION}"
CMD ["bitcoind"]
