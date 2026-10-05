# 聊天（Zova）

Zova 是面向 Windows、Android、iPhone 和 macOS 的中文通信客户端。本仓库是项目的单仓库交付入口，包含客户端、通信核心、官网、服务端组件和发布脚本，供其他电脑或 AI 一次克隆后继续维护。

线上地址：<https://zova.38-60-203-167.sslip.io/>

## 目录

- `client-qt/`：Windows / Linux 桌面客户端。
- `client-android/`：Android 客户端。
- `client-ios/`、`client-macosx/`：Apple 客户端源码。
- `daemon/`、`lrc/`：通信核心与客户端库。
- `website/`：官网源文件及已生成的上线页面。
- `deployment/`：用户名服务、Nginx/TURN 配置和服务器发布脚本。
- `branding/`、`packaging/`：Zova 品牌资源与 Windows 安装包配置。
- `scripts/`、`tests/`：构建、打包和验收脚本。

## 日常流程

```text
开发电脑修改并测试
        ↓ git push
GitHub 仓库 chat（唯一代码源）
        ↓ 服务器定时拉取 main
官网与服务端代码上线
```

首次接手请先阅读 [`AGENTS.md`](AGENTS.md) 和 [`DEPLOYMENT.md`](DEPLOYMENT.md)。

大型安装包、APK、编译缓存、运行数据库和密钥不进入 Git。Windows 与 Android 发布物仍由构建机生成，经校验后上传服务器；源码改动和部署定义以本仓库为准。

官网背景视频属于大文件，不进入 Git。全新克隆后运行 `website/fetch-large-assets.ps1` 可从正式站点下载并校验该资源；服务器自动发布不会删除已经在线的视频。

## 开源说明

Zova 基于 Jami 开源项目定制。第三方代码保留原始版权和许可，详见 `COPYING` 及各组件中的许可证文件。Zova 品牌和部署配置不改变上游代码的开源属性。
