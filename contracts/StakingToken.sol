// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakingToken is ERC20 {

    address public immutable owner;
    address public nftStaking;

    constructor(address _nftStaking) ERC20("StakingToken", "STK") {
        owner = msg.sender;
        nftStaking = _nftStaking;

    }

    function setNFTStaking(address _nftStaking) external onlyOwner {
        nftStaking = _nftStaking;
    }

    function mint(address receiver, uint amount) external {
        require(msg.sender == owner || msg.sender == nftStaking, "Unauthorized");
        _mint(receiver, amount);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }
}