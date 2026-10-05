# 当前交付方向和待办（2026-09-20）

## 2026-09-21 Windows 0.2.8 窗口图标统一

用户截图指出右上角最小化/最大化/关闭大小不一致。MainApplicationWindow不再用字体字符（破折号/方框/乘号），改为Qt Rectangle几何绘制；每个按钮46x36不变，三个图形均12x12光学框、1px线宽并居中。无黑条、可访问名称和按钮行为保留。qmlformat/build通过，最终EXE SHA256 9ED23C895274CB9A2B23E51C680DA52D4BF9B0961E6DFC09B962237C68EE9760。computer-use实际截图核对三图标尺寸/基线明显统一，未点击最小化/关闭。

MSI125510939字节，SHA256 b3cfdd9f3cc61d1d16318d0bfa3bfc1d3af88c66b2cd130077325139eb42071c；源码169733494字节，SHA25688a684127753c897e0c610754df4f9aa5b32f052f9eaed4d3c37d646d6b2d53c。MSI/source/notes服务器hash全OK，gzip通过；安装session73836 exit0、安装EXE匹配，开发进程59184退出并切回C:\Program Files\Zova\Zova.exe。官网已切0.2.8，旧首页备份/data/zova/index-before-028.html；公网主页/MSI/source HTTP200且字节一致。旧包、Android0.2.2、账户数据均保留，无未完成任务。

## 2026-09-21 Windows 0.2.7 去装饰与交互修复

完成补记：最终离线测试23行为用例+init/cleanup共25通过0失败，主线程复跑同样通过。测试目录已纳入6356文件源码，169732634字节，SHA25640b84f7531bfd268d3187abe92e616152e49774c9cb28cb7b98d8010643a38d4。安装62001 exit0、MSI上传11984 exit0、源码上传91387 exit0。安装EXE hash与payload一致；开发进程19572退出，已切回C:\Program Files\Zova\Zova.exe，computer-use只读截图核对最终主页。未继续抢用户输入。

官网0.2.7已切换，旧首页备份/data/zova/index-before-027.html。服务器4文件hash全部OK，源码gzip通过；公网首页和下载HTTP200且字节匹配，Android仍0.2.2。当前无未完成构建/安装/上传任务，所有旧包和账号数据保留。仅本次改动文件diff --check通过；全工作树存在之前安装器/欢迎页空白问题未动。网站仅版本说明和下载更新，不是新落地页设计。

用户明确调用“网站超级美化”，完整读取并采用先审查后改的流程；明确告知技能网站范围与Qt软件范围，保留Qt、品牌及原账户通信。新首页删口号和等高DepthCard三卡，新增QuickAction操作行、可选中ID/复制确认/QR；保留关于入口删除。QR改Popup，有明确关闭/焦点/加载错误重试，关闭Esc与全局快捷键分离。homeDevices使用openAccountSettings而非startWizard；MainView的windowControlsNeedInset+Loader.topMargin在聊天设置窄窗向导给36px透明安全区，避免浮动控制挡住原通话按钮。搜索选中旧输入/可见性shortcut/esc清空/清空后焦点。MaterialButton及PushButton由子agent完成按下优先、禁用、visualFocus、Enter松开单次/Action不重复、可访问名称。设置英文漏译修复qsTranslate既有翻译context。按钮白字对比度5.69:1起。

最终build3退出0，EXE 3B0425E6B583571D60F4C84BD9FBF0511B0103428C044667AF4AE1A0AE5AF442。MSI125469979字节，C02517CC53E7B14B882EC2F435A0FCEC07D2FA12E77AF0D0D81E078B2E3EAC95。实际UI检查主页/二维码打开/当前账户与设备路由通过；部分输入反复被user input保护拒绝，因此没有继续抢鼠标，未声称Esc、全窗口或全浅色UI均实机验收。已移除不用的AboutPopUp实例，最终运行无新QML加载/绑定循环，旧QQuickWidget OpenGL提示仍在。

tests/ui027由button_polish子agent添加offscreen Qt Quick Test，直接import生产组件，Constants/Helpers stub隔离后端。首轮19行为用例+init/cleanup共21通过，QuickAction扩展正在收尾；源代码导出需等完成。本机安装session62001、MSI上传11984进行中；首页本地0.2.7，线上尚未切。源码尚未导出。后续必须补完成记录。当前运行D:\ZovaRelease-App-0.2.7\Zova.exe开发payload，升级后需切回安装版。资料deployment/UI-AUDIT-0.2.7.md、RELEASE-0.2.7.md。

