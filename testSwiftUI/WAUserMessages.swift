//
//  WAUserDetailView.swift
//  testSwiftUI
//
//  Created by Akash kahalkar on 13/06/19.
//  Copyright © 2019 Akashka. All rights reserved.
//

import SwiftUI

// MARK: - User Detail View

struct WAUserDetailView: View {
    
    var user: UserInfo
    @State private var newMessage: String = ""
    @ObservedObject private var msgStore = MessageStore()
    @ObservedObject private var keyboard = KeyboardResponder()
            
    init(user: UserInfo) {
        self.user = user
        // To remove only extra separators below the list:
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        
        VStack (alignment: HorizontalAlignment.leading) {
            
            HStack(spacing: CGFloat(10.0)) {
                Image(user.userImage)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: ContentMode.fill)
                    .frame(width: 50.0, height: 50.0)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .padding(.leading, 10.0)
                
                
                VStack(alignment: .leading) {
                    //PresentationButton(Text(user.userName).font(.title).color(.white), destination: UserInfoScreen(user: user)).foregroundColor(.clear)
                    NavigationLink(destination: UserInfoScreen(user: user)) {
                        Text(verbatim: user.userName).font(.headline).foregroundColor(.white)
                    }
                    if user.isOnline {
                        Text(verbatim: "online").font(.footnote).foregroundColor(.white)
                    }
                }
            }
            .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: 80.0, alignment: .leading)
            .background(Color(AVColors.headerBlue))
            .shadow(radius: 5)
            Group {
                //UITableView.appearance().separatorColor = .clear
                WAChatList(user: user, msgStore: msgStore)
            }.background(Color.WAMsgListBackground)
            
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 10).foregroundColor(.white).shadow(radius: 5).frame(height: 80).padding(.horizontal, 2)
                
                HStack {
                    TextField("Type a message", text: $newMessage)
                        .foregroundColor(Color(AVColors.headerBlue))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    Button(action: {
                        self.sendMessage()
                        }) {
                            
                            Text("Send")
                            .foregroundColor(.blue)
                                .padding(.horizontal).padding(.vertical, 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                }.padding()
                    
            }.padding(.bottom, keyboard.currentHeight)
        }
        .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity, alignment: .leading)
        .navigationBarTitle("User details")
    }
    
    func sendMessage() {
        if !$newMessage.wrappedValue.isEmpty {
            msgStore.sendMessage(uid: user.id, msg: newMessage)
            newMessage = ""
        }
    }
}

// MARK: User detail list
struct WAChatList: View {
    var user: UserInfo
    @ObservedObject var msgStore: MessageStore
    
    var body: some View {
        
        let messages = msgStore.messageDatabase[user.id] ?? []
        return List {
            ForEach(messages) {
                WAChatListRow(message: $0).frame(height: 50).animation(Animation.easeInOut)
            }.onDelete(perform: delete)
        }.environment(\.defaultMinListRowHeight, 60)
    }
    
    func delete(at index: IndexSet) {
        msgStore.delete(user: user, indexSet: index)
    }
}
// MARK: User detail List row
struct WAChatListRow: View {
    var message: UserMessage
    
    var body: some View {
        
        var horizontalAlignment: HorizontalAlignment = .leading
        var alignment: Alignment = .leading
        var color: Color = Color.WAMsgListBackground
        
        if message.messageType == .sent {
            horizontalAlignment = .trailing
            alignment = .trailing
            color = .WASentMessage
        }
        
        return VStack(alignment: horizontalAlignment) {
            HStack {
                HStack {
                    Text(message.message)
                    Text(message.timeStamp).font(.footnote).foregroundColor(.gray).offset(x: 0, y: 10)
                }
                .padding()
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }.frame(minWidth: .zero, maxWidth: .infinity, maxHeight: 50, alignment: alignment)
                .shadow(color: .gray, radius: 2, x: 1, y: 1)
        }
    }
}
