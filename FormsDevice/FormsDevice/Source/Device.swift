//
//  Device.swift
//  FormsDevice
//
//  Created by Konrad on 6/12/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import UIKit

// MARK: Device
public enum Device {
    case iPodTouch5
    case iPodTouch6
    case iPodTouch7
    case iPhone4
    case iPhone4s
    case iPhone5
    case iPhone5c
    case iPhone5s
    case iPhone6
    case iPhone6Plus
    case iPhone6s
    case iPhone6sPlus
    case iPhone7
    case iPhone7Plus
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPhoneSE2
    case iPad2
    case iPad3
    case iPad4
    case iPadAir
    case iPadAir2
    case iPad5
    case iPad6
    case iPadAir3
    case iPad7
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4
    case iPadMini5
    case iPadPro9Inch
    case iPadPro12Inch
    case iPadPro12Inch2
    case iPadPro10Inch
    case iPadPro11Inch
    case iPadPro12Inch3
    case iPadPro11Inch2
    case iPadPro12Inch4
    case homePod
    indirect case simulator(Device)
    case unknown(String)
    
    public init(identifier: String) {
        switch identifier {
        case "iPod5,1": self = .iPodTouch5
        case "iPod7,1": self = .iPodTouch6
        case "iPod9,1": self = .iPodTouch7
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": self = .iPhone4
        case "iPhone4,1": self = .iPhone4s
        case "iPhone5,1", "iPhone5,2": self = .iPhone5
        case "iPhone5,3", "iPhone5,4": self = .iPhone5c
        case "iPhone6,1", "iPhone6,2": self = .iPhone5s
        case "iPhone7,2": self = .iPhone6
        case "iPhone7,1": self = .iPhone6Plus
        case "iPhone8,1": self = .iPhone6s
        case "iPhone8,2": self = .iPhone6sPlus
        case "iPhone9,1", "iPhone9,3": self = .iPhone7
        case "iPhone9,2", "iPhone9,4": self = .iPhone7Plus
        case "iPhone8,4": self = .iPhoneSE
        case "iPhone10,1", "iPhone10,4": self = .iPhone8
        case "iPhone10,2", "iPhone10,5": self = .iPhone8Plus
        case "iPhone10,3", "iPhone10,6": self = .iPhoneX
        case "iPhone11,2": self = .iPhoneXS
        case "iPhone11,4", "iPhone11,6": self = .iPhoneXSMax
        case "iPhone11,8": self = .iPhoneXR
        case "iPhone12,1": self = .iPhone11
        case "iPhone12,3": self = .iPhone11Pro
        case "iPhone12,5": self = .iPhone11ProMax
        case "iPhone12,8": self = .iPhoneSE2
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": self = .iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3": self = .iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6": self = .iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3": self = .iPadAir
        case "iPad5,3", "iPad5,4": self = .iPadAir2
        case "iPad6,11", "iPad6,12": self = .iPad5
        case "iPad7,5", "iPad7,6": self = .iPad6
        case "iPad11,3", "iPad11,4": self = .iPadAir3
        case "iPad7,11", "iPad7,12": self = .iPad7
        case "iPad2,5", "iPad2,6", "iPad2,7": self = .iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6": self = .iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9": self = .iPadMini3
        case "iPad5,1", "iPad5,2": self = .iPadMini4
        case "iPad11,1", "iPad11,2": self = .iPadMini5
        case "iPad6,3", "iPad6,4": self = .iPadPro9Inch
        case "iPad6,7", "iPad6,8": self = .iPadPro12Inch
        case "iPad7,1", "iPad7,2": self = .iPadPro12Inch2
        case "iPad7,3", "iPad7,4": self = .iPadPro10Inch
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": self = .iPadPro11Inch
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": self = .iPadPro12Inch3
        case "iPad8,9", "iPad8,10": self = .iPadPro11Inch2
        case "iPad8,11", "iPad8,12": self = .iPadPro12Inch4
        case "AudioAccessory1,1": self = .homePod
        case "i386", "x86_64": self = .simulator(Device(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))
        default: self = .unknown(identifier)
        }
    }
}

