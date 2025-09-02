// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IStabrl is IERC20 {

    function mint(address customer, uint amount) external;
    

    function burn(address customer, uint amount) external;
   
}