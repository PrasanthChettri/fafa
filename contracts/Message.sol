// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract Message {
    struct MessageData {
        string eventType;
        string location;
        uint sourceID;
        uint distance;
    }

    MessageData public message;

    function setMessage(string memory eventType, string memory location, uint256 sourceID, uint distance) public {
        message = MessageData(eventType, location, sourceID, distance );
    }
    function getMessage() public view returns (string memory, string memory, uint256 , uint) {
        return (message.eventType, message.location, message.sourceID, message.distance);
    }
}
