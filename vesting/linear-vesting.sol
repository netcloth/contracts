pragma solidity 0.6.0;

/**
 * Math operations with safety checks
 */
contract SafeMath {
    //internals
    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c>=a && c>=b);
        return c;
    }
}

contract LinearVesting is SafeMath {    
    struct Item {
        uint256 vestingAmount;
        uint256 vestedAmount;
        uint256 vestingStartTime;
        uint256 vestingEndTime;
    }

    mapping(address => Item) public records;

    function currTimeInSeconds() public view returns (uint256) {
        return now;
    }

    function vestingInfo(address _owner) view public returns (uint256 vestingAmount, uint256 vestedAmount, uint256 vestingStartTime, uint256 vestingEndTime) {
        return (records[_owner].vestingAmount, records[_owner].vestedAmount, records[_owner].vestingStartTime, records[_owner].vestingEndTime);
    }
    
    function create(address _to, uint256 _vestingStartTime, uint256 _vestingEndTime) public payable {
        require(_vestingEndTime >= _vestingStartTime);
        require(_vestingStartTime >= currTimeInSeconds());
        require(records[_to].vestingAmount == 0);

        Item memory item = Item(msg.value, 0, _vestingStartTime, _vestingEndTime);
        records[_to] = item;
    }

    function claim() public {
        require(records[msg.sender].vestingAmount > 0);

        Item memory item = records[msg.sender];

        uint256 percentage = safeDiv(safeMul(100, safeSub(currTimeInSeconds(), item.vestingStartTime)), safeSub(item.vestingEndTime, item.vestingStartTime));
        if (percentage > 100) {
            percentage = 100;
        }

        uint256 vestedAmount = safeDiv(safeMul(item.vestingAmount, percentage), 100);

        vestedAmount = safeSub(vestedAmount, item.vestedAmount);
        assert(vestedAmount > 0);

        msg.sender.transfer(vestedAmount);

        item.vestedAmount = item.vestedAmount + vestedAmount;
        if (item.vestingAmount == item.vestedAmount) {
            delete records[msg.sender];
        } else {
            records[msg.sender] = item;
        }
    }
}
