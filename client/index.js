const {ethers, Wallet, Contract, providers, BigNumber} = require("ethers");
//Read abi and address of contract
const contractInfo = require("./transferCryptoTestament.json");
let contractABI = contractInfo.abi;
let contractADDRESS = contractInfo.address;
//Get provider
var provider = new providers.JsonRpcProvider("http://localhost:8545");
//Create wallet
const PRIVATEKEY = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
const wallet = new Wallet(PRIVATEKEY, provider);
console.log("Address: " + wallet.address);
var balancePromise = wallet.getBalance();

balancePromise.then(function(balance) {
    let balance_ = BigNumber.from(balance);
    console.log(balance_);
});
//Create contract
const TestamentContract = new Contract(contractADDRESS, contractABI, wallet);
async function main(){
    const owner = await TestamentContract.getOwner();
    console.log("The owner of this testament is: " + owner);
    const mount = await TestamentContract.getMount();
    console.log("The recent mount of this ownner is: " + mount);
    const addBenef = await TestamentContract.addBeneficiary("0x71be63f3384f5fb98995898a86b02fb2426c5788", 2);
}

main();






