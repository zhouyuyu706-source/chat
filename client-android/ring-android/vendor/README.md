# 原版本界面依赖

原 JCenter 工件已不可获取，以下代码直接保留原始实现及 Apache-2.0 许可证；只替换构建脚本，不重写布局或动画。

- flexbox 2.0.1：https://github.com/google/flexbox-layout ，tag 2.0.1，commit 5b9f531877a2a7c06fc0d6e2a9d2fa6fc2dded60。
- ShapeRippleLibrary 1.0.0：https://github.com/poldz123/ShapeRipple ，commit 9d81d4d908bf1f1c8979eb4af6d0ddcb29111956，原 build.gradle 标注版本 1.0.0。

复制 src/main 与许可证；移除上传 Bintray 的构建脚本依赖，使用主项目 Android Gradle 插件。源码作者及版权不变。
