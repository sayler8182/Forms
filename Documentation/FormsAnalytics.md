# FormsAnalytics

FormsAnalytics collect user events.
By default integrate Firebase.

## Import

```swift
import FormsAnalytics
```

## Dependencies

```
FormsInjector.framework
FormsLogger.framework
```

## External dependencies

```
FirebaseAnalytics.framework
FirebaseCore.framework
FirebaseCoreDiagnostics.framework
FirebaseInstallations.framework
GoogleAppMeasurement.framework
GoogleDataTransport.framework
GoogleDataTransportCCTSupport.framework
GoogleUtilities.framework
nanopb.framework
PromisesObjC.framework
```

## NOTICE
Currently firebase DOSN'T support dynamic framework. You can't use *Analytics* and *Notifications* framework together
see https://github.com/firebase/firebase-ios-sdk/blob/master/docs/firebase_in_libraries.md

## Integration

Library uses Firebase service. You should create and configure project [here](https://console.firebase.google.com/). Then download *GoogleService-Info.plist* and add to your project. It's also important to add *URL Type* in your Target Info's - *URL Schemas* is your *REVERSED_CLIENT_ID* from *GoogleService-Info.plist*.

## Usage

### Configuration

```swift
Analytics.configure()
```

### Event definition 

```swift
enum DemoEvent: String, AnalyticsTag {
    case demoEvent = "demo_event"
}
```

### Event parameters definition 
 
```swift
enum DemoEvent: String, AnalyticsTag {
    case demoEvent = "demo_event"
    
    enum Parameter: AnalyticsTagParameter {
        case demoParameter(value: String)
        
        var parameters: [String: Any?] {
            switch self {
            case .demoParameter(let value):
                return ["value": value]
            }
        }
        var userProperties: [String: String?] {
            switch self {
            case .demoParameter(let value):
                return ["value": value]
            }
        }
    }
}
```

### Sending event

```swift
Analytics.log(DemoEvent.demoEvent)
```

### Sending event with parameters

```swift
Analytics.log(DemoEvent.demoEvent, [
    DemoEvent.Parameter.demoParameter(value: "value")
])
```