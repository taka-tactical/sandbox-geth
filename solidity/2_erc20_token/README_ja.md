# sandbox-geth-erc20token

## Overview

gethを使用したイーサリアムのプライベートネットワーク（POA）上で、Solidity + OpenZeppelin + HradhatによるERC20トークンのスマートコントラクトを動かしてみる。

## システム要件

- 当プロジェクトのEthereumネットワークが動作可能な要件に準ずる
- Node.js LTS（2023-03時点ではv18系）がインストールされておりPATHが通っている

### Windows環境での注意事項

Windowsの場合、シェルはMSYS2、MinGW、cygwin 等のbashシェルを動かせれば良いがフロントエンドとしてWindows Terminalを使用することを強く推奨。

# 事前準備・セットアップ

`git pull` を行いソースコードを最新化しておく。

## Ethereumネットワーク

当プロジェクトのrootディレクトリにある [README_ja](../../README_ja.md) を参照してPOAネットワークを作成・起動。

## Ethereumウォレットアプリ

発行したERC20トークンの残高表示、送金確認を行えるウォレットアプリを用意する。

便宜上ここでは導入のための敷居が低く情報も多いMETAMASKを使用して説明を進めるが、独自のEthereumuネットワークを追加することが可能かつERC20トークンを扱うことが出来るウォレットアプリであれば何を使用してもOK。

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
インポートにはしばらく時間がかかるのでそのまま待つ。

| 項目名   | 値        |
|-------|----------|
| パスワード | 12345678 |

しばらくするとMETAMASKの画面が切り替わり、多量のETHを保持するアカウントが表示されればインポート完了。

### 3. 初期アカウントの秘密鍵を取得

デプロイに必要となるアカウントの秘密鍵を取得する。<br>
METAMASKの画面を開いて上記 2. でインポートしたアカウントを選択し、メニューから秘密鍵のエクスポートを選択して実行。

エクスポートした秘密鍵は後述する `.env` ファイルに記述するので手元に控えておく。

### 4. 送金先アカウントの作成（任意）

上記の 1. で登録した private poa geth ネットワークに送金先となるアカウントを用意する。

- METAMASKの機能を使って新規に作成する
- 手持ちの既存アカウントを private poa geth ネットワークで使う

上記のどちらでもOK。

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
POANET_PRIVATE_KEY="上記 3. でエクスポートした秘密鍵"
```

## Solidityコードのコンパイルとテスト

### 5. コンパイル

bashシェル上で次のコマンドを実行。<br>
contracts ディレクトリ配下の .sol ファイルがコンパイルされる。

```shell
npx hardhat clean
npx hardhat --network private compile
```

コンソールに `Compiled *** Solidity files successfully` と表示されればコンパイル成功。
以下の成果物が出力される。

```
./artifacts/    コンパイルしたスマートコントラクトの情報
./cache/        キャッシュデータ
```

- デプロイ時は透過的にコンパイル実行されるためコンパイルの手動実行は必須ではない
- コンパイル済みのスマートコントラクト情報を取得したりエラーの有無を確認したい場合には有用

### 6. ユニットテスト

bashシェル上で次のコマンドを実行。<br>
test ディレクトリ配下の .js ファイルが読み込まれてテスト実行される。

```shell
npx hardhat test
```

- テストに先駆けて自動でデプロイ処理が行われる
- ユニットテストの実行にネットワークを指定することも可能
  - 未指定の場合は hardhat.config.js の `defaultNetwork` が適用される
    - デフォルトで hardhat 内部の揮発的なネットワークが使用される（ゴミが残らないためテストに便利）

## スマートコントラクトのデプロイ

bashシェル上で次のコマンドを実行。<br>
hardhatを使用してスマートコントラクトをデプロイする。

```shell
npx hardhat --network private run scripts/deploy.js
```

コンソールに以下の内容が表示されたらデプロイ完了。

```shell
Deployed contracts address: 0x...

Deployed hash (tx hash) is: 0x...
```

前者の `Deployed contracts address` がスマートコントラクトのデプロイ先アドレスとなるので手元に控えておく。

## スマートコントラクトを動かしてみよう

デプロイ成功時のアドレスを使ってスマートコントラクトを呼び出すことで、METAMASKからトークンの残高を確認したり他のアカウントに送金することが可能となる。

### 7. METAMASKにERC20トークンを認識させる

METAMASKの画面を開き 1. で登録した private poa geth ネットワークを選択。<br>
次に 2. でインポートしたアカウントを選択。

「トークンをインポート」メニューをクリックして以下の内容を入力し、独自発行したERC20トークン（先程デプロイしたスマートコントラクト）を認識させる。

| 項目名            | 値                                        |
|----------------|------------------------------------------|
| トークンコントラクトアドレス | デプロイ完了時に表示された Deployed contracts address |
| トークンシンボル       | ※自動的に反映されるので不要                           |
| トークンの小数桁数      | ※自動的に反映されるので不要                           |

カスタムトークンを追加＞トークンをインポート、と進むとERC20トークンが当該アカウントの画面で表示される。
この操作をアカウント毎に繰り返すことで任意のアカウントで独自トークンを扱うことが出来るようになる。

### 8. ERC20トークンを送金してみる

上記 7. の手順を踏むことで初期アカウントに `7,777,777 TEC` （TEC = 独自トークンの通貨記号）の残高があることが確認できるようになるので、

- 残高表示をクリック
  - 送金
    - 送金先の選択から「自分のアカウント間での振替」を選択すると 4. で用意した別アカウントが表示される
      - これを選択して任意の送金額を入力
        - 次へ
          - 確認

と進むことで送金が実行されます。

### 9. 残高の変動を確認する

しばらく待つとMETAMASKの画面がトランザクション完了＝送金が実行された旨の表示に変わるので送金元、送金先のアカウントを切り替えてERC20トークンの残高が変動していることを確認できる。

```
送金元の「送金前残高」 = 送金元の「送金後残高」 + 送金先の「送金後残高」
```

となっていれば成功。

## クリーンアップ

```shell
npx hardhat clean
```

POAネットワークも削除する場合は [こちら](../../README_ja.md) を参照。

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
