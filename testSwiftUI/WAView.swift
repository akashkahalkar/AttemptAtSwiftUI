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
    @State private var addContactsViewPresented = false
    @State private var selectetState: Int = 0
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .singleLine
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                Picker(selection: $selectetState, label: Text(verbatim: "picker")) {
                    Text(verbatim: "CHAT").tag(0)
                    Text(verbatim: "STATUS").tag(1)
                    Text(verbatim: "CALLS").tag(2)
                }
                .frame(height: 60.0).background(Color.WADarkGreen).foregroundColor(.white)
                .pickerStyle(SegmentedPickerStyle())
                    
                
                if selectetState == 0 {
                    List {
                        ForEach(userStore.userInfo) { user in
                            WAHomeRow(userInfo: user)
                        }
                    }
                } else if selectetState == 1 {
                    List {
                        StatusRow()
                        StatusRow()
                        StatusRow()
                        
                    }
                } else {
                    List {
                        StatusRow()
                        StatusRow()
                        StatusRow()
                    }
                }
            }
            .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity, alignment: .leading)
            //.background(Color.WADarkGreen)
            
            Button(action: {
                self.addContactsViewPresented.toggle()
            }) {
                FloatingButton().padding(.trailing, 10.0)
            }
            
            .sheet(isPresented: $addContactsViewPresented) {
                AddContactsView(userStore: self.$userStore, hideView: self.$addContactsViewPresented)
            }
        .navigationBarTitle("Wassup")
        }//zstack
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
    @Binding var hideView: Bool
    @State private var name: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Enter friends Name").foregroundColor(.black)
                HStack {
                    TextField("Enter friends name", text: $name).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        self.addUser()
                    }) {
                        AppButton(title: "Add")
                    }
                }
                }.padding()
            .navigationBarTitle(Text("Add User"), displayMode: .inline)
        }
    }
    
    func addUser() {
        if !name.isEmpty {
            userStore.addUser(userName: name)
            name = ""
            hideView.toggle()
        }
    }
}

struct HeaderButton: View {
    var title: String
    @Binding var selectedMenuItem: Int
    
    var body: some View {
        Button(action: {
            self.buttonPressed()
        }, label: {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .underline(isCurrentIndexSelected(), color: .white)
        })
    }
    
    func isCurrentIndexSelected() -> Bool {
        selectedMenuItem == menuArray.firstIndex(of: title)
    }
    func buttonPressed() {
        selectedMenuItem = menuArray.firstIndex(of: title) ?? 0
    }
}
// MARK: Home row
struct WAHomeRow : View {
    
    var userInfo: UserInfo
    var body: some View {
        NavigationLink(destination: WAUserDetailView(user: userInfo)) {
            HStack {
                Image(userInfo.userImage)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: ContentMode.fill)
                    .frame(width: CGFloat(50.0),
                           height: CGFloat(50.0),
                           alignment: Alignment.center)
                    
                VStack(alignment: .leading) {
                    Text(userInfo.userName).font(.headline)
                    Text(userInfo.lastMessage).font(.subheadline).foregroundColor(.gray)
                }
            }
        }
    }
}

struct StatusRow : View {
    
    var body: some View {
        HStack {
            Image(systemName: "faceid")
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: ContentMode.fill)
                .frame(width: CGFloat(50.0),
                       height: CGFloat(50.0),
                       alignment: Alignment.center)
                
            VStack(alignment: .leading) {
                Text("userInfo.userName").font(.headline)
                Text("userInfo.lastUpdateTiming").font(.subheadline).foregroundColor(.gray)
            }
        }
    }
}




