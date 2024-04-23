// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyERC721 is ERC721URIStorage {
    // using Counters for Counters.Counter;
    // Counters.Counter private _tokenIds;

    constructor() ERC721("JunhuaToken", "JHT") {}

    uint256 private _nextTOkenId;

    function mint(address _address, string memory tokenURI) public returns (uint256) {
        uint256 tokenId = _nextTOkenId++;
        _mint(_address, tokenId);
        _setTokenURI(tokenId, tokenURI);

        return tokenId;
    }
}
