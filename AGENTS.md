# 聊天（Zova）项目接手说明

## 项目目标

本仓库是 Zova 的唯一云端源码入口。不要重新拆成多个私有子模块，也不要恢复已失效的上游式仓库指针。

## 修改前

1. 阅读 `README.md`、`DEPLOYMENT.md` 和目标组件的构建说明。
2. 执行 `git status --short`，保留用户已有修改。
3. 不读取、提交或输出本机 SSH 私钥、服务器密码、签名密钥、运行数据库和账号资料。

## 交付规则

- UI、品牌和中文文字以 Zova 当前实现为准；不要批量恢复 Jami 的用户可见品牌。
- 编译产物、安装包、APK、日志、缓存和 `website/public/downloads/` 不进入 Git。
- 官网源文件改在 `website/index.template.html`，运行 `website/build.ps1` 生成 `website/public/index.html` 后一并提交。
- 服务端发布只允许通过 `deployment/server-update.sh` 覆盖清单中的文件，不删除下载目录、更新包、数据库、证书或备份。
- Windows/Android 客户端变更必须在对应平台构建验证后再更新正式下载物；Git 推送本身不等于客户端安装包已经发布。
- 改动后记录实际执行的测试，不能把“构建通过”描述成真机或跨网络验收通过。

## Git 流程

默认分支为 `main`。常规流程：新分支修改 → 本地验证 → 合并到 `main` → 推送。服务器只跟踪 `origin/main`。
