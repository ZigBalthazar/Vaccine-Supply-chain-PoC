//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

library cryptoSuite {
    
    function splitSignature(bytes memory _sig) internal pure returns(uint8 v, bytes32 r, bytes32 s) {
        require(_sig.length == 65); 
        assembly{
            
        }   
        return (v, r, s);    
    }
}