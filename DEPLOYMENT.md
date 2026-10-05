# Zova 发布流程

## 架构

```text
Windows 开发机 → GitHub / chat → 香港服务器 → 官网与服务
```

GitHub 保存源码和部署定义。服务器以只读方式拉取 `main`，验证提交后运行 `deployment/server-update.sh`。

## 自动上线范围

自动发布：

- `website/public/index.html`
- `website/public/assets/`
- `deployment/nameservice/` 的服务代码（只有内容变化时才重启）

不会自动发布或删除：

- `website/public/downloads/` 中的 MSI、APK 和源码归档
- `website/updates/` 更新通道文件
- 用户名数据库、TLS 证书、TURN 密钥、访问日志和服务器备份
- Windows、Android、iOS、macOS 的二进制客户端

## 服务器布局

- Git 工作副本：`/data/zova/source`
- 网站目录：`/data/zova/website`
- 用户名服务：`/data/zova/deploy-names`
- 发布锁：`/run/lock/zova-deploy.lock`

服务器使用 `zova-git-deploy.timer` 定时拉取。每次发布将提交号写入 `/data/zova/website/DEPLOYED_COMMIT`，可据此确认线上版本。

## 客户端正式发布

客户端需要在对应构建机生成，并执行项目中的校验脚本。校验完成后再上传服务器下载目录，并更新官网版本、校验和及软件内更新通道。安装包目前未使用商业代码签名证书，不能跳过 Windows 的安全提示。

## 回滚

服务器每次覆盖前会把当前首页与用户名服务代码备份到 `/data/zova/backups/git-deploy-<时间>-<提交号>/`。回滚时选择已验证提交，在服务器工作副本切换后重新运行发布脚本；数据库不随代码回滚。
