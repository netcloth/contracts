# Token Standard

A standard interface for tokens.

## Specification

### Token

#### Methods

##### name

Returns the name of the token.

```javascript
function name() public view returns (string)
```

##### symbol

Returns the symbol of the token.

```javascript
function symbol() public view returns (string)
```

##### decimals

Returns the number of dicimals the token uses.

```javascript
function decimals() public view returns (uint8)
```

###### totalSupply

Returns the total token supply.

```javascript
function totalSupply() public view returns (uint256)
```

###### balanceOf

Returns the account balance of another account with address _owner.

```javascript
function balanceOf(address _owner) public view returns (uint256 balance)
```

##### transfer

Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The function SHOULD throw if the message caller’s account balance does not have enough tokens to spend.

Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.

function transfer(address _to, uint256 _value) public returns (bool success)

##### transferFrom

Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.

```javascript
function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
```

##### approve

Allows _spender to withdraw from your account multiple times, up to the _value amount. If this function is called again it overwrites the current allowance with _value.

```javascript
function approve(address _spender, uint256 _value) public returns (bool success)
```

##### allowance

Returns the amount which _spender is still allowed to withdraw from _owner.

```javascript
function allowance(address _owner, address _spender) public view returns (uint256 remaining)
```

#### Events

##### Transfer

MUST trigger when tokens are transferred, including zero value transfers.

```javascript
event Transfer(address indexed _from, address indexed _to, uint256 _value)
```

##### Approval

MUST trigger on any successful call to approve(address _spender, uint256 _value).

```javascript
event Approval(address indexed _owner, address indexed _spender, uint256 _value)
```