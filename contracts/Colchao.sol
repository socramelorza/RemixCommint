// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract Colchao {

    IERC20 public token;
    mapping(address => uint) public balances;//user => balance

    constructor(address tokenAddress){
        token = IERC20(tokenAddress);
    }

    function deposit(uint amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
    }

    function withdraw(uint amount) external {
        require(balances[msg.sender] >= amount, "Insuficient funds");
        balances[msg.sender] -= amount;
        token.transfer(msg.sender, amount);
    }

}