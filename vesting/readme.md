# linear vesting 合约

合约示例包含2个接口：

1. create 创建一笔线性释放的锁仓资产，指定_to为收款人，_vestingStartTime为释放开始时间，_vestingEndTime为结束时间，可取回资产的数量在[_vestingStartTime, _vestingEndTime]之间，根据锁仓量线性增加。 其中锁仓量，在调用create接口的时候，发送给合约。

2. claim 取回锁仓资产，若未全部释放，则合约会计算实际可取回数量； 若已全部释放，则可一次性取回全部。

使用方法，点击[这里](https://docs.netcloth.org/advanced/contract-repertory.html#%E9%94%81%E4%BB%93%E5%90%88%E7%BA%A6)
