//SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "./Combination.sol";

interface ISetup {
    event Deployed(address instance);

    function isSolved() external view returns (bool);
}

contract Setup is ISetup {
    Combination public combination;

    constructor() {
        combination = new Combination(32, 2, 8, 2, 180);
        emit Deployed(address(combination));
    }

    function isSolved() external view override returns (bool) {
        return combination.unlocked() == true;
    }
}
