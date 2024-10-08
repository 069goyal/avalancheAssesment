// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Fundcollection {
    address public owner;
    uint public fundsCollected;
    uint public fundsNeeded = 100;

    constructor() {
        owner = msg.sender;
    }

    function contribute() public payable {
        require(msg.value > 0, "Contribution amount must be greater than 0");
        require(fundsCollected + msg.value <= fundsNeeded, "Either the funds needed are accomplished or this much funds are not required");

        fundsCollected += msg.value;
    }

    function withdraw() public {
        require(msg.sender  == owner, "Only the owner can withdraw funds");

		if ( fundsCollected < fundsNeeded ) {
			revert("Target amount not yet reached");
		}

		payable(owner).transfer(fundsCollected);
        fundsCollected = 0;
		
		assert(fundsCollected == 0);
    }

    function finalizeCampaign() view public {
        require(msg.sender == owner, "Only the owner can finalize the campaign");
        require(fundsCollected == fundsNeeded, "Target amount not yet reached");
    }
}
