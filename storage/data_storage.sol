pragma solidity 0.6.0;

contract DataStorage {
    event Storage(address from, string key, string value);
    
    mapping(string=>string) Records;
    
    function store(string memory key, string memory value) public {

        Records[key] = value;
        emit Storage(msg.sender, key, value);
    }
    

    function queryStore(string memory key) public view returns (string memory value) {
        return Records[key];
    }
}
