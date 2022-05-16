import {ethers} from 'ethers';
const Wallet = ethers.Wallet;
const provider = ethers.providers;

const PRIVATEKEY = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
const wallet = new Wallet(PRIVATEKEY);
console.log("Address: " + wallet.address);