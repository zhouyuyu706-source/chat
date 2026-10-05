$ErrorActionPreference = 'Stop'
$path = Join-Path $PSScriptRoot '../website/index.template.html'
$s = [IO.File]::ReadAllText($path)
$s = $s.Replace('当前仅提供 Windows 开发预览包，未达到正式发布标准。', 'Windows 安装包与安卓签名 APK 已提供下载。请先阅读验证范围与发布说明；苹果端正在构建中。')
$s = $s.Replace('开发预览 · 非正式版', '0.2.2 · Windows x64')
$s = $s.Replace('Windows 64 位免安装包。下载后完整解压，再运行 Zova.exe。已验证启动及中文欢迎页，尚未完成双设备通信和安全验收，请勿用于敏感或生产业务。', 'Windows 64 位 MSI 安装包，保留原有界面与功能入口，采用 Zova 品牌、中文界面与自有默认通信服务。安装后从开始菜单打开 Zova。请先在非敏感环境完成实际通信验收。')
$s = $s.Replace('downloads/Zova-Windows-x64-preview.zip', 'downloads/Zova-0.2.2-Windows-x64.msi').Replace('下载 Windows 预览包', '下载 Windows 安装包')
$s = $s.Replace('downloads/Zova-corresponding-source.tar.gz', 'downloads/Zova-0.2.2-source-complete.tar.gz')
$s = $s.Replace('downloads/SHA256SUMS.txt', 'downloads/SHA256SUMS-0.2.2.txt')
$s = $s.Replace('<span class="status">尚未发布</span><h3>把对话，带在身边。</h3><p>Android 客户端正在准备构建与签名。完成真机收发消息、文件及通话验收后，这里将提供 Zova 官方 APK。</p><button class="download-action" aria-disabled="true" disabled>安卓下载暂未开放</button><p class="small">当前没有可交付 APK。请勿安装冒用 Zova 名称的来源不明安装包。</p>', '<span class="status">0.2.2 · 已签名 APK</span><h3>把对话，带在身边。</h3><p>Android 5.0 及以上 ARM64 安装包，已完成构建、独立密钥签名、包校验与单元测试。手机实测由使用者完成。该版本不含 Firebase 推送，后台接收受系统电池策略影响。</p><a class="download-action" href="downloads/Zova-0.2.2-Android-arm64.apk" download>下载安卓 APK</a><div class="links"><a href="downloads/SHA256SUMS-0.2.2.txt" target="_blank" rel="noopener">校验文件</a><a href="downloads/RELEASE-0.2.2.md" target="_blank" rel="noopener">发布说明</a></div><p class="small">约 20.6 MB · ARM64 · 保留账号备份，不要先卸载旧版 Zova。未宣称通过全部机型或端到端通信测试。</p>')
$s = $s.Replace('网站上线不代表三端正式版已交付。只有完成构建、签名与端到端测试的版本，才会标记为正式版。', '0.2.2 已提供实际安装文件，不将构建通过等同于全部功能或安全验收通过。<a href="downloads/RELEASE-0.2.2.md" target="_blank" rel="noopener">查看完整发布说明</a>。')
$s = $s.Replace('Windows：可启动的开发预览版', 'Windows：MSI 安装包').Replace('名称、图标、默认中文、独立数据目录及运行依赖已落地。尚缺代码签名、安全审查和双设备功能验收。', 'Zova 名称与图标、默认中文、独立数据目录和运行依赖已打包。此前版本已验证安装、卸载保留数据及升级。Windows 尚无受信任代码签名，双设备通信和安全审计不作完成声明。')
$s = $s.Replace('Android：待完成构建和真机验收', 'Android：已构建与签名').Replace('已准备品牌及包名改造。原生通信库、APK 签名与真机测试仍待完成。', '原生 ARM64 通信库与 Release APK 已生成，独立发布密钥签名及包名校验通过，16 项单元测试通过。真机测试由使用者完成；noPush 版本不保证被强制停止后的离线唤醒。')
$s = $s.Replace('基础设施：尚未完成独立通信服务', '基础设施：自有默认服务').Replace('当前客户端仍有 Jami 公共通信服务依赖；自有引导、中继、推送、域名服务和更新渠道尚未全部配置验证。免费网站子域名由第三方提供，不属于独占注册域名。', '新建账号默认使用自有引导、HTTPS 代理、认证 TURN 中继及签名用户名目录。已有账号不会自动改写；使用公开 DHT 网络，非封闭私网。更新从本站手动下载；免费子域名由第三方提供，不是独占注册域名。')
if ($s.Contains('安卓下载暂未开放') -or $s.Contains('当前仅提供 Windows')) { throw 'Old download copy remains' }
[IO.File]::WriteAllText($path, $s, [Text.UTF8Encoding]::new($false))
