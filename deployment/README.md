# Zova 基础服务

保留原 Jami 客户端 UI 与通信协议；本目录仅用于自有服务部署。

`dhtnode-override.conf` 安装到 `/etc/systemd/system/dhtnode.service.d/zova.conf`。
依赖 Ubuntu dhtnode 软件包，监听 UDP 4222。未设置任何上游引导节点。
网络 ID 仍为 0，以保持现有客户端协议兼容；这不构成私有网络隔离。
限制内存 160 MiB、CPU 25%，避免影响同机商城。

当前仅引导节点部署，不代表 TURN、代理、用户名服务或推送迁移完成。
不得将没有通过双设备通信验证的构建标记为正式交付。
