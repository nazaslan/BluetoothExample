//
//  ServicesVC.swift
//  BluetoothExample
//
//  Created by Nazire Aslan on 19.06.2018.
//  Copyright © 2018 Identitat. All rights reserved.
//

import UIKit
import CoreBluetooth

class ServicesVC: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var services = [CBService]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    DeviceManager.shared().delegate = self
    title = "Connected"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    services = DeviceManager.shared().currentDeviceServices
    tableView.reloadData()
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ServicesVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 2
    }
    return services.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
    cell.textLabel?.textColor = UIColor.black
    cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
    cell.backgroundColor = .clear
    cell.contentView.backgroundColor = .clear
    if indexPath.section == 0 {
      cell.textLabel?.text = indexPath.row == 0 ? DeviceManager.shared().currentDevice?.name : DeviceManager.shared().currentDevice?.identifier.uuidString
    } else {
      cell.textLabel?.text = services[indexPath.row].uuid.name
    }

    let backgroundView = UIView()
    backgroundView.backgroundColor = UIColor.clear
    cell.selectedBackgroundView = backgroundView
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "\t Device"
    }
    return "\t Services"
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40.0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 45.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.section == 1 {
      let service = services[indexPath.row]
      let characteristicsVC = CharacteristicsVC(service: service)
      navigationController?.pushViewController(characteristicsVC, animated: true)
    }
  }
  
}

extension ServicesVC: DeviceManagerDelegate {
  func didUpdateServicesList(services: [CBService]) {
    self.services = services
    tableView.reloadData()
  }
  
  func didConnectToDevice() {
    
  }
  
  func didDisconnectFromDevice() {
    title = "Disconnected"
  }
  
}
