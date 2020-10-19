# FormsAppStoreReview

FormsAppStoreReview is review helper.

## Import

```swift
import FormsAppStoreReview
```

## Dependencies

```
StoreKit.framework
```

## Usage

```swift
let appStoreReview = AppStoreReview(
    minLaunchCount: 3, // minimum launch count
    minPeriod: 60 * 60 * 24, // after 1 day
    minPeriodInterval: 60 * 60 * 24 * 30 // each 1 month
)
```

Right after app starts you should notify service. This method will save first launch date for later comparisons.

```swift
appStoreReview.initFirstLaunchIfNeeded()
```

After each launch you should also notify service for changing launch counter. (Notice that init doesn't change launch count)

```swift
appStoreReview.launch()
```

When your app is ready to display review information you can show modal 

```swift
appStoreReview.show()
appStoreReview.showIfNeeded()
```