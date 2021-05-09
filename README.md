[![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-12.0-blue.svg)](https://developer.apple.com/xcode)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/NativeUI.svg)](https://cocoapods.org/pods/NativeUI)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

# NativeUI

## Minimum Requirements:
- iOS 9.0
- Xcode 12.0
- Swift 5

## Installation

#### CocoaPods

```ruby
target 'MyApp' do
  pod 'NativeUI', '~> 1.2.1'
end
```

If you don't need to connect all UI components you may use subspecs like:

```ruby
target 'MyApp' do
  pod 'NativeUI/Alert', '~> 1.2.1'
end
```

Available subspecs:
- `Utils`
- `Alert`

## Alert

<img src="https://github.com/AntonPoltoratskyi/NativeUI/blob/master/Example/Demo/default.gif" width="250" /> <img src="https://github.com/AntonPoltoratskyi/NativeUI/blob/master/Example/Demo/custom.gif" width="250" />

**`AlertViewController` is a customizable replacement for native `UIAlertController`.**

Sometimes we need to set NSAttributedString into native alert, but public API doesn't allow it. As a workaroud we could use private API, but in general we should avoid using it.

`AlertViewController` looks exactly like native `UIAlertController`, but very configurable.

### Configuration

1. Default initialization with title, message as `String`.

```swift
let cancelAction = Alert.Action(title: "Cancel", style: .primary)
let confirmAction = Alert.Action(title: "Confirm", style: .default)
            
let viewModel = Alert(
    title: "Your Title",
    titleFont: ... // your custom title font
    message: "Your Message",
    messageFont: ... // your custom message font
    actions: [cancelAction, confirmAction]
)
let alert = AlertViewController(viewModel: viewModel)
present(alert, animated: true)
```

2. Default initialization with title, message as `NSAttributedString`

```swift
let cancelAction = Alert.Action(title: "Cancel", style: .primary)
let confirmAction = Alert.Action(title: "Confirm", style: .default)
            
let viewModel = Alert(
    title: ... // your title (NSAttributedString)
    message: ... // your message (NSAttributedString)
    actions: [cancelAction, confirmAction]
)
let alert = AlertViewController(viewModel: viewModel)
present(alert, animated: true)
```

3. Initialization with title, message and custom `UIView` object as content view to implement complex layout.


```swift
let cancelAction = Alert.Action(title: "Cancel", style: .primary)
let confirmAction = Alert.Action(title: "Confirm", style: .default)

let customView = CustomView()
customView.translatesAutoresizingMaskIntoConstraints = false
customView.imageView.backgroundColor = .orange
customView.titleLabel.text = "Some text"
customView.subtitleLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

let viewModel = Alert(
    title: "Your Title",
    message: nil,
    contentView: customView,
    actions: [cancelAction, confirmAction]
)
let alert = AlertViewController(viewModel: viewModel)
present(alert, animated: true)
```

See [Alert.swift](https://github.com/devpolant/NativeUI/blob/master/NativeUI/Sources/Alert/Alert.swift) for more details.

### Edge cases

When you need to present few alerts in a row you should set `shouldDismissAutomatically` flag to `false` and add action AFTER view controller initialization to be able to capture alert instance in action handler's closure.

```swift

let viewModel = Alert(
    title: "Your Title",
    message: "Your Message"
)
let alert = AlertViewController(viewModel: viewModel)
alert.shouldDismissAutomatically = false

let cancelAction = Alert.Action(title: "Cancel", style: .primary) { [weak alert] _ in
    alert?.dismiss(animated: true) {
        // present something else
    }
}
alert.addAction(cancelAction)

let confirmAction = Alert.Action(title: "Confirm", style: .default) { [weak alert] _ in
    alert?.dismiss(animated: true) {
        // present something else
    }
}
alert.addAction(confirmAction)

present(alert, animated: true)
```

## Author

Anton Poltoratskyi

## License

NativeUI is available under the MIT license. See the [LICENSE](https://github.com/devpolant/NativeUI/blob/master/LICENSE) file for more info.
