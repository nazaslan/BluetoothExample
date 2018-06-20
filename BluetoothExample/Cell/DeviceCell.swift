//
//  DeviceCell.swift
//  BluetoothExample
//
//  Created by Nazire Aslan on 20/06/2018.
//  Copyright © 2018 Identitat. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var rightLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  class var identifier: String {
    return String(describing: self)
  }
  
  class var nib: UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
}
