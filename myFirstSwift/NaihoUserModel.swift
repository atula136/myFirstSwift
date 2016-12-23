//
//  NaihoUserModel.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/16/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import Foundation

struct NaihoChatGroups {
    let id: String
    let isClosed: Bool
    
    init(id: String, isClosed: Bool) {
        self.id = id
        self.isClosed = isClosed
    }
}

struct NaihoUserInfo {
    var avatar: String?
    var department: String?
    var display_name: String?
}

class NaihoUserModel {
    var id: String
    var chat_groups: [NaihoChatGroups]?
    var user_info: NaihoUserInfo?
    
    init(id: String) {
        self.id = id
        self.chat_groups = [NaihoChatGroups]()
    }
    
}
