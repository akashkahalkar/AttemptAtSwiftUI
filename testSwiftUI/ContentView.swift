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
            ZStack {
                Image("poster").offset(CGSize(width: 00, height: -30))
//                Color(Color.black.opacity(0.5 ))
                NavigationLink(destination: WAView()) {
                    ZStack {
                        Text("ENTER")
                            .font(.largeTitle)
                        .padding(.all)
                        .foregroundColor(.white)
                            .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(radius: 0.5)
                    }
                    }.buttonStyle(PlainButtonStyle())
            }
         .navigationBarTitle("HOME", displayMode: .inline)
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
