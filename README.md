# 腾讯定位 Swift 示例项目
[English](README.md) | [中文](README_CN.md)
一个全面的 Swift 示例项目，展示如何在 iOS 应用中集成和使用腾讯位置服务(LBS) SDK。

## 📱 功能特性

本示例应用展示了腾讯 LBS SDK 的以下功能：

- **隐私协议管理** - 处理位置服务的用户隐私协议
- **连续定位更新** - 带有 POI 信息的实时位置跟踪
- **基础定位服务** - 不包含 POI 数据的简单位置更新
- **DR(惯性导航)** - 先进的步行和骑行导航，支持传感器融合
- **间隔定位** - 可自定义定位更新间隔和提供商信息

## 🛠 项目结构

```
location_demo/
├── TencentLBS.xcframework/          # 腾讯 LBS SDK 框架
├── location_demo/
│   ├── src/
│   │   ├── ViewController.swift                    # 主菜单控制器
│   │   ├── UserPrivacyViewController.swift         # 隐私协议演示
│   │   ├── SerialLocationAloneViewController.swift # POI 定位演示
│   │   ├── BaseTestSerialLocationController.swift  # 基础定位演示
│   │   ├── TencentLBSDRViewController.swift         # DR 导航演示
│   │   ├── IntervalFeatureViewController.swift     # 间隔定位演示
│   │   ├── BaseMapViewController.swift             # 基础地图控制器
│   │   └── Constants.swift                         # API 密钥配置
│   ├── AppDelegate.swift
│   ├── Info.plist
│   └── location_demo-Bridging-Header.h             # Objective-C 桥接头文件
└── README.md
```

## 🚀 快速开始

### 环境要求

- Xcode 14.0+
- iOS 12.0+
- Swift 5.0+
- 有效的腾讯 LBS API 密钥

### 安装步骤

1. **克隆仓库**
   ```bash
   git clone https://github.com/zhMoody/Tencent_location_swift_dome.git
   cd tencent_location_swift_demo/location_demo
   ```

2. **配置 API 密钥**

   打开 `location_demo/src/Constants.swift` 并替换 API 密钥：
   ```swift
   let API_KEY = "你的腾讯LBS_API_KEY"
   ```

3. **打开项目**
   ```bash
   open location_demo.xcodeproj
   ```

4. **安装依赖**

   项目使用 Swift Package Manager 管理 SnapKit 依赖。打开项目时依赖会自动解析。

5. **构建运行**

   选择目标设备/模拟器，按 `Cmd + R` 构建并运行项目。

### 设置腾讯 LBS SDK

项目已包含 TencentLBS.xcframework。如需更新：

1. 从 [腾讯位置服务官网](https://lbs.qq.com/) 下载最新的 TencentLBS SDK
2. 替换项目中现有的 `TencentLBS.xcframework`
3. 确保框架在项目设置中正确链接

## 📋 功能演示

### 1. 隐私协议 (UserPrivacyViewController)
- 演示正确的隐私政策处理
- 展示如何通过用户同意初始化 SDK
- 使用任何定位服务前的必要步骤

### 2. POI 定位服务 (SerialLocationAloneViewController)
- 带有 POI 信息的连续定位更新
- 地址逆地理编码
- 行政区域信息

### 3. 基础定位服务 (BaseTestSerialLocationController)
- 不包含 POI 数据的简单位置跟踪
- 基本坐标信息
- 定位精度指标

### 4. DR 导航 (TencentLBSDRViewController)
- 用于步行/骑行导航的高级惯性导航
- GPS 和加速度计的传感器融合
- 使用 `getPosition()` 实时位置更新

### 5. 间隔定位更新 (IntervalFeatureViewController)
- 可自定义回调间隔（演示为2秒）
- 定位提供商信息
- 网络 vs GPS 来源检测

## 🔧 配置说明

### Info.plist 设置

项目包含必要的隐私描述：

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>定位</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>App 需要持续访问您的位置，用于后台记录运动轨迹</string>
```

### 后台定位

项目中已启用后台定位：

```xml
<key>UIBackgroundModes</key>
<array>
    <string>location</string>
</array>
```

## 🏗 架构设计

### 关键组件

- **纯 Swift 实现** - 无 Storyboard，所有 UI 使用 SnapKit 构建
- **桥接头文件** - 无缝集成 Objective-C SDK
- **委托模式** - 正确实现 `TencentLBSLocationManagerDelegate`
- **内存管理** - 定位服务的正确生命周期管理

### 代码结构

演示项目遵循清晰的架构原则：

- 每个功能使用独立的视图控制器
- 共享常量和配置
- 正确的错误处理和用户反馈
- UI 和定位逻辑的清晰分离

## 📱 支持的 iOS 版本

- iOS 12.0 及更高版本
- iPhone 和 iPad 兼容
- 支持真机和模拟器测试

## 🔐 隐私和权限

应用正确处理定位权限：

- 默认请求"使用期间"权限
- 支持后台定位的"始终"权限
- 提供清晰的隐私政策说明
- 优雅处理权限被拒绝的情况

## 🐛 故障排除

### 常见问题

1. **API 密钥问题**
   - 确保 API 密钥有效且正确配置
   - 检查密钥是否具有定位服务的必要权限

2. **权限问题**
   - 确保已授予定位权限
   - 检查 Info.plist 中的正确使用说明

3. **构建问题**
   - 验证 TencentLBS.xcframework 是否正确链接
   - 确保桥接头文件路径正确
   - 检查 Swift 版本兼容性

## 📄 许可证

本项目为腾讯定位dome翻译演示实现。SDK 使用请参考腾讯 LBS SDK 许可证条款。

## 📞 支持

- [腾讯位置服务官方文档](https://lbs.qq.com/mobile/iosLocationSDK/iosGeoGuide/iosGeoOverview)
- [SDK API 参考](https://lbs.qq.com/mobile/iosLocationSDK/iosGeoDownload)
- [GitHub Issues](https://github.com/zhMoody/Tencent_location_swift_dome/issues)

## 📈 更新日志

### 版本 1.0.0
- 初始 Swift 实现
- 演示所有主要腾讯 LBS 功能
- 使用 SnapKit 的纯编程 UI
- 完善的错误处理
- 后台定位支持

---

**注意**：运行演示前请记得将 `你的腾讯LBS_API密钥` 替换为您的实际 API 密钥。
