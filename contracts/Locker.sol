//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

error UnAuthorized(address _contract, address _sender, uint256 _tokenId);
error RequiredApproval(address _contract, address _sender, address _approver, uint256 _tokenId);

contract Locker is IERC721Receiver {
    
    address private _operator;
    uint256 private _lockNounce;
    uint256 private _releaseNounce;

    event LockNFT(address _nftAddress, address _from, uint256 _tokenId, uint256 _nounce, string _data);
    event ReleaseNFT(address _nftAddress, address _to, uint256 _tokenId, uint256 _nounce, string _data);

    constructor() {
        _operator = msg.sender;
    }

    function lock(
        address _nftAddress,
        uint256 _tokenId,
        string memory _data
    ) external {
        ERC721 nftContract = ERC721(_nftAddress);

        // check ownership
        address nftOwner = nftContract.ownerOf(_tokenId);
        if (msg.sender != nftOwner) {
            revert UnAuthorized({
                _contract: _nftAddress,
                _sender: msg.sender,
                _tokenId: _tokenId
            });
        }

        // check approval
        address operator = nftContract.getApproved(_tokenId);
        if (address(this) != operator) {
            revert RequiredApproval({
                _contract: _nftAddress,
                _sender: msg.sender,
                _approver: address(this),
                _tokenId: _tokenId
            });
        }

        // transfer NFT to locker
        _lockNounce++;
        nftContract.safeTransferFrom(msg.sender, address(this), _tokenId);

        console.log("NFT Contract: ", _nftAddress);
        console.log("Sender: ", msg.sender);
        console.log("TokenID: ", _tokenId);
        console.log("Arbitrage data: ", _data);

        emit LockNFT(_nftAddress, msg.sender, _tokenId, _lockNounce, _data);
    }

    function release(
        address _nftAddress,
        uint256 _tokenId,
        address _receiver,
        string memory _data
    ) external {
        ERC721 nftContract = ERC721(_nftAddress);

        // check ownership
        address nftOwner = nftContract.ownerOf(_tokenId);
        if (address(this) != nftOwner) {
            revert UnAuthorized({
                _contract: _nftAddress,
                _sender: msg.sender,
                _tokenId: _tokenId
            });
        }

        // DANGEROUS call transfer directly
        // need special permission
        _releaseNounce++;
        _nftAddress.call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", address(this), _receiver, _tokenId));

        console.log("NFT Contract: ", _nftAddress);
        console.log("Operator: ", msg.sender);
        console.log("Receiver: ", _receiver);
        console.log("TokenID: ", _tokenId);
        console.log("Arbitrage data: ", _data);

        emit ReleaseNFT(_nftAddress, _receiver, _tokenId, _releaseNounce, _data);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
 
}
