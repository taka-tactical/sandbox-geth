// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  //
  // 引数付きで Lock.deploy() メソッドを呼ぶと「too many arguments」と怒られるので引数付けない方が良い模様。
  // https://qiita.com/FinanceMofumofu/items/a46488333fbee819bb01
  //
  const factory = await hre.ethers.getContractFactory("TestNfToken");
  const tnt = await factory.deploy();

  // デプロイ実行
  await tnt.deployed();

  // コントラクトアドレス
  console.log("\nDeployed contracts address:", tnt.address);
  // トランザクションハッシュ（TXアドレス）
  console.log("\nDeployed hash (tx hash) is:", tnt.deployTransaction.hash, "\n");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
