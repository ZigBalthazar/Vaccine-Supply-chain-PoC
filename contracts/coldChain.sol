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
        certificateStatus _status;
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

    function addVaccineBatch(string memory _brand, address _manufacturer) public returns(uint){
        uint[] memory _certificateIds = new uint[](MAX_CERTIFICATION);
        uint _id = vaccineBatchIds.length;
        vaccineBatch memory _vaccineBatch = vaccineBatch(_id, _brand, _manufacturer, _certificateIds);
        vaccineBatches[_id] = _vaccineBatch;
        vaccineBatchIds.push(_id);
        emit addVaccineBatchEvent(_id, _manufacturer);
        return _id;
    }

    function issueCertificate(address _issuer, address _prover, string memory _status, uint vaccineBatchId, bytes memory _sig) public returns(uint) {
        entity memory issuer = entities[_issuer];
        require(issuer._mode == mode.ISSUER);

        entity memory prover = entities[_prover];
        require(prover._mode == mode.PROVER);

        certificateStatus status = unmarshalStatus(_status);
        uint id = certificateIds.length;
        certificate memory _certificate = certificate(id,issuer,prover,_sig,status);

        certificateIds.push(certificateIds.length);
        certificates[certificateIds.length-1] = _certificate;

        emit IssueCertificateEvent(_issuer, _prover, certificateIds.length-1);
        return certificateIds.length-1;
        
        
    }

    
    function unmarshalStatus(string memory _status) private pure returns(certificateStatus status_) {
        bytes32 encodedMode = keccak256(abi.encodePacked(_status));
        bytes32 encodedMode0 = keccak256(abi.encodePacked("MANUFACTURED"));
        bytes32 encodedMode1 = keccak256(abi.encodePacked("DELIVERING_INTERNATIONAL"));
        bytes32 encodedMode2 = keccak256(abi.encodePacked("STORED"));
        bytes32 encodedMode3 = keccak256(abi.encodePacked("DELIVERING_LOCAL"));
        bytes32 encodedMode4 = keccak256(abi.encodePacked("DELIVERD"));

        if(encodedMode == encodedMode0){
            return certificateStatus.MANUFACTURED;
        }else if(encodedMode == encodedMode1){
            return certificateStatus.DELIVERING_INTERNATIONAL;
        } else if(encodedMode == encodedMode2){
            return certificateStatus.STORED;
        } else if(encodedMode == encodedMode3){
            return certificateStatus.DELIVERING_LOCAL;
        } else if(encodedMode == encodedMode4){
            return certificateStatus.DELIVERD;
        }

        revert("invalid status");
    }

}