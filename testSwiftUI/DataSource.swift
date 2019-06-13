//
//  DataSource.swift
//  testSwiftUI
//
//  Created by Akash kahalkar on 12/06/19.
//  Copyright © 2019 Akashka. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

let menuArray = ["CHAT", "STATUS", "CAllS"]

struct UserInfo: Identifiable {
    var id: UUID = UUID()
    
    var userImage: String
    var userName: String
    var time: String
    var lastMessage: String
    var isOnline = false
}

enum MessageType {
    case sent, received
}

struct UserMessage: Identifiable {
    var id: UUID = UUID()
    
    var messageType: MessageType
    var message: String
    var timeStamp: String
}

//MARK: - Dummy Message

let messageData: [String: [UserMessage]] = [ "Ivanka T.": [UserMessage(messageType: .sent, message: "Hey", timeStamp: "00:00 PM"),
                                                           UserMessage(messageType: .received, message: "hello", timeStamp: "00:00 PM"),
                                                           UserMessage(messageType: .received, message: "where r u?🥰", timeStamp: "00:00 PM")],
                                             "Donald T.": [UserMessage(messageType: .received, message: "Stay Away from my daughter", timeStamp: "00:00 PM")]
]

class MessageStore: BindableObject {
    var didChange = PassthroughSubject<MessageStore, Never>()
    
    var messageDatabase: [String: [UserMessage]]
    
    init(msgDb: [String: [UserMessage]] = messageData) {
        messageDatabase = msgDb
    }
    
    func sendMessage(uname: String, msg: String) {
        
        let newMessage = UserMessage(messageType: .sent, message: msg, timeStamp: getTimeStamp())

        if var msgStore = messageDatabase[uname] {
            msgStore.append(newMessage)
            messageDatabase[uname] = msgStore
        } else {
            messageDatabase[uname] = [newMessage]
        }
        print("Message Count", messageDatabase[uname]?.count ?? 0)
        print(getTimeStamp())
        didChange.send(self)
    }
    
    func delete(user: UserInfo, indexSet: IndexSet) {
        if var messages = messageDatabase[user.userName], let index = indexSet.first {
            messages.remove(at: index)
            messageDatabase[user.userName] = messages
            didChange.send(self)
        }
    }
}

public func getTimeStamp() -> String {
    let currentDateTime = Date()
    // initialize the date formatter and set the style
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    return formatter.string(from: currentDateTime)
}

// MARK: - Dummy users
let dataArray = [
    UserInfo(userImage: "ivanka", userName: "Ivanka T.", time: "12.15 pm", lastMessage: "where r u?🥰", isOnline: true),
    UserInfo(userImage: "donald", userName: "Donald T.", time: "2.15 pm", lastMessage: "Stay away from my daughter"),
    UserInfo(userImage: "boy", userName: "Trudev", time: "1.16 pm", lastMessage: "Hey dude!"),
]

class UserStore: BindableObject {
    var didChange = PassthroughSubject<[UserInfo], Never>()
    var userInfo: [UserInfo]
    
    init(users: [UserInfo] = dataArray) {
        self.userInfo = users
    }
    
    func addUser(userName: String) {
        let user = UserInfo(userImage: "boy", userName: userName, time: getTimeStamp(), lastMessage: "No New Message", isOnline: false)
        userInfo.append(user)
        didChange.send(userInfo)
    }
}

extension Color {
    public static let WADarkGreen = Color.init(.sRGB, red: 7.0/255.0, green: 94.0/255.0, blue: 84.0/255.0, opacity: 1.0)
    public static let WASentMessage = Color.init(.sRGB, red: 0.86, green: 0.97, blue: 0.78, opacity: 1.0)
    public static let WAMsgListBackground = Color.init(.sRGB, red: 0.93, green: 0.90, blue: 0.87, opacity: 1.0)
    public static let WAWhiteUnselected = Color.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 0.5)
}

