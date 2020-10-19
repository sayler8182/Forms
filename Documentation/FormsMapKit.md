# FormsMapKit

FormsMapKit is map library.

## Import

```swift
import FormsMapKit
```

## Dependencies

```
Forms.framework
```

## Usage

```swift
let mapView = Components.map.apple()
    .with(height: 350)
    .with(delegate: self)
    .with(isClusterEnabled: true)
    .with(showsUserLocation: true)
    .register([SomeAnnotationView.self])

self.mapView.dequeue(SomeAnnotationView.self)
self.mapView.setRegion(center: some_location)
```