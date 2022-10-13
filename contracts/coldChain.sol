//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "./libs/cryptoSuite.sol";
contract coldChain{
    
    enum certificateStatus{ MANUFACTURED, DELIVERING_INTERNATIONAL, STORED, DELIVERING_LOCAL, DELIVERD }
    enum mode { ISSUER, PROVER, VERIFIER }
    
    struct entity{
        address id;
        mode _mode;
        uint[] certificateId;
    }
    struct certificate{
        uint id;
        entity issuer;
        entity prover;
        bytes signature;
        // status _status;
    }
    struct vaccineBatch{
        uint id;
        string brand;
        address manifacturer;
        uint[] certificateIds;
    }

    mapping (uint => vaccineBatch) public vaccineBatches;
    mapping (uint => certificate) public certificates;
    mapping (address => entity) public entities;

    

    uint public constant MAX_CERTIFICATION = 2;
    uint[] public certificateIds;
    uint[] public vaccineBatchIds;

    //events
    event addEntityEvent(address entityId, string entityMode);
    event addVaccineBatchEvent(uint vaccineBatchId, address indexed manufacturer);
    event IssueCertificateEvent(address indexed issuer, address indexed prover, uint certificateId);

    function addEntity(address _id, string memory _mode) public {
        mode mode_ = unmarshalMode(_mode);
        uint[] memory _certificateIds = new uint[](MAX_CERTIFICATION);
        entity memory _entity = entity(_id, mode_, _certificateIds);
        entities[_id] = _entity;
        emit addEntityEvent(_id, _mode); 
    }

    function unmarshalMode(string memory _mode) private pure returns(mode mode_) {
        bytes32 encodedMode = keccak256(abi.encodePacked(_mode));
        bytes32 encodedMode0 = keccak256(abi.encodePacked("ISSUER"));
        bytes32 encodedMode1 = keccak256(abi.encodePacked("PROVER"));
        bytes32 encodedMode2 = keccak256(abi.encodePacked("VERIFIER"));

        if(encodedMode == encodedMode0){
            return mode.ISSUER;
        }else if(encodedMode == encodedMode1){
            return mode.PROVER;
        } else if(encodedMode == encodedMode2){
            return mode.VERIFIER;
        }

        revert("invalid entity mode");
    }
}