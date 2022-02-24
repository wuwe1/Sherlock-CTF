// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract GovToken is ERC777 {
    constructor(
        string memory name,
        string memory symbol,
        address[] memory operators,
        uint256 amount
    ) ERC777(name, symbol, operators) {
        _mint(msg.sender, amount, "", "");
    }
}
