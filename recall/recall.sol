pragma solidity 0.6.0;

contract ChatRecall {
    event Recall(string f, string t, uint8 rt, uint64 ts);
    
    mapping(string=>mapping(string=>mapping(uint8=>uint64))) Records;
    
    function recall(string memory fromPubkey, string memory toPubkey, address fromAddr, uint8 recallType, uint64 timestamp, bytes32 R, bytes32 S, uint8 V) public {
        bytes memory d = abi.encodePacked(fromPubkey, toPubkey, fromAddr, recallType, timestamp);
        bytes32 hash = sha256(d);
        
        address expected_addr = ecrecover(hash, V, R, S);
        
        if (expected_addr != fromAddr) {
            revert();
        }

        if (Records[fromPubkey][toPubkey][recallType] < timestamp) {
            Records[fromPubkey][toPubkey][recallType] = timestamp;
        }

        emit Recall(fromPubkey, toPubkey, recallType, timestamp);
    }
    

    function queryRecall(string memory fromPubkey, string memory toPubkey, uint8 recallType) public view returns (uint64) {
        return Records[fromPubkey][toPubkey][recallType];
    }
}
