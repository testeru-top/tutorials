# 2」Zookeeper实现深入剖析
## Zookeeper核心模块
Zookeeper是一个分布式集群，部署的时候部署奇数个节点；为了达到资源的有效利用 
- 奇数个节点中有一个节点的角色是leader 
#### 选主逻辑
#### 数据一致性保障
- `zookeeper`中**leader**负责把数据**写入**
- 使用的是**ZAB协议**进行数据的同步工作
（dubbo用的是Pax OS协议）
#### 数据模型
- 树的模型
- 注册中心要解决的事


## 节点角色 

`server`节点组成的一个集群，在集群中存在一个唯一的`leader`节点负责响应写入请求，其他节点只负责接收转发Client请求
- **Leader**：响应**写**入请求，发起提案，超过半数`Follower`同意写入，写入成功
    - `ZK`集群中中会有唯一的一个`leader`，其它的称为`followers`
    - **Leader**是数据变更的核心点
    - `leader`通过一个叫事务的过程来处理，它包含**数据变更**和**版本号变更**两个方面
    - 一个事务是个原子操作，和数据库的事务不同，ZK的事务没有回滚
    - 状态变更操作 create,delete,setData则被委托给leader处理
- **Follower**：响应查询请求，将写入请求发给Leader，参与选举和写入投票
- **ObServer**：响应查询请求，将写入请求发给Leader，不参与投票，只接收写入结果
    - leader和follwers保证了数据更新的一致性，除了crash。因此会有第三种类型的服务，称为observer
    - observer不参与任何数据变更的决定过程，它仅仅应用这些变更，observer用于保证扩展性


```
如果想加速写的操作，扩容集群是否可以办到？
比如说之前有3个节点，扩容到5个节点的时候对应的写操作是否可以加速？？
```
- 扩容并不能加速写，因为不管扩容多大对应的写操作只是在Leader上进行

