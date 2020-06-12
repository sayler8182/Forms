# FormsAnalytics

FormsAnalytics collect user events and sends to multiple providers.

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

## Integration

Library uses Firebase service. You should create and configure project [here](https://console.firebase.google.com/). Then download *GoogleService-Info.plist* and add to your project. It's also important to add *URL Type* in your Target Info's - *URL Schemas* is your *REVERSED_CLIENT_ID* from *GoogleService-Info.plist*.

## Usage

### Configuration

```swift
class DemoAnalyticsFirebaseProvider: AnalyticsProvider {
    let name: String = "Firebase"
    
    func logEvent(_ event: AnalyticsEvent,
                  _ parameters: [String: Any],
                  _ userProperties: [String: String]) {
        for userProperty in userProperties {
            FirebaseAnalytics.Analytics.setUserProperty(
                userProperty.value,
                forName: userProperty.key)
        }
        FirebaseAnalytics.Analytics.logEvent(
            event.name,
            parameters: parameters)
    }
    
    func setUserId(_ userId: String?) {
        FirebaseAnalytics.Analytics.setUserID(userId)
    }
}
```

```swift
Analytics.register([
    DemoAnalyticsFirebaseProvider()
])
```

### Event definition 

```swift
enum DemoEvent: String, AnalyticsTag {
    case demoEvent = "demo_event"
}
```

### Event parameters definition 
 
```swift
enum DemoEvent: AnalyticsEvent {
    case demoEvent(value: Int?)
        
    var name: String {
        switch self {
        case .demoEvent: return "demo_event"
        }
    }
    var parameters: [String: Any?] {
        switch self {
        case .demoEvent(let value):
            return ["value": value]
        }
    }
    var userProperties: [String: String?] {
        switch self {
        case .demoEvent(let value):
            return ["value": value.description]
        }
    }
}
```

### Sending event

```swift
Analytics.log(DemoEvent.demoEvent(value: 12))
```