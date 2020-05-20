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
                    .padding(.leading, 10.0).aspectRatio(contentMode: ContentMode.fill)
                    .frame(width: 50.0, height: 50.0)
                
                
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
                .background(Color.WADarkGreen)
            Group {
                //UITableView.appearance().separatorColor = .clear
                WAChatList(user: user, msgStore: msgStore)
                }.background(Color.WAMsgListBackground)
            
            Spacer()
            HStack {
                TextField("Type a message", text: $newMessage)
                    .foregroundColor(.WADarkGreen)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                Button(action: {
                    self.sendMessage()
                }) {
                    Text(verbatim: "send")
                }
                }.padding().padding(.bottom, keyboard.currentHeight)
            .navigationBarTitle("User details")
            }
            .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity, alignment: .leading)
    }
    
    func sendMessage() {
        if !$newMessage.wrappedValue.isEmpty {
            msgStore.sendMessage(uname: user.userName, msg: newMessage)
            newMessage = ""
        }
    }
}

// MARK: User detail list
struct WAChatList: View {
    var user: UserInfo
    @ObservedObject var msgStore: MessageStore
    
    var body: some View {
        
        let messages = msgStore.messageDatabase[user.userName] ?? []
        return List {
            ForEach(messages) {
                WAChatListRow(message: $0).frame(height: 50)
            }.onDelete(perform: delete)
        }
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
                    Text(message.timeStamp).font(.footnote)
                    }
                .padding()
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            .frame(minWidth: .zero, maxWidth: .infinity, maxHeight: 50, alignment: alignment)
        }
    }
}
