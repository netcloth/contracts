pragma solidity 0.6.0;

contract ChatRecall {
    event Recall(string fromPubkey, string toPubkey, uint8 recallType, uint64 timestamp, address from);
    
    struct st {
       uint64 timestamp;
       address addr;
    }

    mapping(string=>mapping(string=>mapping(uint8=>st))) Records;
    uint256 public fee;
    
    constructor(uint256 _initFee) public {
        fee = _initFee;
    }

    function setFee(uint256 _fee) public {
		require (msg.sender != owner);
        fee = _fee;
    }

    function currTimeInSeconds() public view returns (uint256) {
        return now;
    }

    function recall(string memory fromPubkey, string memory toPubkey, uint8 recallType) public payable {
        require(msg.value >= fee);
        
        timestamp = currTimeInSeconds();

        if (Records[fromPubkey][toPubkey][recallType].timestamp < timestamp) {
            st memory s = st(timestamp, msg.sender);
            Records[fromPubkey][toPubkey][recallType] = s;
        }

        emit Recall(fromPubkey, toPubkey, recallType, timestamp, msg.sender);
    }
    
    function queryRecall(string memory fromPubkey, string memory toPubkey, uint8 recallType) public view returns (uint64, address) {
        return (Records[fromPubkey][toPubkey][recallType].timestamp, Records[fromPubkey][toPubkey][recallType].addr);
    }

    // transfer balance to owner
	function withdraw(uint256 amount) public {
		require (msg.sender != owner);
		owner.transfer(amount);
	}
}
