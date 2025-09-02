// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./LiquidityToken.sol";

contract LiquidityMining is ReentrancyGuard {
    
    IERC20 public token;
    LiquidityToken public reward;

    mapping(address => uint) public balances;//user => balance
    mapping(address => uint) public checkpoints;//liquidity provider => deposit block number

    uint public rewardPerBlock =1;

    constructor(address tokenAddress, address rewardAddress){
        token = IERC20(tokenAddress);
        reward = LiquidityToken(rewardAddress);
    }

    function rewardPayment(uint balance) internal {
        uint difference = block.number - checkpoints[msg.sender];
        if(difference > 0){
            reward.mint(msg.sender, balance * difference * rewardPerBlock);
            checkpoints[msg.sender] = block.number;
        }        
    }

    function deposit(uint amount) external nonReentrant{
        token.transferFrom(msg.sender, address(this), amount);
        uint originalBalance = balances[msg.sender];
        balances[msg.sender] += amount;

        if(checkpoints[msg.sender] == 0) {
            checkpoints[msg.sender] = block.number;
        }
        else rewardPayment(originalBalance);
    }

    function withdraw(uint amount) external {
        require(balances[msg.sender] >= amount, "Insuficient funds");
        uint originalBalance = balances[msg.sender];
        balances[msg.sender] -= amount;        
        token.transfer(msg.sender, amount);
        rewardPayment(originalBalance);
    }

    function calculateRewards() external view returns(uint) {
        uint difference = block.number - checkpoints[msg.sender];
        return balances[msg.sender] * difference * rewardPerBlock;
    }
}