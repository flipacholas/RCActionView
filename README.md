# RCActionView
[![](http://img.shields.io/badge/iOS-8.0%2B-blue.svg)]()
[![](http://img.shields.io/badge/Swift-2.0-blue.svg)]()
[![CI Status](http://img.shields.io/travis/flipacholas/RCActionView.svg?style=flat)](https://travis-ci.org/flipacholas/RCActionView)
[![Version](https://img.shields.io/cocoapods/v/RCActionView.svg?style=flat)](http://cocoapods.org/pods/RCActionView)
[![License](https://img.shields.io/cocoapods/l/RCActionView.svg?style=flat)](http://cocoapods.org/pods/RCActionView)
[![Platform](https://img.shields.io/cocoapods/p/RCActionView.svg?style=flat)](http://cocoapods.org/pods/RCActionView)

RCActionView is a reimplementation of [sagiwei/SGActionView](https://github.com/sagiwei/SGActionView) written entirely in Swift. A customizable bottom menu, similar to Bottomsheet in Android. 


|               | Light | Black |
| ------------- | ------------- | ------------- |
| RCGridView  | <img src="Images/GridLight.png" alt="Drawing" height="525px" width="357px"/> | <img src="Images/GridBlack.png" alt="Drawing" height="525px" width="357px"/>  |
| RCAlertView  | <img src="Images/AlertLight.png" alt="Drawing" height="525px" width="357px"/> | <img src="Images/AlertBlack.png" alt="Drawing" height="525px" width="357px"/>  |
| RCSheetView  | <img src="Images/SheetLight.png" alt="Drawing" height="525px" width="357px"/> | <img src="Images/SheetBlack.png" alt="Drawing" height="525px" width="357px"/>  |


## Implementation

You can use the example project, alternatively you can use the following methods:

For RCAlertView:

```swift
RCActionView(style: .Light)
                    .showAlertWithTitle("Alert View",
                                        message: "This is a amessage",
                                        leftButtonTitle: "Cancel",
                                        rightButtonTitle: "OK",
                                        selectedHandle: { (selectedOption:Int) -> Void in
self.doSomething(selectedOption) })
```

For RCSheetView:

```swift
 RCActionView(style: .Light)
                    .showSheetWithTitle("Sheet View",
                                        itemTitles: ["Wedding Bell", "I'm Yours", "When I Was Your Man"],
                                        itemSubTitles: ["Depapepe - Let's go!!!", "Jason Mraz", "Bruno Mars"],
                                        selectedIndex: 0,
                                        selectedHandle: { (selectedOption:Int) -> Void in
self.doSomething(selectedOption) })
```

For RCGridView:

```swift
RCActionView(style: .Light)
                    .showGridMenuWithTitle("Grid View",
                                           itemTitles: ["Facebook", "Twitter", "Google+", "Linkedin", "Weibo", "WeChat", "Pocket", "Dropbox"],
                                           images: [UIImage(named: "facebook")!, UIImage(named: "twitter")!, UIImage(named: "googleplus")!, UIImage(named: "linkedin")!, UIImage(named: "weibo")!, UIImage(named: "wechat")!, UIImage(named: "pocket")!, UIImage(named: "dropbox")!],
                                           selectedHandle: { (selectedOption:Int) -> Void in
self.doSomething(selectedOption) })
```

The above examples use white styles, for black styles replace

```swift
RCActionView(style: .Light)
```

With

```swift
RCActionView(style: .Black)
```

## Installation

RCActionView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RCActionView", '~> 1.0.0'
```

## Bug, improvements...

You can open issues, pull requests... I will be happy to help

## Current projects using RCActionView

[Bus n'Tour Mataró](https://itunes.apple.com/us/app/bus-ntour-mataro/id990772306)

You can Pull Request to add your projects

## License

RCActionView is available under the MIT license. See the LICENSE file for more info.
