[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Plaforms](https://img.shields.io/badge/platforms-iOS%20-lightgrey.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/nodes-ios/Drawer/blob/master/LICENSE)
[![CircleCI](https://circleci.com/gh/nodes-ios/Drawer.svg?style=shield)](https://circleci.com/gh/nodes-ios/Drawer)

## Intro

`Drawer` is a framework that enables you to easily embed a `UIViewController` in a drawer and display it on top of another `UIViewController`.

![](drawer_open.gif)
![](drawer_close.gif)

## 📝 Requirements

- iOS 11
- Swift 4.0+

## 📦 Installation

### Carthage
~~~bash
github "nodes-ios/Drawer"
~~~

### Cocoapods
~~~bash
pod 'NDrawer'
~~~

## 💻 Usage

### Requirements

* A `UIViewController` for the drawer to be displayed over. This `ViewController` is referred to as the `backgroundViewController` in the following steps
* A `UIViewController` to act as the content of the drawer. This `ViewController` is referred to as the `contentViewController` in the following steps.

### Steps

#### Creating a Drawer
Start by conforming your `contentViewController` to the `Embeddable` protocol. This exposes several delegate functions to the `contentViewController`.

```swift
extension ContentViewController: Embeddable {}
```

Furthermore an instance of `EmbeddableContentDelegate` is exposed. This `delegate` can be used to instruct the drawer to perform various tasks by calling the `handle` function on it.

The `handle` function takes an `enum` of type `Drawer.Action` which allows these actions:

- `layoutUpdated(config: Drawer.Configuration)` to update the layout of your drawer
- `changeState(to: MovementState)` to show/hide your drawer.

After creating the `contentViewController`, initialize an instance of `DrawerCoordinator` in your `backgroundViewController` to initialize the drawer.

```swift
let drawer = DrawerCoordinator(contentViewController: contentVC,
                               backgroundViewController: self,
                               drawerBackgroundType: .withColor(UIColor.black.withAlphaComponent(0.5)))
```

#### Displaying a Drawer
After your content's views have finished creating and you are ready to display the drawer, create an instance of `Drawer.Configuration` to set the drawer state and properties.

```swift

let options: [Drawer.Configuration.Key : Any] = [
.animationDuration: 0.5,
.fullHeight: maxHeight,
.minimumHeight: minHeight,
.initialState: Drawer.State.minimized,
.cornerRadius: Drawer.Configuration.CornerRadius(fullSize: 20,
                                                 minimized: 0)
]

let contentConfiguration = Drawer.Configuration(options: options,
                                                dismissCompleteCallback: nil)

```

Communication with the `EmbeddableContentDelegate` is managed by calling the `handle` function, which takes an `enum` of type `Drawer.Action` as a parameter.
Finally call the `EmbeddableContentDelegate` `handle` function to update the drawer's layout to the new `Configuration`

 ```swift
 embedDelegate?.handle(action: .layoutUpdated(config: contentConfiguration))
 ```

 #### Expanding and Collapsing a Drawer
 To expand and collapse the drawer programatically, call the `EmbeddableContentDelegate` `handle` function with a `changeState` action containing the state which the drawer should transition to.

 ```swift
embedDelegate?.handle(action: .changeState(to: .fullScreen))
 ```

## Example Project
To learn more, please refer to the example project contained in this repository.

## 👥 Credits
Made with ❤️ at [Nodes](http://nodesagency.com).

## 📄 License
**Drawer** is available under the MIT license. See the [LICENSE](https://github.com/nodes-ios/DrawerI/blob/master/LICENSE) file for more info.
