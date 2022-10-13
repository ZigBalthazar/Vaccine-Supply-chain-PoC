//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "./libs/cryptoSuite.sol";
contract coldChain{
    
    enum certificateStatus{ MANUFACTURED, DELIVERING_INTERNATIONAL, STORED, DELIVERING_LOCAL, DELIVERD }
    enum mode { ISSUER, PROVIDER, VERIFIER }
    
    struct entity{
        address id;
        mode _mode;
        uint[] certificateId;
    }
    struct certificate{
        uint id;
        entity issuer;
        entity provider;
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


}