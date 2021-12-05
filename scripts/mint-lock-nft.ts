// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from 'hardhat'
import { AesNFT__factory as AesNFTFactory } from '../typechain'
import { Locker__factory as LockerFactory } from '../typechain'

async function main() {
  const [owner] = await ethers.getSigners()

  const lockerAddr = '0x5fbdb2315678afecb367f032d93f642f64180aa3'
  const aesNftAddr = '0xe7f1725e7734ce288f8367e1bb143e90bb3f0512'
  const aesCosmosAddr = 'aes10yzuqe0k64fajvhdsr0pgewqe2pxytgr5ccvzu';

  const aesNFTContract = await AesNFTFactory.connect(aesNftAddr, owner)
  const lockerContract = await LockerFactory.connect(lockerAddr, owner)

  // mint nft
  await aesNFTContract.mint(owner.address)
  const tokenId = await aesNFTContract.getTokenId()

  // approve and lock nft
  await aesNFTContract.approve(lockerAddr, tokenId)
  await lockerContract.lock(aesNftAddr, tokenId, aesCosmosAddr)
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
