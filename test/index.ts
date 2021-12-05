import { BigNumber } from '@ethersproject/bignumber';
import { expect } from "chai";
import { ethers } from "hardhat";
import { AesNFT, Locker } from '../typechain';

describe("Locker", function () {

  let locker: Locker;
  let anft: AesNFT;
  let tokenId: BigNumber;

  before(async function() {
    const [owner, receiver, nftCreator] = await ethers.getSigners();

    const Locker = await ethers.getContractFactory("Locker");
    locker = await Locker.connect(owner).deploy();
    await locker.deployed();

    const aNFT = await ethers.getContractFactory("AesNFT");
    anft = await aNFT.connect(nftCreator).deploy("AesNFT", "aNFT", "https://aeternalism.com/nft/");
    await anft.deployed(); 
  })

  it("Mint and transfer NFT to Locker", async function() {
    const [owner, receiver, nftCreator] = await ethers.getSigners();

    await anft.connect(nftCreator).mint(nftCreator.address);

    tokenId = await anft.getTokenId();
    console.log('TokenURI: ', await anft.tokenURI(tokenId));
    await anft.connect(nftCreator).approve(locker.address, tokenId);
    await locker.connect(nftCreator).lock(anft.address, tokenId, "aes1tv5khjsm50u2hhfd7lng39dc08wx2xz64d6pga");

    expect(await anft.ownerOf(tokenId)).to.eq(locker.address);
  });

  it("Release NFT from locker", async function() {
    const [owner, receiver, nftCreator] = await ethers.getSigners();
    await locker.release(anft.address, tokenId, receiver.address, "Send from AES");

    expect(await anft.ownerOf(tokenId)).to.eq(receiver.address);
  });

});

