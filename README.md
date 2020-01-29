# SSSwiftUILoader

[![CI Status](https://img.shields.io/travis/simformsolutions/SSSwiftUILoader.svg?style=flat)](https://travis-ci.org/simformsolutions/SSSwiftUILoader)
[![Version](https://img.shields.io/cocoapods/v/SSSwiftUILoader.svg?style=flat)](https://cocoapods.org/pods/SSSwiftUILoader)
[![License](https://img.shields.io/cocoapods/l/SSSwiftUILoader.svg?style=flat)](https://cocoapods.org/pods/SSSwiftUILoader)
[![Platform](https://img.shields.io/cocoapods/p/SSSwiftUILoader.svg?style=flat)](https://cocoapods.org/pods/SSSwiftUILoader)

![Alt text](https://github.com/simformsolutions/SSSwiftUILoader/blob/master/SSSwiftUiLoader.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
  - iOS 13.0+
  - Xcode 11+

## Installation

SSSwiftUILoader is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SSSwiftUILoader'
```
# Usage example
-
    Import framework

        import SSSwiftUILoader
   
-
    **To start the loader**
  
     - It has default settings but you can also use custon setting if you want.

           SSLoader.shared.startloader("SSLoader...", config: .defaultSettings)
        
    - For custom configuration below is the demo, you just need to confirm the LoaderConfiguration protocol as shown below.

            

           struct CustomConfig: LoaderConfiguration {
            var loaderTextColor: Color = .blue
            var loaderBackgroundColor: Color = .red
            var loaderCornerRadius: CGFloat =  10.0
            var loaderWindowColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 0.5)
            var activityIndicatorColor: UIColor = .blue
            var activityIndicatorStyle: UIActivityIndicatorView.Style = .large 
           }

           SSLoader.shared.startloader(config: .customSettings(config: CustomConfig()))
-
    **To stop the loader**

         SSLoader.shared.stopLoader()

## Author

 simformsolutions.com

## License

SSSwiftUILoader is available under the MIT license. See the LICENSE file for more info.

