// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "./IStabrl.sol";

contract Exchange{
    address private immutable owner;
    IStabrl private immutable stableCoin;

    constructor(address _stablecoin) {
        stableCoin = IStabrl(_stablecoin);
        owner = msg.sender;
    }
    
    function deposit(address customer, uint amount) external onlyOwner {
        stableCoin.mint(customer, amount);
    }
    
    function withdraw(address customer, uint amount) external onlyOwner {
        stableCoin.burn(customer, amount);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can make this call");
        _;
    }   
    
}