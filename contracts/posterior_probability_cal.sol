// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./trust_calculation.sol";
import "./trust_store.sol";
import "./RSU.sol" ; 

contract PosteriorProbabilityCalculator {
    CredibilityMetrics public cm ;
    SourceTrust public sourceTrust ;
    RSU public rsu ; 
    uint public P_e ; 
    uint[] credibility = [0];
    uint[] credibilitySourceIds = [0] ; 
    mapping(string => uint) peMapping;
    string  eventType = "accident" ; 
    string  location = "gangtok" ; 

    constructor(){
        sourceTrust = new SourceTrust() ;
        P_e = peMapping["accident"] != 0 ? peMapping["accident"] : 500 ; 
        cm = new CredibilityMetrics(eventType, location);
    }
    function updateTrust(uint trust , bool offset) public pure returns (uint256){
        if(trust < 3 && offset){
            return trust+3 ; 
        }
        else if(trust < 3 && !offset){
            return trust-1 < 0 ? 0 : trust - 1; 
        }
        else if(trust < 8 && offset) {
            return trust + 2 ; 
        }
        else if(trust < 8 && !offset) {
            return trust - 2 ;
        }
        else if(offset){
            return trust + 1 > 10 ? 10 : trust + 1; 
        }
        else {
            return trust - 3; 
        }
    }

    function setRSU(address add) public {
        rsu = RSU(add);
        cm.setSourceTrust(add);
    }
    
    function callEventCredibility(uint sourceId, uint distance) public  returns (uint256){
        cm.setEvent(sourceId, distance);
        credibility.push(cm.getEventCredibility()) ; 
        credibilitySourceIds.push(sourceId) ; 
    }
    function getCredibilityList() public view returns (uint[] memory) {
        return credibility;
    }
    function calculatePosteriorProbability(uint P_E) public view returns (uint) {
        uint numerator = 0;
        uint denominator = 0;
        for (uint i = 1; i <= credibility.length - 1; i++) {
            numerator += P_e*(credibility[i]);
            denominator += P_e*(credibility[i]);
            denominator += (1000 - P_e) * (1000 - credibility[i]);
        }
        uint posteriorProbability = numerator * 1000/ denominator;
        return posteriorProbability;
    }

    function updateState() public {
        P_e = peMapping["accident"] != 0 ? peMapping["accident"] : 500 ; 
        peMapping["accident"] = calculatePosteriorProbability(P_e);
        bool offset = peMapping["accident"] > 500 ; 
        updateVehicleTrust(offset);
    }
    function updateVehicleTrust(bool offset) public returns (uint){
        uint id ;
        for (uint i = 1; i < credibilitySourceIds.length ; i++) {
            id = credibilitySourceIds[i];
            (uint trust ,uint dash, string memory dash2) = rsu.getRsuMessage(id);
            updateTrust(trust, offset) ;
            rsu.setRsuMessage(id, trust) ;
        }

        return 0 ; 
    }
}
