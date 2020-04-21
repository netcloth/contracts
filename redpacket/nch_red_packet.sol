pragma solidity 0.6.0;

contract RedPacket {

    event Send(
        address indexed sender,
        uint256 indexed value
    );
    event Receive(
        address indexed receiver,
        uint256 indexed value
    );

    struct Record {
        address owner;
        bool equalDivision;
        uint256 amount;
        uint256 remainAmount;
        uint256 size;
        uint256 remainSize;
        uint256 height;
        uint256 expiredHeight;
        uint256 id;
    }
    
    mapping(bytes32 => Record) records;
    mapping(uint256 => mapping(address => bool)) grabbed;
    uint256 internal nonce = 0;

    function isWordExists(bytes32 word) internal view returns (bool) {
        Record memory r = records[word];
        return r.owner != address(0x0);
    }
    
    // Giving gives out ETH.
    function create(bytes32 word, bool equalDivision, uint256 size, uint256 expireHeight) public payable {
        //创建红包

        require(size > 0 && msg.value > 0 && msg.value > size && expireHeight > 0, "invalid data provided");

        require(!isWordExists(word), "Red package exists");

        if (equalDivision) {
            require(msg.value % size == 0, "Invalid value and size for equal division mode");
        }

        records[word] = Record(
            msg.sender,
            equalDivision,
            msg.value,
            msg.value,
            size,
            size,
            block.number,
            block.number + expireHeight,
            nonce
        );
        nonce++;
        emit Send(msg.sender, msg.value);
    }
    
    function revoke(bytes32 word) public {
        Record storage r = records[word];
        require(r.owner == msg.sender, "Red package not exists or you're not the owner");
        require(r.expiredHeight < block.number, "Only revoke expired one");
        
        msg.sender.transfer(r.amount);
        delete records[word];
    }

    function open(bytes32 word) public {
        Record storage r = records[word];
        require(r.owner != address(0x0), "Red package not exists");
        require(r.expiredHeight >= block.number, "Red package expired");
        require(!grabbed[r.id][msg.sender], "can't grabbed twice");

        uint256 value = 0;
        if (r.equalDivision) {
            value = uint256(r.amount) / uint256(r.size);
        } else if (r.remainSize == 1) {
            value = r.remainAmount;
        } else {
            bytes memory entropy = abi.encode(
                msg.sender,
                r.remainAmount,
                r.remainSize,
                block.number
            );
            uint256 val = uint256(keccak256(entropy)) % r.remainAmount;
            uint256 max = uint256(r.remainAmount) / uint256(r.remainSize);
            if (val == 0) {
                value = 1;
            } else if (val > max) {
                value = max;
            } else {
                value = val;
            }
        }

        msg.sender.transfer(value);
        
        r.remainAmount -= value;
        r.remainSize--;
        if (r.remainSize == 0) {
            delete records[word];
        } else {
            grabbed[r.id][msg.sender] = true;
        }
        
        emit Receive(msg.sender, value);
    }
    
    function getRecord(bytes32 word) public view returns (address owner, bool equalDivision, uint256 amount,
        uint256 remainAmount, uint256 size, uint256 remainSize, uint256 height, uint256 expiredHeight )
    {
        Record memory r = records[word];
        return (r.owner, r.equalDivision, r.amount, r.remainAmount, r.size, r.remainSize, r.height, r.expiredHeight);
    }
}

