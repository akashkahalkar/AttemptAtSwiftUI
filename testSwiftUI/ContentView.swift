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
            NavigationLink(destination: WAView(), label: {
                Text(verbatim: "Show Wasup")
            })
                .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}
// MARK: - App Default Button
struct AppButton: View {
    var title: String
    
    var body: some View {
        Text(verbatim: title)
    }
}
