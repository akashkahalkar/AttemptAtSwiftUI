//
//  WAView.swift
//  testSwiftUI
//
//  Created by Akash kahalkar on 10/06/19.
//  Copyright © 2019 Akashka. All rights reserved.
//

import SwiftUI

// MARK: - Home
struct WAView : View {
    /// It is not advise to use external dependecies with @State wrapper
    @State private var userStore: UserStore = UserStore()
    @State private var selectedMenuItem: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                Text("SupApp").bold().font(.title).padding().foregroundColor(.white)
                HStack(alignment: .center, spacing: 50) {
                    //can not iterate with ForEach because menuArray does not conform
                    //to protocol Identifiable
                    HeaderButton(title: menuArray[0], selectedMenuItem: $selectedMenuItem)
                    HeaderButton(title: menuArray[1], selectedMenuItem: $selectedMenuItem)
                    HeaderButton(title: menuArray[2], selectedMenuItem: $selectedMenuItem)
                    }
                    .frame(minWidth: .zero, maxWidth: .infinity, alignment: .center)//.padding(0.0)
                    .background(Color.WADarkGreen)
                
                if selectedMenuItem == 0 {
                    List {
                        ForEach(userStore.userInfo) { user in
                            WAHomeRow(userInfo: user)
                        }
                    }
                } else if selectedMenuItem == 1 {
                    List {
                        Text("Status View")
                        Text("Status View")
                        Text("Status View")
                        Text("Status View")
                    }
                } else {
                    List {
                        Text("CAlls View")
                        Text("CAlls View")
                        Text("CAlls View")
                        Text("CAlls View")
                    }
                }
                }
                .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity, alignment: .leading)
                .background(Color.WADarkGreen)
            
            PresentationButton(FloatingButton(), destination: AddContactsView(userStore: $userStore)).padding()
        }
    }
}

struct FloatingButton: View {
    var body: some View {
        
        Image(systemName: "line.horizontal.3.decrease.circle")
            .resizable()
            .frame(width: 50, height: 50)
            .background(Color.WADarkGreen)
            .clipShape(Circle())
            .font(.subheadline).foregroundColor(.white)
    }
}

struct AddContactsView: View {
    @Binding var userStore: UserStore
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Name : ").color(.white).font(.headline)
                    //TextField($name).foregroundColor(.white).background(Color.gray).frame(height: 60).padding()
                    TextField($name, placeholder: Text("User Name"))
                        //.frame(maxWidth: 100, maxHeight: 60)
                        .background(Color.white)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading, 10)
                        .lineLimit(3)
                    }
                    .padding()
                    .background(Color.WADarkGreen)
                
                Button(action: {
                    withAnimation(Animation.basic(duration: 0.5, curve: BasicAnimationTimingCurve.easeInOut)) {
                        self.addUser()
                    }
                }) {
                    AppButton(title: "Add User", color: .WADarkGreen, textColor: .white)
                }
            }
            .navigationBarTitle(Text("Add User"), displayMode: .inline)
        }
    }
    
    func addUser() {
        if !name.isEmpty {
            userStore.addUser(userName: name)
        }
    }
}

struct HeaderButton: View {
    var title: String
    @Binding var selectedMenuItem: Int
    
    var body: some View {
        
        return Button(action: {
            withAnimation(Animation.basic(duration: 0.5, curve: BasicAnimationTimingCurve.easeInOut)) {
                self.buttonPressed()
            }
        }) {
            Text(title).color(selectedMenuItem == menuArray.firstIndex(of: title) ? Color.white : Color.WAWhiteUnselected)
                                .bold()
                                .layoutPriority(0.5)
        }
    }
    
    func buttonPressed() {
        selectedMenuItem = menuArray.firstIndex(of: title) ?? 0
    }
}
// MARK: Home row
struct WAHomeRow : View {
    
    var userInfo: UserInfo
    var body: some View {
        
        NavigationButton(destination: WAUserDetailView(user: userInfo).navigationBarTitle(Text("Details View"), displayMode: .inline)) {
            HStack {
                Image(userInfo.userImage)
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fill)
                    .clipShape(Circle())
                    .frame(width: 50.0, height: 50.0, alignment: .center)
                VStack(alignment: .leading) {
                    HStack {
                        Text(userInfo.userName).font(.headline)
                        Spacer()
                        Text(userInfo.time).font(.footnote).foregroundColor(Color.secondary)
                    } //user name and time stack
                    Text(userInfo.lastMessage)
                        .color(.secondary)
                } //user info area stack
            }
        }
    }
}




