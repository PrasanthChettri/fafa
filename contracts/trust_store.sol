// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract SourceTrust {
    struct Source {
        uint256 trust;
        string  vehicleNumber ;
        int priority ; // 1 = hight priority, 0 = trusted, -1  = untrusted
        bool exists ; 
    }
    uint private uuid ; 
    constructor(){
        uuid = 1; 
    }
    mapping(uint256 => Source) private sources;
    function updateSourceTrust(uint256 uuId, uint256 trust) public{
        require(sources[uuId].exists, "Source does not exist");
        if(trust >= 8)
            sources[uuId].priority = 1 ;
        else if(trust >= 5) {
            sources[uuId].priority = 0 ;
        }
        else {
            sources[uuId].priority = -1;

        }
        sources[uuId].trust = trust ;
    }
    function setSourceTrust(uint256 uuId,string memory vehicleNumber) private {
        if (keccak256(abi.encodePacked(vehicleNumber)) == keccak256(abi.encodePacked("911"))) {
                    sources[uuId] = Source(8, vehicleNumber,1, true);
        }
        else {
            sources[uuId] = Source(5, vehicleNumber,0, true);

        }
    }

    function getSourceTrust(uint256 uuId) public view returns (uint256) {
        require(sources[uuId].exists, "Source does not exist");
        return sources[uuId].trust;
    }
    function addVehicle(string memory vehicleNumber) public returns (uint){
        setSourceTrust(uuid, vehicleNumber) ;
        return uuid ++ ;
    }
    function setSampleVehicles() public {
        for (uint256 i = 0; i < 10; i++) {
            addVehicle(string(abi.encodePacked("sample", i)));
        }
    }

    function getVehicles() public view returns (uint256) {
        return getSourceTrust(0);
    }
}
