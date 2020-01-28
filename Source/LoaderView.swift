//
//  LoaderView.swift
//  SwiftUIFullScreenLoader
//
//  Created by Jasmine Chaniara on 01/01/20.
//  Copyright © 2020 Jasmine Chaniara. All rights reserved.
//
import SwiftUI
/// Description Here
public protocol LoaderConfiguration {
    /// To set loader background color.
    var loaderBackgroundColor: Color { get set}
    /// To set loading text color.
    var loaderTextColor: Color { get set}
    /// It will set corner radius.
    var loaderCornerRadius: CGFloat { get set}
    /// It will set the backgroud color of whole screen.
    var loaderWindowColor: UIColor { get set}
    /// Set activity indicator color.
    var activityIndicatorColor: UIColor { get set}
    /// set activityindicator style : .medium, .large etc.
    var activityIndicatorStyle: UIActivityIndicatorView.Style { get set}
}

/// Enum to set custom and default configuration.
public enum ConfigSettings {
    case defaultSettings
    case customSettings(config: LoaderConfiguration)
    /// Return default and custom configuration which confirm LoaderConfiguration protocol
    func configuration() -> LoaderConfiguration {
        switch  self {
        case .defaultSettings:
            return DefaultConfig()
        case .customSettings( let configSetting):
            return configSetting
        }
    }
}

/// LoadingView create the loader view
private struct LoadingView: View {
    /// parameter to hide and show loader
    @Binding var isShowing: Bool
    let config: LoaderConfiguration
    let loaderText: String
    var body: some View {
        GeometryReader { geomerty in
            ZStack(alignment: .center) {
                VStack {
                    Text(self.loaderText).foregroundColor(self.config.loaderTextColor).multilineTextAlignment(.center)
                    ActivityIndicator(isAnimating: .constant(self.isShowing), style: self.config.activityIndicatorStyle, color: self.config.activityIndicatorColor)
                }
                .frame(width: geomerty.size.width / 2, height: geomerty.size.width / 2)
                .background(self.config.loaderBackgroundColor)
                .cornerRadius(self.config.loaderCornerRadius)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

/// Activity Indicator Of UIkit
struct ActivityIndicator: UIViewRepresentable {
    /// property to start stop animation
    @Binding var isAnimating: Bool
    /// property set the style of activitty indicator
    let style: UIActivityIndicatorView.Style
    let color: UIColor
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = color
        return activityIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
    
}

public class SSLoader {
    /// shared object of SSLoader
    public static var shared = SSLoader()
    private init() { }
    /// popupWindow is a subclass of window to add loader on existing window
    private var popupWindow: LoaderWindow?
    /// - Parameters:
    ///   - loaderText: Text to be shown in loader
    ///   - config: configuration of loader define in protocol
    
    public func startloader(_ loaderText: String = "", config: ConfigSettings = .defaultSettings) {
       setLoader(loaderText: loaderText, and: config)
    }
    
    /// function to remove loader from screen.
    public func stopLoader() {
        removeLoader()
    }
    
}

// MARK: - LoaderWindow
private class LoaderWindow: UIWindow {
}

/// Default loader settings
struct DefaultConfig: LoaderConfiguration {
    var loaderTextColor: Color = .white
    var loaderBackgroundColor: Color = .secondary
    var loaderCornerRadius: CGFloat =  10.0
    var loaderWindowColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 0.5)
    var activityIndicatorColor: UIColor = .white
    var activityIndicatorStyle: UIActivityIndicatorView.Style = .large
}

private extension SSLoader {
    /// - Parameters:
    ///   - loaderText: loaderText
    ///   - config: loader UI configuration
    func setLoader(loaderText: String, and config: ConfigSettings) {
        let configuration = config.configuration()
               let windowScene = UIApplication.shared
                   .connectedScenes
                   .filter { $0.activationState == .foregroundActive }
                   .first
               if let windowScene = windowScene as? UIWindowScene {
                   popupWindow = LoaderWindow(windowScene: windowScene)
                   popupWindow?.frame = UIScreen.main.bounds
                   popupWindow?.backgroundColor = .clear
                   popupWindow?.rootViewController = UIHostingController(rootView: LoadingView(isShowing: .constant(true), config: configuration, loaderText: loaderText))
                   popupWindow?.rootViewController?.view.backgroundColor = configuration.loaderWindowColor
                   popupWindow?.makeKeyAndVisible()
               }
    }
    /// Remove loader from screen
    func removeLoader() {
        let alertwindows = UIApplication.shared.windows.filter { $0 is LoaderWindow }
        alertwindows.forEach { (window) in
            window.removeFromSuperview()
        }
        popupWindow = nil
    }
    
}

