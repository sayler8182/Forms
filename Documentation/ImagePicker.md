# ImagePicker

ImagePicker is image chooser library.

## Import

```swift
import ImagePicker
```

## Dependencies

```
Forms.framework
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

### Custom picker

Custom picker class should implement ImagePickerView protocol.