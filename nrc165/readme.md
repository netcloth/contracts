# NRC - 165 标准接口检测

创建一个标准方法，以发布和检测智能合约实现了哪些接口。

## 规范

兼容NRC-165的合约应该实现以下接口：

```javascript
pragma solidity ^0.6.2;

interface NRC165 {
    /// @notice 查询一个合约时候实现了一个接口
    /// @param interfaceID  参数：接口ID, 参考上面的定义
    /// @return true 如果函数实现了 interfaceID (interfaceID 不为 0xffffffff )返回true, 否则为 false
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}
```

这个接口的接口ID 为 0x01ffc9a7， 可以使用 bytes4(keccak256('supportsInterface(bytes4)')); 计算得到。

合约实现 supportsInterface 函数将返回：

* true ：当接口ID interfaceID 是 0x01ffc9a7 (EIP165 标准接口)返回 true
* false ：当 interfaceID 是 0xffffffff 返回 false
* true ：任何合约实现了接口的 interfaceID 都返回 true
* false ：其他的都返回 false