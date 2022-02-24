// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
// fix
import "./Challenge2.sol";

interface ISetup {
    event Deployed(address instance);

    function isSolved() external view returns (bool);
}

contract Setup is ISetup {
    Challenge2 public instance;

    constructor() payable {
        require(msg.value == 1 ether);

        instance = new Challenge2{value: 1 ether}();
        emit Deployed(address(instance));
    }

    function isSolved() external view override returns (bool) {
        return address(instance).balance == 0;
    }
}
