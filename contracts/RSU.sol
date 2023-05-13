// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./trust_store.sol";

contract RSU {
    SourceTrust public sourceTrust;

    constructor() {
        sourceTrust = new SourceTrust();
        //sourceTrust.setSampleVehicles();
    }
    function setSourceTrust(address add) public{
        sourceTrust = SourceTrust(add) ;
    }
    function getRsuMessage(uint256 uuId) public view returns (uint, uint, string memory) {
        uint256 trust = sourceTrust.getSourceTrust(uuId);
        return (trust , 10, trust != 0  ? "legitimate" : "revoked");
    }
    function setRsuMessage(uint256 uuId, uint256 trust) public {
        sourceTrust.updateSourceTrust(uuId, trust);
    }
}