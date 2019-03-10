FROM alpine

# Install Bitcoin Core runtime dependencies
RUN apk update && \
apk add libevent boost libressl miniupnpc zeromq

# install and remove compile time dependencies
# create dedicated user
# compile and install Bitcoin Core
## Make this layer compact
RUN addgroup -S bitcoin && \
adduser -h /bitcoin -g bitcoin -S -s /bin/sh bitcoin && \
cd /bitcoin && \
apk add --virtual build_deps build-base autoconf automake libtool libevent-dev boost-dev libressl-dev zeromq-dev wget && \
wget https://github.com/bitcoin/bitcoin/archive/v0.17.1.tar.gz && \
echo "45105e8a51b29c1d0b00dc3a49313632bc645c2aa57ea24027aed9ea  v0.17.1.tar.gz" | sha3sum -c - && \
tar -xzf v0.17.1.tar.gz && cd bitcoin-0.17.1 && \
./autogen.sh && ./configure --disable-wallet --with-gui=no && make -j4 && make install-strip && \
cd .. && rm -rf bitcoin-0.17.1 v0.17.1.tar.gz && \
apk del build_deps

USER bitcoin:bitcoin

WORKDIR /bitcoin

ENTRYPOINT /usr/local/bin/bitcoind -datadir=/bitcoin -txindex -rpcuser=keep-the-RPC-port-closed -rpcpassword=keep-the-RPC-port-closed -zmqpubrawblock=tcp://127.0.0.1:28332 -zmqpubrawtx=tcp://127.0.0.1:28333 -maxuploadtarget=20000