## 2026-09-21 Windows 0.2.6 删除底部关于入口

完成补记：46917上传exit0。服务器三项hash及源码gzip校验通过，旧首页备份/data/zova/index-before-026.html，官网已更新0.2.6；公网首页和两个下载链接HTTP200且字节数匹配。未删除旧包或用户数据，无后台未完成任务。

按截图删除mainview及wizardview的WelcomePage“关于 Zova”按钮（非隐藏），主页卡片改锚定parent.bottom，40px间距。wizard未使用的AboutPopUp实例一并移除；许可证版权保留。构建及MSI成功。computer-use截图右侧底部及完整AX树均确认主页无关于按钮；窗口左侧被用户其他窗口遮挡，未抢占。未新增QML加载错误，旧AboutPopUp绑定循环警告保留。
MSI125461787字节，SHA25686a31b1a290f231dff1fd134670c1630ab78fdae3e2c76ca44b16cddb4f9cb54；源码169718778字节，SHA2566bbe8e7724040adaa669ff50e6cc6e99aac0976cd13f301af44c162a9ee1338f。安装session63133 exit0，已安装EXE hash BEBA287DC7D9B5187D6CF2D8834961A39CECD1A9C8BC014D180306F7265CFEB0匹配payload；开发进程53920退出，已切回安装版。源码上传36949 exit0；MSI上传46917待完成。需要切换线上首页并补记。

## 2026-09-21 Windows 0.2.5 视觉精修

完成补记：MSI上传55071 exit0；服务器三项hash全部OK且源码gzip通过；官网首页已切0.2.5，旧页备份/data/zova/index-before-025.html。公网首页、MSI、源码HTTP200且大小匹配。旧发布文件和用户账号未删除。升级后的安装版已启动。无待运行构建/上传/安装任务。

用户继续要求更高级的质感。改石墨蓝 Atmosphere、非斜体品牌字标、主标题/副标题/等宽识别码层级，DepthCard细边缘高光、图标底座、克制透视与按压动画，SidePanel同色系材质和ContactSearchBar焦点描边。未更改账号/通信服务/Android。
实际运行截图通过，二维码卡片点击打开、点击遮罩关闭通过；联系人卡片点击后搜索框光标与焦点描边确认。Escape未关闭原二维码弹层；最大化尝试报window bounds changed，未声明通过。旧AboutPopUp绑定循环与OpenGL警告仍在，本次无QML加载错误。
编译成功、MSI成功、安装session22983 exit0。EXE SHA256 6239D2BDBFFB8B04D8ACC0A38B548986E7350A68F652350372D9D11F2066EEDD（已安装版一致）。MSI125457691字节，def49f94047bb9d4658b3fdbaf02dafef9ed060b5bcb16141df0d0fea8fc1500。源码169718663字节，1116b41548c0d1d80eb5aa2dbc3a1a5e70ca64de9eba86d9d4d381b37f46476b，6342文件。源码上传session82807已exit0；MSI上传55071待完成。开发进程40132已退出并切回安装版。公开首页待切换，后续需补记。

## 2026-09-21 Windows 0.2.4 轻立体界面（最新）

完成补记：MSI 构建 session66954 exit0，125453595字节，SHA256 c618b003c7c76f4aacceb2cbb969909a74d518cf406d9d6fd35e29a54ca3a2e7。源码上传 session13025、MSI上传 session39378 均 exit0。管理员安装 session23897 exit0，已安装 EXE 与最终payload hash一致。已退出开发进程55744并启动 C:\Program Files\Zova\Zova.exe；computer-use 实际截图确认安装版顶部无黑条、三个按钮保留、光影/卡片与原 zzz 账号正常显示。没有补称点击/拖动/通信全验收。

网站已切换 Windows0.2.4，Android仍0.2.2；旧首页保存在 /data/zova/index-before-024.html，旧安装包保留。服务器三个发布文件 SHA256 全部OK、源码gzip完整性通过。公网首页200且版本链接正确，MSI/source HEAD200且Content-Length分别125453595/169718461匹配本地。无未完成构建、上传或安装session。本次仅升级Windows UI。

