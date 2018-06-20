//
//  Utilities.swift
//  BluetoothExample
//
//  Created by Nazire Aslan on 19.06.2018.
//  Copyright © 2018 Identitat. All rights reserved.
//

import Foundation
import CoreBluetooth

extension Data {
  private static let hexAlphabet = "0123456789abcdef".unicodeScalars.map { $0 }
  
  // converts data to hex string
  public func hexEncodedString() -> String {
    return String(self.reduce(into: "".unicodeScalars, { (result, value) in
      result.append(Data.hexAlphabet[Int(value/16)])
      result.append(Data.hexAlphabet[Int(value%16)])
    }))
  }
  
  // converts hex string to human readable string
  func hexToStr() -> String {
    let text = hexEncodedString()
    let regex = try! NSRegularExpression(pattern: "(0x)?([0-9A-Fa-f]{2})", options: .caseInsensitive)
    let textNS = text as NSString
    let matchesArray = regex.matches(in: textNS as String, options: [], range: NSMakeRange(0, textNS.length))
    let characters = matchesArray.map {
      Character(UnicodeScalar(UInt32(textNS.substring(with: $0.range(at: 2)), radix: 16)!)!)
    }
    
    return String(characters)
  }  
}

public let kStandardServiceUUIDDeviceInformation = CBUUID(string: "180A")
extension CBUUID {
  public var name : String {
    if self == kStandardServiceUUIDDeviceInformation {
      return "Device Information"
    }
    return self.uuidString
  }
}
