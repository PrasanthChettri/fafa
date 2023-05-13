// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;
import "./trust_store.sol";
import "./RSU.sol";
import "./Message.sol";
import "./trust_calculation.sol";

struct Event {
    string eventType;
    string location;
}

contract CredibilityMetrics {
       uint256 sourceVehicleId = 1; 
    RSU public rsu;
    string public  _eventType ; 
    string public _eventLocation ; 
    Message public message ; 
    CredibilityMetrics public credibilityMetrics;
    SourceTrust public sourceTrust;
    constructor(string memory eventType, string memory eventLocation){
        rsu = new RSU();
        message = new Message();
        sourceTrust = new SourceTrust() ;
        _eventType = eventType ; 
        _eventLocation = eventLocation ;
    }
    function setSourceTrust(address add) public {
        rsu.setSourceTrust(add) ; 
    }
    function setEvent(uint sourceID, uint distance) public  {
        message.setMessage(_eventType, _eventLocation, sourceID, distance);
    }

    function dynamicTrustCal(uint distance, uint noOfZonesAffected) public pure returns (uint256) {

        //normalized to integer from ffloating point
        uint totalScore = noOfZonesAffected * 10**3;
        uint noOfHopsPerZone = 2;
        uint borderNodesNum = ((distance) * 10**3 )/ noOfHopsPerZone;
        uint dynamicScore = (totalScore) - borderNodesNum;
        uint normalizedScore = (dynamicScore - 10**3) / (noOfZonesAffected - 1);
        return normalizedScore;
    }

    function trustLevelCalc(uint trustLevel) public pure returns (uint256) {
        uint maxTrustLevel = 10;
        uint minTrustLevel = 1;
        uint normalizedTrustLevel = ((trustLevel - minTrustLevel) * 10**3) / (maxTrustLevel - minTrustLevel);
        return normalizedTrustLevel;
    }
    function getSecurityStatus(string memory vehicleStatus) public pure returns (uint256) {
        if (keccak256(abi.encodePacked(vehicleStatus)) == keccak256(abi.encodePacked("legitimate"))) {
            return 10**3;
        } else if (keccak256(abi.encodePacked(vehicleStatus)) == keccak256(abi.encodePacked("revoked"))) {
            return 0;
        }
        return 0;
    }

    function eventSpecificTrustCalc(string memory eventType) public pure returns (uint) {
        // Implementation of event-specific trust calculation can be added here
    }

    function credibilityGrade(uint dynamicMetric, uint trustLevel, uint securityStatus) public pure returns (uint256) {
        uint credibility = (dynamicMetric + trustLevel + securityStatus) / 3;
        return credibility;
    }

    function getMessageCredibility(uint distance, uint noOfZonesAffected, uint sourceTrustLevel, string memory vehicleStatus) public pure returns (uint256) {
        uint dynamicMetric = dynamicTrustCal(distance, noOfZonesAffected);
        uint trustLevelNormalized = trustLevelCalc(sourceTrustLevel);
        uint securityStatus = getSecurityStatus(vehicleStatus);
        uint credibility = credibilityGrade(dynamicMetric, trustLevelNormalized, securityStatus);
        return credibility;
    }

    function getEventCredibility() public view returns (uint256){
        (string memory eventType, string memory location, uint256 sourceID, uint distance) = message.getMessage();
        (uint trust, uint zones, string memory status) = rsu.getRsuMessage(sourceID);
        return getMessageCredibility(distance, zones, trust, status);
    }
}
