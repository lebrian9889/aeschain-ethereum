# Aeternalism Ethereum contracts

Smartcontracts for hackatomVI

The project comes with 2 smart contracts
1. AesNFT.sol (an ERC721 implementation contract)
2. Locker.sol (contract that can locks NFT and emits LockNFT event)

## Install and deploy contracts

1. Prerequisites:
- Nodejs version >= 12
- Replace ROPSTEN_URL and PRIVATE_KEY in .env.sample to your deployment's account, change .env.sample to .env

2. Install dependencies:
Run command in the project root to install dependencies
```
npm i
```

3. Deploy contracts
- To deploy Locker contract, run these commands
```
NETWORK=ropsten npm run deploy-locker
```

- To deploy NFT contract, run these commands
```
NETWORK=ropsten npm run deploy-nft
```
- To mint and lock nft, replace lockerAddr & aesNftAddr in scripts/mint-lock-nft.ts by the addresses of the contracts that have deployed above then run these commands
```
NETWORK=ropsten npm run mint-lock-nft
```
