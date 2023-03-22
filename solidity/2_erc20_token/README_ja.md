# sandbox-geth-erc20token

## Overview

gethを使用したイーサリアムのプライベートネットワーク（POA）上で、Solidity + OpenZeppelin + HradhatによるERC20トークンのスマートコントラクトを動かしてみる。

## システム要件

- 当プロジェクトのEthereumネットワークが動作可能な要件に準ずる
- Node.js LTS（2023-03時点ではv18系）がインストールされておりPATHが通っている

### Windows環境での注意事項

Windowsの場合、シェルはMSYS2、MinGW、cygwin 等のbashシェルを動かせれば良いですがフロントエンドとしてWindows Terminalを使用することを強く推奨します。

# 事前準備・セットアップ

`git pull` を行いソースコードを最新化してください。

## Ethereumネットワーク

当プロジェクトのrootディレクトリにある [README_ja](../../README_ja.md) を参照してPOAネットワークを作成・起動。

## Ethereumウォレットアプリ

発行したERC20トークンの残高表示、送金確認を行えるウォレットアプリを用意します。

便宜上ここでは導入のための敷居が低く情報も多いMETAMASKを使用して説明を進めますが、独自のEthereumuネットワークを追加することが可能かつERC20トークンを扱うことが出来るウォレットアプリであれば何を使用しても構いません。

### 1. Ethereumネットワークの追加

ブラウザにインストールしたMETAMASKプラグイン（以下、 METAMASKと称する）の設定画面を開き、起動してあるPOAネットワークの情報を登録。

| 項目名     | 値                      |
|---------|------------------------|
| ネットワーク名 | private poa geth       |
| RPC URL | http://localhost:8545/ |
| チェーンID  | 12345                  |
| 通貨記号    | ETH                    |

### 2. Ethereumネットワークの初期アカウントをMETAMASKに登録

METAMASKの画面を開き 1. で登録した private poa geth ネットワークを選択。<br>
次にアカウントメニューから「アカウントのインポート」を選択。

表示された画面でインポートの種類からJSONファイルを選び、ファイルの選択ダイアログから `プロジェクトのrootディレクトリ/docker/geth-signer/accounts/UTC--2022-11-21T00-08-39.501620000Z--2842d8c1f3dc36394337e8289c63634f8b77f0ae` を選択。

最後にパスワードを入力してインポートを実行。
インポートにはしばらく時間がかかるのでそのままお待ちください。

| 項目名   | 値        |
|-------|----------|
| パスワード | 12345678 |

しばらくするとMETAMASKの画面が切り替わり、多量のETHを保持するアカウントが表示されればインポート完了。

### 3. 初期アカウントの秘密鍵を取得

デプロイに必要となるアカウントの秘密鍵を取得します。<br>
METAMASKの画面を開いて上記 2. でインポートしたアカウントを選択し、メニューから秘密鍵のエクスポートを選択して実行。

エクスポートした秘密鍵は後述する `.env` ファイルに記述するので手元に控えておいてください。

### 4. 送金先アカウントの作成（任意）

上記の 1. で登録した private poa geth ネットワークに送金先となるアカウントを用意します。
METAMASKの機能を使って新規に作成する、あるいは手持ちの既存アカウントを private poa geth ネットワークで使うのでも構いません。

# 利用手順

## npmモジュールのインストール

当READMEが設置されているディレクトリから、bashシェル上で次のコマンドを実行。

```shell
cd "プロジェクトのrootディレクトリ"
cd solidity/2_erc20_token/
npm install
```

## .env の設定

bashシェル上で次のコマンドを実行。

```shell
cp sample.env .env
```

生成された .env ファイルを開いて以下の設定を書き加え、保存。

```
POA_PRIVATE_KEY="上記 3. でエクスポートした秘密鍵"
```

## Solidityサンプルコードのコンパイル

bashシェル上で次のコマンドを実行。<br>
contracts ディレクトリ配下の .sol ファイルがコンパイルされます。

```shell
npx hardhat clean
npx hardhat --network private compile
```

コンソールに `Compiled *** Solidity files successfully` と表示されればコンパイル成功です。
以下の成果物が出力されます。

```
./artifacts/    コンパイルしたスマートコントラクトの情報
./cache/        キャッシュデータ
```

- デプロイ時は透過的にコンパイルも実行されるのでコンパイルの手順は必須ではありません
- コンパイル済のスマートコントラクト情報を取得したりエラーの有無を確認したい場合に有用です

## スマートコントラクトのデプロイ

bashシェル上で次のコマンドを実行。<br>
hardhatを使用してスマートコントラクトをデプロイします。

```shell
npx hardhat --network private run scripts/deploy.js
```

コンソールに以下の内容が表示されたらデプロイ完了です。

