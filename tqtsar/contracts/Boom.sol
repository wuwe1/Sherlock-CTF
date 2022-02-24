pragma solidity 0.8.9;

contract Boom {
    constructor(address x) payable {
        selfdestruct(payable(x));
    }
}
