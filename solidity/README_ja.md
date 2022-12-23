# sandbox-geth-solidity

## Overview

gethを使用したイーサリアムのプライベートネットワーク（POA）上でSolidityによるスマートコントラクトを動かしてみる。

## システム要件

- 当プロジェクトのEthereumネットワークが動作可能な要件に準ずる

### Windows環境での注意事項

Windowsの場合、シェルはMSYS2、MinGW、cygwin 等のbashシェルを動かせれば良いですがフロントエンドとしてWindows Terminalを使用することを強く推奨します。

スマートコントラクトのデプロイ手順で長文テキストをgethコンソールに貼り付ける箇所があり、cygwinのターミナルなど一部環境で相性問題と思われる不具合（フリーズ・操作不能に陥る）が発生するためです。Windows Terminalをフロントエンドとすることでこの問題を回避できることを確認済みです。

## 事前準備・セットアップ

`git pull` を行いソースコードを最新化してください。

また、以下を実行してサブモジュール関係も最新化してください。

```shell
cd "プロジェクトのrootディレクトリ"
git submodule update --init --recursive
```

### Ethereumネットワーク

当プロジェクトのrootディレクトリにある [README_ja](../README_ja.md) を参照してPOAネットワークを作成・起動してください。

## 利用手順

### Solidityサンプルコードのコンパイル

bashシェル上で次のコマンドを実行。

```shell
cd "プロジェクトのrootディレクトリ"
cd solidity
make build_hello
```

以下の成果物が出力されます。

```
./src/output/Hello.abi    コンパイルしたスマートコントラクトのABI情報
./src/output/Hello.bin    コンパイルしたスマートコントラクトのデータ
```

その他のファイルは副産物なので無視してOKです。

### ローカルgethへの接続

```shell
geth attach http://127.0.0.1:8545
```

### スマートコントラクトのデプロイ

ネットワークに接続（geth attach）できたらgethのJSコンソールが使用可能になります。
ここからスマートコントラクトをデプロイします。

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
```

まずはデプロイを行うEthereumアカウントを、パスワードを入力してunlockします。

```javascript
personal.unlockAccount(eth.accounts[0])

Passphrase: 12345678
```

続いて、先程コンパイルしたスマートコントラクトの情報を変数に格納します。

```javascript
const abi = [ ... ] // "= " の後に Hello.abi の内容をそのまま貼り付ける
const bin = "0x..." // "0x" の後に Hello.bin の内容をそのまま貼り付ける
```

デプロイ実行。

```javascript
// コントラクトのインスタンスを作成
const contract = eth.contract(abi)

// ガス代を算出
const gas = eth.estimateGas({data: bin})

// デプロイ
const tx = {'from': eth.accounts[0], data: bin, gas: gas}
const deployed_one = contract.new(tx)
```

以下をタイプして address が空でなければデプロイ成功（＝マイニングされた）となります。
address の値はスマートコントラクトの実行に必要なので手元に控えておいてください。
```javascript
> deployed_one

{
  abi: [{
    inputs: [],
    name: "name",
    outputs: [{...}],
    stateMutability: "view",
    type: "function"
  }, {
    inputs: [],
    name: "sayHello",
    outputs: [{...}],
    stateMutability: "view",
    type: "function"
  }, {
    inputs: [{...}],
    name: "setName",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function"
  }],
  address: "0x...",
  transactionHash: "0x...",
  allEvents: function bound(),
  name: function bound(),
  sayHello: function bound(),
  setName: function bound()
}
```

### スマートコントラクトを動かしてみよう

デプロイ成功時の address を使ってスマートコントラクトを呼び出します。

```javascript
const instance = contract.at(deployed_one.address) // addressの値でスマコンを呼び出す
```

スマートコントラクトの状態を変更しない場合は、トランザクションなしでメソッドを実行します。`コントラクトオブジェクト.メソッド名.call()` で呼び出します。

```javascript
instance.name.call()

"Solidity"

instance.sayHello.call()

"Hello Solidity!"
```

スマートコントラクトの状態を変更する場合（＝ブロックチェーンネットワークにデータを書き込む＝状態の変化を生む）は sendTransaction() メソッドを使用します。
`コントラクトオブジェクト.メソッド名.sendTransaction()` で呼び出します。

```javascript
instance.setName.sendTransaction('Ethereum', {'from': eth.accounts[0]})

"0x..."

instance.name.call()

"Ethereum"

instance.sayHello.call()

"Hello Ethereum!"
```


### クリーンアップ

```shell
make destroy
```

POAネットワークも削除する場合は [こちら](../README_ja.md) を参照してください。

## 機能詳細

### コマンドリファレンス

```shell
USAGE:
  make command

COMMANDS:
  build_hello   Build sample smart contract
  clean         Delete contents of output directory
  destroy       Destroy and clean up network
```

## リファレンス

- [スマートコントラクト入門](https://tech.isid.co.jp/entry/2022/01/17/%E3%82%B9%E3%83%9E%E3%83%BC%E3%83%88%E3%82%B3%E3%83%B3%E3%83%88%E3%83%A9%E3%82%AF%E3%83%88%E5%85%A5%E9%96%80)
- [【Solidity入門】まず最初にSolidityで覚えるべき基本構文まとめ](https://qiita.com/sho11hei12-1998/items/31ed7c5d4c2f34409223)

## 作者

[Taka](https://github.com/taka-tactical/)

## ライセンス

[MIT](https://opensource.org/licenses/mit-license.php)
