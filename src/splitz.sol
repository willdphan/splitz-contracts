// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */


contract Splitz {

    // stores list of recipients and their ids
    address payable [] public recipients;

    event TransferReceived(address _from, uint _amount);

    address payable public splitOwner;

    // maps address to array id
    mapping(address => uint) public addressToUint;

    modifier onlyOwner {
        require(msg.sender == splitOwner);
        _;
    }

    receive() payable external {
        uint256 share = msg.value / recipients.length;
         for (uint i=0; i< recipients.length; i++){
             recipients[i].transfer(share);
         }
         emit TransferReceived(msg.sender, msg.value);
    }

    function createSplit (address payable _owner, address payable [] memory newRecipients) external {

        for(uint i=0; i<newRecipients.length; i++) {
            recipients.push(newRecipients[i]);
        }
        // sets splitOwner
        splitOwner = _owner;
    }

    // add recipient with address
    function addRecipient( address payable newRecipient) external {
        recipients.push(newRecipient);
    }

    // remove recipient with address
    function removeRecipient(address payable recipient) external {
        uint index = addressToUint[recipient];

       require(index < recipients.length, "index out of bound");

        for (uint i = index; i < recipients.length - 1; i++) {
            recipients[i] = recipients[i + 1];
        }
        recipients.pop();
    }

    function splitRecipients() public view returns (address payable [] memory) {
        return recipients;
    }

    function splitRecipientCount() public view returns (uint) {
        return recipients.length;
    }

}