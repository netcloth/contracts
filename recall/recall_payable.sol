pragma solidity 0.6.0;

contract ChatRecall {
    event Recall(string f, string t, uint8 rt, uint64 ts);
    
    mapping(string=>mapping(string=>mapping(uint8=>uint64))) Records;
    address payable public owner;
    uint256 public fee;
    
    constructor(uint256 _initFee) public {
		owner = msg.sender;
        fee = _initFee;
    }

    function setFee(uint256 _fee) public {
		require (msg.sender != owner);
        fee = _fee;
    }


    function recall(string memory fromPubkey, string memory toPubkey, address fromAddr, uint8 recallType, uint64 timestamp, bytes32 R, bytes32 S, uint8 V) public payable {
        require(msg.value >= fee);
        
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

    // transfer balance to owner
	function withdraw(uint256 amount) public {
		assert (msg.sender != owner);
		owner.transfer(amount);
	}
}
