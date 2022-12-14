# sandbox-geth

## Overview

Sandbox for geth private network (POA) built on docker.

\* Japanese version of README is [here](./README_ja.md).

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
  - Install MSYS2 or MinGW or cygwin or similar software
- macOS
  - bash: `chsh -s /bin/bash`
  - make: Install from Homebrew

### Docker, Docker compose

Recommended:
- Docker Desktop
- Rancher Desktop

Or similar software.

### Go Ethereum (geth)

1. Download "Geth & Tools" archive package from [here](https://geth.ethereum.org/downloads/).
2. Extract package to destination directory
3. Create a path

## Usage

### git clone

`--recursive` option is required because submodule is used.

```shell
# cloning via SSH
git clone --recursive "this-repository" /path/to/dest
```

### Initialize nodes and start POA network

```shell
cd /path/to/dest
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

### Execute command(s)

```javascript
Welcome to the Geth JavaScript console!
...
To exit, press ctrl-d or type exit
>
> eth.mining
true
> eth.blockNumber
3
> eth.blockNumber
4
> admin.peers
[{ ... }]
```

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

### Structure

```
.
├── docker              (Docker container definitions)
├── privatenet          (Definition and data of ethereum nodes)
├── utilities           (Scripts to init|create network)
├── docker-compose.yml  (Docker compose definition)
├── Makefile            (Launcher with make command)
├── README.md           (This file)
└── README_ja.md        (README in Japanese)
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
