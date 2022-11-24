# sandbox-geth

## Overview

Sandbox for geth private network (POA) built on docker.

## Requirement

- Bash, make
  - Windows
    - MSYS, cygwin, etc ...
  - macOS
    - Install from Homebrew
- Docker 20.*
- Docker Compose 2.*
- Go Ethereum (Geth) 1.10
  - "Geth & Tools" archive version required, not an installer version

## Usage

### Initialize nodes and start POA network 
```shell
make init
make setup
```

### Attach geth

```shell
geth attach http://127.0.0.1:8545
```

| Node | RPC Port | WS Port | Mining |
|:----:|:--------:|:-------:|:------:|
|  1   |   8545   |  8546   |  Yes   |
|  2   |  18545   |  18546  |  Yes   |
|  3   |  28545   |  28546  |  Yes   |
|  4   |  38545   |  38546  |   No   |
|  5   |  48545   |  48546  |   No   |

### Destroy network

```shell
make clean
```

## Features

### Command reference

```shell
USAGE:
  make command

COMMANDS:
  genesis   Create genesis.json setting (launch puppeth binary)
  init      Initialize nodes
  setup     Build docker containers and start network
  start     Start network
  stop      Stop neiwork
  status    Show docker containers status
  clean     Destroy and clean up network
  check     Check required binaries exists or not
  test      Check network initialized or not
  build     Build docker containers
```

### Available API modules

```javascript
web3
eth
personal
net
miner
txpool
admin
debug
```

## Reference

- [Docker](https://www.docker.com/)
- Docker documentation
  - [EN](https://docs.docker.com/)
  - [JA](https://docs.docker.jp/)
- [Go Ethereum](https://geth.ethereum.org/)
  - [Download page](https://geth.ethereum.org/downloads/)

## Author

[Taka](https://github.com/taka-tactical/)

## Licence

[MIT](https://opensource.org/licenses/mit-license.php)
