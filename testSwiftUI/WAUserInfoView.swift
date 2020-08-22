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
        VStack(alignment: .center) {
            MapView().onTapGesture {
                withAnimation{ self.showUserImage.toggle() }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if showUserImage {
                ZStack {
                    Circle()
                        .foregroundColor(.white).frame(width: 200, height: 200)
                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 2, y: 2)
                        .offset(x: 0, y: -100)
                    
                    Image(user.userImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 180, height: 180)
                        .transition(.move(edge: .bottom))
                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 1, y: 1)
                        .offset(x: 0, y: -100)
                }
                
            } // end if condition
        } // end vstack
        .navigationBarTitle(Text(user.userName), displayMode: .inline)
    }
}
