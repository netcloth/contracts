# ERC 20代币标准

代币的标准接口。

## 规范

### 代币

#### 函数

##### name

返回代币的名称，可选函数。

```javascript
function name() public view returns (string)
```

##### symbol

返回代币的代号，可选函数。

```javascript
function symbol() public view returns (string)
```

##### decimals

返回代币的精度，即小数位数，可选函数。

```javascript
function decimals() public view returns (uint8)
```

###### totalSupply

返回代币的总供应量。

```javascript
function totalSupply() public view returns (uint256)
```

###### balanceOf

返回帐户（通过参数"_owner"）的余额。

```javascript
function balanceOf(address _owner) public view returns (uint256 balance)
```

##### transfer

向 _to 地址转移 _value 数量的代币，函数必须触发事件 Transfer 。

如果调用方的帐户余额没有足够的令牌，则该函数需要抛出异常。

```javascript
function transfer(address _to, uint256 _value) public returns (bool success)
```

##### transferFrom

从 _from 向 _to 地址转移 _value 数量的代币，函数必须触发事件 Transfer 。

transferFrom 函数，可以允许第三方代表我们转移代币。

```javascript
function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
```

##### approve

授权 _spender 可以从我们账户最多转移代币的数量 _value，可以多次转移，总量不超过 _value 。

这个函数可以再次调用，以覆盖授权额度 _value 。

```javascript
function approve(address _spender, uint256 _value) public returns (bool success)
```

##### allowance

查询 _owner 授权给 _spender 的额度。

```javascript
function allowance(address _owner, address _spender) public view returns (uint256 remaining)
```

#### Events

##### Transfer

当有代币转移时（包括转移0），必须触发 Transfer 事件。

如果是新产生代币，触发 Transfer 事件的 _from 应该设置为 0x0 。

```javascript
event Transfer(address indexed _from, address indexed _to, uint256 _value)
```

##### Approval

approve(address _spender, uint256 _value) 函数成功执行时，必须触发 Approval 事件。

```javascript
event Approval(address indexed _owner, address indexed _spender, uint256 _value)
```