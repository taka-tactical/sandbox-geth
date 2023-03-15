const { expect } = require("chai");
const { ethers } = require("hardhat");

describe('TestEthereumCoin contract', function () {
    // 発行されたトークンがすべてオーナーに割り当てられているか
    it('Deployment should assign the total supply of tokens to the owner', async function() {
        const [owner] = await ethers.getSigners();

        const factory = await ethers.getContractFactory('TestEthereumCoin');
        const hardhatToken = await factory.deploy();
        const ownerBalance = await hardhatToken.balanceOf(owner.address);

        expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);
    });
});
