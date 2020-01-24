//
//  ContentView.swift
//  SSSwiftUILoader
//
//  Created by Jasmine Chaniara on 21/01/20.
//  Copyright © 2020 Jasmine Chaniara. All rights reserved.
//

import SwiftUI
import SSSwiftUILoader

struct ContentView: View {
    @State var isLoaderShowing = true
    let disciplines = [1,2,3,4,5,6,7,8,9]
    var body: some View {
        HomeList(disciplines: self.disciplines)
    }
}

struct HomeList: View {
    let timer = Timer.publish(every: 10, on: .main, in: .commonModes).autoconnect()
    var disciplines: [Int]
    var body: some View {
        NavigationView {
            ZStack {
                List(self.disciplines, id: \.self) { item  in
                    NavigationLink(destination: DetailView(discipline: "\(item)")) {
                        Image("img1")
                            .resizable()
                            .cornerRadius(10)
                            .frame(width: 80, height: 80)
                        VStack(alignment: .leading) {
                            Text("\(item)")
                                .font(.headline)
                            Text ("No of rooms ")
                                .font(.subheadline)
                        }
                    }
                }
                VStack {
                    Spacer()
                    Button(action: {
                        SSLoader.shared.startloader(config: .defaultSettings)
                        /*
                         For custom cunfiguration:-
                         SSLoader.shared.startloader(config: .customSettings(config: CustomConfig()))
                         */
                    }) {
                        Text("Show Loader")
                            .frame(width: UIScreen.main.bounds.width - 80, height: 40, alignment: .center)
                            .foregroundColor(Color.white)
                            .background(Color.black)
                            .cornerRadius(20)
                    }
                    Spacer().frame(width: UIScreen.main.bounds.width - 80, height: 20, alignment: .center)
                }
                
            }
            .navigationBarTitle("Rooms")
        }
        .onReceive(timer) { _ in
            SSLoader.shared.stopLoader()
        }
    }
}

/* Demo of custom configuration structure
struct CustomConfig: LoaderConfiguration {
    var loaderTextColor: Color = .blue
    var loaderBackgourndColor: Color = .red
    var loaderForeGroundColor: Color = .green
    var loaderCornerRadius: CGFloat =  10.0
    var loaderWindowColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 0.5)
    var activityIndicatorColor: UIColor = .blue
    var activityIndicatorStyle: UIActivityIndicatorView.Style = .large
}
*/

struct DetailView: View {
    let discipline: String
    var body: some View {
        NavigationView {
            Text(discipline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
