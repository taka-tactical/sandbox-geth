require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

/** @type import('hardhat/config').NetworksUserConfig */
var networks = {
  private: {
    url: "http://127.0.0.1:8545",
    chainId: 12345,
    accounts: [`0x${process.env.POANET_PRIVATE_KEY}`],
  },
};

if (process.env.GOERLI_API_URL !== '' && process.env.GOERLI_PRIVATE_KEY !== '') {
  networks['goerli'] = {
    url: process.env.GOERLI_API_URL,
    accounts: [`0x${process.env.GOERLI_PRIVATE_KEY}`],
  };
}

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  defaultNetwork: "hardhat",
  networks: networks,
  etherscan: {
    apiKey: `${process.env.ETHERSCAN_API_KEY}`,
  },
};
