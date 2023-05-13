// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./trust_store.sol";
import "./RSU.sol";
import "./Message.sol";
import "./trust_calculation.sol";
contract EventSimulation {
    uint256 sourceVehicleId = 1; 
    RSU public rsu;
    Message public message ; 
    CredibilityMetrics public credibilityMetrics;
    SourceTrust public sourceTrust;
 
    constructor(){
        rsu = new RSU();
        message = new Message();
        sourceTrust = new SourceTrust() ;
        message.setMessage("accident", "gangtok", 1, 20);
    }
    function emulate ()  public view returns (uint) {

        (string memory eventType, string memory location, uint256 sourceID, uint distance) = message.getMessage();
        
        (uint trust, uint zones, string memory status) = rsu.getRsuMessage(sourceID);
        return credibilityMetrics.get(10, 10 , 10, "legitimate");
    }
}