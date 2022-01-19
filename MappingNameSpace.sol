// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

contract MappingNameSpace {

    mapping(address => string) AddressKeyUsernameLookup;
    mapping(string => address) UsernameKeyAddressLookup;

    function Claim_MNS(string memory inputString) public {
        require(keccak256(bytes(inputString)) != keccak256(bytes("0")), "USERNAME_VALUE_CANNOT_BE_0.");
        require(UsernameKeyAddressLookup[inputString] == 0x0000000000000000000000000000000000000000, "USERNAME_ALREADY_TAKEN.");
        require(bytes(AddressKeyUsernameLookup[msg.sender]).length == 0, "CANNOT_CHANGE_YOUR_NAME!");
        AddressKeyUsernameLookup[msg.sender] = inputString;
        UsernameKeyAddressLookup[inputString] = msg.sender;
    }    

    function User_MNS() public view returns(string memory) {
        return AddressKeyUsernameLookup[msg.sender];
    }

    function String_Lookup_Address_MNS(string memory _stringLookup) public view returns(address) {
        return UsernameKeyAddressLookup[_stringLookup];
    }

}