![](https://gitee.com/datau001/picgo/raw/master/images/202201072004287.png)
- 如果`Leader`节点挂了，对应的`Follower`是有选举权、可被选举为新的`Leader`，`ObServer`是没有选举权的

# 选主过程
## 1.选主逻辑 
- 投票
    - 获得法定数量票数
- 判断依据
    - `Epoch`：`leader`的任期
    - `ZXID`：`ZooKeeper`事务Id，越大表示数据越新；
        - 事务会有一个事务`ID`称为`ZXID`，`ZXID`是个64位的数据，包含时间+技术两部分
    - `SID`：集群中每个节点的唯一编号； 自定义

#### 比较策略： 
##### 任期大的胜出； 
##### 任期相同比较ZXID大的胜出； 
##### ZXID相同比较SID大的胜出

### 步骤：
对应Leader节点丢失
##### 1.所有 Follower 节点进入 Looking** 状态 
##### 2.广播发起投票
- 投票肯定是多次
- 第一次投票选择自己为Leader
##### 3.选出“最大”发起二次投票
##### 4.超过半数成为主

![](https://gitee.com/datau001/picgo/raw/master/images/202201072021802.png)
- 整个投票过程不是一次完成的，可以投票多次
- 任期都相同
- 第一次投票，每个server都投自己「毛遂自荐」，先比较ZXID的大小，然后再比较SID的大小
- 不变更的节点则不需要进行再一次投票
- 实际代码中，是节点收到一次投票，进行一次比较，看是否进行变更投票，不等到所有其他节点投票完成后再进行比对
    - 由于网络或其他原因，会有延迟

## 2.选主代码分析

### lookForLeader
#### 第一次选主
```java
    public Vote lookForLeader() throws InterruptedException {
        ...
        synchronized (this) {
                //选举轮数+1
                logicalclock.incrementAndGet();
                //初始化投票信息；updateProposal提案  我选我
                //getInitId:sid; getInitLastLoggedZxid:事务ID; getPeerEpoch:任期
                updateProposal(getInitId(), getInitLastLoggedZxid(), getPeerEpoch());
            }

    
        LOG.info(
            "New election. My id = {}, proposed zxid=0x{}",
            self.getId(),
            Long.toHexString(proposedZxid));
        //把对应的信息发送出去
        sendNotifications();
    }
```
##### updateProposal
- 第一轮投票选择自己
```java
synchronized void updateProposal(long leader, long zxid, long epoch) {
        LOG.debug(
            "Updating proposal: {} (newleader), 0x{} (newzxid), {} (oldleader), 0x{} (oldzxid)",
            leader,
            Long.toHexString(zxid),
            proposedLeader,
            Long.toHexString(proposedZxid));
        //选自己
        proposedLeader = leader;
        proposedZxid = zxid;
        proposedEpoch = epoch;
    }
```    
- 第一轮选举
- 开始新一轮的领导人选举

##### sendNotifications
```java
    //在我们的投票发生变化时向所有同行发送通知
    private void sendNotifications() {
        //通过for循环找到 对应的其他节点的路由信息 ，把票投出去
        for (long sid : self.getCurrentAndNextConfigVoters()) {
        QuorumVerifier qv = self.getQuorumVerifier();
        //notmsg 通知信息
            ToSend notmsg = new ToSend(
                ToSend.mType.notification,
                //投的Leader
                proposedLeader,
                //事务ID
                proposedZxid,
                //选举轮数
                logicalclock.get(),
                QuorumPeer.ServerState.LOOKING,
                //编号，第一个的时候sid和Leader是相等的
                sid,
                //任期
                proposedEpoch,
                qv.toString().getBytes(UTF_8));

            LOG.debug(
                "Sending Notification: {} (n.leader), 0x{} (n.zxid), 0x{} (n.round), {} (recipient),"
                    + " {} (myid), 0x{} (n.peerEpoch) ",
                proposedLeader,
                Long.toHexString(proposedZxid),
                Long.toHexString(logicalclock.get()),
                sid,
                self.getId(),
                Long.toHexString(proposedEpoch));

            sendqueue.offer(notmsg);
        }
}
```

##### Notification
- 发送消息的实体类的成员变量
```java
public static class Notification {
        /*
         * Format version, introduced in 3.4.6
         */

        public static final int CURRENTVERSION = 0x2;
        int version;

        /*
         * 选举的哪个节点为Leader
         */ long leader;

        /*
         * 提议的领导者的zxid
         */ long zxid;

        /*
         * 时代
         * 
         */ long electionEpoch;

        /*
         * 发送节点的当前状态
         */ QuorumPeer.ServerState state;

        /*
         * 发件人地址
         */ long sid;

        QuorumVerifier qv;
        /*
         * 任期，拟议领导人的时代
         */ long peerEpoch;

    }
```
![](https://gitee.com/datau001/picgo/raw/master/images/202201081723893.png)



#### 后面循环选举-while
- 根据投票结果，一直昌票，一直到选出主节点为止
- while循环
    - `recvqueue.poll(notTimeout, TimeUnit.MILLISECONDS);`
        - `recvqueue`:接收队列
        - `poll`:从队列中拿消息出来
        - 拿出来的消息就是上面分析的`Notification`
```java
while ((self.getPeerState() == ServerState.LOOKING) && (!stop)) {
    //recvqueue 接收队列
    //poll 从队列中拿消息出来
    Notification n = recvqueue.poll(notTimeout, TimeUnit.MILLISECONDS);
   if (n == null) {
        ......    
            
    } else if (validVoter(n.sid) && validVoter(n.leader)) {
    
            switch (n.state) {
            case LOOKING:
                ...
                break;
            case OBSERVING:
                LOG.debug("Notification from observer: {}", n.sid);
                break;
            case FOLLOWING:
                ...
            case LEADING:
                ...
            default:
                ...
                break;
            }
        } else {
           ...
        }
    }
```



##### validVoter
- `validVoter(n.sid) && validVoter(n.leader)`
    - 限定投票的人和leader 一定是集群的部署的范围之内
        - 集群的3节点上sid分别是：1，2，3；如果来了个sid=5的则不是该集群的节点
        - 检查传入的sid是否在当前部署的集群范围内
        - 如果给定的sid不是集群内已存在的，则为无效
    - 过滤成功后，则进行分支状态的判断

```java
    private boolean validVoter(long sid) {
        //限定投票的人和选中的leader就是在部署的范围之内
        return self.getCurrentAndNextConfigVoters().contains(sid);
    }
```
##### switch (n.state)
###### LOOKING：选主状态 
###### FOLLOWING：跟随者状态 
###### LEADING：领导者状态

![](https://gitee.com/datau001/picgo/raw/master/images/202201081744260.png)
#### 选举状态LOOKING逻辑查看


```java
while ((self.getPeerState() == ServerState.LOOKING) && (!stop)) {
    //recvqueue 接收队列
    //poll 从队列中拿消息出来
    Notification n = recvqueue.poll(notTimeout, TimeUnit.MILLISECONDS);
   if (n == null) {
        ......    
            
    } else if (validVoter(n.sid) && validVoter(n.leader)) {
    
            switch (n.state) {
            case LOOKING:
                ...
                //n.electionEpoch 收到的选票的选举轮数
                //logicalclock.get()  当前节点的选举轮数
                if (n.electionEpoch > logicalclock.get()) {
                    logicalclock.set(n.electionEpoch);
                    //清理记录选票
                    recvset.clear();
                    //真正选举的逻辑代码
                    if (totalOrderPredicate(n.leader, n.zxid, n.peerEpoch, getInitId(), getInitLastLoggedZxid(), getPeerEpoch())) {
                        //如果比较出来，则选举Leader为其他节点的数据否则选举自己节点为Leader节点
                        updateProposal(n.leader, n.zxid, n.peerEpoch);
                    } else {
                        updateProposal(getInitId(), getInitLastLoggedZxid(), getPeerEpoch());
                    }
                    sendNotifications();
                } else if (n.electionEpoch < logicalclock.get()) {
                        LOG.debug(
                            "Notification election epoch is smaller than logicalclock. n.electionEpoch = 0x{}, logicalclock=0x{}",
                            Long.toHexString(n.electionEpoch),
                            Long.toHexString(logicalclock.get()));
                    break;
                } else if (totalOrderPredicate(n.leader, n.zxid, n.peerEpoch, proposedLeader, proposedZxid, proposedEpoch)) {
                    updateProposal(n.leader, n.zxid, n.peerEpoch);
                    sendNotifications();
                }

                LOG.debug(
                    "Adding vote: from={}, proposed leader={}, proposed zxid=0x{}, proposed election epoch=0x{}",
                    n.sid,
                    n.leader,
                    Long.toHexString(n.zxid),
                    Long.toHexString(n.electionEpoch));

                recvset.put(n.sid, new Vote(n.leader, n.zxid, n.electionEpoch, n.peerEpoch));

                voteSet = getVoteTracker(recvset, new Vote(proposedLeader, proposedZxid, logicalclock.get(), proposedEpoch));

                if (voteSet.hasAllQuorums()) {

                    while ((n = recvqueue.poll(finalizeWait, TimeUnit.MILLISECONDS)) != null) {
                        if (totalOrderPredicate(n.leader, n.zxid, n.peerEpoch, proposedLeader, proposedZxid, proposedEpoch)) {
                            recvqueue.put(n);
                            break;
                        }
                    }

                 
                    if (n == null) {
                        setPeerState(proposedLeader, voteSet);
                        Vote endVote = new Vote(proposedLeader, proposedZxid, logicalclock.get(), proposedEpoch);
                        leaveInstance(endVote);
                        return endVote;
                    }
                }
                break;
            case OBSERVING:
                LOG.debug("Notification from observer: {}", n.sid);
                break;

               
            case FOLLOWING:

                Vote resultFN = receivedFollowingNotification(recvset, outofelection, voteSet, n);
                if (resultFN == null) {
                    break;
                } else {
                    return resultFN;
                }
            case LEADING:
               
                Vote resultLN = receivedLeadingNotification(recvset, outofelection, voteSet, n);
                if (resultLN == null) {
                    break;
                } else {
                    return resultLN;
                }
            default:
                LOG.warn("Notification state unrecognized: {} (n.state), {}(n.sid)", n.state, n.sid);
                break;
            }
        } else {
            if (!validVoter(n.leader)) {
                LOG.warn("Ignoring notification for non-cluster member sid {} from sid {}", n.leader, n.sid);
            }
            if (!validVoter(n.sid)) {
                LOG.warn("Ignoring notification for sid {} from non-quorum member sid {}", n.leader, n.sid);
            }
        }
    }
    return null;
} finally {
    try {
        if (self.jmxLeaderElectionBean != null) {
            MBeanRegistry.getInstance().unregister(self.jmxLeaderElectionBean);
        }
    } catch (Exception e) {
        LOG.warn("Failed to unregister with JMX", e);
    }
    self.jmxLeaderElectionBean = null;
    LOG.debug("Number of connection processing threads: {}", manager.getConnectionThreadCount());
}
```




##### totalOrderPredicate
选举的逻辑代码，如果以下三种情况之一成立，我们将返回 true：
* 1- 先比较任期，任期高的胜出
* 2- 任期相同，比较zxid，zxid高的胜出
* 3- 任期相同，zxid相同，比较但 server id 更高


- LOOKING内代码：
```java
//如果选举逻辑其他节点和当前节点比较返回true，则更新选举的Leader为其他节点
//否则，选举的Leader为自己当前节点
if (totalOrderPredicate(n.leader, n.zxid, n.peerEpoch, getInitId(), getInitLastLoggedZxid(), getPeerEpoch())) {
    updateProposal(n.leader, n.zxid, n.peerEpoch);
} else {
    updateProposal(getInitId(), getInitLastLoggedZxid(), getPeerEpoch());
}
//在我们的投票发生变化时向所有同行发送通知；把变更之后的投票发出去，给其他节点
sendNotifications();
```

- 真正选举的逻辑代码
```java
protected boolean totalOrderPredicate(long newId, long newZxid, long newEpoch, long curId, long curZxid, long curEpoch) {
        LOG.debug(
            "id: {}, proposed id: {}, zxid: 0x{}, proposed zxid: 0x{}",
            newId,
            curId,
            Long.toHexString(newZxid),
            Long.toHexString(curZxid));

        if (self.getQuorumVerifier().getWeight(newId) == 0) {
            return false;
        }

        /*
        怎样选举的逻辑代码
         * 如果以下三种情况之一成立，我们将返回 true：
         * 1- 先比较任期，任期高的胜出
         * 2- 任期相同，比较zxid，zxid高的胜出
         * 3- 任期相同，zxid相同，比较但 server id 更高
         */
        return ((newEpoch > curEpoch)
                || ((newEpoch == curEpoch)
                    && ((newZxid > curZxid)
                        || ((newZxid == curZxid)
                            && (newId > curId)))));
    }
```
##### updateProposal
- 如果比较出来，则选举Leader为其他节点的数据否则选举自己节点为Leader节点
- 代码和第一次选主调用的updateProposal一样



- LOOKING内代码：
```java
    else if (totalOrderPredicate(n.leader, n.zxid, n.peerEpoch, proposedLeader, proposedZxid, proposedEpoch)) {
    //如果你投票的比我当前选举的leader大，则更新推送出去
    updateProposal(n.leader, n.zxid, n.peerEpoch);
    sendNotifications();
    }
```
- 收到推荐的Leader一票和当前节点的Leader推荐票比较，如果没有变更不广播，如果变更则进行广播
- 如果我拿到了票，则需要进行计票环节


![](https://gitee.com/datau001/picgo/raw/master/images/test/202201111338812.png)

##### recvset

- LOOKING内代码：
```java
// don't care about the version if it's in LOOKING state
recvset.put(n.sid, new Vote(n.leader, n.zxid, n.electionEpoch, n.peerEpoch));
```

- 对应是一个map结构，k:Long. v:Vote,一票
    - (sid,Vote) 投票 (1,9)
- looking状态下不管任期
```
Map<Long, Vote> recvset = new HashMap<Long, Vote>();
```

##### getVoteTracker

- LOOKING内代码：
```java
voteSet = getVoteTracker(recvset, new Vote(proposedLeader, proposedZxid, logicalclock.get(), proposedEpoch));
```
- 拿着我投的这一票Vote，在我收到的投票中Map<Long, Vote>
    - 去找一下有没有相同的
    - 如果有相同的，则add一下addAck，看看票数是否超过1/2
```java
protected SyncedLearnerTracker getVoteTracker(Map<Long, Vote> votes, Vote vote) {
        SyncedLearnerTracker voteSet = new SyncedLearnerTracker();
        
        //拿着我投的这一票，在我收到的票数中查找是否有相同的
        voteSet.addQuorumVerifier(self.getQuorumVerifier());
        
        if (self.getLastSeenQuorumVerifier() != null
            && self.getLastSeenQuorumVerifier().getVersion() > self.getQuorumVerifier().getVersion()) {
            voteSet.addQuorumVerifier(self.getLastSeenQuorumVerifier());
        }


        for (Map.Entry<Long, Vote> entry : votes.entrySet()) {
            //看看对应是否有相同的投票
            //如果有，则在相同的上面add一下，然后看看是否超过1/2
            if (vote.equals(entry.getValue())) {
                voteSet.addAck(entry.getKey());
            }
        }

        return voteSet;
    }
```

![](https://gitee.com/datau001/picgo/raw/master/images/test/202201111354810.png)


##### hasAllQuorums
- LOOKING内代码：
```java
if (voteSet.hasAllQuorums()) {

    // Verify if there is any change in the proposed leader
    while ((n = recvqueue.poll(finalizeWait, TimeUnit.MILLISECONDS)) != null) {
        if (totalOrderPredicate(n.leader, n.zxid, n.peerEpoch, proposedLeader, proposedZxid, proposedEpoch)) {
            recvqueue.put(n);
            break;
        }
    }
```


- 判断票数是否超过一半


![](https://gitee.com/datau001/picgo/raw/master/images/test/202201111513953.png)

##### 看看队列里还是否能拿到一个票数出来
```java
while ((n = recvqueue.poll(finalizeWait, TimeUnit.MILLISECONDS)) != null) {
    if (totalOrderPredicate(n.leader, n.zxid, n.peerEpoch, proposedLeader, proposedZxid, proposedEpoch)) {
        recvqueue.put(n);
        break;
    }
}
```
- 去看看队列里还是否能拿到一个票数出来
    - `(n = recvqueue.poll(finalizeWait, TimeUnit.MILLISECONDS)) != null`
- 会不会有其他节点再发一张票出来
- 如果真的有,再来一次
    - `recvqueue.put`

##### 队列没有票了
    
```
if (n == null) {
    setPeerState(proposedLeader, voteSet);
    Vote endVote = new Vote(proposedLeader, proposedZxid, logicalclock.get(), proposedEpoch);
    leaveInstance(endVote);
    return endVote;
}
```
- 如果对应的没有则构造一个投票信息，返回
- 整个选举结束




#### 选举状态FOLLOWING逻辑查看
- 已经有主被选出来，但当前节点不知道
- 或者是刚刚加入到选举节点的集群中来


- LOOKING内代码：
```java
case FOLLOWING:
    Vote resultFN = receivedFollowingNotification(recvset, outofelection, voteSet, n);
    if (resultFN == null) {
        break;
    } else {
        return resultFN;
    }
```

##### receivedFollowingNotification
```java
private Vote receivedFollowingNotification(Map<Long, Vote> recvset, Map<Long, Vote> outofelection, SyncedLearnerTracker voteSet, Notification n) {

    if (n.electionEpoch == logicalclock.get()) {
        recvset.put(n.sid, new Vote(n.leader, n.zxid, n.electionEpoch, n.peerEpoch, n.state));
        voteSet = getVoteTracker(recvset, new Vote(n.version, n.leader, n.zxid, n.electionEpoch, n.peerEpoch, n.state));
        if (voteSet.hasAllQuorums() && checkLeader(recvset, n.leader, n.electionEpoch)) {
            setPeerState(n.leader, voteSet);
            Vote endVote = new Vote(n.leader, n.zxid, n.electionEpoch, n.peerEpoch);
            leaveInstance(endVote);
            return endVote;
        }
    }

  
    outofelection.put(n.sid, new Vote(n.version, n.leader, n.zxid, n.electionEpoch, n.peerEpoch, n.state));
    voteSet = getVoteTracker(outofelection, new Vote(n.version, n.leader, n.zxid, n.electionEpoch, n.peerEpoch, n.state));

    if (voteSet.hasAllQuorums() && checkLeader(outofelection, n.leader, n.electionEpoch)) {
        synchronized (this) {
            logicalclock.set(n.electionEpoch);
            setPeerState(n.leader, voteSet);
        }
        Vote endVote = new Vote(n.leader, n.zxid, n.electionEpoch, n.peerEpoch);
        leaveInstance(endVote);
        return endVote;
    }

    return null;
}

```

##### checkLeader
- 检查是否是领导者
```
protected boolean checkLeader(Map<Long, Vote> votes, long leader, long electionEpoch) {

    boolean predicate = true;
    if (leader != self.getId()) {
        if (votes.get(leader) == null) {
            predicate = false;
        } else if (votes.get(leader).getState() != ServerState.LEADING) {
            predicate = false;
        }
    } else if (logicalclock.get() != electionEpoch) {
        predicate = false;
    }

    return predicate;
}
```

![](https://gitee.com/datau001/picgo/raw/master/images/test/202201111548969.png)
# 数据一致性保障
- 描述写数据的过程
- Zab协议
    - `Zookeeper Atomic Broadcast`
    - `Leader`节点负责处理写请求
    - 2 阶段提交
## 01」数据一致性保障
- 如果写的请求发送给了 `follower` 节点
    - `follower` 节点会把该请求发送给 `Leader`
    - `Leader`去执行数据写入的操作

![](https://gitee.com/datau001/picgo/raw/master/images/test/202201111714684.png)

- 原子广播协议

第一个阶段：
- leader会告诉所有的follower 每个都要给我写
- 写完的给leader返回ack
- leader不会等待所有的节点返回ack
- 只要有一半或一半以上的follower节点返回ack「过半写」
- 超过一半写入


第二阶段：
- leader会向所有follower发送commit 请求提交
- 告诉事务可以结束，提交请求

## 02」Zab协议
> 不是强一致性协议，因为只要超过一半的写入成功就可以提交事务，这个时候并不是所有`follower` 节点数据一致

- Zab协议实现的是数据的顺序一致性 
### 强一致
### 顺序一致
### 最终一致

事务ID



```
public class ZxidUtils {

    public static long getEpochFromZxid(long zxid) {
        return zxid >> 32L;
    }
    public static long getCounterFromZxid(long zxid) {
        return zxid & 0xffffffffL;
    }
    public static long makeZxid(long epoch, long counter) {
        return (epoch << 32L) | (counter & 0xffffffffL);
    }
    public static String zxidToString(long zxid) {
        return Long.toHexString(zxid);
    }

}
```


##### getEpochFromZxid
- `zxid >> 32L`
- 获取任期
- 把低32位丢弃
##### getCounterFromZxid
- `zxid & 0xffffffffL`
- 逻辑与运算符
- 8个f;2个f是一个字节，一共4个字节
    - f就是1，与上任何一个值都能保留原值
    - 0与上任何一个值，操作结果都是0

```
00000000   ffffffff
任期值     事务计数器的值
----------------------- & 与
00000000  事务计数器的值
```
##### makeZxid
- `epoch << 32L`
- 事务ID左移32位，低32位为0
    - 任期丢掉
    ```
    00000000  事务计数器的值
    ```
- `counter & 0xffffffffL`

    ```
    任期值   00000000
    ```

```
ffffffff    00000000   
任期值     事务计数器的值
----------------------- & 与 
任期值       00000000
```

- `(epoch << 32L) | (counter & 0xffffffffL)`

```
00000000  事务计数器的值   
任期值      00000000
----------------------- | 或
任期值     事务计数器的值 
```

![](https://gitee.com/datau001/picgo/raw/master/images/test/202201111755075.png)

## 03」ZK数据一致性保障
### {1} 提案的发送
#### 创建出一个提案 
#### 提案放入待提交Map，key为ZXID 
#### 向所有Follow发送提案

```java
public Proposal propose(Request request) throws XidRolloverException {
    if (request.isThrottled()) {
        LOG.error("Throttled request send as proposal: {}. Exiting.", request);
        ServiceUtils.requestSystemExit(ExitCode.UNEXPECTED_ERROR.getValue());
    }
    if ((request.zxid & 0xffffffffL) == 0xffffffffL) {
        String msg = "zxid lower 32 bits have rolled over, forcing re-election, and therefore new epoch start";
        shutdown(msg);
        throw new XidRolloverException(msg);
    }
    //对应序列化  拿到data流
    byte[] data = SerializeUtils.serializeRequest(request);
    proposalStats.setLastBufferSize(data.length);
    //封装成一个对象 pp
    QuorumPacket pp = new QuorumPacket(Leader.PROPOSAL, request.zxid, data, null);
    Proposal p = new Proposal();
    //封装成了一个提案
    p.packet = pp;
    p.request = request;
    synchronized (this) {
        p.addQuorumVerifier(self.getQuorumVerifier());

        if (request.getHdr().getType() == OpCode.reconfig) {
            self.setLastSeenQuorumVerifier(request.qv, true);
        }

        if (self.getQuorumVerifier().getVersion() < self.getLastSeenQuorumVerifier().getVersion()) {
            p.addQuorumVerifier(self.getLastSeenQuorumVerifier());
        }

        LOG.debug("Proposing:: {}", request);
        //上一次已经提交的事务ID
        lastProposed = p.packet.getZxid();
        //outstandingProposals 待提交的map里面
        //把提案放在待提交的map里面
        outstandingProposals.put(lastProposed, p);
        //向所有的follower发送这个提案
        sendPacket(pp);
    }
    ServerMetrics.getMetrics().PROPOSAL_COUNT.add(1);
    return p;
}
```

![](https://gitee.com/datau001/picgo/raw/master/images/test/202201111824941.png)

### {2} 提案的确认数
- 记录leader针对特定提案收到的确认数
- follower发送给Leader的时候发送ack
#### 判断提案是否已经提交 
- `lastCommitted >= zxid`
    - lastCommitted 最后一次提交的事务
    - zxid 要提交的事务；客户端回的事务
- 因为是过半写入成功后就开始提交，那回消息比较慢的follower则会出现该情况
#### 从待提交Map中取出提案
##### outstandingProposals.get(zxid)
#### 记录ACK
##### p.addAck(sid)
- 每次都记录下来，等数值超过1/2就可以commit了

### {3} 提案的提交
##### tryToCommit
```java
//sid 哪个follower发送的请求
//zxid 事务ID
//followerAddr follower的地址
public synchronized void processAck(long sid, long zxid, SocketAddress followerAddr) {
        if (!allowedToCommit) {
            return; // 上次提交的操作是领导者变更 - 从现在开始
        }
        // 新领导人应该承诺
        if (LOG.isTraceEnabled()) {
            LOG.trace("Ack zxid: 0x{}", Long.toHexString(zxid));
            for (Proposal p : outstandingProposals.values()) {
                long packetZxid = p.packet.getZxid();
                LOG.trace("outstanding proposal: 0x{}", Long.toHexString(packetZxid));
            }
            LOG.trace("outstanding proposals all");
        }
        if ((zxid & 0xffffffffL) == 0) {return;}
        if (outstandingProposals.size() == 0) {
            LOG.debug("outstanding is 0");
            return;
        }
        //1. 判断提案是否已经提交  要提交的zxid 是99；如果lastCommitted是101，那对应的zxid已经被提交过了
        //lastCommitted最后一次提交的事务
        if (lastCommitted >= zxid) {
            LOG.debug(
                "proposal has already been committed, pzxid: 0x{} zxid: 0x{}",
                Long.toHexString(lastCommitted),
                Long.toHexString(zxid));
            // 该提案已经提交
            return;
        }
        //2. 从待提交map中取出提案   根据待提交的zxid获取它的提案
        Proposal p = outstandingProposals.get(zxid);
        //已经被提交过的时候会取不出来
        if (p == null) {
            LOG.warn("Trying to commit future proposal: zxid 0x{} from {}", Long.toHexString(zxid), followerAddr);
            return;
        }
        if (ackLoggingFrequency > 0 && (zxid % ackLoggingFrequency == 0)) {
            p.request.logLatency(ServerMetrics.getMetrics().ACK_LATENCY, Long.toString(sid));
        }
        //3. 记录ack 需要记录 sid （发送 ack 的服务器的 id）
        p.addAck(sid);
        boolean hasCommitted = tryToCommit(p, zxid, followerAddr);
```
![](https://gitee.com/datau001/picgo/raw/master/images/test/202201111859962.png)