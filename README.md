配置 volume

GlusterFS中的volume的模式有很多中，包括以下几种：

分布卷（默认模式）：即DHT, 也叫 分布卷: 将文件已hash算法随机分布到 一台服务器节点中存储。
复制模式：即AFR, 创建volume 时带 replica x 数量: 将文件复制到 replica x 个节点中。
条带模式：即Striped, 创建volume 时带 stripe x 数量： 将文件切割成数据块，分别存储到 stripe x 个节点中 ( 类似raid 0 )。
分布式条带模式：最少需要4台服务器才能创建。 创建volume 时 stripe 2 server = 4 个节点： 是DHT 与 Striped 的组合型。
分布式复制模式：最少需要4台服务器才能创建。 创建volume 时 replica 2 server = 4 个节点：是DHT 与 AFR 的组合型。
条带复制卷模式：最少需要4台服务器才能创建。 创建volume 时 stripe 2 replica 2 server = 4 个节点： 是 Striped 与 AFR 的组合型。
三种模式混合： 至少需要8台 服务器才能创建。 stripe 2 replica 2 , 每4个节点 组成一个 组。
这几种模式的示例图参考：CentOS7安装GlusterFS。

因为我们只有三台主机，在此我们使用默认的分布卷模式。请勿在生产环境上使用该模式，容易导致数据丢失。

Glusterfs调优

# 开启 指定 volume 的配额
$ gluster volume quota k8s-volume enable

# 限制 指定 volume 的配额
$ gluster volume quota k8s-volume limit-usage / 1TB

# 设置 cache 大小, 默认32MB
$ gluster volume set k8s-volume performance.cache-size 4GB

# 设置 io 线程, 太大会导致进程崩溃
$ gluster volume set k8s-volume performance.io-thread-count 16

# 设置 网络检测时间, 默认42s
$ gluster volume set k8s-volume network.ping-timeout 10

# 设置 写缓冲区的大小, 默认1M
$ gluster volume set k8s-volume performance.write-behind-window-size 1024MB


配置PersistentVolume

PersistentVolume（PV）和 PersistentVolumeClaim（PVC）是kubernetes提供的两种API资源，用于抽象存储细节。管理员关注于如何通过pv提供存储功能而无需关注用户如何使用，同样的用户只需要挂载PVC到容器中而不需要关注存储卷采用何种技术实现。

PVC和PV的关系跟pod和node关系类似，前者消耗后者的资源。PVC可以向PV申请指定大小的存储资源并设置访问模式。

PV属性

storage容量
读写属性：分别为ReadWriteOnce：单个节点读写； ReadOnlyMany：多节点只读 ； ReadWriteMany：多节点读写

PVC属性

访问属性与PV相同
容量：向PV申请的容量 <= PV总容量
