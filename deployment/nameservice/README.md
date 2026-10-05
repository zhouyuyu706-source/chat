# Zova 独立用户名目录

与原客户端协议兼容的独立命名空间；不导入或冒充 Jami 公共目录。
每个注册必须提供账号公钥、对应的 40 位账号 ID 和对小写用户名的
RSA-SHA512 签名。账号 ID 使用 GnuTLS 的 SHA1(SPKI DER) 规则：
https://www.gnutls.org/manual/html_node/Abstract-public-keys.html

防止未签名占名、冒用别人的账号、覆盖已有名字；每账号一个名字。
数据库使用事务和唯一索引解决并发注册。公开接口没有改名、删除或管理后门。
服务仅监听回环地址，经 Nginx HTTPS、请求体上限及速率限制开放。
签名证明账号密钥的控制权，不代表实名身份或商标归属。

运行：Ubuntu 软件包 `gunicorn python3-cryptography`；
`gunicorn --bind 127.0.0.1:8491 'app:create_app()'`。
测试：`python3 -m unittest -v`，使用临时数据库和临时测试密钥。
线上数据路径 `/data/zova/names/names.sqlite3`，不可放进网站根目录。
客户端默认地址应为 `https://zova.38-60-203-167.sslip.io/names`。
