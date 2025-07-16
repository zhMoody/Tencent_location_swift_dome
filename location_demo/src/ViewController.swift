//
//  ViewController.swift
//  location_demo
//
//  Created by Moody on 2025/7/16.
//

import SnapKit
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  private var titles: [[String]] = []
  private var classNames: [[String]] = []
  private var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "腾讯定位SDK"
    view.backgroundColor = .white

    initTitles()
    initClassNames()
    initTableView()
  }

  // MARK: - Initialization

  private func initTitles() {
    let locTitles = [
      "先设置用户隐私同意",
      "POI连续定位展示",
      "不带POI连续定位展示",
      "步骑行惯导（DR）示例",
      "设置回调间隔和获取 location provider",
    ]
    titles = [locTitles]
  }

  private func initClassNames() {
    let locClassNames = [
      "UserPrivacyViewController",
      "SerialLocationAloneViewController",
      "BaseTestSerialLocationController",
      "TencentLBSDRViewController",
      "IntervalFeatureViewController",
    ]
    classNames = [locClassNames]
  }

  private func initTableView() {
    tableView = UITableView(frame: .zero, style: .grouped)
    tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCellIdentifier")

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  // MARK: - UITableViewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titles[section].count
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "TencentLBSKit"
    default:
      return ""
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "mainCellIdentifier", for: indexPath)

    cell.textLabel?.text = titles[indexPath.section][indexPath.row]
    cell.detailTextLabel?.text = classNames[indexPath.section][indexPath.row]
    cell.accessoryType = .disclosureIndicator

    return cell
  }

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    let className = classNames[indexPath.section][indexPath.row]

    var subViewController: UIViewController?

    switch className {
    case "UserPrivacyViewController":
      subViewController = UserPrivacyViewController()
    case "SerialLocationAloneViewController":
      subViewController = SerialLocationAloneViewController()
    case "BaseTestSerialLocationController":
      subViewController = BaseTestSerialLocationController()
    case "TencentLBSDRViewController":
      subViewController = TencentLBSDRViewController()
    case "IntervalFeatureViewController":
      subViewController = IntervalFeatureViewController()
    default:
      break
    }

    if let vc = subViewController {
      vc.title = titles[indexPath.section][indexPath.row]
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
