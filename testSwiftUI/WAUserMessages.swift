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
    let msgStore = MessageStore()
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack(spacing: 10.0) {
                Image(user.userImage)
                    .resizable()
                    .clipShape(Circle())
                    .padding(.leading, 10.0)
                    .frame( width: 40.0, height: 40.0)
                
                
                VStack(alignment: .leading) {
                    PresentationButton(Text(user.userName).font(.title).color(.white), destination: UserInfoScreen(user: user)).foregroundColor(.clear)
                    if user.isOnline {
                        Text("online").font(.footnote).color(.white)
                    }
                }
                }
                .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: 80.0, alignment: .leading)
                .background(Color.WADarkGreen)
            Group {
                WAChatList(user: user, msgStore: msgStore)
                }.background(Color.WAMsgListBackground)
            
            HStack {
                HStack {
                    Image(systemName: "smiley")
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: 40)
                    //Spacer()
                    TextField($newMessage, placeholder: Text("Type a Message"))
                        //.frame(maxWidth: 100, maxHeight: 60)
                        .background(Color.white)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading, 10)
                        .lineLimit(3)
                    
//                    TextField($newMessage, placeholder: Text("Type a Message"))
//                        .lineLimit(10)
//                        .frame(height: 80)
//                        .textFieldStyle(.roundedBorder)
//                        .fixedSize(horizontal: true, vertical: false)
                }
                //.frame(height: 60)
                //Spacer()
                Button(action: {
                    self.sendMessage()
                }) {
                    Group {
                        Image(systemName: "greaterthan.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: ContentMode.fit)
                        }
                        .background(Color.WADarkGreen)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                }
                .frame(maxWidth: .infinity, maxHeight: 100)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            }
            .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity, alignment: .leading)
    }
    
    func sendMessage() {
        if !$newMessage.value.isEmpty {
            msgStore.sendMessage(uname: user.userName, msg: newMessage)
            newMessage = ""
        }
    }
}

// MARK: User detail list
struct WAChatList: View {
    var user: UserInfo
    @ObjectBinding var msgStore: MessageStore
    
    var body: some View {
        
        let messages = msgStore.messageDatabase[user.userName] ?? []
        return List {
            ForEach(messages) {
                WAChatListRow(message: $0).frame(height: 60)
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
                    Text(message.message).color(.black).lineLimit(nil)
                    Text(message.timeStamp).font(.footnote)
                    }
                    .padding().background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .frame(minWidth: .zero, maxWidth: .infinity, maxHeight: 60, alignment: alignment)
        }
    }
}
