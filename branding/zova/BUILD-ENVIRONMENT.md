# Windows 构建环境

2026-09-20 实际安装和验证：

- VS Build Tools 2022：D:\ZovaBuildTools（MSVC 14.44，Windows SDK 10.0.26100.0）。
- CMake：VS 自带版本，已成功生成 daemon 和 Qt 工程。
- Qt 6.2.1 msvc2019_64：D:\ZovaQt，含 WebEngine/Core5Compat/NetworkAuth/Positioning/WebChannel/ShaderTools。
- Python 独立环境：D:\ZovaBuildEnv，aqtinstall/ninja 已安装。
- MSYS2：C:\msys64，patch/make/diffutils/nasm/yasm 已安装。
- 二维码静态库 qrcodelib.lib 已在 x64 Release-Lib 目录编译生成。
- Strawberry Perl 5.42.3.1 与 ATL 已安装并验证文件存在，管理员授权已完成。

补充源码：lrc 采用 707a7b60a46b5021057382b2ca7906f667d18942（2021-09-08 Qt6 迁移版），从公开 jami-libclient 获取，保留许可证；运行时不依赖其 Git remote。

已修复旧脚本的 vswhere 参数分词、VS2022 generator、Qt 路径参数和错误入口名称。重试命令：scripts/build-zova-windows.ps1。

真实编译结果：全部依赖、daemon、lrc 和客户端构建成功，Zova.exe 已链接并打包至 D:\ZovaRelease。2026-09-20 已实际启动并检查中文欢迎窗口、Zova 图标和原图标志；数据目录为 %LOCALAPPDATA%\zova。GnuTLS 的 mkdir、UPnP 的误用 MFC、中文 Windows UTF-8 编译均已修复。QtSerialPort 运行依赖已补齐。

当前 exe SHA256：0445571BE9450B8045624FB033784CB7295DB7CD77D7AA79726D929922F3E599。仅通过启动检查，尚未进行双设备通信验收。

本环境仅为旧源码兼容构建；发布前仍须完成依赖版本审查、签名及功能验收。
