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
                spacing: 10
            ) {
                Text("Hello, world!")
                    .padding()
                
                NavigationLink(destination: NavigationLazyView(MemojiView())) {
                                    Text("Memoji View")
                                }
                                .navigationTitle("Navigation")
                
                Button("Button 2") {
                    print("button1")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
