# Android 构建修复记录

使用独立 WSL1 ZovaAndroidBuild，不改变原 UI，JDK11、SDK30、NDK23.1.7779620，先编译 ARM64。

- 构建副本 shell/make/校验文件统一 LF，原始 Windows 工作区不做全量换行转换。
- FFmpeg n4.4 旧 gitweb 下载返回 HTML，改为官方 GitHub FFmpeg/FFmpeg 的 n4.4 归档；从官方重新下载，SHA512 与本地已有 Windows 构建使用的同版本归档相同。
- libarchive 3.5.1 官方 Release tag 为 v3.5.1，原 URL 缺 v 导致 404；原有校验值保留。
- LibreSSL openbsd 归档旧 SHA512 不符。没有关闭校验：另行克隆官方 libressl/openbsd 的 libressl-v3.4.0 tag，解析到 76f3844ea887613e8a6df2ccc1f84d9ac93169b3；解压归档与 Git checkout 逐文件 diff（排除 .git）退出码 0，再记录新归档哈希。portable 归档与原校验值相同。
- libressl 校验规则改为同时验证两个归档，修正原规则串接 grep 只验证最后一个文件的问题。
- 原中文缺失 9 项已补齐；默认字符串从中文资源机械同步，保留版权头，Android 资源语言筛选为中文。版本名 0.2.0，versionCode319。

密钥：仅在本机 Linux /opt/zova-signing，权限 0700/0600。绝不能包含在对应源码或网站下载中。签名脚本读取密码文件而不输出密码。

尚未生成或发布 APK，不得把本记录视为完成构建/安全验收。
