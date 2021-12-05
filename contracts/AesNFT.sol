//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AesNFT is ERC721 {

    string private _baseTokenURI;
    uint private _tokenIdTracker;

    event MintNFT(address from, address to, uint256 tokenId);

    constructor(string memory _name, string memory _symbol, string memory _baseUri)
        ERC721(_name, _symbol)
    {
        _baseTokenURI = _baseUri;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function mint(address _to) external {
        _tokenIdTracker++;
        _mint(_to, _tokenIdTracker);
    }

    function getTokenId() public view returns(uint256) {
        return _tokenIdTracker;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        emit MintNFT(from, to, tokenId);
    }

}
