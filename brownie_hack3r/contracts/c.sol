// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

interface ISetup {
    event Deployed(address instance);

    function isSolved() external view returns (bool);
}

contract Setup is ISetup {
    BitMania public instance;

    constructor() {
        instance = new BitMania();
        emit Deployed(address(instance));
    }

    function isSolved() external view override returns (bool) {
        return instance.isSolved();
    }
}

contract Solve {
    constructor(BitMania ins) {
        string memory stringFlag = string(
            bytes(hex"534845524c4f434b5f4354465f3078305f57494e4e45525f333333")
        );
        ins.solveIt(stringFlag);
    }
}

contract BitMania {
    bool public isSolved;
    bytes public constant encFlag =
        bytes(hex"6e3c5b0f722c430e6d324c0d6f67173d4b1565345915753504211f");

    // following function was used to encrypt the given string
    // when a particular string is passed, encrypted output is `encFlag`
    // reverse `encFlag` to input stirng to solve CTF
    function encryptFlag(string memory stringFlag)
        public
        pure
        returns (bytes memory)
    {
        bytes memory flag = bytes(stringFlag);
        for (uint256 i; i < flag.length; i++) {
            if (i > 0) flag[i] ^= flag[i - 1];
            // a ^ previous = target
            flag[i] ^= flag[i] >> 4;
            flag[i] ^= flag[i] >> 3;
            flag[i] ^= flag[i] >> 2;
            // a ^ (a >> 2) =
            flag[i] ^= flag[i] >> 1;
            // a ^ (a >> 1) = '0x6e'
        }

        return flag;
    }

    // solve the ctf by calling this function
    function solveIt(string memory flag) external {
        bytes memory output = encryptFlag(flag);
        if (keccak256(output) == keccak256(encFlag)) isSolved = true;
    }
}
