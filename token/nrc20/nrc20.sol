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

contract StandardToken is SafeMath  {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping(address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(
        uint256 _initialSupply,
        string memory _name,
        uint8 _decimals,
        string memory _symbol
    ) public {
        balances[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
        name = _name;
        decimals = _decimals;
        symbol = _symbol;
    }

    /**
     * @dev Returns true if `account` is a contract.
     */
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0);
    }
    
    function balanceOf(address _owner) view public returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public {
        require(!isContract(_to), "Can't transfer to contract");
        require(balances[msg.sender] >= _value, "Insuffient balance");
        require(balances[_to] + _value > balances[_to], "Overflow");

        balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);
        balances[_to] = SafeMath.safeAdd(balances[_to], _value);
        emit Transfer(msg.sender, _to, _value);
      
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        require (balances[_from] >= _value, "Insuffient balance");
        require (allowed[_from][msg.sender] >= _value, "Insuffient allowance");
        require (balances[_to] + _value > balances[_to], "Overflows");

        balances[_to] = SafeMath.safeAdd(balances[_to] ,_value);
        balances[_from] = SafeMath.safeSub(balances[_from], _value);
        allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
      
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        assert(_value >= 0);
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}