# Zova 改造状态（2026-09-20）

这是基于现有 Jami 源码的 Zova 开发版本。Windows 已构建并实际启动，尚未签名或完成通信验收，不能作为生产成品发布。

## 已落地

- 桌面界面显示名称、设置命名空间和安装产品名称改为 Zova。
- Windows MSI 独立 UpgradeCode；停止运行旧 Jami/Ring 的清理和强制结束进程动作。
- 桌面默认加载简体中文翻译，品牌相关翻译源键同步更新。
- 桌面 zh_CN 翻译表 532 项经检查，非空 source 无 unfinished/空翻译；这不代表运行时所有组件已完成中文验收。
- 横版品牌图保持用户提供原图；方形图标由 imagegen 基于原图生成。
- Qt 欢迎页、关于、托盘、ICO/ICNS；Android 启动图标/品牌图片；iOS 图标资源已替换。
- Android applicationId 为 io.github.zhoyu1910_ship_it.zova，文件共享 provider 使用动态 applicationId。
- 桌面 Windows 官方自动更新默认停用；旧 macOS 客户端移除官方 Sparkle feed。
- 原始版权、许可证、协议名和内部源代码命名空间保留。

## 尚未完成，不能宣称独立可用

- Windows 已安装 VS2022 C++/ATL、SDK、Qt 6.2.1、CMake、MSYS2 和原生 Perl；Android 缺 SDK/NDK，现有 Android 源码版本为 20210908-01。
- Windows 全量构建已通过；Zova.exe 与运行依赖已打包至 D:\ZovaRelease，实际窗口标题、中文欢迎页、图标及品牌图已检查。
- 本机 Docker 引擎未运行；iOS/macOS 构建需要 macOS/Xcode。
- 已有 Windows 免安装开发目录，尚无签名安装包，没有进行双设备注册、文字/文件/音视频通话验收。
- 仍含官方 bootstrap.jami.net、dhtproxy.jami.net、turn.jami.net、ns.jami.net 通信服务地址。没有将其伪替换成未部署地址。
- 签名证书、Apple 开发者团队、推送凭据、域名和独立服务仍需配置及验证。
- 苹果 Bundle ID、App Group、推送权限必须协调修改；当前只完成显示名称/图像，未伪造签名身份。
- Windows 输出名称和安装文件引用已同步改为 Zova.exe；免安装打包及启动通过，MSI 安装流程未验证。
- Android 中文默认语言及剩余文案、客户端帮助/反馈外链需继续审查。
- Windows daemon 数据目录名已改为 zova，并停用旧账号目录自动迁移；首次运行已验证写入 %LOCALAPPDATA%\zova，原版 Jami 未被覆盖。
- GitHub 私有仓库是否成功推送需另行验证；上传服务器源码不等于完成源码托管或应用部署。

## 图像来源

wordmark.png 为用户提供的原图。icon.png 使用内置 imagegen 编辑生成，提示：保留原图蓝青色折叠 Z 形状与阴影，深海军蓝底，方形安全留白，移除文字。其他尺寸由脚本机械缩放/封装。

## 重现

运行 scripts/apply-zova-brand.ps1 更新受控范围内的品牌文字；运行 scripts/build-zova-assets.ps1 并传入 Wordmark、Icon 源文件生成各端资源。不要在生成时把输出文件自身作为输入。

生产发布前须补齐以上项目，保留本文件作为阻止误发布的验收清单。

## 已执行检查

- 739 个客户端 XML/翻译/plist 文件能够解析。
- 四个客户端 git diff --check 通过（Windows CRLF 按 cr-at-eol 检查）。
- 图片由原图/生成图派生，各端图像修改不触碰版权文件。
- Windows C++ 编译、链接、运行依赖部署及欢迎窗口检查已通过；尚未覆盖 Kotlin/Swift 编译、安装、签名或通信功能。
