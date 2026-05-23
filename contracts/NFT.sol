// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract NFT is Initializable, ERC721Upgradeable, OwnableUpgradeable, UUPSUpgradeable {

    uint256 public nextTokenId;
    string public baseURI;
    uint256 public totalSupply;

    uint256[50] private __gap;

    event MintedNFT(uint256 tokenId, address owner);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(string memory baseURI_) public initializer {
        baseURI = baseURI_;
        __ERC721_init("Staking NFT", "SNFT");
        __Ownable_init(msg.sender);
        totalSupply = 1000;
    }

    function mint() public payable {
        require(nextTokenId < totalSupply, "All 1000 NFTs have been minted");
        require(balanceOf(msg.sender) == 0, "Already minted one NFT");
        require(msg.value == 0.0001 ether, "Requires exactly 0.0001 ether");
        uint256 tokenId = nextTokenId;
        _safeMint(msg.sender, tokenId);
        nextTokenId++;
        emit MintedNFT(tokenId, msg.sender);
    }

    function withdraw() external onlyOwner {
        (bool ok, ) = owner().call{value: address(this).balance}("");
        require(ok, "Withdraw failed");
    }


    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        return string(abi.encodePacked(baseURI, "0.json"));
    }

    function setBaseURI(string memory baseURI_) public onlyOwner {
        baseURI = baseURI_;
    }

    function _authorizeUpgrade(address newImpl) internal override onlyOwner {}
}