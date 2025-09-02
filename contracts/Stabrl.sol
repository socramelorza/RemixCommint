// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IStabrl.sol";

contract Stabrl is ERC20, IStabrl {

    address private immutable owner;
    address public exchange;

    constructor() ERC20("Stabrl", "STBRL") {
        owner = msg.sender;
    }

    function setExchange(address _exchange) external {
        require(owner == msg.sender, "Only owner can make this call");
        exchange = _exchange;
    }

    function mint(address customer, uint amount) external onlyExchange {
        _mint(customer, amount);
    }

    function burn(address customer, uint amount) external onlyExchange {
        _burn(customer, amount);
    }

    modifier onlyExchange() {
        require(msg.sender == exchange, "Only the exchange can do this call");
        _;
    }
}