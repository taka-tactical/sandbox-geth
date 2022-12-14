# sandbox-geth

## Overview

gethを使用したイーサリアムのプライベートネットワーク（POA）を作成可能な箱庭環境。

\* English version of README is [here](./README.md).

## システム要件

- bash シェルを動かせること
- make コマンドを使用可能なこと
- Docker
- Docker Compose v2
- Go Ethereum (Geth) 1.10
  - インストーラー形式のものではなく "Geth & Tools" の圧縮ファイル形式のものが必要です

## 事前準備・セットアップ

### bash, make

- Windows
  - bashシェルを動かせる環境が必要
    - MSYS2、MinGW、cygwin 等のbashシェルを動かせる環境をインストールしておく
    - git for windows のbashで代用することも可能
- macOS
  - bash: ターミナルでzshを使用している場合は `chsh -s /bin/bash` でbashに切り替える
    - zshでも動くかもしれないが未確認
  - make: 無い場合は Homebrew 等からインストールしておく

### Docker, Docker compose

以下のいずれかのインストールを推奨:
- Docker Desktop
- Rancher Desktop

上記を導入しない場合は、docker および docker compose の使える環境を手動で用意してください。

### Go Ethereum (geth)

1. "Geth & Tools" 圧縮ファイル形式のものを [公式サイト](https://geth.ethereum.org/downloads/) からダウンロード
2. ダウンロードした圧縮ファイルを任意のディレクトリに解凍、設置する
3. 設置先へのパスを通しておく（bashシェルからパスが通っている必要があります）

## 起動と利用手順

### git clone

submoduleを使用しているので `--recursive` オプションは必須。

```shell
# cloning via SSH
git clone --recursive "this-repository" /path/to/dest
```

### ノードの初期化とプライベートネットワーク（POA）の起動

bashシェル上で次のコマンドを実行。

```shell
cd /path/to/dest
make init
make setup
```

### ローカルgethからの接続

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

### geth上でのコマンド実行

ネットワークに接続（attach）できたらgethのJSコンソールが使用可能になります。

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

### 作成したネットワークの削除とクリーンアップ

```shell
make clean
```

## 機能詳細

### コマンドリファレンス

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

### gethで利用可能なAPIモジュール群

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

### 当リポジトリのディレクトリ構成

```
.
├── docker              (Dockerコンテナ定義)
├── privatenet          (Ethereumネットワークのノードデータなど)
├── utilities           (ノード初期化、ネットワーク構築に使用するスクリプト群)
├── docker-compose.yml  (Docker compose 定義)
├── Makefile            (makeコマンドを使用したランチャー的な。)
├── README.md           (英語README)
└── README_ja.md        (日本語README。当ファイル)
```

## リファレンス

- [Docker](https://www.docker.com/)
- Docker ドキュメント
  - [EN](https://docs.docker.com/)
  - [JA](https://docs.docker.jp/)
- [Go Ethereum](https://geth.ethereum.org/)
  - [Download page](https://geth.ethereum.org/downloads/)

## 作者

[Taka](https://github.com/taka-tactical/)

## ライセンス

[MIT](https://opensource.org/licenses/mit-license.php)
