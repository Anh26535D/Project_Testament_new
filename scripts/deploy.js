// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const { ethers } = require("hardhat");
const fs = require('fs');

async function main(){
    const [deployer] = await ethers.getSigners();
    console.log('Deploying contracts with the account: ' + deployer.address);

    const balance = await deployer.getBalance();
    console.log('Account balance: ' + balance.toString());

    const transTesta = await ethers.getContractFactory('transferCryptoTestament');
    const transtesta = await transTesta.deploy();

    console.log('Transtesta contract address:' + transtesta.address);

    const data_transtesta = {
        address: transtesta.address,
        abi: JSON.parse(transtesta.interface.format('json'))
    };

    fs.writeFileSync('client/transferCryptoTestament.json', JSON.stringify(data_transtesta));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
