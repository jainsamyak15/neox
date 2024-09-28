// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts//access/Ownable.sol";

contract InitNFT is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;
    uint256 public constant MAX_NFTS_PER_USER = 5;
    mapping(address => uint256) public userMintCount;
    string[] public tokenURIs;

    constructor(string[] memory uris) ERC721("InitialNFT", "INFT") Ownable(msg.sender) {
        tokenURIs = uris;
    }

    function mintNFT(uint256 count) external {
        require(count <= MAX_NFTS_PER_USER, "Cannot mint more than 5 NFTs at once");
        
        uint256 userCount = userMintCount[msg.sender];
        require(userCount + count <= MAX_NFTS_PER_USER, "User has already claimed maximum NFTs");

        for (uint256 i = 0; i < count; i++) {
            require(nextTokenId < tokenURIs.length, "No more NFTs available to mint");
            
            uint256 tokenId = nextTokenId;
            _mint(msg.sender, tokenId);
            _setTokenURI(tokenId, tokenURIs[tokenId]);
            nextTokenId++; 
        }

        userMintCount[msg.sender] += count;
    }
}

