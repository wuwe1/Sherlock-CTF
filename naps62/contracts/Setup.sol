// SPDX-License-Identifier: None
pragma solidity 0.8.4;

import "./ISetup.sol";
import "./BuiltByANoob.sol";

contract Setup is ISetup {
    BuiltByANoob public instance;

    constructor() {
        instance = new BuiltByANoob();
        emit Deployed(address(instance));
    }

    function isSolved() external view override(ISetup) returns (bool) {
        return instance.won();
    }
}
