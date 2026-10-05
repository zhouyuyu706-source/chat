# Zova 0.2.2 发布说明

这是保留 Jami 原有客户端布局、采用 Zova 品牌的定制版本，不是 D:\ZovaCore 的另一套界面。
底层包含 Jami 和第三方开源组件，保留原版权与 GPL 等许可证；不声称独占第三方代码版权。

## 安装与平台

- Windows：64 位 MSI，安装到 Program Files\Zova，独立数据目录 %LOCALAPPDATA%\zova。
  不覆盖 Jami、不迁移或删除原 Jami 账号。安装程序尚无受信任的商业代码签名。
- Android：ARM64 APK，最低 Android 5.0，包名 io.github.zhoyu1910_ship_it.zova。
  使用本项目独立发布密钥签名。安装或升级时不应卸载已有 Zova，否则可能丢失本地账号。
  该包不是 ARM32/x86 通用包；新系统和具体厂商机型兼容性由实际设备验证。
- iPhone：正在构建中，不提供虚假下载链接。

## 自有服务

新建账号的默认服务如下，Windows 与 Android 同步编译：

- 引导：38.60.203.167:4222。
- HTTPS DHT 代理：https://dht.zova.38-60-203-167.sslip.io:443。
- TURN：38.60.203.167:3478，realm zova；已启用认证、并发/带宽限额和内网目标拦截。
- 用户名：https://zova.38-60-203-167.sslip.io/names；公钥身份校验及 RSA-SHA512 签名注册。
- 官方动态 bootstrap/proxy 列表覆盖已禁用。

既有账号可能保存旧服务器设置，本次不会擅自改写用户数据。自有用户名空间和官方目录相互独立，
原 Jami 用户名不会自动迁入；仍可使用完整账号 ID 联系别人。
网络 ID 保持 0，兼容公开 DHT，不等同封闭私有网络；客户端可以直接点对点通信。
TURN 客户端凭据随应用分发，不是管理员密码，不能视为保密防滥用机制；当前总容量上限约 8 Mbit/s、
16 个分配，适合小规模使用，不宣称无限并发。服务器流量/租金仍由运营方承担。

## 推送、数据和更新

Android 为 noPush 构建，不接入官方 Firebase 推送。后台收消息依赖应用后台运行和系统电池策略；
被系统强制停止后不能承诺即时唤醒。不得把它宣传为已验证的系统级离线推送。
聊天身份密钥和消息保存在用户设备，服务端数据库只保存公开用户名映射，不备份用户聊天密钥。
用户必须在客户端自行导出账号备份并妥善保管密码；不要发送给客服或放到网站目录。
Windows 原官方自动更新已停用，版本更新从 Zova 网站手动下载。
sslip.io 为免费第三方子域名，不是独占注册域名；生产长期运营建议迁至自己注册的域名。

## 实际验证边界

已验证：Windows 构建；此前 0.2.0 安装/卸载/重装以及 0.2.1 升级保留数据；
Android 原生库编译、16 项 JVM 单元测试；目录服务 8 项测试及线上 HTTPS 签名注册/双向查询；
外网 TURN 双向数据转发、匿名/错误口令拒绝、私网和云元数据目标拒绝；数据库在线备份完整性。
最终安装包签名、校验值、最新 MSI 安装结果另见 ACCEPTANCE-0.2.2.md。
手机端真机测试由用户负责，这是用户明确要求，不伪称已完成手机实测。
双设备消息/文件/语音/视频、后台保活和长期稳定性尚不能仅凭构建或协议测试认定通过。
本版本仍基于较旧的开源代码，未完成全面安全审计；请先在非敏感测试环境验收，不宣传为安全审计通过的生产版本。

## 运维与私密交付

服务：dhtnode、zova-turn、zova-names、zova-names-backup.timer。
目录数据库 /data/zova/names/names.sqlite3；每日备份 /data/zova/backups/names/，位于网站目录外。
备份当前保留全部版本，运营方应监控磁盘并定期把备份复制到自己的另一台机器。
网站 /data/zova/website；现有同机商城保持不变。
安卓私钥备份仅保存在本机 D:\ZovaSigning，绝不能上传网站或公开源码。
保留此密钥才能发布覆盖安装的后续更新；本机丢失前应由运营方做离线备份。

## 重建

Windows：scripts/build-zova-windows.ps1 → package-zova-windows.ps1 → build-zova-msi.ps1。
Android：scripts/prepare-android-linux.sh → build-zova-android-linux.sh → sign-zova-android-linux.sh → verify-zova-apk.sh。
Ubuntu 22.04、JDK 11、SDK 30、Build Tools 30.0.3、NDK 23.1.7779620、Gradle 7.0.2。
首次准备需下载开源构建依赖；保留校验和，不关闭签名或哈希校验。
旧仓库两个离线 UI 依赖已按原版本源码放在 ring-android/vendor，许可证一并保留。
