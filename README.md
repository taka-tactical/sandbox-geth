# sandbox-geth

## Overview

Sandbox for geth private network (POA) built on docker.

## Requirement

- bash
- make
- Docker
- Docker Compose v2
- Go Ethereum (Geth) 1.10
  - "Geth & Tools" archive version required, not an installer version

## Setup

### bash, make

- Windows
  - Install MSYS | MinGW | cygwin or similar software
- macOS
  - bash: `chsh -s /bin/bash`
  - make: Install from Homebrew

### Docker, Docker compose

Recommended:
- Docker Desktop
- Rancher Desktop

Or similar software.

### Go Ethereum

1. Download "Geth & Tools" archive package from [here](https://geth.ethereum.org/downloads/).
2. Extract package to destination directory
3. Create a path

## Usage

### Initialize nodes and start POA network 
```shell
make init
make setup
```

### Attach

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
  build     Build docker containers
  init      Initialize nodes
  setup     Build docker containers and start network
  start     Start network
  stop      Stop neiwork
  status    Show docker containers status
  clean     Destroy and clean up network
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
