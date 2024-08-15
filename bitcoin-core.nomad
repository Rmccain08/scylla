job "bitcoin-core-job" {
  datacenters = ["dc1"]

  group "bitcoin-core-group" {
    network {
      port "rpc" {
        static = 8332
      }

      port "p2p" {
        static = 8333
      }
    }

    task "bitcoin-core" {
      driver = "docker"

      config {
        image = "bitcoin:22.0"
        command = "bitcoind"
        args = [
          "-printtoconsole",
          "-server=1",
          "-rpcuser=bitcoinrpc",
          "-rpcpassword=Passw0rd!",
          "-rpcallowip=0.0.0.0/0",
          "-rpcbind=0.0.0.0",
          "-rpcport=8332",
          "-listen=1",
          "-port=8333"
        ]
      }

      resources {
        cpu    = 500
        memory = 512
      }

      service {
        name = "bitcoin-core"
        port = "rpc"
        tags = ["rpc"]
      }

      service {
        name = "bitcoin-core-p2p"
        port = "p2p"
        tags = ["p2p"]
      }
    }
  }
}

