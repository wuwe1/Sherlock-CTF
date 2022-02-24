// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./Token.sol";
import "./GovToken.sol";

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Challenge {
    using SafeERC20 for Token;

    struct Proposal {
        uint256 amount;
        address author;
        uint256 votes;
    }

    address[] public tokens; // 0
    Proposal[] public proposals; // 1
    mapping(uint256 => mapping(address => bool)) public votes; // 2
    address[] public govTokens; // 3
    bool public faucetUsed; // 4

    mapping(address => mapping(address => uint256)) public balances;

    constructor() {
        address[] memory operators;
        GovToken govToken = new GovToken(
            "ChallengeGov",
            "CGOV",
            operators,
            500 ether
        );
        govTokens.push(address(govToken));

        Token sherlockUSDC = new Token("SherlockUSDC", "SUSDC", 2000 ether);
        tokens.push(address(sherlockUSDC));

        Token sherlockUSDT = new Token("SherlockUSDT", "SUSDT", 3000 ether);
        tokens.push(address(sherlockUSDT));
    }

    function addProposal(uint256 amount) external {
        require(amount > 0, "amount has to be more than 0");

        Proposal storage proposal;
        proposal.amount = amount;
        proposal.author = msg.sender;
        proposal.votes = 0;

        proposals.push(proposal);
    }

    function voteProposal(uint256 idx, bool approved) external {
        require(idx < proposals.length, "wrong prposal idx");
        require(!votes[idx][msg.sender], "already voted");

        votes[idx][msg.sender] = true;

        if (approved) {
            proposals[idx].votes += 1;
        } else {
            proposals[idx].votes -= 1;
        }
    }

    /* just give some initial tokens to play with */
    function faucet() external {
        require(!faucetUsed, "already used");
        faucetUsed = true;

        for (uint256 i = 0; i < govTokens.length; i++) {
            GovToken(govTokens[i]).transfer(msg.sender, 10 ether);
        }

        for (uint256 i = 0; i < tokens.length; i++) {
            Token(tokens[i]).transfer(msg.sender, 10 ether);
        }
    }

    function deposit(uint256 idx, uint256 amount) external {
        require(idx < tokens.length, "invalid token idx");

        address token = tokens[idx];
        balances[token][msg.sender] += amount;
        Token(token).safeTransferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 idx) external {
        require(idx < tokens.length, "invalid token idx");

        address token = tokens[idx];
        uint256 balance = balances[token][msg.sender];

        if (balance > 0) {
            Token(token).safeTransfer(msg.sender, balance);
            balances[token][msg.sender] = 0;
        }
    }
}