用户要求更精致 UI、交互、少量3D，并去掉顶部黑色横条只留三个按钮。修改 MainApplicationWindow：header 改透明 overlay；拖动区只在中央，左侧搜索不被挡；边缘 resize Repeater 移到 Overlay 父级以消除 sibling 报警。
新增 Atmosphere.qml 全区域柔和径向光影、DepthCard.qml 可点击卡片（悬停scale/Rotation、press反馈、阴影/渐变/焦点边框）；主页三卡片分别 focusContactSearch、qrDialog.open、mainView.startWizard。识别码复制后显示已复制1.8秒。SidePanel加空态图标/阴影/边缘；MaterialButton加短暂scale和color动效；搜索提示对比度提高。
初版使用 Qt6.2 不支持的 DropShadow.samples 导致窗口不可见，已根据本地 Qt组件源码移除；新版已能正常加载。光影局部矩形边界已修成全区域渐变。已实机截图核对顶部无黑条、三个按钮、光影和卡片；多次点击尝试被 computer-use 的“检测到用户输入”保护中止，没有假称按钮点击/拖动/缩放全验收。后续不抢占用户点击。
最终payload D:\ZovaRelease-App-0.2.4，EXE SHA256 80924D58B00D932D24BFDB1AF0CF177405E48C63EF6BC5F6D0FDC011CD450335。
对应源码 Zova-0.2.4-source-complete.tar.gz，169718461字节，SHA256 f9c495b5be9ba02d0e99016bbd05fc8c806f918316af2f5325b0456d0ba0e48b。6341工作树文件，隐私排除规则保留。
编译build3退出0，源码完成；MSI session66954仍在生成（需后续完成记录）。本机安装版暂为0.2.3，当前运行0.2.4开发payload。网站本地Windows文案已为0.2.4，安卓仍0.2.2，尚未切换首页。
运行日志 ui024-final.stderr.log：仍有旧的 AboutPopUp MaterialLineEdit implicitWidth 循环提示、QQuickWidget OpenGL警告，不能说零警告；本轮无界面加载错误。QT_LOGGING_TO_CONSOLE=1和QT_ASSUME_STDERR_HAS_CONSOLE=1用于本轮子进程日志，未全局设置。

## 2026-09-21 Windows 0.2.3 界面修复（本轮最新）

完成补记：上传 session86717 exit0；管理员 MSI 升级 session65440 exit0，日志 D:\ZovaInstallers\upgrade-023-admin.log。已安装 EXE hash 与最终 payload 一致，现运行 C:\Program Files\Zova\Zova.exe PID43196（当时）。computer-use 核对安装版深色主页、透明品牌、底部账户栏与原 zzz 账号仍存在。开发包进程均已退出。
网站更新已完成，旧首页备份 /data/zova/index-before-023.html。三个新发布文件服务器 SHA256 全部 OK、源码 gzip 完整性通过。公网主页200且 Windows0.2.3/Android0.2.2链接正确，MSI/源码 HEAD200且字节数一致。0.2.2文件保留，不删原始用户数据。本轮没有有效未完成上传/安装 session。

用户要求收起开发者名单、去掉品牌黑底、按其 Jami 截图恢复 UI。改动仅 Windows Qt 客户端，安卓仍为 0.2.2。
已编译并运行 D:\ZovaRelease-App-0.2.3\Zova.exe；SHA256 F242EBB9D76C242FEB852C6F36491F33D2CA383726C50A9EC2A917CD0E4B327D。
欢迎页两主按钮/展开导入与高级入口、透明蓝标+原生字标、深色默认迁移、主页渐变/提示卡片/底部账户栏、无边框窗口与移动/缩放操作。保留所有已有账户流程、网络默认值和版权许可。About 名单默认收起并可展开。字体改 Microsoft YaHei UI。
用 computer-use 实际检查原账户 zzz 的主页、底部账户菜单、欢迎页、已有账户/高级展开、关于窗口名单收起。没有创建或删除账号、没有发送消息；最大化检查因检测到用户输入未执行，不声称通过。
图片使用内置 imagegen，第二稿只显示蓝色图形，字标用 QML 文本；资源 client-qt/resources/images/zova-transparent.png，组件 BrandLogo.qml。完整提示与限制见 RELEASE-0.2.3.md。并非逐像素新版 Jami 迁移，已明确告诉用户。
MSI D:\ZovaInstallers\Zova-0.2.3-Windows-x64.msi，125424923 字节，SHA256 b14cb0882fa6009e4f24033456cffda6150401d8104631f990865be5d9c9eeb9，WiX ICE 校验通过，未签名。
对应源码 Zova-0.2.3-source-complete.tar.gz，169719561 字节，SHA256 8453beb863d3270b5329253e297f6bf9e822c3aedb878f7bb7033be6020e146c。源码导出于网站版本文案更新之前，包含实际编译的 Qt 修改和素材。原 0.2.2 隐私排除规则保留。
目前上传 session86717、管理员升级 session65440 进行中，需看后续完成记录。网站本地已更新只切换 Windows 0.2.3，尚未上传首页。不得覆盖安卓0.2.2为未构建的新版本。

