# FormsImagePickerKit

FormsImagePickerKit is image chooser library.

## Import

```swift
import FormsImagePickerKit
```

## Dependencies

```
Forms.framework
FormsPermissions.framework
```

## Permissions

```
NSCameraUsageDescription
NSPhotoLibraryUsageDescription
NSMicrophoneUsageDescription
```

## Usage

### System picker

Pick image 

```swift
let request = ImagePickerRequest()
    .with(allowsEditing: true)
    .with(mediaTypes: [.image])
ImagePicker.pick(
    on: controller,
    pickerType: SystemImagePickerView.self,
    request: request,
    onSelect: { (data: ImagePickerData) in }, 
    onCancel: { })
```

Pick video 

```swift
let request = ImagePickerRequest()
    .with(allowsEditing: true)
    .with(mediaTypes: [.video])
ImagePicker.pick(
    on: controller,
    pickerType: SystemImagePickerView.self,
    request: request,
    onSelect: { (data: ImagePickerData) in }, 
    onCancel: { })
```

Pick image and video 

```swift
let request = ImagePickerRequest()
    .with(mediaTypes: [.image, .video])
ImagePicker.pick(
    on: controller,
    pickerType: SystemImagePickerView.self,
    request: request,
    onSelect: { (data: ImagePickerData) in }, 
    onCancel: { })
```

Handle rejected permissions

```swift
let request = ImagePickerRequest() 
    .with(mediaTypes: [.image]) 
ImagePicker.pick(
    on: controller,
    pickerType: SystemImagePickerView.self,
    request: request,
    onSelect: { (data: ImagePickerData) in }, 
    onFail: { },
    onCancel: { })
```

Source

```swift
let request = ImagePickerRequest() 
    .with(mediaTypes: [.image]) 
    .with(source: [.photoLibrary]) 
ImagePicker.pick(
    on: controller,
    pickerType: SystemImagePickerView.self,
    request: request,
    onSelect: { (data: ImagePickerData) in }, 
    onCancel: { })
```

### WDImagePicker

Pick image 

```swift
let request = ImagePickerRequest()
    .with(allowsEditing: true)
    .with(cropSize: CGSize(size: 300))
    .with(mediaTypes: [.image])
    .with(resizableCropArea: true)
ImagePicker.pick(
    on: controller,
    pickerType: WDImagePickerView.self,
    request: request,
    onSelect: { (data: ImagePickerData) in }, 
    onCancel: { })
```

### Custom picker

Custom picker class should implement ImagePickerView protocol.