// MARK: Lists
public extension Device {
    static var allPods: [Device] {
        return [.iPodTouch5, .iPodTouch6, .iPodTouch7]
    }
    
    static var allPhones: [Device] {
        return [.iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2]
    }
    
    static var allPads: [Device] {
        return [.iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPad5, .iPad6, .iPadAir3, .iPad7, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    static var allXNotchDevices: [Device] {
        return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax]
    }
    
    static var allPlusSizedDevices: [Device] {
        return [.iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus, .iPhoneXSMax, .iPhone11ProMax]
    }
    
    static var allProDevices: [Device] {
        return [.iPhone11Pro, .iPhone11ProMax, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    static var allMiniDevices: [Device] {
        return [.iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5]
    }
    
    static var allTouchIDCapableDevices: [Device] {
        return [.iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneSE2, .iPadAir2, .iPad5, .iPad6, .iPadAir3, .iPad7, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch]
    }
    
    static var allFaceIDCapableDevices: [Device] {
        return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    static var allBiometricAuthenticationCapableDevices: [Device] {
        return [.iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPadAir2, .iPad5, .iPad6, .iPadAir3, .iPad7, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    static var allDevicesWithSensorHousing: [Device] {
        return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax]
    }
    
    static var allDevicesWithRoundedDisplayCorners: [Device] {
        return [.iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    static var allDevicesWith3dTouchSupport: [Device] {
        return [.iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax]
    }
    
    static var allDevicesWithWirelessChargingSupport: [Device] {
        return [.iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2]
    }
    
    static var allDevicesWithALidarSensor: [Device] {
        return [.iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    static var allApplePencilCapableDevices: [Device] {
        return [.iPad6, .iPadAir3, .iPad7, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    static var allDevicesWithCamera: [Device] {
        return [.iPodTouch5, .iPodTouch6, .iPodTouch7, .iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPad5, .iPad6, .iPadAir3, .iPad7, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    static var allDevicesWithWideCamera: [Device] {
        return [.iPodTouch5, .iPodTouch6, .iPodTouch7, .iPhone4, .iPhone4s, .iPhone5, .iPhone5c, .iPhone5s, .iPhone6, .iPhone6Plus, .iPhone6s, .iPhone6sPlus, .iPhone7, .iPhone7Plus, .iPhoneSE, .iPhone8, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE2, .iPad2, .iPad3, .iPad4, .iPadAir, .iPadAir2, .iPad5, .iPad6, .iPadAir3, .iPad7, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadPro9Inch, .iPadPro12Inch, .iPadPro12Inch2, .iPadPro10Inch, .iPadPro11Inch, .iPadPro12Inch3, .iPadPro11Inch2, .iPadPro12Inch4]
    }
    
    static var allDevicesWithTelephotoCamera: [Device] {
        return [.iPhone7Plus, .iPhone8Plus, .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhone11Pro, .iPhone11ProMax]
    }
    
    static var allDevicesWithUltraWideCamera: [Device] {
        return [.iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPadPro11Inch2, .iPadPro12Inch4]
    }
}

// MARK: Switch
public extension Device {
    var diagonal: Double {
        switch self {
        case .iPodTouch5: return 4
        case .iPodTouch6: return 4
        case .iPodTouch7: return 4
        case .iPhone4: return 3.5
        case .iPhone4s: return 3.5
        case .iPhone5: return 4
        case .iPhone5c: return 4
        case .iPhone5s: return 4
        case .iPhone6: return 4.7
        case .iPhone6Plus: return 5.5
        case .iPhone6s: return 4.7
        case .iPhone6sPlus: return 5.5
        case .iPhone7: return 4.7
        case .iPhone7Plus: return 5.5
        case .iPhoneSE: return 4
        case .iPhone8: return 4.7
        case .iPhone8Plus: return 5.5
        case .iPhoneX: return 5.8
        case .iPhoneXS: return 5.8
        case .iPhoneXSMax: return 6.5
        case .iPhoneXR: return 6.1
        case .iPhone11: return 6.1
        case .iPhone11Pro: return 5.8
        case .iPhone11ProMax: return 6.5
        case .iPhoneSE2: return 4.7
        case .iPad2: return 9.7
        case .iPad3: return 9.7
        case .iPad4: return 9.7
        case .iPadAir: return 9.7
        case .iPadAir2: return 9.7
        case .iPad5: return 9.7
        case .iPad6: return 9.7
        case .iPadAir3: return 10.5
        case .iPad7: return 10.2
        case .iPadMini: return 7.9
        case .iPadMini2: return 7.9
        case .iPadMini3: return 7.9
        case .iPadMini4: return 7.9
        case .iPadMini5: return 7.9
        case .iPadPro9Inch: return 9.7
        case .iPadPro12Inch: return 12.9
        case .iPadPro12Inch2: return 12.9
        case .iPadPro10Inch: return 10.5
        case .iPadPro11Inch: return 11.0
        case .iPadPro12Inch3: return 12.9
        case .iPadPro11Inch2: return 11.0
        case .iPadPro12Inch4: return 12.9
        case .homePod: return -1
        case .simulator(let model): return model.diagonal
        case .unknown: return -1
        }
    }
    
    var screenRatio: (width: Double, height: Double) {
        switch self {
        case .iPodTouch5: return (width: 9, height: 16)
        case .iPodTouch6: return (width: 9, height: 16)
        case .iPodTouch7: return (width: 9, height: 16)
        case .iPhone4: return (width: 2, height: 3)
        case .iPhone4s: return (width: 2, height: 3)
        case .iPhone5: return (width: 9, height: 16)
        case .iPhone5c: return (width: 9, height: 16)
        case .iPhone5s: return (width: 9, height: 16)
        case .iPhone6: return (width: 9, height: 16)
        case .iPhone6Plus: return (width: 9, height: 16)
        case .iPhone6s: return (width: 9, height: 16)
        case .iPhone6sPlus: return (width: 9, height: 16)
        case .iPhone7: return (width: 9, height: 16)
        case .iPhone7Plus: return (width: 9, height: 16)
        case .iPhoneSE: return (width: 9, height: 16)
        case .iPhone8: return (width: 9, height: 16)
        case .iPhone8Plus: return (width: 9, height: 16)
        case .iPhoneX: return (width: 9, height: 19.5)
        case .iPhoneXS: return (width: 9, height: 19.5)
        case .iPhoneXSMax: return (width: 9, height: 19.5)
        case .iPhoneXR: return (width: 9, height: 19.5)
        case .iPhone11: return (width: 9, height: 19.5)
        case .iPhone11Pro: return (width: 9, height: 19.5)
        case .iPhone11ProMax: return (width: 9, height: 19.5)
        case .iPhoneSE2: return (width: 9, height: 16)
        case .iPad2: return (width: 3, height: 4)
        case .iPad3: return (width: 3, height: 4)
        case .iPad4: return (width: 3, height: 4)
        case .iPadAir: return (width: 3, height: 4)
        case .iPadAir2: return (width: 3, height: 4)
        case .iPad5: return (width: 3, height: 4)
        case .iPad6: return (width: 3, height: 4)
        case .iPadAir3: return (width: 3, height: 4)
        case .iPad7: return (width: 3, height: 4)
        case .iPadMini: return (width: 3, height: 4)
        case .iPadMini2: return (width: 3, height: 4)
        case .iPadMini3: return (width: 3, height: 4)
        case .iPadMini4: return (width: 3, height: 4)
        case .iPadMini5: return (width: 3, height: 4)
        case .iPadPro9Inch: return (width: 3, height: 4)
        case .iPadPro12Inch: return (width: 3, height: 4)
        case .iPadPro12Inch2: return (width: 3, height: 4)
        case .iPadPro10Inch: return (width: 3, height: 4)
        case .iPadPro11Inch: return (width: 139, height: 199)
        case .iPadPro12Inch3: return (width: 512, height: 683)
        case .iPadPro11Inch2: return (width: 139, height: 199)
        case .iPadPro12Inch4: return (width: 512, height: 683)
        case .homePod: return (width: 4, height: 5)
        case .simulator(let model): return model.screenRatio
        case .unknown: return (width: -1, height: -1)
        }
    }
    
    var ppi: Int? {
        switch self {
        case .iPodTouch5: return 326
        case .iPodTouch6: return 326
        case .iPodTouch7: return 326
        case .iPhone4: return 326
        case .iPhone4s: return 326
        case .iPhone5: return 326
        case .iPhone5c: return 326
        case .iPhone5s: return 326
        case .iPhone6: return 326
        case .iPhone6Plus: return 401
        case .iPhone6s: return 326
        case .iPhone6sPlus: return 401
        case .iPhone7: return 326
        case .iPhone7Plus: return 401
        case .iPhoneSE: return 326
        case .iPhone8: return 326
        case .iPhone8Plus: return 401
        case .iPhoneX: return 458
        case .iPhoneXS: return 458
        case .iPhoneXSMax: return 458
        case .iPhoneXR: return 326
        case .iPhone11: return 326
        case .iPhone11Pro: return 458
        case .iPhone11ProMax: return 458
        case .iPhoneSE2: return 326
        case .iPad2: return 132
        case .iPad3: return 264
        case .iPad4: return 264
        case .iPadAir: return 264
        case .iPadAir2: return 264
        case .iPad5: return 264
        case .iPad6: return 264
        case .iPadAir3: return 264
        case .iPad7: return 264
        case .iPadMini: return 163
        case .iPadMini2: return 326
        case .iPadMini3: return 326
        case .iPadMini4: return 326
        case .iPadMini5: return 326
        case .iPadPro9Inch: return 264
        case .iPadPro12Inch: return 264
        case .iPadPro12Inch2: return 264
        case .iPadPro10Inch: return 264
        case .iPadPro11Inch: return 264
        case .iPadPro12Inch3: return 264
        case .iPadPro11Inch2: return 264
        case .iPadPro12Inch4: return 264
        case .homePod: return -1
        case .simulator(let model): return model.ppi
        case .unknown: return nil
        }
    }
}

// MARK: Properties
public extension Device {
    static var current: Device {
        return Device(identifier: Device.identifier)
    }
    
    static var identifier: String = {
        var systemInfo: utsname = utsname()
        uname(&systemInfo)
        let mirror: Mirror = Mirror(reflecting: systemInfo.machine)
        return mirror.children.reduce(into: "") { (result: inout String, element: Mirror.Child) in
            guard let value: Int8 = element.value as? Int8, value != 0 else { return }
            result += String(UnicodeScalar(UInt8(value)))
        }
    }()
    
    var realDevice: Device {
        if case let .simulator(model) = self {
            return model
        }
        return self
    }
    
    static var allSimulatorPods: [Device] {
        return Self.allPods.map(Device.simulator)
    }
    
    static var allSimulatorPhones: [Device] {
        return Self.allPhones.map(Device.simulator)
    }
    
    static var allSimulatorPads: [Device] {
        return Self.allPads.map(Device.simulator)
    }
    
    static var allSimulatorMiniDevices: [Device] {
        return Self.allMiniDevices.map(Device.simulator)
    }
    
    static var allSimulatorXNotchDevices: [Device] {
        return Self.allXNotchDevices.map(Device.simulator)
    }
    
    static var allSimulatorPlusSizedDevices: [Device] {
        return Self.allPlusSizedDevices.map(Device.simulator)
    }
    
    static var allSimulatorProDevices: [Device] {
        return Self.allProDevices.map(Device.simulator)
    }
     
    static var allSimulatorDevicesWithSensorHousing: [Device] {
        return Self.allDevicesWithSensorHousing.map(Device.simulator)
    }
    
    static var allRealDevices: [Device] {
        return Self.allPods + Self.allPhones + Self.allPads
    }
    
    static var allSimulators: [Device] {
        return Self.allRealDevices.map(Device.simulator)
    }
    
    var isCurrent: Bool {
        return self == Device.current
    }
    
    var isPod: Bool {
        return self.isOneOf(Device.allPods) || self.isOneOf(Device.allSimulatorPods)
    }
    
    var isPhone: Bool {
        return (self.isOneOf(Device.allPhones + Device.allSimulatorPhones)
        || (UIDevice.current.userInterfaceIdiom == .phone && self.isCurrent)) && !self.isPod
    }
    
    var isPad: Bool {
        return self.isOneOf(Device.allPads + Device.allSimulatorPads)
        || (UIDevice.current.userInterfaceIdiom == .pad && self.isCurrent)
    }
    
    var isSimulator: Bool {
        return self.isOneOf(Device.allSimulators)
    }
    
    var isZoomed: Bool? {
        guard self.isCurrent else { return nil }
        if Int(UIScreen.main.scale.rounded()) == 3 {
            return UIScreen.main.nativeScale > 2.7 && UIScreen.main.nativeScale < 3
        } else {
            return UIScreen.main.nativeScale > UIScreen.main.scale
        }
    }
    
    var isTouchIDCapable: Bool {
        return self.isOneOf(Device.allTouchIDCapableDevices) || self.isOneOf(Device.allTouchIDCapableDevices.map(Device.simulator))
    }
    
    var isFaceIDCapable: Bool {
        return self.isOneOf(Device.allFaceIDCapableDevices) || self.isOneOf(Device.allFaceIDCapableDevices.map(Device.simulator))
    }
    
    var hasBiometricSensor: Bool {
        return self.isTouchIDCapable || self.isFaceIDCapable
    }
    
    var hasSensorHousing: Bool {
        return self.isOneOf(Device.allDevicesWithSensorHousing) || self.isOneOf(Device.allDevicesWithSensorHousing.map(Device.simulator))
    }
    
    var hasRoundedDisplayCorners: Bool {
        return self.isOneOf(Device.allDevicesWithRoundedDisplayCorners) || self.isOneOf(Device.allDevicesWithRoundedDisplayCorners.map(Device.simulator))
    }
    
    var has3dTouchSupport: Bool {
        return self.isOneOf(Device.allDevicesWith3dTouchSupport) || self.isOneOf(Device.allDevicesWith3dTouchSupport.map(Device.simulator))
    }
    
    var supportsWirelessCharging: Bool {
        return self.isOneOf(Device.allDevicesWithWirelessChargingSupport) || self.isOneOf(Device.allDevicesWithWirelessChargingSupport.map(Device.simulator))
    }
    
    var hasLidarSensor: Bool {
        return self.isOneOf(Device.allDevicesWithALidarSensor) || self.isOneOf(Device.allDevicesWithALidarSensor.map(Device.simulator))
    }
    
    var name: String? {
        guard self.isCurrent else { return nil }
        return UIDevice.current.name
    }
    
    var systemName: String? {
        guard self.isCurrent else { return nil }
        return UIDevice.current.systemName
    }
    
    var systemVersion: String? {
        guard self.isCurrent else { return nil }
        return UIDevice.current.systemVersion
    }
    
    var model: String? {
        guard self.isCurrent else { return nil }
        return UIDevice.current.model
    }
    
    var localizedModel: String? {
        guard self.isCurrent else { return nil }
        return UIDevice.current.localizedModel
    }
    
    var isGuidedAccessSessionActive: Bool {
        return UIAccessibility.isGuidedAccessEnabled
    }
    
    var screenBrightness: Int {
        return Int(UIScreen.main.brightness * 100)
    }
     
    func isOneOf(_ devices: [Device]) -> Bool {
        return devices.contains(self)
    }
}

// MARK: CustomStringConvertible
extension Device: CustomStringConvertible {
    public var description: String {
        switch self {
        case .iPodTouch5: return "iPod touch (5th generation)"
        case .iPodTouch6: return "iPod touch (6th generation)"
        case .iPodTouch7: return "iPod touch (7th generation)"
        case .iPhone4: return "iPhone 4"
        case .iPhone4s: return "iPhone 4s"
        case .iPhone5: return "iPhone 5"
        case .iPhone5c: return "iPhone 5c"
        case .iPhone5s: return "iPhone 5s"
        case .iPhone6: return "iPhone 6"
        case .iPhone6Plus: return "iPhone 6 Plus"
        case .iPhone6s: return "iPhone 6s"
        case .iPhone6sPlus: return "iPhone 6s Plus"
        case .iPhone7: return "iPhone 7"
        case .iPhone7Plus: return "iPhone 7 Plus"
        case .iPhoneSE: return "iPhone SE"
        case .iPhone8: return "iPhone 8"
        case .iPhone8Plus: return "iPhone 8 Plus"
        case .iPhoneX: return "iPhone X"
        case .iPhoneXS: return "iPhone XS"
        case .iPhoneXSMax: return "iPhone XS Max"
        case .iPhoneXR: return "iPhone XR"
        case .iPhone11: return "iPhone 11"
        case .iPhone11Pro: return "iPhone 11 Pro"
        case .iPhone11ProMax: return "iPhone 11 Pro Max"
        case .iPhoneSE2: return "iPhone SE (2nd generation)"
        case .iPad2: return "iPad 2"
        case .iPad3: return "iPad (3rd generation)"
        case .iPad4: return "iPad (4th generation)"
        case .iPadAir: return "iPad Air"
        case .iPadAir2: return "iPad Air 2"
        case .iPad5: return "iPad (5th generation)"
        case .iPad6: return "iPad (6th generation)"
        case .iPadAir3: return "iPad Air (3rd generation)"
        case .iPad7: return "iPad (7th generation)"
        case .iPadMini: return "iPad Mini"
        case .iPadMini2: return "iPad Mini 2"
        case .iPadMini3: return "iPad Mini 3"
        case .iPadMini4: return "iPad Mini 4"
        case .iPadMini5: return "iPad Mini (5th generation)"
        case .iPadPro9Inch: return "iPad Pro (9.7-inch)"
        case .iPadPro12Inch: return "iPad Pro (12.9-inch)"
        case .iPadPro12Inch2: return "iPad Pro (12.9-inch) (2nd generation)"
        case .iPadPro10Inch: return "iPad Pro (10.5-inch)"
        case .iPadPro11Inch: return "iPad Pro (11-inch)"
        case .iPadPro12Inch3: return "iPad Pro (12.9-inch) (3rd generation)"
        case .iPadPro11Inch2: return "iPad Pro (11-inch) (2nd generation)"
        case .iPadPro12Inch4: return "iPad Pro (12.9-inch) (4th generation)"
        case .homePod: return "HomePod"
        case .simulator(let model): return "Simulator (\(model))"
        case .unknown(let identifier): return identifier
        }
    }
}

// MARK: Equatable
extension Device: Equatable {
    public static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.description == rhs.description
    }
}

// MARK: Battery
public extension Device {
    enum BatteryState: CustomStringConvertible, Equatable {
        case full
        case charging(Int)
        case unplugged(Int)
        
        fileprivate init() {
            let wasBatteryMonitoringEnabled: Bool = UIDevice.current.isBatteryMonitoringEnabled
            UIDevice.current.isBatteryMonitoringEnabled = true
            let batteryLevel: Int = Int(round(UIDevice.current.batteryLevel * 100))
            switch UIDevice.current.batteryState {
            case .charging: self = .charging(batteryLevel)
            case .full: self = .full
            case .unplugged: self = .unplugged(batteryLevel)
            case .unknown: self = .full
            @unknown default: self = .full
            }
            UIDevice.current.isBatteryMonitoringEnabled = wasBatteryMonitoringEnabled
        }
        
        public var lowPowerMode: Bool {
            return ProcessInfo.processInfo.isLowPowerModeEnabled
        }
        
        public var description: String {
            switch self {
            case .charging(let batteryLevel): return "Battery level: \(batteryLevel)%, device is plugged in."
            case .full: return "Battery level: 100 % (Full), device is plugged in."
            case .unplugged(let batteryLevel): return "Battery level: \(batteryLevel)%, device is unplugged."
            }
        }
    }
    
    var batteryState: BatteryState? {
        guard self.isCurrent else { return nil }
        return BatteryState()
    }
    
    var batteryLevel: Int? {
        guard self.isCurrent else { return nil }
        switch BatteryState() {
        case .charging(let value): return value
        case .full: return 100
        case .unplugged(let value): return value
        }
    }
}

extension Device.BatteryState: Comparable {
    public static func == (lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
        return lhs.description == rhs.description
    }
    
    public static func < (lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
        switch (lhs, rhs) {
        case (.full, _): return false
        case (_, .full): return true
        case let (.charging(lhsLevel), .charging(rhsLevel)): return lhsLevel < rhsLevel
        case let (.charging(lhsLevel), .unplugged(rhsLevel)): return lhsLevel < rhsLevel
        case let (.unplugged(lhsLevel), .charging(rhsLevel)): return lhsLevel < rhsLevel
        case let (.unplugged(lhsLevel), .unplugged(rhsLevel)): return lhsLevel < rhsLevel
        default: return false
        }
    }
}

// MARK: Orientation
public extension Device {
    enum Orientation {
        case landscape
        case portrait
    }
    
    var orientation: Orientation {
        if UIDevice.current.orientation.isLandscape {
            return .landscape
        } else {
            return .portrait
        }
    }
}

// MARK: DiskVolume
public extension Device {
    private static let rootURL = URL(fileURLWithPath: NSHomeDirectory())
    
    static var diskVolumeTotalCapacity: Int? {
        let values: URLResourceValues? = try? Device.rootURL.resourceValues(forKeys: [.volumeTotalCapacityKey])
        return values?.volumeTotalCapacity
    }
    
    static var diskVolumeAvailableCapacity: Int? {
        let values: URLResourceValues? = try? Device.rootURL.resourceValues(forKeys: [.volumeAvailableCapacityKey])
        return values?.volumeAvailableCapacity
    }
    
    @available(iOS 11.0, *)
    static var diskVolumeAvailableCapacityForImportantUsage: Int64? {
        let values: URLResourceValues? = try? Device.rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
        return values?.volumeAvailableCapacityForImportantUsage
    }
    
    @available(iOS 11.0, *)
    static var diskVolumeAvailableCapacityForOpportunisticUsage: Int64? {
        let values: URLResourceValues? = try? Device.rootURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey])
        return values?.volumeAvailableCapacityForOpportunisticUsage
    }
    
    @available(iOS 11.0, *)
    static var diskVolumes: [URLResourceKey: Int64]? {
        let values: URLResourceValues? = try? rootURL.resourceValues(forKeys: [
            .volumeAvailableCapacityForImportantUsageKey,
            .volumeAvailableCapacityKey,
            .volumeAvailableCapacityForOpportunisticUsageKey,
            .volumeTotalCapacityKey
        ])
        return values?.allValues.mapValues {
            if let int: Int64 = $0 as? Int64 {
                return int
            } else if let int: Int = $0 as? Int {
                return Int64(int)
            } else {
                return 0
            }
        }
    }
}

// MARK: ApplePencil
public extension Device {
    struct ApplePencilSupport: OptionSet {
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static let firstGeneration = ApplePencilSupport(rawValue: 0x01)
        public static let secondGeneration = ApplePencilSupport(rawValue: 0x02)
    }
    
    var applePencilSupport: ApplePencilSupport {
        switch self {
        case .iPad6: return .firstGeneration
        case .iPadAir3: return .firstGeneration
        case .iPad7: return .firstGeneration
        case .iPadMini5: return .firstGeneration
        case .iPadPro9Inch: return .firstGeneration
        case .iPadPro12Inch: return .firstGeneration
        case .iPadPro12Inch2: return .firstGeneration
        case .iPadPro10Inch: return .firstGeneration
        case .iPadPro11Inch: return .secondGeneration
        case .iPadPro12Inch3: return .secondGeneration
        case .iPadPro11Inch2: return .secondGeneration
        case .iPadPro12Inch4: return .secondGeneration
        case .simulator(let model): return model.applePencilSupport
        default: return []
        }
    }
}
// MARK: Camera
public extension Device {
    enum CameraType {
        case wide
        case telephoto
        case ultraWide
    }
    
    var cameras: [CameraType] {
        switch self {
        case .iPodTouch5: return [.wide]
        case .iPodTouch6: return [.wide]
        case .iPodTouch7: return [.wide]
        case .iPhone4: return [.wide]
        case .iPhone4s: return [.wide]
        case .iPhone5: return [.wide]
        case .iPhone5c: return [.wide]
        case .iPhone5s: return [.wide]
        case .iPhone6: return [.wide]
        case .iPhone6Plus: return [.wide]
        case .iPhone6s: return [.wide]
        case .iPhone6sPlus: return [.wide]
        case .iPhone7: return [.wide]
        case .iPhoneSE: return [.wide]
        case .iPhone8: return [.wide]
        case .iPhoneXR: return [.wide]
        case .iPhoneSE2: return [.wide]
        case .iPad2: return [.wide]
        case .iPad3: return [.wide]
        case .iPad4: return [.wide]
        case .iPadAir: return [.wide]
        case .iPadAir2: return [.wide]
        case .iPad5: return [.wide]
        case .iPad6: return [.wide]
        case .iPadAir3: return [.wide]
        case .iPad7: return [.wide]
        case .iPadMini: return [.wide]
        case .iPadMini2: return [.wide]
        case .iPadMini3: return [.wide]
        case .iPadMini4: return [.wide]
        case .iPadMini5: return [.wide]
        case .iPadPro9Inch: return [.wide]
        case .iPadPro12Inch: return [.wide]
        case .iPadPro12Inch2: return [.wide]
        case .iPadPro10Inch: return [.wide]
        case .iPadPro11Inch: return [.wide]
        case .iPadPro12Inch3: return [.wide]
        case .iPhone7Plus: return [.wide, .telephoto]
        case .iPhone8Plus: return [.wide, .telephoto]
        case .iPhoneX: return [.wide, .telephoto]
        case .iPhoneXS: return [.wide, .telephoto]
        case .iPhoneXSMax: return [.wide, .telephoto]
        case .iPhone11: return [.wide, .ultraWide]
        case .iPadPro11Inch2: return [.wide, .ultraWide]
        case .iPadPro12Inch4: return [.wide, .ultraWide]
        case .iPhone11Pro: return [.wide, .telephoto, .ultraWide]
        case .iPhone11ProMax: return [.wide, .telephoto, .ultraWide]
        default: return []
        }
    }
    
    var hasCamera: Bool {
        return !self.cameras.isEmpty
    }
    
    var hasWideCamera: Bool {
        return self.cameras.contains(.wide)
    }
    
    var hasTelephotoCamera: Bool {
        return self.cameras.contains(.telephoto)
    }
    
    var hasUltraWideCamera: Bool {
        return self.cameras.contains(.ultraWide)
    }
}
