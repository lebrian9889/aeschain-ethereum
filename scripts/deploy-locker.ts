// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import { Locker__factory as LockerFactory } from '../typechain';

async function main() {
  const [owner] = await ethers.getSigners();

  const lockerInstance = await new LockerFactory(owner).deploy();
  const lockerContract = await lockerInstance.deployed();

  console.log('Locker address: ', lockerContract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
