//
//  UserPrivacyViewController.swift
//  location_demo
//
//  Created by Moody on 2025/7/16.
//

import CoreLocation
import SnapKit
import UIKit

class UserPrivacyViewController: UIViewController, TencentLBSLocationManagerDelegate {
  private let displayLabel = UILabel()
  private var locationManager: TencentLBSLocationManager?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupNavigationBar()
    setupDisplayLabel()
    alertMessage("是否同意腾讯定位SDK隐私政策")
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

  @objc private func returnAction() {
    stopUpdatingLocation()
    navigationController?.popViewController(animated: true)
  }

  private func alertMessage(_ message: String) {
    let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
    alert.addAction(
      UIAlertAction(
        title: "同意", style: .default,
        handler: { _ in
          TencentLBSLocationManager.setUserAgreePrivacy(true)
          DispatchQueue.main.async {
            self.configLocationManager()
            self.startUpdatingLocation()
          }
        }))
    alert.addAction(
      UIAlertAction(
        title: "拒绝", style: .cancel,
        handler: { _ in
          TencentLBSLocationManager.setUserAgreePrivacy(false)
          DispatchQueue.main.async {
            self.displayLabel.text = "用户未同意隐私政策，定位不可用"
          }
        }))
    present(alert, animated: true)
  }

  private func configLocationManager() {
    let manager = TencentLBSLocationManager()
    manager.delegate = self
    manager.requestLevel = .adminName
    manager.pausesLocationUpdatesAutomatically = false
    manager.allowsBackgroundLocationUpdates = true
    manager.apiKey = API_KEY

    if CLLocationManager.authorizationStatus() == .notDetermined {
      manager.requestWhenInUseAuthorization()
    }

    self.locationManager = manager
  }

  private func startUpdatingLocation() {
    locationManager?.startUpdatingLocation()
  }

  private func stopUpdatingLocation() {
    locationManager?.stopUpdatingLocation()
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

    displayLabel.text = """
      version: \(TencentLBSLocationManager.getLBSSDKVersion())
      \(location.name ?? "")
      \(location.address ?? "")
      latitude: \(location.location.coordinate.latitude), longitude: \(location.location.coordinate.longitude)
      horizontalAccuracy: \(location.location.horizontalAccuracy)
      verticalAccuracy: \(location.location.verticalAccuracy)
      speed: \(location.location.speed)
      course: \(location.location.course)
      altitude: \(location.location.altitude)
      nationcode: \(location.nationCode)
      timestamp: \(dateString)
      """
  }
}
