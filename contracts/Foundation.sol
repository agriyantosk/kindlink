// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Foundation {
    address public ownerAddress;
    address public withdrawalAddress;
    
    uint public approval;

    constructor(address _ownerAddress, address _withdrawalAddress) {
        ownerAddress = _ownerAddress;
        withdrawalAddress = _withdrawalAddress;
    }

    function withdraw() external {

        (bool sent, ) = address(this).call{value: address(this).balance}("");
        require(sent, "Withdrawal Failed");
    }

    receive() external payable {}
}
