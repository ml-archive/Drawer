[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Plaforms](https://img.shields.io/badge/platforms-iOS%20-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Reachability-UI/blob/master/LICENSE)
### Intro


## 📝 Requirements

- iOS 11
- Swift 4.0+

## 📦 Installation

### Carthage 
~~~bash
github "nodes-ios/Drawer"
~~~

## 💻 Usage

Requirements: 

* An `UIViewController` for the drawer to be displayed on top
* An `UIViewController` to act as the content for the drawer

Start by conforming your content `UIViewController` to the `Embeddable` protocol. This exposes several delgate functions to the content `UIViewController` and an instance of `EmbeddableContentDelegate` that can be used to instruct the drawer to perform various tasks.

```swift

extension ContentViewController: Embeddable {}

```

After creating the content `UIViewController` inititalise an instance of `DrawerCoordinator` in your background  `UIViewController` to initialise the drawer.

```swift 

let drawer = DrawerCoordinator(contentViewController: contentVC,
backgroundViewController: self,
drawerBackgroundType: .withColor(UIColor.black.withAlphaComponent(0.5)))

```

When your content's views have finished creating and you are ready to display the drawer, create an instance of `Drawer.ContentConfiguration` to set the drawer state and properties and call the `EmbeddableContentDelegate` handle function to update the drawer's layout. 

```swift
let contentConfiguration = Drawer.ContentConfiguration(duration: animationDuration,
                                                        embeddedFullHeight: maxHeight,
                                                        state: .minimised,
                                                        embeddedMinimumHeight: minHeight,
                                                        cornerRadius: Drawer.ContentConfiguration.CornerRadius(fullSize: 20,
                                                                                                                minimised: 0),
                                                        dismissCompleteCallback:
{ [weak self] in
    guard let self = self else { return }
    //TODO: Drawer dismissed.
})

embedDelegate?.handle(embeddedAction: .layoutUpdated(config: contentConfiguration))
```

## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Drawer** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/DrawerI/blob/master/LICENSE) file for more info.
