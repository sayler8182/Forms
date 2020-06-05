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
ImagePicker.pick(
    on: controller,
    pickerType: SystemImagePickerView.self,
    allowsEditing: true,
    mediaTypes: [.image],
    onSelect: { (data: ImagePickerData) in }, 
    onCancel: { })
```

Pick video 

```swift
ImagePicker.pick(
    on: controller,
    pickerType: SystemImagePickerView.self,
    allowsEditing: true,
    mediaTypes: [.video],
    onSelect: { (data: ImagePickerData) in }, 
    onCancel: { })
```

Pick image and video 

```swift
ImagePicker.pick(
    on: controller,
    pickerType: SystemImagePickerView.self,
    allowsEditing: true,
    mediaTypes: [.image, .video],
    onSelect: { (data: ImagePickerData) in }, 
    onCancel: { })
```

Handle rejected permissions

```swift
ImagePicker.pick(
    on: controller,
    pickerType: SystemImagePickerView.self,
    allowsEditing: true,
    mediaTypes: [.image, .video],
    onSelect: { (data: ImagePickerData) in }, 
    onFail: { },
    onCancel: { })
```

### Custom picker

Custom picker class should implement ImagePickerView protocol.