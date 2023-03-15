require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    private: {
      url: "http://127.0.0.1:8545",
      chainId: 12345,
    },
  },
  solidity: "0.8.18",
};
