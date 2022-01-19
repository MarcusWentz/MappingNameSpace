// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20TokenContract is ERC20('Chainlink', 'LINK') {}

contract RedditNameSpace is ChainlinkClient {

    using Chainlink for Chainlink.Request;

    bytes32 public data;
    uint public MonthEruption;

    address public currentOracleAddress;
    string public currentRedditUsername;
    string public urlRebuiltJSON;
    bytes32 public addressPartOne;
    bytes32 public hexUsername;
    uint private immutable fee = 1*10**16;
    bytes32 private immutable jobIdGetBytes32 = "187bb80e5ee74a139734cac7475f3c6e";
    address private immutable oracle = 0x3A56aE4a2831C3d3514b5D7Af5578E45eBDb7a40; 
    address private ChainlinkTokenAddressRinkeby = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    ERC20TokenContract tokenObject = ERC20TokenContract(ChainlinkTokenAddressRinkeby);

    constructor() {
        setPublicChainlinkToken();
    }

    mapping(address => string) AddressKeyUsernameLookup;
    mapping(string => address) UsernameKeyAddressLookup;

    function Step2VerifyRNS() public {
        require(keccak256(bytes(currentRedditUsername)) != keccak256(bytes("0")), "USERNAME_VALUE_NOT_SET!");
        require(UsernameKeyAddressLookup[currentRedditUsername] == 0x0000000000000000000000000000000000000000, "USERNAME_ALREADY_TAKEN.");
        require(msg.sender == currentOracleAddress, "ORACLE_VALUE_DOES_NOT_MATCH_MSG.VALUE.");
        AddressKeyUsernameLookup[msg.sender] = currentRedditUsername;
        UsernameKeyAddressLookup[currentRedditUsername] = msg.sender;
    }    

    function LookupAddressRNS() public view returns(string memory) {
        return AddressKeyUsernameLookup[msg.sender];
    }

    function LookupStringRNS(string memory _stringLookup) public view returns(address) {
        return UsernameKeyAddressLookup[_stringLookup];
    }

    function request_Address() private returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobIdGetBytes32, address(this), this.fulfill_Address.selector);
        request.add("get", "https://www.reddit.com/user/singularityyear2045.json");
        // request.add("path", "data.children.0.data.title");
        request.add("path", "kind");
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill_Address(bytes32 _requestId, bytes32 _currentOracleAddress) public recordChainlinkFulfillment(_requestId)
    {
        addressPartOne = _currentOracleAddress;
        // currentOracleAddress = address(uint160(uint256(_currentOracleAddress)));
    }

    // function request_Username() private returns (bytes32 requestId) {
    //     Chainlink.Request memory request = buildChainlinkRequest(jobIdGetBytes32, address(this), this.fulfill_Username.selector);
    //     request.add("get", "https://www.reddit.com/user/singularityyear2045.json");
    //     // request.add("path", "data.children.0.data.author");
    //     return sendChainlinkRequestTo(oracle, request, fee);
    // }

    // function fulfill_Username(bytes32 _requestId, bytes32 _currentRedditUsername) public recordChainlinkFulfillment(_requestId)
    // {
    //     hexUsername = _currentRedditUsername;
    //     // currentRedditUsername = bytes32ToString(_currentRedditUsername);
    // }

    function requestFruit() private returns (bytes32 requestId)  {
    Chainlink.Request memory request = buildChainlinkRequest(jobIdGetBytes32, address(this), this.fulfillBytes.selector);
    request.add("get","https://filesamples.com/samples/code/json/sample1.json");
    request.add("path", "fruit");
    return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfillBytes(bytes32 requestId, bytes32 bytesData) public recordChainlinkFulfillment(requestId) {
    data = bytesData;
      }

}
