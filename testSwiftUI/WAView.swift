//
//  WAView.swift
//  testSwiftUI
//
//  Created by Akash kahalkar on 10/06/19.
//  Copyright © 2019 Akashka. All rights reserved.
//

import SwiftUI



enum Menu: Int, CaseIterable {
    case chat, status, calls
    
    func getMenuTitle() -> String {
        switch self {
            
            case .chat: return "CHAT"
            case .status: return "STATUS"
            case .calls: return "CALLS"
        }
    }
}

// MARK: - Home
struct WAView : View {
    /// It is not advise to use external dependecies with @State wrapper
    @State private var userStore: UserStore = UserStore()
    @State private var addContactsViewPresented = false
    @State private var selectetState: Int = 0

    init() {
        //configuring table view appearance
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = AVColors.cellBackgroundColor
        UITableViewCell.appearance().backgroundColor = AVColors.cellBackgroundColor
        
        UISegmentedControl
            .appearance()
            .setTitleTextAttributes([.foregroundColor: AVColors.headerLightBlue,
                                     .font: UIFont.boldSystemFont(ofSize: 12)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().tintColor = UIColor.clear
    }
    
    var body: some View {
        //zstack with bottom trailing to add floating button at bottom with the view
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                //top bar using segmented control
                Picker(selection: $selectetState, label: Text(verbatim: "picker")) {
                    
                    MenuSegment(selectedState: $selectetState, menu: Menu.chat)
                    MenuSegment(selectedState: $selectetState, menu: Menu.status)
                    MenuSegment(selectedState: $selectetState, menu: Menu.calls)
                }
                .frame(height: 60.0)
                .background(Color(AVColors.headerBlue))
                .foregroundColor(.white)
                .pickerStyle(SegmentedPickerStyle())
                
                if selectetState == Menu.chat.rawValue {
                    List {
                        ForEach(userStore.userInfo) { user in
                            ListRow(userInfo: user)
                        }
                    }.environment(\.defaultMinListRowHeight, 100)
                } else if selectetState == Menu.status.rawValue {
                    List {
                        StatusRow()
                        StatusRow()
                        StatusRow()
                        
                    }.environment(\.defaultMinListRowHeight, 100)
                } else {
                    List {
                        StatusRow()
                        StatusRow()
                        StatusRow()
                    }.environment(\.defaultMinListRowHeight, 100)
                }
            }
            .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity, alignment: .leading)
            
            Button(action: {
                self.addContactsViewPresented.toggle()
            }) {
                FloatingButton().padding(.bottom, 20).padding(.trailing, 20)
            }.buttonStyle(PlainButtonStyle())
            
            .sheet(isPresented: $addContactsViewPresented) {
                AddContactsView(userStore: self.$userStore, hideView: self.$addContactsViewPresented)
            }
        .navigationBarTitle("")
        }
    }
}

struct MenuSegment: View {
    
    @Binding var selectedState: Int
    var menu: Menu
    
    var body: some View {
        
        Text(verbatim: menu.getMenuTitle()).font(Font.system(.title)).bold()
            .tag(menu.rawValue)
    }
}

//floating button at bottom right corner
struct FloatingButton: View {
    var body: some View {
        
        ZStack {
            Circle()
                .foregroundColor(Color.white)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 5, y: 5)
            
            Image(systemName: "plus")
                .resizable()
                .padding()
                .foregroundColor(Color(AVColors.darkRed))
                .font(Font.system(.body))

            }.frame(width: 50, height: 50)
            
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
                    TextField("Enter friends name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
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
//list row with image title and subtitle
struct ListRow : View {
    
    let userImageSize: CGFloat  = 40.0
    var userInfo: UserInfo
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            //background view with shadow
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(Color(AVColors.cellColor))
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 4, y: 0)
            
            NavigationLink(destination: WAUserDetailView(user: userInfo)) {
                
                HStack {
                    ZStack(alignment: .bottomTrailing) {
                        Image(userInfo.userImage)
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: ContentMode.fill)
                        .frame(width: userImageSize,
                               height: userImageSize,
                               alignment: Alignment.center)
                        .shadow(radius: 3)
                        
                        //online indicator
                        Circle()
                            .foregroundColor(.green).frame(width: 10, height: 10)
                    }
                        
                    
                    VStack(alignment: .leading) {
                        Text(userInfo.userName).font(.headline)
                        Text(userInfo.lastMessage?.message ?? "No recent message")
                            .font(.subheadline).foregroundColor(.gray)
                    }
                }
            }.padding()
        }.padding(.top, 5)
    }
}

struct StatusRow : View {
    
    let userImageSize: CGFloat  = 40.0
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            //background view with shadow
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(Color(AVColors.cellColor))
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 4, y: 0)
            
            HStack {
                Image(systemName: "faceid")
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: ContentMode.fill)
                    .frame(width: userImageSize,
                           height: userImageSize,
                           alignment: Alignment.center)
                    .shadow(radius: 3)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("userInfo.userName").font(.headline)
                    Text("subtitle")
                        .font(.subheadline).foregroundColor(.gray)
                }
            }
        }.padding(.top, 5)
    }
}




