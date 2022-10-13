//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

library cryptoSuite {
    
    function splitSignature(bytes memory _sig) internal pure returns(uint8 v, bytes32 r, bytes32 s) {
        require(_sig.length == 65); 
        assembly{
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }   
        return (v, r, s);    
    }

    function recoverSigner(bytes32 _msg, bytes memory _sig) internal pure returns(address) {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(_sig);
        return ecrecover(_msg, v, r, s);
    }
}