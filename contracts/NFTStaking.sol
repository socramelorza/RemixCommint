// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ISToken.sol";

contract NFTStaking is ERC721Holder, ReentrancyGuard {

    ISToken public reward;
    IERC721 public collection;
    mapping(uint => address) public ownerOf;//tokenId => owner
    mapping(uint => uint) public depositDate;//tokenId = deposit timestamp

    uint public rewardPerPeriod = 1000;
    uint public duration = 30 * 24 * 60 * 60;//30 days

    constructor(address _collection, address _reward){
        collection = IERC721(_collection);
        reward = ISToken(_reward);
    }

    function deposit(uint tokenId) external nonReentrant{
        collection.safeTransferFrom(msg.sender, address(this), tokenId);
        ownerOf[tokenId] = msg.sender;
        depositDate[tokenId] = block.timestamp;
    }

    function withdraw(uint tokenId) external nonReentrant{
        require(ownerOf[tokenId] == msg.sender, "Unauthorized");
        require(block.timestamp >= depositDate[tokenId] + duration, "NFT Locked");
        delete ownerOf[tokenId];
        delete depositDate[tokenId];
        collection.safeTransferFrom(address(this), msg.sender, tokenId);
        reward.mint(msg.sender, rewardPerPeriod);
    }

    function canWithdraw(uint tokenId) external view returns (bool) {
        return ownerOf[tokenId] == msg.sender && block.timestamp >= depositDate[tokenId] + duration;
    }
        
}
