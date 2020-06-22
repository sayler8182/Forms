# FormsAnchor

FormsAnchor is a DSL to make Auto Layout easy.

## Import

```swift
import FormsAnchor
``` 

## Usage

### Adding anchor

```swift
// create view
let centerView = UIView()
view.addSubview(centerView)

// add anchor
centerView.anchors([
    // create centerX and centerY constraints
    Anchor.to(view).centerX,
    Anchor.to(view).centerY,
    // create width and height constraints
    Anchor.to(centerView).height(100),
    Anchor.to(centerView).width(100)
])
```

### Adding subview with anchor

```swift
let fillView = UIView()
view.addSubview(fillView, with: [
    Anchor.to(view).fill
])
```

### Offset

```swift
// default 0
Anchor.to(view).offset(8) 
```

### Multiplier

```swift
// default 1
Anchor.to(view).multiplier(2) 
```

### Relation

```swift
// default .equal
Anchor.to(view).relation(.greaterThanOrEqual)
Anchor.to(view).relation(.equal) 
Anchor.to(view).relation(.lessThanOrEqual)
```

or

```swift
Anchor.to(view).greaterThanOrEqual
Anchor.to(view).equal
Anchor.to(view).lessThanOrEqual
```

### LayoutGuide
LayoutGuide

```swift
// default normal
Anchor.to(view).layoutGuide(.normal)
Anchor.to(view).layoutGuide(.safeArea)
Anchor.to(view).layoutGuide(.margins)
```

```swift
Anchor.to(view).normal
Anchor.to(view).safeArea
Anchor.to(view).margins
```

### Priority

```swift
// default required
Anchor.to(view).priority(.required) 
Anchor.to(view).priority(UILayoutPriority(1)) 
```

or

```swift 
Anchor.to(view).requiredPriority
Anchor.to(view).highPriority
Anchor.to(view).lowPriority
Anchor.to(view).priority(750)
```

### Activation

```swift
// default true
Anchor.to(view).isActive(true)
Anchor.to(view).isActive(false)
```

### Positions

Base positions

```swift
Anchor.to(view).top
Anchor.to(view).bottom
Anchor.to(view).topToBottom
Anchor.to(view).bottomToTop
Anchor.to(view).leading
Anchor.to(view).trailing
Anchor.to(view).leadingToTrailing
Anchor.to(view).trailingToLeading
Anchor.to(view).centerX
Anchor.to(view).centerXToLeading
Anchor.to(view).centerXToTrailing
Anchor.to(view).leadingToCenterX
Anchor.to(view).trailingToCenterX
Anchor.to(view).centerY
Anchor.to(view).centerYToTop
Anchor.to(view).centerYToBottom
Anchor.to(view).topToCenterY
Anchor.to(view).bottomToCenterY
Anchor.to(view).width
Anchor.to(view).widthToHeight
Anchor.to(view).heightToWidth
Anchor.to(view).width(width)
Anchor.to(view).height(height)
Anchor.to(view).size(size)
Anchor.to(view).size(size)
```

Combined positions
```swift
Anchor.to(view).vertical
Anchor.to(view).horizontal
Anchor.to(view).fill
Anchor.to(view).center
Anchor.to(view).centerX(width)
Anchor.to(view).centerY(height)
Anchor.to(view).center(width, height)
Anchor.to(view).center(size)
```

### Update constraint value

```swift
// create connection
let heightAnchor = AnchorConnection()

let fillView = UIView()
view.addSubview(fillView, with: [
    Anchor.to(view).center,
    Anchor.to(view).width(200),
    Anchor.to(view).height(100).connect(heightAnchor)
])

// update constraint
heightAnchor.constraint?.constant = 200
view.layoutIfNeeded()
```