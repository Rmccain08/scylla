# Minimal base image
FROM ubuntu:22.04

# Set env_vars
ENV BITCOIN_VERSION=22.0
ENV BITCOIN_URL=https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz
ENV BITCOIN_SHA256=59ebd25dd82a51638b7a6bb914586201e67db67b919b2a1ff08925a7936d1b16

# Create a non-root user
RUN useradd -ms /bin/bash bitcoin

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget gnupg2 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Verify and install Bitcoin Core
RUN wget $BITCOIN_URL && \
    echo "$BITCOIN_SHA256  bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz" | sha256sum -c - && \
    tar -xzf bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz && \
    install -m 0755 -o root -g root -t /usr/local/bin bitcoin-$BITCOIN_VERSION/bin/* && \
    rm -rf bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz bitcoin-$BITCOIN_VERSION

# Switch to created user
USER bitcoin

# Expose Bitcoin Core default ports
EXPOSE 8332 8333

# Set the default command to run Bitcoin daemon
CMD ["bitcoind", "-printtoconsole"]

