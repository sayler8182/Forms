# FormsLocation

FormsLocation is location manager

## Import

```swift
import FormsLocation
```

## Dependencies

```
FormsInjector.framework
FormsLogger.framework
FormsPermissions.framework
```

## Permissions

```
NSLocationWhenInUseUsageDescription
NSLocationAlwaysAndWhenInUseUsageDescription
```

## Usage

### Observe location

```swift
let location = Location()
location.onLocationChanged = { (location: CLLocation?) in }
location.startUpdatingLocation()
location.stopUpdatingLocation()
```

### Get location once

```swift
location.locationOnce = { (location: CLLocation?) in }
```

### Get last location

```swift
location.lastLocation
```