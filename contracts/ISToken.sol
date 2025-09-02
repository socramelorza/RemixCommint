// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ISToken is IERC20 {
    function mint(address receiver, uint amount) external;

}