## 2026-09-21 继续执行结果（最新）

0.2.2 下载页已正式替换上线，旧首页备份在 /data/zova/index-before-022-*.html，旧安装包保留。
Windows MSI、安卓 APK、清理后的对应源码、发布说明和验收说明全部上传；服务器 sha256sum -c 五项均 OK。
源码最终 SHA256 adb80a0bfc96bb534d23d0ffea618c5db079a732ebb9ecce198e44b25bfb773b，文件名 Zova-0.2.2-source-complete.tar.gz。
源码排除了私密签名文件、本 HANDOFF 和 iOS review_information 审核资料；早先待复查源码移到网站外 /data/zova/source-022-review.tar.gz，不在公开下载链接中。
线上 index SHA256 ec3a73d1a93b1b00b2f0c63f3ba7ea0084b671461ca6e188289218148ea8813d。
实际浏览器验证 Windows 下载、安卓下载、iPhone 禁用的正在构建中入口均正确。公网重新下载完整 APK，SHA256 与签名发布包一致。
已退出无账号的旧开发欢迎进程 PID17184，启动 C:\Program Files\Zova\Zova.exe（PID60748，当时）。界面检查技能确认安装版中文欢迎页、Zova 图标/品牌、原有创建/关联/恢复账号入口。安装EXE与payload哈希一致。
自有服务 active，TURN 跨网络认证/私网拦截/双向转发复查通过；商城容器 Up 6 days，未修改。61622 临时 SOCKS 监听已不存在，无需误杀旧 PID。
手机实测由用户负责。仍不可声称全功能端到端验收或全面安全审计完成；noPush、公开DHT、免费第三方域名及未受信Windows签名等限制已公开说明。

## 最新中断点（22:38，优先于下方旧记录）

用户物理 Escape 停止了 Computer Use；本轮禁止继续界面工具。不是整个项目完成。
0.2.2 Windows 已编译、打包、MSI 实际管理员升级成功 exit 0（upgrade-022-admin.log），安装 EXE SHA256 应与 payload 核对。
MSI：D:\ZovaInstallers\Zova-0.2.2-Windows-x64.msi，SHA256 F9EF36C1B6D02974E35A5FD0ADD74665B2C301C6DBE72B358D90D342E5DE7F84。
APK：D:\ZovaInstallers\Zova-0.2.2-Android-arm64.apk，SHA256 38a32426dc51cf1b57b4055c826850a78d7c0d76d18380c03ae7fc6fc43b93ec。
APK Release 构建成功（android-release-022c.log），16 项 JVM 测试全通过，独立发布密钥签名、zipalign、包名/版本/ABI/库检查成功（android-apk-verify-022b.log）。真机由用户测试，不阻塞构建，不伪称实测。
安卓保持原布局，新增 CallAccounts 归属适配与测试，把 2021-09 Android 接口接到 2021-12 daemon。原来缺失的 flexbox2.0.1 和 ShapeRipple1.0.0 已 vendor 原源码+许可。旧测试脚手架及不再匹配实际 API 的测试已修正，不能说所有功能已测。
Windows payload D:\ZovaRelease-App-0.2.2；当前仍运行老的 OwnBootstrap 开发欢迎窗口，尚未重启检查新安装窗口。用户停止了该检查。

