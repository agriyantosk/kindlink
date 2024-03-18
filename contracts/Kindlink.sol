// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Kindlink {
    struct FoundationCandidate {
        address contractAddress;
        string name;
        uint yesVotes;
        uint noVotes;
    }

    struct Foundation {
        address contractAddress;
        string name;
    }

    address public owner;
    mapping(address => FoundationCandidate) candidates;
    mapping(address => Foundation) foundations;
    mapping(address => mapping(address => bool)) isVoted;
    mapping(address => uint) totalUsersDonations;

    constructor() {
        owner = msg.sender;
    }

    function donate(address foundationAddress) external payable {
        Foundation storage foundation = foundations[foundationAddress];
        require(
            foundation.contractAddress == foundationAddress,
            "Foundation is not registered"
        );
        (bool sent, ) = foundationAddress.call{value: msg.value}("");
        require(sent, "Donation Failed");
        totalUsersDonations[msg.sender] += msg.value;
    }

    function vote(bool inputVote, address foundationAddress) external {
        // ini bagian pas dicek nya dulu
        require(
            totalUsersDonations[msg.sender] > 1,
            "You must have a minimal total donations of 1 ETH to be able to contribute in the voting process"
        );
        require(
            !isVoted[foundationAddress][msg.sender],
            "You have already voted for this Foundation"
        );

        // ini bagian dia ngevote aja
        FoundationCandidate storage candidate = candidates[foundationAddress];
        require(
            candidate.contractAddress == foundationAddress,
            "Foundation Candidate not found"
        );

        if (inputVote) {
            candidate.yesVotes++;
        } else {
            candidate.noVotes++;
        }

        // ini bagian yang udah vote diitung
        isVoted[foundationAddress][msg.sender] = true;
    }

    function addCandidates(
        address foundationAddress,
        string memory name
    ) external onlyOwner {
        candidates[foundationAddress] = FoundationCandidate(
            foundationAddress,
            name,
            0,
            0
        );
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this action");
        _;
    }
}
