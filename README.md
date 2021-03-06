
# SystemAlertQueue

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
![CocoaPods Compatible][version-url]
[![Platform][platform-url]][pod-url]

Simple manager that presents alerts by adding them in queue and chains their presentation. A priority can be set to have further control.

## Requirements
- iOS 11.0+
- Swift 5

## Installation

SystemAlertQueue is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'SystemAlertQueue'
```

  ## Usage Example
#### Simple Alert

```swift
AlertFactoryManager.shared.presentSimpleAlert(withMessage: "I am Simple Alert!", title: nil)
```
#### Action Alert

```swift
let defaultAction = UIAlertAction(title: "Default", style: .default, handler: nil)
let destructive = UIAlertAction(title: "Destructive", style: .destructive, handler: nil)
let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
AlertFactoryManager.shared.presentActionAlert(withMessage: "Hello, I am ActionAlert!",
                                                title: nil,
                                                withActions: [defaultAction, destructive, cancel])
```

## License

SystemAlertQueue is available under the MIT license. See the [LICENSE][license-url] file for more info.

[swift-image]:https://img.shields.io/badge/swift-5-green.svg
[swift-url]:  https://swift.org/
[license-url]: https://github.com/scalefocus/system-alert-queue/blob/master/LICENSE
[license-image]:  https://img.shields.io/badge/License-MIT-blue.svg
[version-url]:  https://img.shields.io/cocoapods/v/SystemAlertQueue.svg
[pod-url]: http://cocoapods.org/pods/SystemAlertQueue
[platform-url]: https://img.shields.io/cocoapods/p/SystemAlertQueue
[travis-image]: https://travis-ci.com/scalefocus/system-alert-queue.svg?branch=master
[travis-url]: https://travis-ci.com/github/scalefocus/system-alert-queue
