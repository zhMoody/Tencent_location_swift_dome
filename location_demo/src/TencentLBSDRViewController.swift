//
//  TencentLBSDRViewController.swift
//  location_demo
//
//  Created by Moody on 2025/7/16.
//

import CoreLocation
import SnapKit
import UIKit

class TencentLBSDRViewController: UIViewController, TencentLBSLocationManagerDelegate {
  private var locationManager: TencentLBSLocationManager?
  private let displayLabel = UILabel()
  private var timer: DispatchSourceTimer?

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
    startTencentDrEngine()
    startTimer()
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
    manager.requestLevel = .adminName

    // 检查定位权限
    if CLLocationManager.authorizationStatus() == .notDetermined {
      manager.requestWhenInUseAuthorization()
    }

    self.locationManager = manager
  }

  private func startUpdatingLocation() {
    locationManager?.startUpdatingLocation()
  }

  private func startTencentDrEngine() {
    guard let manager = locationManager else { return }

    // 检查是否支持DR引擎
    let isSupport = manager.isSupport()

    if isSupport {
      // 启动DR引擎，2表示步行模式
      let startCode = manager.startDrEngine(.walk)

      if startCode == .success {
        print("步骑行惯导启动成功，然后可通过getPosition获取结果")
      }
    }
  }

  private func startTimer() {
    let timer = DispatchSource.makeTimerSource(
      queue: DispatchQueue(label: "com.tencent.lbs.dr.timer"))
    timer.schedule(deadline: .now(), repeating: 1.0)
    timer.setEventHandler { [weak self] in
      self?.timerEventHandler()
    }
    timer.resume()
    self.timer = timer
  }

  private func stopTimer() {
    timer?.cancel()
    timer = nil
  }

  private func timerEventHandler() {
    guard let manager = locationManager else { return }
    let drLocation = manager.getPosition()

    DispatchQueue.main.async {
      self.displayLabel.text =
        "version: \(TencentLBSLocationManager.getLBSSDKVersion())\n\(drLocation)"
    }
  }

  @objc private func returnAction() {
    locationManager?.stopUpdatingLocation()
    locationManager?.terminateDrEngine()
    stopTimer()
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
    // DR模式下，主要通过getPosition获取位置，这里可以选择不处理或做简单日志
    // print("DR模式定位更新: \(location)")
  }
}
