//
//  LoaderView.swift
//  SwiftUIFullScreenLoader
//
//  Created by Jasmine Chaniara on 01/01/20.
//  Copyright © 2020 Jasmine Chaniara. All rights reserved.
//

import SwiftUI

public protocol LoaderConfiguration {
    var loaderBackgourndColor: Color { get set}
    var loaderForeGroundColor: Color { get set}
    var loaderTextColor: Color { get set}
    var loaderCornerRadius: CGFloat { get set}
    var loaderWindowColor: UIColor { get set}
    var activityIndicatorColor: UIColor { get set}
    var activityIndicatorStyle: UIActivityIndicatorView.Style { get set}
}

public enum ConfigSettings {
    case defaultSettings
    case customSettings(config: LoaderConfiguration)
    func configuration() -> LoaderConfiguration {
        switch  self {
        case .defaultSettings:
            return DefaultConfig()
        case .customSettings( let configSetting):
            return configSetting
        }
    }
}

struct LoadingView: View {
    
    @Binding var isShowing: Bool
    let config: LoaderConfiguration
    let loaderText: String
    
    var body: some View {
        GeometryReader { geomerty in
            ZStack (alignment: .center) {
                
                VStack {
                    Text(self.loaderText).foregroundColor(self.config.loaderTextColor)
                    ActivityIndicator(isAnimating: .constant(self.isShowing), style: self.config.activityIndicatorStyle, color: self.config.activityIndicatorColor)
                }
                .frame(width: geomerty.size.width / 2, height: geomerty.size.width / 2)
                .background(self.config.loaderBackgourndColor)
                .foregroundColor(self.config.loaderForeGroundColor)
                .cornerRadius(self.config.loaderCornerRadius)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
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
    
    public static var shared = SSLoader()
    private init() { }
    fileprivate var popupWindow: LoaderWindow?
    
    public func startloader(_ loaderText: String = "Loading...." ,config: ConfigSettings = .defaultSettings) {
       setLoader(loaderText: loaderText, and: config)
    }
    
    public func stopLoader() {
        removeLoader()
    }

}

fileprivate class LoaderWindow: UIWindow {
}

struct DefaultConfig: LoaderConfiguration {
    var loaderTextColor: Color = .white
    var loaderBackgourndColor: Color = .secondary
    var loaderForeGroundColor: Color = .primary
    var loaderCornerRadius: CGFloat =  10.0
    var loaderWindowColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 0.5)
    var activityIndicatorColor: UIColor = .white
    var activityIndicatorStyle: UIActivityIndicatorView.Style = .large
}

extension SSLoader {
    
    private func setLoader(loaderText: String, and config: ConfigSettings) {
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
    
    private func removeLoader() {
        let alertwindows = UIApplication.shared.windows.filter { $0 is LoaderWindow }
        alertwindows.forEach { (window) in
            window.removeFromSuperview()
        }
        popupWindow = nil
    }
    
}
