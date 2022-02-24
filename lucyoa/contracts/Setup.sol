// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./Challenge.sol";
import "./GovToken.sol";

contract Setup {
    event Deployed(address instance);
    Challenge public instance;

    constructor() payable {
        instance = new Challenge();

        emit Deployed(address(instance));
    }

    function isSolved() external view returns (bool) {
        address govToken = instance.govTokens(0);
        return GovToken(govToken).balanceOf(address(instance)) == 0;
    }
}
