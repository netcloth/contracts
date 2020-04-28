# Escrow

第三方托管（ESCROW），即买方将货款付给买卖双方之外的第三方，第三方收到款项后通知已收到买方货款，并同时通知卖方发货，卖方即可将货物发运给买方，买方通知第三方收到满意的卖方货物，第三方便将货款付给卖方。

合约包含三种状态：

```javascript
* Active 合约创建时的默认状态
* Refunding 合约owner可将状态从Active设置为Refunding，此时取款人可从合约中取回全部资产
* Closed 合约owner可将状态从Active设置为Closed，收益人可从合约中取回全部资产
```

其中合约创建时，默认状态为Active; 


## 合约方法

### 创建合约

创建合约时：

* 创建者默认为合约 owner

* 构造函数传入收益者地址，合约关闭时，收益者可取回合约中全部资产

### deposit

向指定收款人地址向合约中存入资产，存入的资产，可通过depositOf方法查询

```javascript
function deposit(address payee) public virtual payable
```

### depositOf

查询指定地址在合约中的资产

```javascript
function depositOf(address payee) public view returns (uint256)
```

### withdraw

从合约中一次性取回自己的存款，取款地址通过参数传入

前置条件：合约状态为Refunding

```javascript
function withdraw(address payable payee) public virtual
```

### enableRefunds

将合约状态从Active状态设置为Refunding状态， 合约owner才可以调用

```javascript
function enableRefunds() public onlyOwner virtual
```

### close

将合约状态从Active状态设置为Closed状态，合约owner才可以调用

前置条件：合约状态为Active

```javascript
function close() public onlyOwner virtual 
```

### state

查询合约当前的状态

```javascript
function state() public view returns (State)
```

### beneficiaryWithdraw

收益人从合约中取出所有资产

前置条件：合约状态为Closed

```javascript
function beneficiaryWithdraw() public virtual 
```

### withdrawalAllowed

取款人是否能从合约中取回资产，当合约状态为Refunding时，返回true

```javascript
 function withdrawalAllowed(address) public view override returns (bool)
```


## 流程

### 合约创建
创建者通过构造函数传入收益人地址beneficiary，创建合约

### 调用deposit存款
调用deposit方法向合约存款，并指定收款人

### 合约owner设置合约状态
合约状态可设置为2种：

#### 从Active设置为Refunding

此时收款人，可从合约中取回指定数量的资产

#### 从Active设置为Closed

此时收益人，可从合约中取回全部资产
