//
//  CharacteristicsVC.swift
//  BluetoothExample
//
//  Created by Nazire Aslan on 20/06/2018.
//  Copyright © 2018 Identitat. All rights reserved.
//

import UIKit
import CoreBluetooth

class CharacteristicsVC: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var characteristics = [CBCharacteristic]()
  var service : CBService!
  
  convenience init (service: CBService) {
    self.init()
    self.service = service
    if let ch = service.characteristics {
      characteristics = ch
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    DeviceManager.shared().delegate = self
    title = "Connected"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
    tableView.reloadData()
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CharacteristicsVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 2
    }
    return characteristics.count * 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
    cell.textLabel?.textColor = UIColor.black
    cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
    cell.backgroundColor = .clear
    cell.textLabel?.numberOfLines = 0
    cell.contentView.backgroundColor = .clear
    cell.textLabel?.textColor = UIColor.darkText
    if indexPath.section == 0 {
      cell.textLabel?.text = indexPath.row == 0 ? DeviceManager.shared().currentDevice?.name : DeviceManager.shared().currentDevice?.identifier.uuidString
    } else {
      let characteristic = characteristics[indexPath.row / 4]
      let mod = indexPath.row % 4
      if mod ==  0 {
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cell.textLabel?.textColor = UIColor.blue
        cell.textLabel?.text = "Software revision string: \(characteristic.uuid.name)"
      } else if mod ==  1 {
        var property = ""
        if characteristic.properties.contains(CBCharacteristicProperties.read) {
          property.append("read")
        }
        if characteristic.properties.contains(CBCharacteristicProperties.notify) {
          if !property.isEmpty {
            property.append(", ")
          }
          property.append("notify")
        }
        if characteristic.properties.contains(CBCharacteristicProperties.write) {
          if !property.isEmpty {
            property.append(", ")
          }
          property.append("write")
        }
        cell.textLabel?.text = "Properties: \(property)"
      } else if mod == 2 {
        if let data = characteristic.value {
          cell.textLabel?.text = "value string: \(data.hexToStr())"
        } else {
          cell.textLabel?.text = "value string: -"
        }
      } else if mod == 3 {
        if let data = characteristic.value {
          cell.textLabel?.text = "value hex: \(data.hexEncodedString())"
        }else {
          cell.textLabel?.text = "value hex: -"
        }
      }
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "\t Device"
    }
    return "\t Characteristics"
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40.0
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 45.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

extension CharacteristicsVC: DeviceManagerDelegate {
  
  func didConnectToDevice() {
  }
  
  func didDisconnectFromDevice() {
    title = "Disconnected"
  }
  
}
