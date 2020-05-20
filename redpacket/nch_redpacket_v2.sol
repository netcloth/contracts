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

    address payable owner ;
    bool public equalDivision;
    bytes32 internal word;
    uint256 public size;
    uint256 public remainSize;

    mapping(address => bool) grabbed;

    // Giving gives out NCH.
    constructor(
        bytes32 _word,
        bool _equalDivision,
        uint256 _size
    ) public payable {
        //创建红包
        require(_size > 0 && msg.value > 0 && msg.value > _size, "invalid data provided");

        if (_equalDivision) {
            require(msg.value % _size == 0, "Invalid value and size for equal division mode");
        }

        owner = msg.sender;
        equalDivision = _equalDivision;
        word = _word;
        size = _size;
        remainSize = _size;

        emit Send(msg.sender, msg.value);
    }

    function kill() public  {
        require(msg.sender == owner, "You're not the owner");
        selfdestruct(owner);
    }

    function open(bytes32 _word) public {
        require(word == _word, "word incorrect");
        require(!grabbed[msg.sender], "can't grabbed twice");

        uint256 balance = address(this).balance;
        uint256 value = 0;
        if (equalDivision) {
            value = uint256(balance) / uint256(size);
        } else if (remainSize == 1) {
            value = address(this).balance;
        } else {
            bytes memory entropy = abi.encode(
                msg.sender,
                balance,
                remainSize,
                block.number
            );
            uint256 val = uint256(keccak256(entropy)) % balance;
            uint256 max = uint256(balance) / uint256(remainSize);
            if (val == 0) {
                value = 1;
            } else if (val > max) {
                value = max;
            } else {
                value = val;
            }
        }

        remainSize--;
        if (remainSize == 0) {
            selfdestruct(msg.sender);
        } else {
            grabbed[msg.sender] = true;
            msg.sender.transfer(value);
        }

        emit Receive(msg.sender, value);
    }
}
