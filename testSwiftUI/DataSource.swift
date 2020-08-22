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

//User class
struct UserInfo: Identifiable {
    var id: UUID = UUID()
    
    var userImage: String
    var userName: String
    //var time: String
    var lastMessage: UserMessage?
    var isOnline = false
}

enum MessageType {
    case sent, received
}

struct UserMessage: Identifiable {
    var id: UUID = UUID()
    var uid: UUID
    var messageType: MessageType
    var message: String
    var timeStamp: String
}

struct Avengers {
    static let captainAmerica = UserInfo(userImage: "steve", userName: "Steve Rogers")
    static let ironMan = UserInfo(userImage: "tony", userName: "Tony Stark")
    static let thor = UserInfo(userImage: "thor", userName: "Thor")
    static let blackWidow = UserInfo(userImage: "natasha", userName: "Natasha Romanoff")
}

let messageData: [UUID: [UserMessage]] = [
    Avengers.ironMan.id: [
        UserMessage(uid: Avengers.ironMan.id, messageType: .sent, message: "Hey", timeStamp: Date().getTimeStamp()),
        UserMessage(uid: Avengers.ironMan.id, messageType: .received, message: "I dont have time.", timeStamp: Date().getTimeStamp())
    ],
    Avengers.captainAmerica.id: [
        UserMessage(uid: Avengers.captainAmerica.id, messageType: .sent, message: "Language", timeStamp: Date().getTimeStamp())
    ],
    Avengers.thor.id: [
        UserMessage(uid: Avengers.thor.id, messageType: .sent, message: "beer", timeStamp: Date().getTimeStamp())
    ]
]

//handles messages database
class MessageStore: ObservableObject {
    
    @Published var messageDatabase: [UUID: [UserMessage]]
    
    init(msgDb: [UUID: [UserMessage]] = messageData) {
        messageDatabase = msgDb
    }
    
    func sendMessage(uid: UUID, msg: String) {
        
        let newMessage = UserMessage(uid: uid, messageType: .sent, message: msg, timeStamp: Date().getTimeStamp())

        if var msgStore = messageDatabase[uid] {
            msgStore.append(newMessage)
            messageDatabase[uid] = msgStore
        } else {
            messageDatabase[uid] = [newMessage]
        }
    }
    
    func delete(user: UserInfo, indexSet: IndexSet) {
        if var messages = messageDatabase[user.id], let index = indexSet.first {
            messages.remove(at: index)
            messageDatabase[user.id] = messages
        }
    }
}

// MARK: - Dummy users
let usersDataArray = [Avengers.ironMan,
                      Avengers.captainAmerica,
                      Avengers.thor,
                      Avengers.blackWidow]

//MARK: - Dummy Message



class UserStore: ObservableObject {
    var didChange = PassthroughSubject<[UserInfo], Never>()
    var userInfo: [UserInfo]
    
    init(users: [UserInfo] = usersDataArray) {
        self.userInfo = users
    }
    
    func addUser(userName: String) {
        let user = UserInfo(userImage: "boy", userName: userName, lastMessage: nil, isOnline: false)
        userInfo.append(user)
        didChange.send(userInfo)
    }
}

struct AVColors {
    public static let darkRed = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
    public static let cellBackgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9764705882, alpha: 1)
    public static let cellColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    public static let headerBlue = #colorLiteral(red: 0.03552591801, green: 0.1493889689, blue: 0.3180473447, alpha: 1)
    public static let headerLightBlue = #colorLiteral(red: 0.1423024237, green: 0.2444138229, blue: 0.3886321485, alpha: 1)
}

extension Color {
    public static let WADarkGreen = Color.init(.sRGB, red: 7.0/255.0, green: 94.0/255.0, blue: 84.0/255.0, opacity: 1.0)
    public static let WASentMessage = Color.init(.sRGB, red: 0.86, green: 0.97, blue: 0.78, opacity: 1.0)
    public static let WAMsgListBackground = Color.init(.sRGB, red: 0.93, green: 0.90, blue: 0.87, opacity: 1.0)
    public static let WAWhiteUnselected = Color.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 0.5)
    public static let WAbackgroundSegment = Color.init(.sRGB, red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, opacity: 1.0)
}

extension Date {
    func getTimeStamp() -> String {
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
       // #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9764705882, alpha: 1)
        
       // #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
