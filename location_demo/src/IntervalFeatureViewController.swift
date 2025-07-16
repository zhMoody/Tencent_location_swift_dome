//
//  IntervalFeatureViewController.swift
//  location_demo
//
//  Created by Moody on 2025/7/16.
//

import CoreLocation
import SnapKit
import UIKit

class IntervalFeatureViewController: UIViewController, TencentLBSLocationManagerDelegate {
  private var locationManager: TencentLBSLocationManager?
  private let displayLabel = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupNavigationBar()
    setupDisplayLabel()

    // 检查用户隐私协议
    guard TencentLBSLocationManager.getUserAgreePrivacy() else {
      displayLabel.text = "用户还未同意隐私政策，定位将不可用"
      return
    }

    configLocationManager()
    startUpdatingLocation()
  }

  private func setupNavigationBar() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: "返回", style: .plain, target: self, action: #selector(returnAction))
  }

  private func setupDisplayLabel() {
    displayLabel.backgroundColor = .clear
    displayLabel.textColor = .black
    displayLabel.textAlignment = .center
    displayLabel.numberOfLines = 0
    view.addSubview(displayLabel)
    displayLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
  }

  private func configLocationManager() {
    let manager = TencentLBSLocationManager()

    // 设置API Key
    manager.apiKey = API_KEY

    // 设置delegate
    manager.delegate = self

    // 设置其他属性
    manager.pausesLocationUpdatesAutomatically = false
    manager.allowsBackgroundLocationUpdates = true
    manager.requestLevel = .name
    manager.locationCallbackInterval = 2000

    // 检查定位权限
    if CLLocationManager.authorizationStatus() == .notDetermined {
      manager.requestWhenInUseAuthorization()
    }

    self.locationManager = manager
  }

  private func startUpdatingLocation() {
    locationManager?.startUpdatingLocation()
  }

  @objc private func returnAction() {
    locationManager?.stopUpdatingLocation()
    navigationController?.popViewController(animated: true)
  }

  // MARK: - TencentLBSLocationManagerDelegate

  func tencentLBSLocationManager(
    _ manager: TencentLBSLocationManager, didFailWithError error: Error
  ) {
    let status = CLLocationManager.authorizationStatus()
    if status == .denied || status == .restricted {
      let alert = UIAlertController(title: "提示", message: "定位权限未开启，是否开启？", preferredStyle: .alert)
      alert.addAction(
        UIAlertAction(
          title: "是", style: .default,
          handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url)
            {
              UIApplication.shared.open(url)
            }
          }))
      alert.addAction(UIAlertAction(title: "否", style: .default, handler: nil))
      present(alert, animated: true)
    } else {
      displayLabel.text = "\(error)"
    }
  }

  func tencentLBSLocationManager(
    _ manager: TencentLBSLocationManager, didUpdate location: TencentLBSLocation
  ) {
    let fmt = DateFormatter()
    fmt.locale = Locale(identifier: "zh_CN")
    fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"

    let dateString = fmt.string(from: location.location.timestamp)
    let currentDate = fmt.string(from: Date())
    let intervalDisplayStr = "当前回调频率: 2s\n\(currentDate)"
    let providerDisplayStr =
      "provider: -1(来源未知), 0(GPS), 1(Network), 2(模拟定位), 3(外设的 GPS), 4(外设的 Network)"

    displayLabel.text = """
      \(intervalDisplayStr)
      \(providerDisplayStr)

      version: \(TencentLBSLocationManager.getLBSSDKVersion())
      \(location.name ?? "")
      \(location.address ?? "")
      latitude: \(location.location.coordinate.latitude), longitude: \(location.location.coordinate.longitude)
      provider: \(location.locationProvider.rawValue)
      horizontalAccuracy: \(location.location.horizontalAccuracy)
      verticalAccuracy: \(location.location.verticalAccuracy)
      speed: \(location.location.speed)
      course: \(location.location.course)
      altitude: \(location.location.altitude)
      timestamp: \(dateString)
      """
  }
}
