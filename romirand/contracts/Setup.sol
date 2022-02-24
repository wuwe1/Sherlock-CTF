// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "./Unbreakable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

interface ISetup {
    event Deployed(address instance);

    function isSolved() external view returns (bool);
}

contract Setup is ISetup {
    Unbreakable public instance;

    constructor() {
        instance = new Unbreakable();
        emit Deployed(address(instance));
    }

    function isSolved() external view override returns (bool) {
        return !Address.isContract(address(instance));
    }
}
