//
//  WAUserInfoView.swift
//  testSwiftUI
//
//  Created by Akash kahalkar on 13/06/19.
//  Copyright © 2019 Akashka. All rights reserved.
//

import SwiftUI
import MapKit

// MARK: - User info screen
struct UserInfoScreen: View {
    
    var user: UserInfo
    @State var showUserImage: Bool = true
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                MapView().tapAction {
                    withAnimation{ self.showUserImage.toggle() }
                }
                    .frame(maxWidth: .infinity, maxHeight: 600)
                if showUserImage {
                    Image(user.userImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 5))
                        .transition(.move(edge: .bottom))
                        .offset(x: 0, y: -100)
                }
            }
                .navigationBarTitle(Text(user.userName), displayMode: .inline)
        }
    }
}