自有服务已部署并已重新编译进 0.2.2 双端：bootstrap、HTTPS proxy、TURN、names。
names 位于 https://zova.38-60-203-167.sslip.io/names，源码 deployment/nameservice；8 项单测及真实 HTTPS 注册/查找/签名拒绝通过；QA 记录 zova-qa-1789914634 保留在测试命名空间数据库。
TURN 38.60.203.167:3478 realm zova，公开分发客户端凭据 zova-client / ZovaPublicClient2026v1（不是管理员秘密）；私网目标拒绝，16分配、总约8Mbit/s限额。scripts/test-zova-turn.py 实际跨网络双向转发、错误口令和私网目标拒绝均通过。公共凭据无法防止所有滥用，勿称私有认证账号系统。
服务 zova-names、zova-turn、dhtnode；新 coturn 默认服务已停用。names 每日备份 timer 已启用，手动备份完整性通过。数据 /data/zova/names，备份 /data/zova/backups/names（非网站目录）。原商城未改。
新服务配置 deployment/website-https.conf 已上线，nginx -t 通过；网页内容仍是旧版，下载新文件尚未上传。

下一步：网站 index.template.html 已用 scripts/update-release-website.ps1 更新下载和真实验证范围，尚未 build/上传。复制 MSI/APK 到 website/public/downloads，复制发布说明 deployment/RELEASE-0.2.2.md，生成 SHA256SUMS-0.2.2.txt；iOS 保留正在构建中。
源码导出脚本 scripts/export-release-source.py（使用实际 dirty 工作树而非 HEAD）。已有 D:\ZovaInstallers\Zova-0.2.2-source.tar.gz 169MB，但在签名脚本修正及最终网页改动之前导出，需重新导出到网页引用名 Zova-0.2.2-source-complete.tar.gz。脚本后续已修正误排除 credentialsmodel 等源码的规则，必须重新跑。不要发布旧源码包冒充最终对应源码。
随后 website/build.ps1、scp 上传版本化真实文件、校验线上哈希和下载响应、最后替换 index.html。旧包保留可回滚。需补 ACCEPTANCE-0.2.2.md，发布说明已诚实列出 noPush/非隔离DHT/无Windows信任签名/未完成全面安全审计/用户手机实测等边界，不可称完整生产验收。
临时 SSH SOCKS 127.0.0.1:61622（PID49776，需重新核对）仍在，为 Gradle 下载使用；完成下载后关闭该特定进程，别误关其他 SSH。
构建环境 WSL1 ZovaAndroidBuild；/opt/zova-src、SDK/NDK 已可用；原生库已重建，不用从头下载。安卓私钥 D:\ZovaSigning 离线备份，绝不公开。
没有有效自动化 zova（用户可能已删除），不要承诺后台自动继续。

最新验收变更：用户明确手机真机测试自行负责；不得再以未连接手机或未做手机实测阻塞 APK 构建和发布。仍必须完成实际 APK 构建、签名、包校验，并准确标注手机实测由用户负责。用户要求完整完成并上线，不要逐个小里程碑当交付。

用户最终确认：保留 Jami 原界面、布局和全部功能，Zova 名称与图标，自有服务器；不继续 D:\ZovaCore 新 UI。保留 GPL 等原始许可。iOS 仅“正在构建中”。严禁把开发包称为正式版。

最新优先级：用户要求先把 App 做好。优先原生 Windows 安装包与 Android 构建，不扩展网页或其他服务。手机验收可以在包准备完成后进行。新增 packaging/ZovaWindows.wxs 与 scripts/build-zova-msi.ps1；WiX 3.14.1 官方 binaries 在 D:\ZovaBuildDeps\WiX3141。当前已重新编译包括自有 HTTPS proxy 的 Windows 可执行文件；新 payload 路径 D:\ZovaRelease-App-0.2.0，MSI 构建日志 zova-msi-build.log。必须验证 MSI 安装升级卸载和保留用户数据后才能正式发布。

## 已完成

- 2026-09-20 后续：Windows test2.msi 实际安装、卸载、重装均退出 0，卸载保留账号目录，现保留安装。Docker 重启获用户授权，但确认系统没有运行 hypervisor，不强行重启电脑；已成功创建独立 WSL1 发行版 ZovaAndroidBuild（D:\ZovaAndroidWSL），安装编译依赖。SDK/NDK 准备日志 android-sdk-prepare.log。脚本 scripts/prepare-android-linux.sh、build-zova-android-linux.sh、sign-zova-android-linux.sh。安卓环境在 Linux /opt/zova-*，不在商城服务器上编译。

