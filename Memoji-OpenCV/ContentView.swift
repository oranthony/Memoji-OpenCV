//
//  ContentView.swift
//  Memoji-OpenCV
//
//  Created by anthony loroscio on 09/03/2022.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack (
                alignment: .center,
                spacing: 30
            ) {
                Text("Welcome to Memoji Opencv")
                    .padding()
                
                NavigationLink(destination: NavigationLazyView(MemojiView())) {
                                    Text("Memoji View")
                                }
                                .navigationTitle("Memoji View")
                
                NavigationLink(destination: NavigationLazyView(CameraLandmarkView())) {
                                    Text("OpenCV Landmark View")
                                }
                                .navigationTitle("OpenCV Landmark View")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
