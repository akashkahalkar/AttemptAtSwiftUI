//
//  ContentView.swift
//  testSwiftUI
//
//  Created by Akash kahalkar on 04/06/19.
//  Copyright © 2019 Akashka. All rights reserved.
//

import SwiftUI


struct ContentView : View {
    
    var body: some View {

        NavigationView {
            NavigationButton(destination: WAView().navigationBarTitle(Text("Home View"), displayMode: .inline)) {
                Text("Show WA")
                    .color(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            .navigationBarTitle(Text("SWIFTUI DEMO"), displayMode: .large)
        }
    }
}
// MARK: - App Default Button
struct AppButton: View {
    var title: String
    var color: Color = .blue
    var textColor: Color = .white
    
    var body: some View {
        Text(title)
            .color(textColor)
            .padding()
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
