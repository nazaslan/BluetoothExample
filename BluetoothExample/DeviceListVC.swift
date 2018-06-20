//
//  ViewController.swift
//  BluetoothExample
//
//  Created by Nazire Aslan on 19/06/2018.
//  Copyright © 2018 Identitat. All rights reserved.
//

import UIKit
import CoreBluetooth

class DeviceListVC: UIViewController {
  @IBOutlet weak var scanButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  var devices = [[String: Any]]()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Device List"
    tableView.register(DeviceCell.nib, forCellReuseIdentifier: DeviceCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DeviceManager.shared().delegate = self
    DeviceManager.shared().disconnectFromDevice()
  }
  
  // MARK: - Actions
  @IBAction func onSelectScanButton(_ sender: Any) {
    scanButton.setTitle("SCANNING...", for: .normal)
    DeviceManager.shared().startScan()
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DeviceListVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return devices.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: DeviceCell.identifier) as? DeviceCell {
      let dict = devices[indexPath.row]
      cell.nameLabel?.text = (dict["name"] as? CBPeripheral)?.name
      if let rssi = dict["rssi"] as? String {
        cell.rightLabel.text = "Signal: \(rssi)"
      }
      let backgroundView = UIView()
      backgroundView.backgroundColor = UIColor.clear
      cell.selectedBackgroundView = backgroundView
      return cell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let dict = devices[indexPath.row]
    if let peripheral = dict["name"] as? CBPeripheral {
      DeviceManager.shared().connectToDevice(device: peripheral)
    }
  }
  
}

extension DeviceListVC: DeviceManagerDelegate {
  
  func didUpdateDeviceList(items: [[String: Any]]) {
    scanButton.setTitle("SCAN", for: .normal)
    devices = items
    tableView.reloadData()
  }
  
  func didConnectToDevice() {
    navigationController?.pushViewController(ServicesVC(), animated: false)
  }
  
  func didDisconnectFromDevice() {
  }
  
}


