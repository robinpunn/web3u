// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// Smart contract deployed to 0xbAC74876B826F4948072FB456061Fb2cD1A4aDBB
contract ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Define a character struct
    struct Character {
        uint256 level;
        uint256 health;
        uint256 power;
        uint256 defense;
    }
    
    // Map tokenIdToLevels to Character struct
    mapping(uint256 => Character) public tokenIdToLevels;

    // Declare constructor function for smart contract
    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    // Generate NFT Image on chain
    function generateCharacter(uint256 tokenId) public view returns(string memory){

        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<defs>',
                '<linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="0%">',
                    '<stop offset="0%" style="stop-color:rgb(255,255,0);stop-opacity:1" />',
                    '<stop offset="100%" style="stop-color:rgb(255,0,0);stop-opacity:1" />',
                '</linearGradient>',
                '<linearGradient id="grad2" x1="0%" y1="0%" x2="100%" y2="0%">',
                    '<stop offset="0%" style="stop-color:rgb(0,255,255);stop-opacity:1" />',
                    '<stop offset="100%" style="stop-color:rgb(255,255,0);stop-opacity:1" />',
                '</linearGradient>',
            '</defs>',
            '<style>.base { font-family: serif; font-size: 14px; font-weight: bold }</style>',
            '<rect width="100%" height="100%" fill="url(#grad1)" />',
            '<image href="https://8upload.com/image/633e78211af8a/MayhemHelmetCrop.png" x="-25%" y="%" height="450px" width="450px"/>',
            '<text x="70%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad2)">',"Warrior",'</text>',
            '<text x="65%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad2)">', "Level: ",getLevel(tokenId),'</text>',
            '<text x="65%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad2)">', "Health: ",getHealth(tokenId),'</text>',
            '<text x="65%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad2)">', "Power: ",getPower(tokenId),'</text>',
            '<text x="65%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle" fill="url(#grad2)">', "Defense: ",getDefense(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    // Get level of NFT
    function getLevel(uint256 tokenId) public view returns (string memory) {
        uint256 _level = tokenIdToLevels[tokenId].level;
        return _level.toString();
    }

    // Get health of NFT
    function getHealth(uint256 tokenId) public view returns (string memory) {
        uint256 _health = tokenIdToLevels[tokenId].health;
        return _health.toString();
    }

    // Get power of NFT
    function getPower(uint256 tokenId) public view returns (string memory) {
        uint256 _power = tokenIdToLevels[tokenId].power;
        return _power.toString();
    }

    // Get defense of NFT
    function getDefense(uint256 tokenId) public view returns (string memory) {
        uint256 _defense = tokenIdToLevels[tokenId].defense;
        return _defense.toString();
    }


    // Generate and retrieve NFT TokenURI
    function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    // Create new NFT, initialize level value, set token URI
    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId].level = 0;
        tokenIdToLevels[newItemId].health = 0;
        tokenIdToLevels[newItemId].power = 0;
        tokenIdToLevels[newItemId].defense = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    // Train function to raise NFT level
    // Make sure nft exists and verify ownership, increment NFT level by 1, update token URI
    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
        uint256 currentLevel = tokenIdToLevels[tokenId].level;
        tokenIdToLevels[tokenId].level = currentLevel + 1;
        tokenIdToLevels[tokenId].health = currentLevel + 10;
        tokenIdToLevels[tokenId].power = currentLevel + 5;
        tokenIdToLevels[tokenId].defense = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}

