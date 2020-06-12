# FormsDevice

FormsDevice is device info helper library.

## Import

```swift
import FormsDevice
```

## Usage

### Types

```swift
enum Device {
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
    case simulator(Device)
    case unknown(String)
}
```

### Properties

```swift
Device.current
Device.identifier
Device.allPods
Device.allPhones
Device.allPads
Device.allXNotchDevices
Device.allPlusSizedDevices
Device.allProDevices
Device.allMiniDevices
Device.allTouchIDCapableDevices
Device.allFaceIDCapableDevices
Device.allBiometricAuthenticationCapableDevices
Device.allDevicesWithSensorHousing
Device.allDevicesWithRoundedDisplayCorners
Device.allDevicesWith3dTouchSupport
Device.allDevicesWithWirelessChargingSupport
Device.allDevicesWithALidarSensor
Device.allApplePencilCapableDevices
Device.allDevicesWithCamera
Device.allDevicesWithWideCamera
Device.allDevicesWithTelephotoCamera
Device.allDevicesWithUltraWideCamera
Device.allSimulatorPods
Device.allSimulatorPhones
Device.allSimulatorPads
Device.allSimulatorMiniDevices
Device.allSimulatorXNotchDevices
Device.allSimulatorPlusSizedDevices
Device.allSimulatorProDevices
Device.allSimulatorDevicesWithSensorHousing
Device.allRealDevices
Device.allSimulators

let device: Device = Device.current
device.diagonal
device.screenRatio
device.ppi
device.realDevice
device.isCurrent
device.isPod
device.isPhone
device.isPad
device.isSimulator
device.isZoomed
device.isTouchIDCapable
device.isFaceIDCapable
device.hasBiometricSensor
device.hasSensorHousing
device.hasRoundedDisplayCorners
device.has3dTouchSupport
device.supportsWirelessCharging
device.hasLidarSensor
device.name
device.systemName
device.systemVersion
device.model
device.localizedModel
device.isGuidedAccessSessionActive
device.screenBrightness
device.isOneOf([.iPhone6, .iPhone6s])
```

### Battery

```swift
enum BatteryState {
    case full
    case charging(Int)
    case unplugged(Int)
}
```

```swift
let device: Device = Device.current
device.batteryState
device.batteryState?.lowPowerMode
device.batteryLevel
```

### Orientation

```swift
enum Orientation {
    case landscape
    case portrait
}
```

```swift
let device: Device = Device.current
device.orientation
``` 

### DiskVolume

```swift
Device.diskVolumeTotalCapacity
Device.diskVolumeAvailableCapacity
Device.diskVolumeAvailableCapacityForImportantUsage
Device.diskVolumeAvailableCapacityForOpportunisticUsage
Device.diskVolumes
```

### ApplePencil

```swift
Device.ApplePencilSupport.firstGeneration
Device.ApplePencilSupport.secondGeneration
let device: Device = Device.current
var supports: [Device.ApplePencilSupport] = device.applePencilSupport
```

### Camera

```swift
enum CameraType {
    case wide
    case telephoto
    case ultraWide
}
```

```swift
let device: Device = Device.current
device.hasCamera
device.hasWideCamera
device.hasTelephotoCamera
device.hasUltraWideCamera
```