
# nch口令红包v2

NCH口令红包。

## 创建红包

部署合约时自动创建红包，指定口令、红包类型(均分或者拼手气)、红包个数、红包金额

构造函数：

```javascript
constructor(
        bytes32 _word,  // 红包口令
        bool _equalDivision, // 是否均分，若为false则表示拼手气
        uint256 _size // 红包个数
    ) public payable // payable表示可附带NCH资产，资产数量即红包总金额
```

## 打开红包

指定红包口令，即可打开红包，获得红包大小取决于红包类型。

若红包为最后一个，则合约自动销毁。

函数定义：

```javascript
function open(bytes32 _word) public 
```

## 关闭红包

红包发行者(即合约创建者)可调用kill接口，关闭红包，合约自动销毁，剩余金额转至发行者帐户。

函数定义：

```javascript
 function kill() public
```
