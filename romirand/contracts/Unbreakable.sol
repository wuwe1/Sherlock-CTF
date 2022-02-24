// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Unbreakable is ERC20, Ownable {
    struct Solution {
        // challenge 1
        uint256 ch1_slot;
        bytes32 ch1_value;
        // challenge 2
        uint256 ch2_amount;
        string ch2_error;
        // reward
        bytes reward;
    }

    uint256 constant SCALE = 10_000;

    // efficient storage packing to "save gas"
    address private solver;
    bool private solved;
    bool private broken;
    bool private external_repair_requested;

    constructor() ERC20("Secureum Sherlock CTF Token", "SSCTF") {
        // for marketing
        _mint(address(this), 1_000_000);
    }

    modifier onlyPrivate() {
        require(msg.sender == address(this), "private function");
        _;
    }

    modifier notBroken() {
        require(!broken, "contract is broken");
        _;
    }

    modifier onlyBroken() {
        require(broken, "contract still working");
        _;
    }

    function challenge1(uint256 slot, bytes32 value) internal returns (bool) {
        require(slot != 6, "Don't touch!");
        StorageSlot.getBytes32Slot(bytes32(slot)).value = value;
        return solver == owner();
    }

    function challenge2(uint256 amount, string memory error_str)
        internal
        returns (bool)
    {
        // you made it very far! Take some tokens if you can ;)
        // Please just take `contract_share` % of the total supply
        // so the protocol can sponsor future CTFs
        uint256 user_share = 20;
        require(amount > 0, error_str);
        // 1000000 + amount
        uint256 new_supply = totalSupply() + amount;
        // 0
        uint256 new_user_share = (balanceOf(address(solver)) * 100 * SCALE) /
            new_supply;
        if (new_user_share > user_share * SCALE) {
            // resupply contract
            uint256 val = balanceOf(address(this)) *
                ((new_user_share / user_share) * SCALE);
            _mint(address(this), val);
        }
        _mint(solver, amount);
        // amount * 8 ==  (1000000 * 2)
        // amount = 250000
        return
            (balanceOf(address(solver)) * 100 * SCALE) / totalSupply() ==
            user_share * SCALE;
    }

    function challenge3() internal view returns (bool) {
        return !(tx.origin == solver || Address.isContract(solver));
    }

    function solveChallenge(Solution memory solution)
        public
        notBroken
        onlyPrivate
        returns (bool)
    {
        return
            challenge1(solution.ch1_slot, solution.ch1_value) &&
            challenge2(solution.ch2_amount, solution.ch2_error) &&
            challenge3();
    }

    function brake(Solution calldata solution) external notBroken {
        if (solver == address(0)) {
            solver = msg.sender;
        }
        (bool success, bytes memory data) = address(this).call(
            abi.encodeCall(this.solveChallenge, (solution))
        );
        if (success) {
            solved = abi.decode(data, (bool));
            if (solved) {
                address(this).call(solution.reward);
            } else {
                revert("challenge not solved");
            }
        } else {
            broken = true;
            address(this).call(data);
        }
        // reset
        solved = false;
        broken = false;
        solver = address(0);
    }

    function Error(string memory error) external onlyBroken onlyPrivate {
        // something broke, try to fix it
        (bool success, bytes memory data) = address(this).call(bytes(error));
        if (!success) {
            // try again
            (success, data) = address(this).call(data);
            bool isfixed = abi.decode(data, (bool));
            // escalate
            external_repair_requested = success && !isfixed;
        }
    }

    function Panic(uint256 id)
        external
        view
        onlyBroken
        onlyPrivate
        returns (bool)
    {
        uint256 solved_int = solved ? 1 : 0;
        return id & solved_int != 1;
    }

    function doStorageMaintenance() external {
        require(external_repair_requested, "don't need maintenance");
        address(solver).delegatecall("");
    }
}