```shell
Deployed contracts address: 0x...

Deployed hash (tx hash) is: 0x...
```

前者の `Deployed contracts address` がスマートコントラクトのデプロイ先アドレスとなるので手元に控えておいてください。

## スマートコントラクトを動かしてみよう

デプロイ成功時のアドレスを使ってスマートコントラクトを呼び出します。<br>
METAMASKから発行したトークンの残高を確認したり他のアカウントに送金することが可能になります。

### 5. METAMASKにERC20トークンを認識させる

METAMASKの画面を開き 1. で登録した private poa geth ネットワークを選択。
次に 2. でインポートしたアカウントを選択。

「トークンをインポート」メニューをクリックして以下の内容を入力し、独自発行したERC20トークン（先程デプロイしたスマートコントラクト）を認識させます。

| 項目名            | 値                                        |
|----------------|------------------------------------------|
| トークンコントラクトアドレス | デプロイ完了時に表示された Deployed contracts address |
| トークンシンボル       | ※自動的に反映されるので不要                           |
| トークンの小数桁数      | ※自動的に反映されるので不要                           |

カスタムトークンを追加＞トークンをインポート、と進めるとERC20トークンが当該アカウントの画面で表示されるようになります。

この操作をアカウント単位に繰り返すことで、任意のアカウントで独自トークンを扱うことが出来るようになります。

### 6. ERC20トークンを送金してみる

上記 5. の手順を踏むことで初期アカウントに 7,777,777 TEC（独自トークン）の残高があることが確認できるようになります。

この残高表示をクリック<br>
　＞送金<br>
　　＞送金先の選択から「自分のアカウント間での振替」を選択すると 4. で用意した別アカウントが表示される<br>
　　　＞これを選択して任意の送金額を入力<br>
　　　　＞次へ<br>
　　　　　＞確認

と進むことで送金が実行されます。

### 7. 残高の変動を確認する

しばらく待つとMETAMASKの画面がトランザクション完了＝送金が実行された旨の表示に変わるので送金元、送金先のアカウントを切り替えてERC20トークンの残高が変動していることを確認します。

```
送金元アカウントの「送金前の残高」 = 送金元アカウントの「送金後の残高」＋送金先アカウントの「送金後の残高」
```

となっていれば成功です。

## クリーンアップ

```shell
npx hardhat clean
```

POAネットワークも削除する場合は [こちら](../../README_ja.md) を参照してください。

## 機能詳細

### hardhat コマンドリファレンス

```shell
USAGE:
  npx hardhat [GLOBAL OPTIONS] <TASK> [TASK OPTIONS]

GLOBAL OPTIONS:

  --config              A Hardhat config file.
  --emoji               Use emoji in messages.
  --flamegraph          Generate a flamegraph of your Hardhat tasks
  --help                Shows this message, or a task's help if its name is provided
  --max-memory          The maximum amount of memory that Hardhat can use.
  --network             The network to connect to.
  --show-stack-traces   Show stack traces (always enabled on CI servers).
  --tsconfig            A TypeScript config file.
  --typecheck           Enable TypeScript type-checking of your scripts/tests
  --verbose             Enables Hardhat verbose logging
  --version             Shows hardhat's version.


AVAILABLE TASKS:

  check                 Check whatever you need
  clean                 Clears the cache and deletes all artifacts
  compile               Compiles the entire project, building all artifacts
  console               Opens a hardhat console
  coverage              Generates a code coverage report for tests
  flatten               Flattens and prints contracts and their dependencies. If no file is passed, all the contracts in the project will be flattened.
  gas-reporter:merge
  help                  Prints this message
  node                  Starts a JSON-RPC server on top of Hardhat Network
  run                   Runs a user-defined script after compiling the project
  test                  Runs mocha tests
  typechain             Generate Typechain typings for compiled contracts
  verify                Verifies contract on Etherscan

To get help for a specific task run: npx hardhat help [task]
```

## リファレンス

- [OpenZeppelin Contracts Wizard](https://wizard.openzeppelin.com/)
- [Hardhat Configuration | Ethereum development environment for professionals by Nomic Foundation](https://hardhat.org/hardhat-runner/docs/config)
- [Hardhatで始めるスマートコントラクト開発 | DevelopersIO](https://dev.classmethod.jp/articles/hardhat-quick-start/)
- [【保存版】Hardhatによるコントラクトのデプロイ方法について](https://note.com/standenglish/n/ndec5e4c69663)
- [Solidity言語メモ](https://qiita.com/hkiridera/items/a7a38fdb677fc9bd67ae)

## 作者

[Taka](https://github.com/taka-tactical/)

## ライセンス

[MIT](https://opensource.org/licenses/mit-license.php)
