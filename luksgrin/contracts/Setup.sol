pragma solidity 0.8.4;

import "./Dungeon.sol";

interface ISetup {
    event Deployed(address instance);

    function isSolved() external view returns (bool);
}

contract Setup is ISetup {
    HauntedDungeon public instance;

    constructor() payable {
        require(msg.value == 9 ether);

        instance = new HauntedDungeon{value: 9 ether}();
        emit Deployed(address(instance));
    }

    function isSolved() external view override returns (bool) {
        return instance.treasure() == 0;
    }
}