- 原品牌 Windows 包 D:\ZovaRelease 保留。
- 新的 bootstrap 包 D:\ZovaRelease-OwnBootstrap-20260920 已编译、启动，账号数据未改。进程启动时 PID 17184。
- 香港 38.60.203.167 安装 Ubuntu dhtnode，systemd override 在本目录；UDP 4222 主机防火墙已放行，网络 ID 0（非隔离私网）。
- dhtnode 开启代理 8480，仅通过 nginx HTTPS 对外，8480 未在 UFW 放行。
- https://dht.zova.38-60-203-167.sslip.io/ 已从 Windows 外网请求，返回真实节点 JSON；证书到期 2026-12-19，有 certbot 续期任务与已有 nginx reload hook。
- daemon/src/jamidht/jamiaccount.h 默认 bootstrap 和 proxy 已修改。代理修改在上次构建之后，必须重新编译。已有账号不能无备份强改。
- 同机商城 HTTPS 200，未改商城。

## 明确未完成

最新 Windows 安装包进展：D:\ZovaInstallers\Zova-0.2.0-x64-test2.msi 已通过 WiX 中文 MSI 构建与 ICE 校验；msiexec /a /qn 管理解包退出 0，解包 EXE SHA256 与源一致。未实际安装或升级卸载验收，未签名。test.msi 为失败旧产物禁止分发，详情见该目录 README。不可把管理解包当安装验收。

- TURN 仍官方；必须认证、限额并阻止内网目标，不能裸开放中继。
- 用户名目录仍官方；必须验证账号公钥 ID 与注册签名，不可用无鉴权名字映射冒充。
- 独立推送、移动端后台收消息、更新渠道、安全和备份验收。
- 安卓源码为 2021 年版本，缺 SDK/NDK；Docker 本地 info 返回 500，WSL list 没有返回发行版。不得在现有商城服务器上直接执行耗尽资源的大编译。
- 用户已确认有安卓真机与移动网络，已请其 USB 连接并授权调试。尚未检测到 adb，不得宣称真机测试完成。
- UDP 简易 bencode ping 超时可能因协议格式，并非确认云防火墙故障；服务器第二 dhtnode 本地连接确实收到 pong。
- 旧官网 iOS 区域仍提到“新自有核心”，需要根据最新方向修正文案，不改整体视觉。旧下载包未替换。

## 验收门槛

原 UI 对照、两端安装/升级/卸载不丢数据、双设备跨网络文字/文件/语音/视频、账号备份恢复、多设备、后台接收、自有服务实际使用证据、服务重启和备份恢复、安全检查、对应源码和依赖许可、发布校验值。无结果不得勾通过。若需要用户签名身份或真机操作应明确通知，不伪造认证。

本目录的 nginx 配置安装到 /www/server/panel/vhost/nginx/zova-dht.conf。部署前 nginx -t，失败不得 reload。已有商城和其他项目全部保留。连接沿用已有 SSH 配置，不把私钥写进文档。
# 2026-09-21 Windows 0.2.9 原生聊天首页

Windows 首页改为功能型会话空状态，移除大 Logo、宣传口号、光晕、身份卡与重复胶囊入口；保留添加联系人、复制识别码、二维码及账户设备操作。侧栏、账户栏圆角与色阶统一。Release 编译及实际启动通过，自动化树可识别全部主页操作，“添加联系人”已验证会聚焦搜索框。MSI 行政映像展开成功，展开 EXE 与发布 EXE SHA256 一致。当前非提权会话执行系统级升级被 Windows Installer 以管理员权限要求拒绝，旧安装未被覆盖；不影响新安装包本身的展开验证。

MSI 125457691 字节，SHA256 8a1a20f8e66da94ee68289e229b4a3a3e3422ef31a74e79d9a555feb1395221f；源码 169733140 字节，SHA256 ea5e1fa7c568da74370d298746a7a3971abdbb9a2b3803d71a4a38f87d7c8c8d。服务器 hash 与 gzip 校验通过，官网已切换 0.2.9，旧首页备份 `/data/zova/backups/index-before-029.html`；公网主页、MSI、源码、校验文件均 HTTP 200 且大小一致。
