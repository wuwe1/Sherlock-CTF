pragma solidity 0.8.4;

import "./Dungeon.sol";

contract Fighter {
    constructor(HauntedDungeon ins) payable {
        ins.treasure();
        ins.enterDungeon{value: 0.1 ether}();
        ins.store{value: 0.2 ether}("mntnDew");
        ins.turn();
        ins.store{value: 0.2 ether}("mntnDew");
        ins.turn();
        ins.store{value: 0.2 ether}("mntnDew");
        ins.turn();
        ins.store{value: 0.2 ether}("mntnDew");
        ins.turn();
        ins.store{value: 0.6 ether}("lifePotion");
        ins.store{value: 0.6 ether}("lifePotion");
        ins.store{value: 0.2 ether}("mntnDew");
        ins.store{value: 0.2 ether}("mntnDew");
        ins.store{value: 0.2 ether}("mntnDew");
        ins.store{value: 0.2 ether}("mntnDew");
        ins.turn();
        ins.turn();
    }
}
