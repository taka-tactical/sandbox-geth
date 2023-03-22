require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    private: {
      url: "http://127.0.0.1:8545",
      chainId: 12345,
      accounts: [`${process.env.POA_PRIVATE_KEY}`],
    },
  },
  solidity: "0.8.18",
};
